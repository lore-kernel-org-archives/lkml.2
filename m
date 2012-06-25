Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755657Ab2FYSZO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 14:25:14 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:46894 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755030Ab2FYSZM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 14:25:12 -0400
Message-ID: <4FE8ACDD.3070007@linux.vnet.ibm.com>
Date: Mon, 25 Jun 2012 13:24:29 -0500
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: devel@driverdev.osuosl.org, Dan Magenheimer <dan.magenheimer@oracle.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Minchan Kim <minchan@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Nitin Gupta <ngupta@vflare.org>
Subject: Re: [PATCH 2/3] zsmalloc: add generic path and remove x86 dependency
References: <1340640878-27536-1-git-send-email-sjenning@linux.vnet.ibm.com> <1340640878-27536-3-git-send-email-sjenning@linux.vnet.ibm.com> <20120625165915.GA20464@kroah.com> <4FE89BA1.3030709@linux.vnet.ibm.com> <20120625171939.GA29371@kroah.com>
In-Reply-To: <20120625171939.GA29371@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12062518-9360-0000-0000-000007C43758
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/25/2012 12:19 PM, Greg Kroah-Hartman wrote:
> On Mon, Jun 25, 2012 at 12:10:57PM -0500, Seth Jennings wrote:
>> On 06/25/2012 11:59 AM, Greg Kroah-Hartman wrote:
>>> On Mon, Jun 25, 2012 at 11:14:37AM -0500, Seth Jennings wrote:
>>>> This patch adds generic pages mapping methods that
>>>> work on all archs in the absence of support for
>>>> local_tlb_flush_kernel_range() advertised by the
>>>> arch through __HAVE_LOCAL_TLB_FLUSH_KERNEL_RANGE
>>>
>>> Is this #define something that other arches define now?  Or is this
>>> something new that you are adding here?
>>
>> Something new I'm adding.
> 
> Ah, ok.
> 
>> The precedent for this approach is the __HAVE_ARCH_* defines
>> that let the arch independent stuff know if a generic
>> function needs to be defined or if there is an arch specific
>> function.
>>
>> You can "grep -R __HAVE_ARCH_* arch/x86/" to see the ones
>> that already exist.
>>
>> I guess I should have called it
>> __HAVE_ARCH_LOCAL_TLB_FLUSH_KERNEL_RANGE though, not
>> __HAVE_LOCAL_TLB_FLUSH_KERNEL_RANGE.
> 
> You need to get the mm developers to agree with this before I can take
> it.
> 
> But, why even depend on this?  Can't you either live without it

The whole point of the patch is _not_ to depend on it.  It
just performs worse without it.  We could just rip out all
the the page table assisted page mapping, but, for the
arches that have support for it, we'd be degrading
performance in exchange for portability.  Why choose when we
can have both?

> , or just implement it for all arches somehow?

It can be implemented for some arches and already is for
some (MIPS, ARM, at least).  But for some arches, I imagine
this can't be implemented due to hardware limitations.

A benefit of this approach is the arches opt-in to the
optimized zsmalloc by implementing
local_tlb_flush_kernel_range() without having to change
anything in zsmalloc.

--
Seth

