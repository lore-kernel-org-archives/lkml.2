Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754608Ab2BVRVT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 12:21:19 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:63619 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751882Ab2BVRVS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 12:21:18 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of linus.walleij@linaro.org designates 10.50.11.129 as permitted sender) smtp.mail=linus.walleij@linaro.org
MIME-Version: 1.0
In-Reply-To: <1329720360-23227-18-git-send-email-swarren@nvidia.com>
References: <1329720360-23227-1-git-send-email-swarren@nvidia.com>
	<1329720360-23227-18-git-send-email-swarren@nvidia.com>
Date: Wed, 22 Feb 2012 18:21:17 +0100
Message-ID: <CACRpkdYJ-ToMZav-sVgJGRxQsXPM38tFvSXsK-YqcDtOCF=7wQ@mail.gmail.com>
Subject: Re: [PATCH 17/20] pinctrl: Add usecount to pins for muxing
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@nvidia.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>, B29396@freescale.com,
        s.hauer@pengutronix.de, dongas86@gmail.com, shawn.guo@linaro.org,
        thomas.abraham@linaro.org, tony@atomide.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 20, 2012 at 7:45 AM, Stephen Warren <swarren@nvidia.com> wrote:

> Multiple mapping table entries could reference the same pin, and hence
> "own" it. This would be unusual now that pinctrl_get() represents a single
> state for a client device, but in the future when it represents all known
> states for a device, this is quite likely. Implement reference counting
> for pin ownership to handle this.
>
> Signed-off-by: Stephen Warren <swarren@nvidia.com>

Seems like a good straight-forward way to solve this.

> diff --git a/drivers/pinctrl/core.h b/drivers/pinctrl/core.h
> index 1290995..64ae1b8 100644
> --- a/drivers/pinctrl/core.h
> +++ b/drivers/pinctrl/core.h
> @@ -92,6 +92,7 @@ struct pin_desc {
>        bool dynamic_name;
>        /* These fields only added when supporting pinmux drivers */
>  #ifdef CONFIG_PINMUX
> +       unsigned usecount;

kerneldoc for this? Preferably verbose...

Thanks,
Linus Walleij
