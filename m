Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753553Ab1G0Gas (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 02:30:48 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:62588 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752178Ab1G0Gap (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 02:30:45 -0400
Message-ID: <4E2FB10B.9080805@cn.fujitsu.com>
Date: Wed, 27 Jul 2011 14:32:43 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 03/11] KVM: x86: fast emulate repeat string write instructions
References: <4E2EA3DB.7040403@cn.fujitsu.com> <4E2EA476.9070607@cn.fujitsu.com> <20110726122710.GM4404@redhat.com> <4E2F6E48.7030802@cn.fujitsu.com> <20110727042602.GA7966@redhat.com>
In-Reply-To: <20110727042602.GA7966@redhat.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-07-27 14:29:48,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-07-27 14:29:49,
	Serialize complete at 2011-07-27 14:29:49
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/27/2011 12:26 PM, Gleb Natapov wrote:
> On Wed, Jul 27, 2011 at 09:47:52AM +0800, Xiao Guangrong wrote:
>> On 07/26/2011 08:27 PM, Gleb Natapov wrote:
>>> On Tue, Jul 26, 2011 at 07:26:46PM +0800, Xiao Guangrong wrote:
>>>> We usually use repeat string instructions to clear the page, for example,
>>> By "we" do you mean Linux guest?
>>>
>>
>> I do not know other guests except linux, but, generally rep instruction is
>> not used to update a page table which is been using.
>>
>>>> we call memset to clear a page table, stosb is used in this function, and 
>>>> repeated for 1024 times, that means we should occupy mmu lock for 1024 times
>>>> and walking shadow page cache for 1024 times, it is terrible
>>>>
>>>> In fact, if it is the repeat string instructions emulated and it is not a
>>>> IO/MMIO access, we can zap all the corresponding shadow pages and return to the
>>>> guest, then the mapping can became writable and directly write the page
>>>>
>>
>>
>>> So this patch does two independent things as far as I can see. First it
>>> stops reentering guest if rep instruction is done on memory and second
>>
>> No.
>> Oppositely, it enters guest as soon as possible if rep instruction is done
>> on memory ;-)
> Oops. Indeed. I read it other way around. So why not just return
> X86EMUL_UNHANDLEABLE from emulator_write_emulated_onepage() which should
> have the same effect?
> 

It seams not, the count register(RCX) is not decreased, and redundant work
need to be done by handling EMULATION_FAILED.
So, emulator_write_emulated_onepage() is not a good place i think. :-)

