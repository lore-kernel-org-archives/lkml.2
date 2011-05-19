Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932445Ab1ESVEk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 17:04:40 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59872 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752177Ab1ESVEj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 17:04:39 -0400
Date: Thu, 19 May 2011 14:04:41 -0700
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH] mfd wm8350: allocate irq descs dynamically
Message-ID: <20110519210440.GA18849@opensource.wolfsonmicro.com>
References: <20110519185648.GR30963@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110519185648.GR30963@pengutronix.de>
X-Cookie: You have no real enemies.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 19, 2011 at 08:56:48PM +0200, Sascha Hauer wrote:

> -	if (!pdata || !pdata->irq_base) {
> -		dev_warn(wm8350->dev, "No interrupt support, no IRQ base\n");
> +	if (!pdata) {
> +		dev_warn(wm8350->dev, "No interrupt support, no platform data\n");

This isn't terribly good, the only reason we're checking pdata here is
because we can't dereference it to look up irq_base if it's not there.
