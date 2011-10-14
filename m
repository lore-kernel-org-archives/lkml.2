Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933009Ab1JNTdS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 15:33:18 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51747 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752030Ab1JNTdR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 15:33:17 -0400
Date: Fri, 14 Oct 2011 20:33:14 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org, zdevai@gmail.com,
        linus.walleij@linaro.org
Subject: Re: [PATCH] staging:iio:proof of concept in kernel interface.
Message-ID: <20111014193314.GE2931@opensource.wolfsonmicro.com>
References: <1318333383-17663-1-git-send-email-jic23@cam.ac.uk>
 <1318333383-17663-2-git-send-email-jic23@cam.ac.uk>
 <20111013143224.GO1098@sirena.org.uk>
 <4E96F9AC.9000001@cam.ac.uk>
 <20111013204410.GA17160@sirena.org.uk>
 <4E985C60.9020308@cam.ac.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E985C60.9020308@cam.ac.uk>
X-Cookie: Chess tonight.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 14, 2011 at 04:59:28PM +0100, Jonathan Cameron wrote:

> I'm trying to work out what our equivalent of the clk finding api is.

> The best match pair to match on I can come up with is:

> part name: iio_dev.name

> dev_name of underlying hardware if specified.
> dev_name(iio_dev->dev.parent)
> This matching source can be overridden by an optional callback if we
> unique matching is achievable in some other way for the device.

For the existing APIs doing this the device used for the request is the
client device, not the providing device.  The APIs then have a mapping
table (clkdev for most of the clk APIs) which means that boards can then
assign providers to users without needing either of the drivers to know
what's going on, though of course they can be coded that way.
