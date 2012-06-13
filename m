Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752242Ab2FMFym (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 01:54:42 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:58928 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750906Ab2FMFyl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 01:54:41 -0400
X-IronPort-AV: E=Sophos;i="4.77,401,1336320000"; 
   d="scan'208";a="5176083"
Message-ID: <4FD826C3.1040209@cn.fujitsu.com>
Date: Wed, 13 Jun 2012 13:36:03 +0800
From: Wen Congyang <wency@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, rob@landley.net,
        tglx@linutronix.de, Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        bhelgaas@google.com
Subject: Re: [PATCH 1/2 v2] x86: add max_addr boot option
References: <4FD5AFF2.3040306@cn.fujitsu.com> <4FD65FD4.4060705@zytor.com> <4FD6E101.3010106@cn.fujitsu.com> <d468fc51-04f6-4e88-aeaa-c4642531325e@email.android.com> <4FD7F937.2010101@jp.fujitsu.com> <4FD80923.1060807@zytor.com>
In-Reply-To: <4FD80923.1060807@zytor.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/06/13 13:32:29,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/06/13 13:32:41,
	Serialize complete at 2012/06/13 13:32:41
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At 06/13/2012 11:29 AM, H. Peter Anvin Wrote:
> On 06/12/2012 07:21 PM, Kamezawa Hiroyuki wrote:
>>
>> But now, we know mem= boot option is buggy....it acts as max_addr=
>> option, we have concerns that 'someone may fix mem= option as sane as ia64. because
>> it's buggy".
>>
>> We'd like to fix mem= boot option by ourselves and preserve old behavior
>> with max_addr= boot option, which ia64 has.
>>
> 
> Now I'm *really* confused.
> 
> Realistically, there is no point in the old mem= behavior of assuming a
> contiguous chunk of memory up to that point; it simply doesn't match how
> modern hardware is constructed.  Your notion that ia64 is "sane" is
> probably more of "outdated" in my opinion.
> 
> As such, the current behavior for mem= seems like the right thing and
> the change was intentional (not to mention has been in place since
> kernel 2.5.65, back in 2003); it also solves your requirements.  If you
> are concerned about it, it would make more sense to make sure it is
> documented as intentional.


Here is the document(Documentation/kernel-parameters.txt):

mem=nn[KMG]	[KNL,BOOT] Force usage of a specific amount of memory

The implementation of mem= on ia64 is the same as the description in the document, but
the implementation of mem= on x86 box is not the same as the descrition.

Now, which should we fix? Document or the implementition?

Another problem is: the mem= cannot work if the user specifies add_efi_memmap
option. I think we should also fix this problem.

Thanks
Wen Congyang
> 
> In fact, it looks like IA64 introduced a divergence when the max_addr=
> patch was introduced in 2004.  You're basically proposing the same
> divergence for x86 now; talk about having the tail wag the dog.
> 
> Sorry.  NAK.
> 
> 	-hpa
> 
> 

