Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751799Ab1IZRXc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 13:23:32 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:63038 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751474Ab1IZRXb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 13:23:31 -0400
Date: Mon, 26 Sep 2011 13:23:07 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        David Vrabel <david.vrabel@citrix.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH] xen: Fix selfballooning and ensure it doesn't go too far
Message-ID: <20110926172307.GA9973@phenom.oracle.com>
References: <9827a70d-dfb2-4bbc-9df6-207b10c835ac@default>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9827a70d-dfb2-4bbc-9df6-207b10c835ac@default>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: rtcsinet21.oracle.com [66.248.204.29]
X-CT-RefId: str=0001.0A090203.4E80B50F.006E,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 24, 2011 at 01:58:08PM -0700, Dan Magenheimer wrote:
> [PATCH] xen: Fix selfballooning and ensure it doesn't go too far
> 
> The balloon driver's "current_pages" is very different from
> totalram_pages.  Self-ballooning needs to be driven by
> the latter.  Also, Committed_AS doesn't account for pages
> used by the kernel so enforce a floor for when there
> are little or no user-space threads using memory.

Hey Dan,
..
> +		floor_pages = totalreserve_pages +
> +				(roundup_pow_of_two(max_pfn) >> 5);

Would it make sense to make the shift be a runtime argument
in case some users report problems with that calculation?

> +		/* don't balloon too far, lest OOMs occur... */
> +		if (tgt_pages < floor_pages)
> +			tgt_pages = floor_pages;
> +		balloon_set_new_target(tgt_pages +
> +			balloon_stats.current_pages - totalram_pages);
>  		reset_timer = true;
>  	}
>  #ifdef CONFIG_FRONTSWAP

Otherwise it looks OK to me. Would you like me to queue it up
for 3.1-rc7?
