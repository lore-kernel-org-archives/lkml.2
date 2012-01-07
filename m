Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753156Ab2AGSXf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jan 2012 13:23:35 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:50150 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752969Ab2AGSXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jan 2012 13:23:34 -0500
Date: Sat, 7 Jan 2012 18:23:19 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Thomas Abraham <thomas.abraham@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kgene.kim@samsung.com, lars@metafoo.de, kwangwoo.lee@gmail.com,
        patches@linaro.org, jg1.han@samsung.com, rob.herring@calxeda.com,
        grant.likely@secretlab.ca, cbou@mail.ru, kyungmin.park@samsung.com,
        linux-samsung-soc@vger.kernel.org, rpurdie@rpsys.net,
        ben-linux@fluff.org, broonie@opensource.wolfsonmicro.com,
        augulis.darius@gmail.com
Subject: Re: [PATCH] backlight: lcd: add driver for raster-type lcd's with
	gpio controlled panel reset
Message-ID: <20120107182319.GA13181@n2100.arm.linux.org.uk>
References: <1325778146-27056-1-git-send-email-thomas.abraham@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1325778146-27056-1-git-send-email-thomas.abraham@linaro.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 05, 2012 at 09:12:26PM +0530, Thomas Abraham wrote:
> Add a lcd panel driver for simple raster-type lcd's which uses a gpio
> controlled panel reset. The driver controls the nRESET line of the panel
> using a gpio connected from the host system. The Vcc supply to the panel
> is (optionally) controlled using a voltage regulator. This driver excludes
> support for lcd panels that use a serial command interface or direct
> memory mapped IO interface.

I'm trying to work out what kind of LCD panel this is for.  I assume
not the panels which would be connected to a SoC, which have a parallel
interface to a frame buffer device (LCD controller)?

If this is for these kinds of LCD panels, how are you handling the
timing required for active panels - some of which must not be powered
up without the LCD controller first being setup and enabled, and must
be powered down before the LCD controller is disabled.

I've seen this requirement with panels connected to ARM Ltd's development
boards, and also some SoCs.
