Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755415Ab0HaVlc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 17:41:32 -0400
Received: from gate.crashing.org ([63.228.1.57]:42444 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754878Ab0HaVla (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 17:41:30 -0400
Subject: Re: [PATCH] arch/powerpc/platforms/83xx/mpc837x_mds.c: Add missing iounmap
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@kernel.crashing.org>
In-Reply-To: <1283111238-3129-1-git-send-email-julia@diku.dk>
Date: Tue, 31 Aug 2010 16:39:11 -0500
Cc: kernel-janitors@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Content-Transfer-Encoding: 7bit
Message-Id: <D97B05D5-3ABF-4B47-97C7-A3EC629A1987@kernel.crashing.org>
References: <1283111238-3129-1-git-send-email-julia@diku.dk>
To: Julia Lawall <julia@diku.dk>
X-Mailer: Apple Mail (2.1081)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 29, 2010, at 2:47 PM, Julia Lawall wrote:

> The function of_iomap returns the result of calling ioremap, so iounmap
> should be called on the result in the error handling code, as done in the
> normal exit of the function.
> 
> The sematic match that finds this problem is as follows:
> (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @r exists@
> local idexpression x;
> expression E,E1;
> identifier l;
> statement S;
> @@
> 
> *x = of_iomap(...);
> ...  when != iounmap(x)
>     when != if (...) { ... iounmap(x); ... }
>     when != E = x
>     when any
> (
> if (x == NULL) S
> |
> if (...) {
>  ... when != iounmap(x)
>      when != if (...) { ... iounmap(x); ... }
> (
>  return <+...x...+>;
> |
> *  return ...;
> )
> }
> )
> ... when != x = E1
>    when any
> iounmap(x);
> // </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>
> 
> ---
> arch/powerpc/platforms/83xx/mpc837x_mds.c |    9 ++++++---
> 1 file changed, 6 insertions(+), 3 deletions(-)

applied to merge

- k
