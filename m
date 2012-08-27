Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752328Ab2H0F5f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 01:57:35 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:37241 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751760Ab2H0F5d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 01:57:33 -0400
MIME-Version: 1.0
In-Reply-To: <1345996865-32082-6-git-send-email-Julia.Lawall@lip6.fr>
References: <1345996865-32082-1-git-send-email-Julia.Lawall@lip6.fr>
	<1345996865-32082-6-git-send-email-Julia.Lawall@lip6.fr>
Date: Mon, 27 Aug 2012 11:27:33 +0530
Message-ID: <CADTbHxqm9Nktcn++-+GFqX8n_CwNzgp79XRJGf21-eDgtm8jsg@mail.gmail.com>
Subject: Re: [PATCH 5/13] arch/arm: use clk_prepare_enable and clk_disable_unprepare
From: Pankaj Jangra <jangra.pankaj9@gmail.com>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: Russell King <linux@arm.linux.org.uk>, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, Aug 26, 2012 at 9:30 PM, Julia Lawall <Julia.Lawall@lip6.fr> wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
>
> Clk_prepare_enable and clk_disable_unprepare combine clk_prepare and
> clk_enable, and clk_disable and clk_unprepare.  They make the code more
> concise, and ensure that clk_unprepare is called when clk_enable fails.
>
> A simplified version of the semantic patch that introduces calls to these
> functions is as follows: (http://coccinelle.lip6.fr/)
>
> // <smpl>
> @@
> expression e;
> @@
>
> - clk_prepare(e);
> - clk_enable(e);
> + clk_prepare_enable(e);
>
> @@
> expression e;
> @@
>
> - clk_disable(e);
> - clk_unprepare(e);
> + clk_disable_unprepare(e);
> // </smpl>
>
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
>
> ---
>  arch/arm/common/sa1111.c   |    3 +--
>  arch/arm/common/timer-sp.c |   16 ++++------------
>  arch/arm/kernel/smp_twd.c  |   13 +++----------
>  3 files changed, 8 insertions(+), 24 deletions(-)
>

Reviewed-by: Pankaj Jangra <jangra.pankaj9@gmail.com>

Regards,
Pankaj Jangra
