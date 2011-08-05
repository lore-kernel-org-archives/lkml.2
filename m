Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756335Ab1HEUN6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 16:13:58 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33903 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756239Ab1HEUNy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 16:13:54 -0400
Message-ID: <4E3C4EF1.3040709@zytor.com>
Date: Fri, 05 Aug 2011 13:13:37 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: [x86] Fix prefetch instruction
References: <alpine.DEB.2.00.1108051116520.28580@router.home>
In-Reply-To: <alpine.DEB.2.00.1108051116520.28580@router.home>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/05/2011 09:18 AM, Christoph Lameter wrote:
> The prefetchnta instruction used for prefetching on x86 is a special instruction
> used for streaming that is usually used to avoid polluting the l2 and l3 caches.
> The cacheline will be evicted rapidly.
> 
> What we need is a prefetch that puts the cacheline in all levels of the cache hierachy instead.
> Change the instruction to do that.
> 
> Acked-by: Andi Kleen <ak@linux.intel.com>
> Signed-off-by: Christoph Lameter <cl@linux.com>
> 

Have you done any performance analysis on this versus the null case?  I
know there are some workloads where it helps, but if it hurts as many as
it helps...

	-hpa

