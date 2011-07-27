Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754418Ab1G0Jfz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 05:35:55 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:65352 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754036Ab1G0Jfx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 05:35:53 -0400
Message-ID: <4E2FDC6F.4050006@cn.fujitsu.com>
Date: Wed, 27 Jul 2011 17:37:51 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 03/11] KVM: x86: fast emulate repeat string write instructions
References: <4E2EA3DB.7040403@cn.fujitsu.com> <4E2EA476.9070607@cn.fujitsu.com> <4E2FD499.2070308@redhat.com>
In-Reply-To: <4E2FD499.2070308@redhat.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-07-27 17:34:56,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-07-27 17:34:58,
	Serialize complete at 2011-07-27 17:34:58
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/27/2011 05:04 PM, Avi Kivity wrote:
> On 07/26/2011 02:26 PM, Xiao Guangrong wrote:
>> We usually use repeat string instructions to clear the page, for example,
>> we call memset to clear a page table, stosb is used in this function, and
>> repeated for 1024 times, that means we should occupy mmu lock for 1024 times
>> and walking shadow page cache for 1024 times, it is terrible
>>
>> In fact, if it is the repeat string instructions emulated and it is not a
>> IO/MMIO access, we can zap all the corresponding shadow pages and return to the
>> guest, then the mapping can became writable and directly write the page
> 
> Please generalize this to fail emulation on all non-page-table instructions when emulating due to a write protected page that we can unprotect.
> 

OK, will do it in the next version, thanks!
