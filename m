Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751763Ab1CTJVB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Mar 2011 05:21:01 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:40989 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751644Ab1CTJU5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Mar 2011 05:20:57 -0400
Date: Sun, 20 Mar 2011 10:20:50 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: linux-kernel@vger.kernel.org, Gilles Muller <Gilles.Muller@lip6.fr>,
        Nicolas Palix <npalix.work@gmail.com>, cocci@diku.dk
Subject: Re: [PATCH 01/13] Coccinelle: introduce list_move.cocci
In-Reply-To: <1300229605-14499-1-git-send-email-kirill@shutemov.name>
Message-ID: <Pine.LNX.4.64.1103201017330.28495@ask.diku.dk>
References: <1300229605-14499-1-git-send-email-kirill@shutemov.name>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kirill,

Thank you very much for your contribution.  Nevertheless, there is a small 
problem.  In the very last python rule, you use org || report, but 
actually you are not generating org mode.

To make an org mode rule, you should replace the call to

coccilib.report.print_report

by a call to

coccilib.org.print_todo

thanks,
julia


On Wed, 16 Mar 2011, Kirill A. Shutemov wrote:

> Use list_move instead of combination of list_del() and list_add()
> 
> Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
> Cc: Julia Lawall <julia@diku.dk>
> Cc: Gilles Muller <Gilles.Muller@lip6.fr>
> Cc: Nicolas Palix <npalix.work@gmail.com>
> Cc: cocci@diku.dk
> ---
>  scripts/coccinelle/api/list/list_move.cocci |   41 +++++++++++++++++++++++++++
>  1 files changed, 41 insertions(+), 0 deletions(-)
>  create mode 100644 scripts/coccinelle/api/list/list_move.cocci
> 
> diff --git a/scripts/coccinelle/api/list/list_move.cocci b/scripts/coccinelle/api/list/list_move.cocci
> new file mode 100644
> index 0000000..2691a8a
> --- /dev/null
> +++ b/scripts/coccinelle/api/list/list_move.cocci
> @@ -0,0 +1,41 @@
> +///
> +/// Use list_move() instead of combination of list_del() and list_add()
> +///
> +// Confidence: High
> +// Copyright: (C) 2011 Kirill A. Shutemov. GPLv2.
> +// Options: -no_includes -include_headers
> +
> +virtual context
> +virtual patch
> +virtual org
> +virtual report
> +
> +@depends on context@
> +expression a, b;
> +@@
> +
> +* list_del(a);
> +* list_add(a, b);
> +
> +@depends on patch@
> +expression a, b;
> +@@
> +
> +- list_del(a);
> +- list_add(a, b);
> ++ list_move(a, b);
> +
> +@r depends on report || org@
> +expression a, b;
> +position p;
> +@@
> +
> + list_del@p(a);
> + list_add(a, b);
> +
> +@script:python depends on org || report@
> +p << r.p;
> +@@
> +
> +msg = "WARNING: list_move() can be used"
> +coccilib.report.print_report(p[0], msg)
> -- 
> 1.7.4.1
> 
> 
