Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753442Ab1B1SPC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 13:15:02 -0500
Received: from terminus.zytor.com ([198.137.202.10]:39516 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751377Ab1B1SPA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 13:15:00 -0500
Message-ID: <4D6BE614.3010007@zytor.com>
Date: Mon, 28 Feb 2011 10:14:44 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc13 Thunderbird/3.1.7
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Yinghai Lu <yinghai@kernel.org>, x86@kernel.org,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org
Subject: Re: questions about init_memory_mapping_high()
References: <20110223171945.GI26065@htj.dyndns.org>
In-Reply-To: <20110223171945.GI26065@htj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/23/2011 09:19 AM, Tejun Heo wrote:
> Hello, guys.
> 
> I've been looking at init_memory_mapping_high() added by commit
> 1411e0ec31 (x86-64, numa: Put pgtable to local node memory) and I got
> curious about several things.
> 
> 1. The only rationale given in the commit description is that a
>    RED-PEN is killed, which was the following.
> 
> 	/*
> 	 * RED-PEN putting page tables only on node 0 could
> 	 * cause a hotspot and fill up ZONE_DMA. The page tables
> 	 * need roughly 0.5KB per GB.
> 	 */
> 
>    This already wasn't true with top-down memblock allocation.
> 
>    The 0.5KB per GiB comment is for 32bit w/ 3 level mapping.  On
>    64bit, it's ~4KiB per GiB when using 2MiB mappings and, well, very
>    small per GiB if 1GiB mapping is used.  Even with 2MiB mapping,
>    1TiB mapping would only be 4MiB.  Under ZONE_DMA, this could be
>    problematic but with top-down this can't be a problem in any
>    realistic way in foreseeable future.
> 

It's true on 64 bits too when PAE is not available (e.g. with Xen.)

	-hpa
