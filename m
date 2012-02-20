Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754513Ab2BTVP0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 16:15:26 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:52195 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754507Ab2BTVPW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 16:15:22 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of linus.walleij@linaro.org designates 10.43.51.135 as permitted sender) smtp.mail=linus.walleij@linaro.org
MIME-Version: 1.0
In-Reply-To: <1329720360-23227-5-git-send-email-swarren@nvidia.com>
References: <1329720360-23227-1-git-send-email-swarren@nvidia.com>
	<1329720360-23227-5-git-send-email-swarren@nvidia.com>
Date: Mon, 20 Feb 2012 22:15:21 +0100
Message-ID: <CACRpkdYCkRrvt+2B2nzAR+4XTeZo=N+OVA49TuExHCwsLAExwg@mail.gmail.com>
Subject: Re: [PATCH 04/20] pinctrl: Record a pin owner, not mux function, when
 requesting pins
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

> When pins are requested/acquired/got, some device becomes the owner of
> their mux setting. At this point, it isn't certain which mux function
> will be selected for the pin, since this may vary between each of the
> device's states in the pinctrl mapping table. As such, we should record
> the owning device, not what we think the initial mux setting will be,
> when requesting pins.
>
> This doesn't make a lot of difference right now since pinctrl_get gets
> only one single device/state combination, but this will make a difference
> when pinctrl_get gets all states, and pinctrl_select_state can switch
> between states.
>
> Signed-off-by: Stephen Warren <swarren@nvidia.com>

Mostly a rename then, OK...

> @@ -66,19 +65,14 @@ static int pin_request(struct pinctrl_dev *pctldev,
>                goto out;
>        }
>
> -       if (!function) {
> -               dev_err(pctldev->dev, "no function name given\n");
> -               return -EINVAL;
> -       }
> -

Why should it be allowed to have a NULL owner? There is a
debug print involving it above but ... maybe this is over-cautious?

Yours,
Linus Walleij
