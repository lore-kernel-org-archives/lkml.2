Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932716Ab2B2QOL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 11:14:11 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:55264 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754230Ab2B2QOK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 11:14:10 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of linus.walleij@linaro.org designates 10.50.41.161 as permitted sender) smtp.mail=linus.walleij@linaro.org
MIME-Version: 1.0
In-Reply-To: <1330386909-17723-1-git-send-email-swarren@nvidia.com>
References: <1330386909-17723-1-git-send-email-swarren@nvidia.com>
Date: Wed, 29 Feb 2012 17:14:09 +0100
Message-ID: <CACRpkdZSrXuvcU3fx9m1d+b=MTpCvGetMqaXBhfcX3YXuiOOXg@mail.gmail.com>
Subject: Re: [PATCH V2 1/2] pinctrl: Introduce PINCTRL_STATE_DEFAULT, define
 hogs as that state
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@nvidia.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>, B29396@freescale.com,
        s.hauer@pengutronix.de, dongas86@gmail.com, shawn.guo@linaro.org,
        thomas.abraham@linaro.org, tony@atomide.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 28, 2012 at 12:55 AM, Stephen Warren <swarren@nvidia.com> wrote:

> This provides a single centralized name for the default state.
>
> Update PIN_MAP_* macros to use this state name, instead of requiring the
> user to pass a state name in.
>
> With this change, hog entries in the mapping table are defined as those
> with state name PINCTRL_STATE_DEFAULT, i.e. all entries have the same
> name. This interacts badly with the nested iteration over mapping table
> entries in pinctrl_hog_maps() and pinctrl_hog_map() which would now
> attempt to claim each hog mapping table entry multiple times. Replacing
> the custom hog code with a simple pinctrl_get()/pinctrl_enable().
>
> Update documentation and mapping tables to use this.
>
> Signed-off-by: Stephen Warren <swarren@nvidia.com>
> ---
> v2: Added all the hogging rework now described above; hopefully will solve
> U300 runtime issues.

This is a bit better, I now have my devices but I lost my hogs :-(

Trying to see if I can fix it...

Yours,
Linus Walleij
