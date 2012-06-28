Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758112Ab2F1CFX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 22:05:23 -0400
Received: from mga01.intel.com ([192.55.52.88]:13078 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757672Ab2F1CFW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 22:05:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="170896216"
Message-ID: <4FEBBB5C.5000505@intel.com>
Date: Thu, 28 Jun 2012 10:03:08 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111229 Thunderbird/9.0
MIME-Version: 1.0
To: Seth Jennings <sjenning@linux.vnet.ibm.com>
CC: Dan Magenheimer <dan.magenheimer@oracle.com>,
        Minchan Kim <minchan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, Konrad Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Nitin Gupta <ngupta@vflare.org>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 3/3] x86: add local_tlb_flush_kernel_range()
References: <1340640878-27536-1-git-send-email-sjenning@linux.vnet.ibm.com> <1340640878-27536-4-git-send-email-sjenning@linux.vnet.ibm.com> <4FEA9FDD.6030102@kernel.org> <4FEAA4AA.3000406@intel.com> <4FEAA7A1.9020307@kernel.org> <90bcc2c8-bcac-4620-b3c0-6b65f8d9174d@default> <4FEB5204.3090707@linux.vnet.ibm.com>
In-Reply-To: <4FEB5204.3090707@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/28/2012 02:33 AM, Seth Jennings wrote:

> On 06/27/2012 10:12 AM, Dan Magenheimer wrote:
>>> From: Minchan Kim [mailto:minchan@kernel.org]
>>> Subject: Re: [PATCH 3/3] x86: add local_tlb_flush_kernel_range()
>>>
>>> On 06/27/2012 03:14 PM, Alex Shi wrote:
>>>>
>>>> On 06/27/2012 01:53 PM, Minchan Kim wrote:
>>>> Different CPU type has different balance point on the invlpg replacing
>>>> flush all. and some CPU never get benefit from invlpg, So, it's better
>>>> to use different value for different CPU, not a fixed
>>>> INVLPG_BREAK_EVEN_PAGES.
>>>
>>> I think it could be another patch as further step and someone who are
>>> very familiar with architecture could do better than.
>>> So I hope it could be merged if it doesn't have real big problem.
>>>
>>> Thanks for the comment, Alex.
>>
>> Just my opinion, but I have to agree with Alex.  Hardcoding
>> behavior that is VERY processor-specific is a bad idea.  TLBs should
>> only be messed with when absolutely necessary, not for the
>> convenience of defending an abstraction that is nice-to-have
>> but, in current OS kernel code, unnecessary.
> 
> I agree that it's not optimal.  The selection based on CPUID
> is part of Alex's patchset, and I'll be glad to use that
> code when it gets integrated.
> 
> But the real discussion is are we going to:
> 1) wait until Alex's patches to be integrated, degrading
> zsmalloc in the meantime or


Peter Anvin is merging my TLB patch set into tip tree, x86/mm branch.

> 2) put in some simple temporary logic that works well (not
> best) for most cases


