Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753242Ab2DWFRg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 01:17:36 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:34024 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752167Ab2DWFRe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 01:17:34 -0400
Date: Mon, 23 Apr 2012 13:18:21 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Rob Lee <rob.lee@linaro.org>
Cc: Sascha Hauer <s.hauer@pengutronix.de>,
        Amit Kucheria <amit.kucheria@linaro.org>, kernel@pengutronix.de,
        linaro-dev@lists.linaro.org, patches@linaro.org,
        daniel.lezcano@linaro.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/3] ARM: imx: Add common imx cpuidle init functionality.
Message-ID: <20120423051813.GM26306@S2101-09.ap.freescale.net>
References: <1334620214-25803-1-git-send-email-rob.lee@linaro.org>
 <1334620214-25803-2-git-send-email-rob.lee@linaro.org>
 <20120417074301.GM20478@pengutronix.de>
 <CAMXH7KH41kWMPu_dEpetZc8OUD3C0-mtxGbXX0Vqd4EODPWJUg@mail.gmail.com>
 <20120417174213.GD3852@pengutronix.de>
 <CAMXH7KFYA24sPUcwgKfwVLNPA0jWQ-QG02y+SfPNnAqdiv0+gg@mail.gmail.com>
 <CAMXH7KGgSmvfqUTC1bufBz0QXbt01dHsPo1cbRA9jLj9mGmfjg@mail.gmail.com>
 <20120419064308.GH3852@pengutronix.de>
 <20120420020816.GH22219@S2101-09.ap.freescale.net>
 <CAMXH7KE2RtdNy3G61guZb2uWy3rn267Z3eEVEgN5e==tHHsiuA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMXH7KE2RtdNy3G61guZb2uWy3rn267Z3eEVEgN5e==tHHsiuA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 22, 2012 at 11:44:39PM -0500, Rob Lee wrote:
> >> I don't think we need a cpu_is_imx6q(), but having some i.MX6 specific
> >> hook at device_initcall time can't be too wrong. Shawn?
> >>
> > Yep, it works for me.
> >
> Sascha, Shawn, thanks for the response.
> 
> Since device_initcall isn't platform specific, it seems I would still
> need a cpu_is_imx6q() function or similiar functionality from a device
> tree call.  Or do you have something else in mind that I'm not seeing?
> 
I guess Sascha is asking for something like the following.

static int __init imx_device_init(void)
{
	imx5_device_init();
	imx6_device_init();
}
device_initcall(imx_device_init)

static int __init imx6_device_init(void)
{
	/*
	 * do whatever needs to get done in device_initcall time
	 */
}

-- 
Regards,
Shawn
