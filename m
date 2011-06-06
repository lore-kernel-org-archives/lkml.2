Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756626Ab1FFE4p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 00:56:45 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:43392 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752641Ab1FFE4n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 00:56:43 -0400
Date: Mon, 6 Jun 2011 06:56:37 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Greg Dietsche <Gregory.Dietsche@cuw.edu>
Cc: Gilles.Muller@lip6.fr, npalix.work@gmail.com, cocci@diku.dk,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] coccinelle: if(ret)return ret; return ret; semantic
 patch
In-Reply-To: <1307320012-31292-1-git-send-email-Gregory.Dietsche@cuw.edu>
Message-ID: <Pine.LNX.4.64.1106060656050.7113@ask.diku.dk>
References: <1307320012-31292-1-git-send-email-Gregory.Dietsche@cuw.edu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 5 Jun 2011, Greg Dietsche wrote:

> This semantic patch finds code matching this pattern:
> 	if(ret)
> 		return ret;
> 	return ret;
> 
> I will be submitting patches shortly against the mainline to cleanup all
> code matching this pattern.
> 
> Signed-off-by: Greg Dietsche <Gregory.Dietsche@cuw.edu>
> ---
>  scripts/coccinelle/misc/doublereturn.cocci |   20 ++++++++++++++++++++
>  1 files changed, 20 insertions(+), 0 deletions(-)
>  create mode 100644 scripts/coccinelle/misc/doublereturn.cocci
> 
> diff --git a/scripts/coccinelle/misc/doublereturn.cocci b/scripts/coccinelle/misc/doublereturn.cocci
> new file mode 100644
> index 0000000..656a118
> --- /dev/null
> +++ b/scripts/coccinelle/misc/doublereturn.cocci
> @@ -0,0 +1,20 @@
> +/// Remove unecessary if/return in code that follows this pattern:
> +///	if(retval)
> +///		return retval;
> +///	return retval;
> +//
> +// Confidence: High
> +// Copyright: (C) 2011 Greg Dietsche GPLv2.
> +// URL: http://www.gregd.org
> +// Comments:
> +// Options: -no_includes
> +
> +virtual patch
> +
> +@@

This line should be @depends on patch@

julia

> +identifier retval;
> +@@
> +-if (retval)
> +-	return retval;
> +-return retval;
> ++return retval;
> -- 
> 1.7.2.5
> 
> 
