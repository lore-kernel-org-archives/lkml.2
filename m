Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754522Ab2BVRSN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 12:18:13 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:37875 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752170Ab2BVRSL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 12:18:11 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of linus.walleij@linaro.org designates 10.43.51.135 as permitted sender) smtp.mail=linus.walleij@linaro.org
MIME-Version: 1.0
In-Reply-To: <1329720360-23227-17-git-send-email-swarren@nvidia.com>
References: <1329720360-23227-1-git-send-email-swarren@nvidia.com>
	<1329720360-23227-17-git-send-email-swarren@nvidia.com>
Date: Wed, 22 Feb 2012 18:18:11 +0100
Message-ID: <CACRpkdY8m2G1secgeun6dUYVSjT0m2u5ZEhvOSp2EYycuZ9A4A@mail.gmail.com>
Subject: Re: [PATCH 16/20] pinctrl: Refactor struct pinctrl handling in core.c
 vs pinmux.c
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

> This change separates two aspects of struct pinctrl:
>
> a) The data representation of the parsed mapping table, into:
>
>   1) The top-level struct pinctrl object, a single entity returned
>      by pinctrl_get().
>
>   2) The parsed version of each mapping table entry, struct
>      pinctrl_setting, of which there is one per mapping table entry.
>
> b) The code that handles this; the code for (1) above is in core.c, and
>   the code to parse/execute each entry in (2) above is in pinmux.c, while
>   the iteration over multiple settings is lifted to core.c.
>
> This will allow the following future changes:
>
> 1) pinctrl_get() API rework, so that struct pinctrl represents all states
>   for the device, and the device can select between them without calling
>   put()/get() again.
>
> 2) To support that, a struct pinctrl_state object will be inserted into
>   the data model between the struct pinctrl and struct pinctrl_setting.
>
> 3) The mapping table will be extended to allow specification of pin config
>   settings too. To support this, struct pinctrl_setting will be enhanced
>   to store either mux settings or config settings, and functions will be
>   added to pinconf.c to parse/execute pin configuration settings.
>
> Signed-off-by: Stephen Warren <swarren@nvidia.com>

This is elegant and exactly what we want to do.

Please rebase on top of well, whatever we agree upon for
handling the get(NULL) case, and we're set to merge this
too.

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Thanks,
Linus Walleij
