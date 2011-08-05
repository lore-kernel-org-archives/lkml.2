Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755707Ab1HEVWP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 17:22:15 -0400
Received: from mga02.intel.com ([134.134.136.20]:49866 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751346Ab1HEVWN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 17:22:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,325,1309762800"; 
   d="scan'208";a="35854162"
Message-ID: <4E3C5F03.8090100@linux.intel.com>
Date: Fri, 05 Aug 2011 14:22:11 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
Organization: Intel Open Source Technology Center
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: Re: [x86] Fix prefetch instruction
References: <alpine.DEB.2.00.1108051116520.28580@router.home> <4E3C4EF1.3040709@zytor.com> <alpine.DEB.2.00.1108051608110.4821@router.home>
In-Reply-To: <alpine.DEB.2.00.1108051608110.4821@router.home>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/05/2011 02:10 PM, Christoph Lameter wrote:
>>
>> Have you done any performance analysis on this versus the null case?  I
>> know there are some workloads where it helps, but if it hurts as many as
>> it helps...
> 
> No I have not. prefetch IMHO means that the cacheline is fetched early so
> that the cacheline is fully available like any other to the code.
> prefetchnta does fetch the cacheline too but its not treated like the other cacheline but
> preferably thrown out again. Its a "streamfetch" designed for apps that
> scan over large amounts of memory and want to avoid cache pollution.
> 
> This is surprising to the end user as far as I can tell.
> 

Right.  However, Linus has brought up the hypothesis that prefetch might
actually be a net loss on x86, because current x86 processors are
generally doing a good job with prefetching in hardware.  Directed
prefetches can thus be a net minus.

	-hpa
