Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752070Ab0LFKSW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 05:18:22 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:58549 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750985Ab0LFKSV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 05:18:21 -0500
Message-ID: <4CFCB983.6020503@cn.fujitsu.com>
Date: Mon, 06 Dec 2010 18:22:59 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v4 3/3] KVM: MMU: retry #PF for softmmu
References: <4CF76A8B.2040102@cn.fujitsu.com> <4CF76B06.6050708@cn.fujitsu.com> <4CFCB150.40202@redhat.com>
In-Reply-To: <4CFCB150.40202@redhat.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-12-06 18:18:24,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-12-06 18:18:25,
	Serialize complete at 2010-12-06 18:18:25
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Avi,

On 12/06/2010 05:48 PM, Avi Kivity wrote:
> On 12/02/2010 11:46 AM, Xiao Guangrong wrote:
>> Retry #PF for softmmu only when the current vcpu has the same cr3 as
>> the time
>> when #PF occurs
>>
>> Changelog:
>>    Just compare cr3 value since It's harmless to instantiate an spte
>> for an
>>    unused translation from Marcelo's comment
>>
> 
> It's not harmless.  We could be in a different process, so we have to
> re-fetch the gpte.  Or we could have switched from one nested guest to
> another.
> 

But it does this in this patch: re-walk guest page table and fixes guest's
shadow page (not use any info when apf is occurred)

>>           if (!eperm&&  !rsvd_fault&&  !(pte&  PT_ACCESSED_MASK)) {
>> +            /*
>> +             * Don't set gpte accessed bit if it's on
>> +             * speculative path.
>> +             */
>> +            if (prefault)
>> +                goto error;
> 
> It's actually legal to set the accessed bit on speculative access.
> 

Oh, you are right, thanks for your reminder.

