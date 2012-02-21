Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755207Ab2BUN3K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 08:29:10 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:38224 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753804Ab2BUN3I convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 08:29:08 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of festevam@gmail.com designates 10.14.28.71 as permitted sender) smtp.mail=festevam@gmail.com; dkim=pass header.i=festevam@gmail.com
MIME-Version: 1.0
In-Reply-To: <1329826410-21739-1-git-send-email-michael.thalmeier@hale.at>
References: <1329826410-21739-1-git-send-email-michael.thalmeier@hale.at>
Date: Tue, 21 Feb 2012 11:29:07 -0200
Message-ID: <CAOMZO5BGVa0HRKqv9nKQUy9iGnQ3FV_6OnguMyk3rAinaJkb6w@mail.gmail.com>
Subject: Re: [PATCH] i.MX31: mxc-rnga: implement waiting for data in driver
From: Fabio Estevam <festevam@gmail.com>
To: Michael Thalmeier <michael.thalmeier@hale.at>
Cc: Matt Mackall <mpm@selenic.com>, Sascha Hauer <s.hauer@pengutronix.de>,
        linux-arm-kernel@lists.infradead.org, michael@thalmeier.at,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 21, 2012 at 10:13 AM, Michael Thalmeier
<michael.thalmeier@hale.at> wrote:

> -static int mxc_rnga_data_present(struct hwrng *rng)
> +static int mxc_rnga_data_present(struct hwrng *rng, int wait)

This looks good, but ...

>  {
> -       int level;
> +       int level, i;
>        void __iomem *rng_base = (void __iomem *)rng->priv;
>
> -       /* how many random numbers is in FIFO? [0-16] */
> -       level = ((__raw_readl(rng_base + RNGA_STATUS) &
> -                       RNGA_STATUS_LEVEL_MASK) >> 8);
> +       for (i = 0; i < 20; i++) {

Why the magic "20" here?

It would be better to add a proper timeout mechanism instead, such as
time_after(jiffies, timeout)
