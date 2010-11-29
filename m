Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754457Ab0K2Poe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 10:44:34 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:34611 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750707Ab0K2Pod (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 10:44:33 -0500
Date: Mon, 29 Nov 2010 15:44:18 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Alberto Panizzo <maramaopercheseimorto@gmail.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Magnus Damm <damm@opensource.se>, M?rton N?meth <nm127@freemail.hu>,
        linux-media@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] soc_camera: Add the ability to bind regulators to
	soc_camedra devices
Message-ID: <20101129154416.GA30926@sirena.org.uk>
References: <1290964687.3016.5.camel@realization> <Pine.LNX.4.64.1011281923440.5731@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1011281923440.5731@axis700.grange>
X-Cookie: f u cn rd ths, u r prbbly a lsy spllr.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 28, 2010 at 08:05:06PM +0100, Guennadi Liakhovetski wrote:
> On Sun, 28 Nov 2010, Alberto Panizzo wrote:

> > In certain machines, camera devices are supplied directly
> > by a number of regulators. This patch add the ability to drive
> > these regulators directly by the soc_camera driver.

> IIRC, there has been a discussion a while ago, how to supply power to 
> cameras by regulators. Someone has tried to provide a .power() hook in the 
> platform code, but the problem was the order of driver loading / probing. 
> So, how about doing the following:

> 1. in your platform code you register a notifier like
> 	bus_register_notifier(&soc_camera_bus_type, &cam_notifier);

FWIW I'm looking at implementing a standard regulator API feature along
these lines in the background.  This should hopefully mean we don't need
driver support for most simple power control applications.  No ETA yet.

> The reasons why I do not want to add this to the core are: (1) I do not 
> want to have two methods for turning power on and off: a platform provided 
> .power() hook and and a set of regulators, (2) would anyone really want to 
> use several regulators for a camera sensor? If so, can it be the case, 
> that, for example, the regulators have to be switched off in the reverse 
> order to switching on? Or something else? (3) regulators can often do 
> more, than just set one of two power levels - for on and off. What if a 
> need arises to use other voltages?

The way MMC handled this was to provide a standard version of the hook
in the core which could be used by platforms with regulators supplying
the device - they just assign the appropriate function as their power()
operation AIUI.  That seems a fairly clean way of keeping stuff in the
core without giving up the flexibility.

> Is there any really good reason, why we _have_ to do this in soc-camera 
> core?

It does save everyone open coding stuff.
