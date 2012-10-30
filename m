Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965657Ab2J3UQ4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 16:16:56 -0400
Received: from li42-95.members.linode.com ([209.123.162.95]:44522 "EHLO
	li42-95.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965249Ab2J3UQx convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 16:16:53 -0400
Subject: Re: [RFC 2/7] capebus: Add beaglebone board support
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
From: Pantelis Antoniou <panto@antoniou-consulting.com>
In-Reply-To: <20121030193939.GR11908@atomide.com>
Date: Tue, 30 Oct 2012 22:16:47 +0200
Cc: linux-arm-kernel@lists.infradead.org, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, Koen Kooi <koen@dominion.thruhere.net>,
        Matt Porter <mporter@ti.com>, Russ Dill <Russ.Dill@ti.com>,
        linux-omap@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <DE47929E-9579-4DD2-B01C-08554D49FADE@antoniou-consulting.com>
References: <1351702333-8456-1-git-send-email-panto@antoniou-consulting.com> <1351702333-8456-3-git-send-email-panto@antoniou-consulting.com> <20121030193939.GR11908@atomide.com>
To: Tony Lindgren <tony@atomide.com>
X-Mailer: Apple Mail (2.1085)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Oct 30, 2012, at 9:39 PM, Tony Lindgren wrote:

> * Pantelis Antoniou <panto@antoniou-consulting.com> [121030 12:00]:
>> +
>> +	priv->lcdc_oh = omap_hwmod_lookup("lcdc");
>> +	if (priv->lcdc_oh == NULL) {
>> +		dev_err(&pdev->dev, "Failed to lookup omap_hwmod lcdc\n");
>> +		return -ENODEV;
>> +	}
>> +
>> +	priv->lcdc_pdev = omap_device_build("da8xx_lcdc", 0, priv->lcdc_oh,
>> +			&priv->lcd_pdata,
>> +			sizeof(struct da8xx_lcdc_platform_data),
>> +			NULL, 0, 0);
>> +	if (priv->lcdc_pdev == NULL) {
>> +		dev_err(&pdev->dev, "Failed to build LCDC device\n");
>> +		return -ENODEV;
>> +	}
> 
> ..and these kind of things need to become private to
> arch/arm/mach-omap2, we already have it working for other
> devices with device tree.
> 
> Regards,
> 
> Tony

I see,

I know that if the device driver is DTified it will pick up the hwmod automatically.
The issue is that the driver is question is not yet; how would I go about
creating the platform device and having it pick up the hwmod automatically?

Regards

-- Pantelis

