Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933711Ab2GFX1n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 19:27:43 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60298 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756537Ab2GFX1l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 19:27:41 -0400
Date: Fri, 6 Jul 2012 16:27:37 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Eduardo Valentin <eduardo.valentin@ti.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org, j-keerthy@ti.com,
        grant.likely@secretlab.ca, b-cousson@ti.com, kbaidarov@dev.rtsoft.ru
Subject: Re: [PATCH 1/4] staging: OMAP4+: thermal: introduce bandgap
 temperature sensor
Message-ID: <20120706232737.GA18598@kroah.com>
References: <1341355030-20800-1-git-send-email-eduardo.valentin@ti.com>
 <1341355030-20800-2-git-send-email-eduardo.valentin@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1341355030-20800-2-git-send-email-eduardo.valentin@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 04, 2012 at 01:37:07AM +0300, Eduardo Valentin wrote:
> In the System Control Module, OMAP supplies a voltage reference
> and a temperature sensor feature that are gathered in the band
> gap voltage and temperature sensor (VBGAPTS) module. The band
> gap provides current and voltage reference for its internal
> circuits and other analog IP blocks. The analog-to-digital
> converter (ADC) produces an output value that is proportional
> to the silicon temperature.
> 
> This patch provides a platform driver which expose this feature.
> It is moduled as a MFD child of the System Control Module core
> MFD driver.
> 
> This driver provides only APIs to access the device properties,
> like temperature, thresholds and update rate.
> 
> Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
> Signed-off-by: Keerthy <j-keerthy@ti.com>
> ---
>  drivers/staging/Kconfig                       |    2 +
>  drivers/staging/Makefile                      |    1 +

By not including the files these files "include" you just broke the
build at this point in the patch series, which isn't good.

Care to redo this series, so that it can build at each step of the way
(you might do this by just adding the Kconfig and Makefile entries as
the last patch), and then I will be glad to apply it to the tree.

Oh, and yes, this implies that I have no problem taking this driver for
the staging tree :)

thanks,

greg k-h
