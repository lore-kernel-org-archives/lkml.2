Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756592Ab2J3X5W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 19:57:22 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:57892 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755863Ab2J3X5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 19:57:21 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+c7EV5kZWGFT6M7HlHepl/
Date: Tue, 30 Oct 2012 16:57:15 -0700
From: Tony Lindgren <tony@atomide.com>
To: Pantelis Antoniou <panto@antoniou-consulting.com>
Cc: linux-arm-kernel@lists.infradead.org, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, Koen Kooi <koen@dominion.thruhere.net>,
        Matt Porter <mporter@ti.com>, Russ Dill <Russ.Dill@ti.com>,
        linux-omap@vger.kernel.org
Subject: Re: [RFC 2/7] capebus: Add beaglebone board support
Message-ID: <20121030235714.GB12739@atomide.com>
References: <1351702333-8456-1-git-send-email-panto@antoniou-consulting.com>
 <1351702333-8456-3-git-send-email-panto@antoniou-consulting.com>
 <20121030193939.GR11908@atomide.com>
 <DE47929E-9579-4DD2-B01C-08554D49FADE@antoniou-consulting.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DE47929E-9579-4DD2-B01C-08554D49FADE@antoniou-consulting.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Pantelis Antoniou <panto@antoniou-consulting.com> [121030 13:18]:
> On Oct 30, 2012, at 9:39 PM, Tony Lindgren wrote:
> 
> > * Pantelis Antoniou <panto@antoniou-consulting.com> [121030 12:00]:
> >> +
> >> +	priv->lcdc_oh = omap_hwmod_lookup("lcdc");
> >> +	if (priv->lcdc_oh == NULL) {
> >> +		dev_err(&pdev->dev, "Failed to lookup omap_hwmod lcdc\n");
> >> +		return -ENODEV;
> >> +	}
> >> +
> >> +	priv->lcdc_pdev = omap_device_build("da8xx_lcdc", 0, priv->lcdc_oh,
> >> +			&priv->lcd_pdata,
> >> +			sizeof(struct da8xx_lcdc_platform_data),
> >> +			NULL, 0, 0);
> >> +	if (priv->lcdc_pdev == NULL) {
> >> +		dev_err(&pdev->dev, "Failed to build LCDC device\n");
> >> +		return -ENODEV;
> >> +	}
> > 
> > ..and these kind of things need to become private to
> > arch/arm/mach-omap2, we already have it working for other
> > devices with device tree.
> > 
> > Regards,
> > 
> > Tony
> 
> I see,
> 
> I know that if the device driver is DTified it will pick up the hwmod automatically.
> The issue is that the driver is question is not yet; how would I go about
> creating the platform device and having it pick up the hwmod automatically?

Maybe you should make this DT only driver for omap? We already
have am33xx DT only to start with.

If you really need the platform device still, just take a look
at the many platform device creating files under arch/arm/mach-omap2.

Regards,

Tony
