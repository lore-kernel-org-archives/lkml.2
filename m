Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751911Ab1GERvU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 13:51:20 -0400
Received: from na3sys009aog120.obsmtp.com ([74.125.149.140]:58698 "EHLO
	na3sys009aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751118Ab1GERvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 13:51:18 -0400
From: Kevin Hilman <khilman@ti.com>
To: Julia Lawall <julia@diku.dk>
Cc: Tony Lindgren <tony@atomide.com>, kernel-janitors@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] arch/arm/mach-omap2/smartreflex.c: add missing error-handling code
Organization: Texas Instruments, Inc.
References: <1309788705-22278-3-git-send-email-julia@diku.dk>
Date: Tue, 05 Jul 2011 10:51:13 -0700
In-Reply-To: <1309788705-22278-3-git-send-email-julia@diku.dk> (Julia Lawall's
	message of "Mon, 4 Jul 2011 16:11:43 +0200")
Message-ID: <87tyb0sjji.fsf@ti.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Julia Lawall <julia@diku.dk> writes:

> From: Julia Lawall <julia@diku.dk>
>
> At this point, the ioremap has taken place, so the error handling code at
> the label err_iounmap should be used rather than returning directly.
>
> The semantic match that finds this problem is as follows:
> (http://coccinelle.lip6.fr/)
>
> // <smpl>
> @r@
> identifier x;
> @@
>
> kfree(x)
>
> @@
> identifier r.x;
> expression E1!=0,E2,E3,E4;
> statement S;
> @@
>
> (
> if (<+...x...+>) S
> |
> if (...) { ... when != kfree(x)
>                when != if (...) { ... kfree(x); ... }
>                when != x = E3
> * return E1;
> }
> ... when != x = E2
> if (...) { ... when != x = E4
>  kfree(x); ... return ...; }
> )
> // </smpl>
>
> Signed-off-by: Julia Lawall <julia@diku.dk>

Acked-by: Kevin Hilman <khilman@ti.com>

Tony, can you add this to devel-fixes?

Kevin
