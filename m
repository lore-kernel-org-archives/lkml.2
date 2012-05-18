Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933581Ab2ERIgF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 04:36:05 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:45957 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758362Ab2ERIgA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 04:36:00 -0400
X-AuditID: 9c930197-b7be2ae000000ebb-7e-4fb609eecaf5
Message-ID: <4FB60A1F.4010202@kernel.org>
Date: Fri, 18 May 2012 17:36:47 +0900
From: Minchan Kim <minchan@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel.mm,gmane.linux.kernel
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nitin Gupta <ngupta@vflare.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Tejun Heo <tj@kernel.org>, David Howells <dhowells@redhat.com>,
        x86@kernel.org, Nick Piggin <npiggin@gmail.com>
Subject: Re: [PATCH v2 3/3] x86: Support local_flush_tlb_kernel_range
References: <1337133919-4182-1-git-send-email-minchan@kernel.org>  <1337133919-4182-3-git-send-email-minchan@kernel.org>  <4FB4B29C.4010908@kernel.org> <1337266310.4281.30.camel@twins>
In-Reply-To: <1337266310.4281.30.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

On 05/17/2012 11:51 PM, Peter Zijlstra wrote:

> On Thu, 2012-05-17 at 17:11 +0900, Minchan Kim wrote:
>>> +++ b/arch/x86/include/asm/tlbflush.h
>>> @@ -172,4 +172,16 @@ static inline void flush_tlb_kernel_range(unsigned long start,
>>>       flush_tlb_all();
>>>  }
>>>  
>>> +static inline void local_flush_tlb_kernel_range(unsigned long start,
>>> +             unsigned long end)
>>> +{
>>> +     if (cpu_has_invlpg) {
>>> +             while (start < end) {
>>> +                     __flush_tlb_single(start);
>>> +                     start += PAGE_SIZE;
>>> +             }
>>> +     } else
>>> +             local_flush_tlb();
>>> +}
> 
> 
> It would be much better if you wait for Alex Shi's patch to mature.
> doing the invlpg thing for ranges is not an unconditional win.


Thanks for the information. I will watch that patchset.
Thanks.

-- 
Kind regards,
Minchan Kim
