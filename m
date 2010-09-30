Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754786Ab0I3GwH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 02:52:07 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:54801 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751583Ab0I3GwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 02:52:05 -0400
Date: Thu, 30 Sep 2010 08:52:02 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Sascha Hauer <s.hauer@pengutronix.de>
Subject: Re: linux-next: manual merge of the sound-asoc tree with the i.MX
	tree
Message-ID: <20100930065202.GK29811@pengutronix.de>
References: <20100930112302.e554d367.sfr@canb.auug.org.au> <20100930064140.GI29811@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100930064140.GI29811@pengutronix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Sep 30, 2010 at 08:41:40AM +0200, Uwe Kleine-König wrote:
> On Thu, Sep 30, 2010 at 11:23:02AM +1000, Stephen Rothwell wrote:
> > Hi all,
> > 
> > Today's linux-next merge of the sound-asoc tree got a conflict in
> > arch/arm/mach-mx3/devices.c between commit
> > 4697bb926f43b8012ebd111ef43834f42126a0ef ("ARM: imx: dynamically allocate
> > imx-ssi devices") from the i.MX tree and commit
> > f0fba2ad1b6b53d5360125c41953b7afcd6deff0 ("ASoC: multi-component - ASoC
> > Multi-Component Support") from the sound-asoc tree.
> > 
> > The former removed that code that the latter changed.  I just used the
> > former.
> > 
> > The latter was just changing some names, so ti may be able to be
> > integrated into the former.
> I think the same problem exists for mx2.  Maybe git didn't notice as
> arch/arm/mach-mx2/devices.c was moved to arch/arm/mach-imx/devices.c
> (and merged with arch/arm/mach-mx1/devices.c)?!
> 
> I didn't test, but I guess we need the following patch squashed into the
> merge:
> 
> diff --git a/arch/arm/plat-mxc/devices/platform-imx-ssi.c b/arch/arm/plat-mxc/devices/platform-imx-ssi.c
> index 38a7a0b..6d74a25 100644
> --- a/arch/arm/plat-mxc/devices/platform-imx-ssi.c
> +++ b/arch/arm/plat-mxc/devices/platform-imx-ssi.c
> @@ -101,7 +101,7 @@ struct platform_device *__init imx_add_imx_ssi(
>  		DMARES(rx1),
>  	};
>  
> -	return imx_add_platform_device("imx-ssi", data->id,
> +	return imx_add_platform_device("imx-ssi-dai", data->id,
>  			res, ARRAY_SIZE(res),
>  			pdata, sizeof(*pdata));
>  }
I just noticed there are some more problems:

	ukl@octopus:~/gsrc/linux-2.6$ git grep \"imx-ssi[^-] next/master -- arch/arm/mach-{imx,mx*}
	next/master:arch/arm/mach-imx/clock-imx27.c:    _REGISTER_CLOCK("imx-ssi.0", NULL, ssi1_clk)
	next/master:arch/arm/mach-imx/clock-imx27.c:    _REGISTER_CLOCK("imx-ssi.1", NULL, ssi2_clk)
	next/master:arch/arm/mach-mx25/clock.c: _REGISTER_CLOCK("imx-ssi.0", NULL, ssi1_clk)
	next/master:arch/arm/mach-mx25/clock.c: _REGISTER_CLOCK("imx-ssi.1", NULL, ssi2_clk)
	next/master:arch/arm/mach-mx5/clock-mx51.c:     _REGISTER_CLOCK("imx-ssi.0", NULL, ssi1_clk)
	next/master:arch/arm/mach-mx5/clock-mx51.c:     _REGISTER_CLOCK("imx-ssi.1", NULL, ssi2_clk)

The change to clock-imx27.c got lost similar to mx2/devices.c.  When
f0fba2ad1b6b53d5360125c41953b7afcd6deff0 was commited
arch/arm/mach-mx5/clock-mx51.c and arch/arm/mach-mx25/clock.c didn't
contain the clock for imx-ssi, yet.

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
