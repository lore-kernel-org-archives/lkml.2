Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759877Ab1FATtd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 15:49:33 -0400
Received: from na3sys009aob106.obsmtp.com ([74.125.149.76]:35551 "EHLO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759492Ab1FATt2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 15:49:28 -0400
Subject: Re: [PATCH 7/10] drivers/net/davinci_emac.c: add missing clk_put
From: Kevin Hilman <khilman@ti.com>
To: Julia Lawall <julia@diku.dk>
Cc: "David S. Miller" <davem@davemloft.net>, kernel-janitors@vger.kernel.org,
        Cyril Chemparathy <cyril@ti.com>, Sriramakrishnan A G <srk@ti.com>,
        Stefan Weil <weil@mail.berlios.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <1306948213-20767-7-git-send-email-julia@diku.dk>
References: <1306948213-20767-7-git-send-email-julia@diku.dk>
Content-Type: text/plain; charset="UTF-8"
Organization: Texas Instruments, Inc.
Date: Wed, 01 Jun 2011 12:49:24 -0700
Message-ID: <1306957764.26236.37.camel@vence>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-06-01 at 19:10 +0200, Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> Go to existing error handling code at the end of the function that calls
> clk_put.
> 
> A simplified version of the semantic match that finds this problem is as
> follows: (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @r exists@
> expression e1,e2;
> statement S;
> @@
> 
> e1 = clk_get@p1(...);
> ... when != e1 = e2
>     when != clk_put(e1)
>     when any
> if (...) { ... when != clk_put(e1)
>                when != if (...) { ... clk_put(e1) ... }
> * return@p3 ...;
>  } else S
> // </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>

Acked-by: Kevin Hilman <khilman@ti.com>


