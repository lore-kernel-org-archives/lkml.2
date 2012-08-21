Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754869Ab2HUJGm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 05:06:42 -0400
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:52873 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753322Ab2HUJGj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 05:06:39 -0400
X-IronPort-AV: E=Sophos;i="4.77,801,1336341600"; 
   d="scan'208";a="170394197"
Date: Tue, 21 Aug 2012 11:06:35 +0200 (CEST)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@hadrien
To: Lars-Peter Clausen <lars@metafoo.de>
cc: Julia Lawall <julia@diku.dk>, linux-kernel@vger.kernel.org, cocci@diku.dk,
        Michal Marek <mmarek@suse.cz>
Subject: Re: [Cocci] [PATCH] scripts/coccinelle: ptr_ret: Add ternary operator
 version
In-Reply-To: <1345538998-24600-1-git-send-email-lars@metafoo.de>
Message-ID: <alpine.DEB.2.02.1208211105300.1984@hadrien>
References: <1345538998-24600-1-git-send-email-lars@metafoo.de>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 21 Aug 2012, Lars-Peter Clausen wrote:

> Add a ternary operator version of the open-coded PTR_RET().
>
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
> ---
>  scripts/coccinelle/api/ptr_ret.cocci |   26 ++++++++++++++++++++++++++
>  1 files changed, 26 insertions(+), 0 deletions(-)
>
> diff --git a/scripts/coccinelle/api/ptr_ret.cocci b/scripts/coccinelle/api/ptr_ret.cocci
> index cbfd08c..15f076f 100644
> --- a/scripts/coccinelle/api/ptr_ret.cocci
> +++ b/scripts/coccinelle/api/ptr_ret.cocci
> @@ -30,6 +30,13 @@ expression ptr;
>  - if (IS_ERR(ptr)) return PTR_ERR(ptr); return 0;
>  + return PTR_RET(ptr);
>
> +@depends on patch@
> +expression ptr;
> +@@
> +
> +- (IS_ERR(ptr) ? PTR_ERR(ptr) : 0)
> ++ PTR_RET(ptr)
> +
>  @r1 depends on !patch@
>  expression ptr;
>  position p1;
> @@ -44,6 +51,13 @@ position p2;
>
>  * if@p2 (IS_ERR(ptr)) return PTR_ERR(ptr); return 0;
>
> +@r3 depends on !patch@
> +expression ptr;
> +position p3;
> +@@
> +
> +* IS_ERR@p3(ptr) ? PTR_ERR(ptr) : 0
> +
>  @script:python depends on org@
>  p << r1.p1;
>  @@
> @@ -57,6 +71,12 @@ p << r2.p2;
>
>  coccilib.org.print_todo(p[0], "WARNING: PTR_RET can be used")
>
> +@script:python depends on org@
> +p << r3.p3;
> +@@
> +
> +coccilib.org.print_todo(p[0], "WARNING: PTR_RET can be used")
> +
>  @script:python depends on report@
>  p << r1.p1;
>  @@
> @@ -68,3 +88,9 @@ p << r2.p2;
>  @@
>
>  coccilib.report.print_report(p[0], "WARNING: PTR_RET can be used")
> +
> +@script:python depends on report@
> +p << r3.p3;
> +@@
> +
> +coccilib.report.print_report(p[0], "WARNING: PTR_RET can be used")

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

> --
> 1.7.2.5
>
> _______________________________________________
> Cocci mailing list
> Cocci@diku.dk
> http://lists.diku.dk/mailman/listinfo/cocci
> (Web access from inside DIKUs LAN only)
>
