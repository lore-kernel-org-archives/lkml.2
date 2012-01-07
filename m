Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752798Ab2AGR2b (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jan 2012 12:28:31 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:44910 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752602Ab2AGR2a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jan 2012 12:28:30 -0500
Date: Sat, 7 Jan 2012 17:28:28 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Thomas Abraham <thomas.abraham@linaro.org>
Cc: Lars-Peter Clausen <lars@metafoo.de>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, rpurdie@rpsys.net,
        linux-samsung-soc@vger.kernel.org, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, kgene.kim@samsung.com, jg1.han@samsung.com,
        kyungmin.park@samsung.com, cbou@mail.ru, kwangwoo.lee@gmail.com,
        augulis.darius@gmail.com, ben-linux@fluff.org, patches@linaro.org
Subject: Re: [PATCH] backlight: lcd: add driver for raster-type lcd's with
	gpio controlled panel reset
Message-ID: <20120107172826.GA355@opensource.wolfsonmicro.com>
References: <1325778146-27056-1-git-send-email-thomas.abraham@linaro.org> <4F05F509.6020405@metafoo.de> <20120106064929.GB3496@opensource.wolfsonmicro.com> <CAJuYYwRxuZAm_JpLw1fN2ypnFc6TocH6veRmCeuqENvZHSz3kg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJuYYwRxuZAm_JpLw1fN2ypnFc6TocH6veRmCeuqENvZHSz3kg@mail.gmail.com>
X-Cookie: You dialed 5483.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 07, 2012 at 04:34:34PM +0530, Thomas Abraham wrote:
> On 6 January 2012 12:19, Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:

> > In principle it should be specified in both places to account for shared
> > supplies though for all practical purposes for an LCD panel I can't see
> > multiple users sharing the same regulator and varying the voltage at
> > runtime.

> It is assumed here that the boot loader as not set the output voltage
> of the regulator that supports variable voltage ranges. So these
> values help in setting up the regulator for LCD display.

Remember that the regulator API won't allow consumers to configure
voltages unless there are constraints granting permission.  Users will
need to set both the LCD vales and the regulator constraints values to
actually allow configuration to happen.
