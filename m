Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753960Ab0K2UyR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 15:54:17 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:57433 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752255Ab0K2UyQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 15:54:16 -0500
Date: Mon, 29 Nov 2010 21:54:10 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Jonathan Corbet <corbet@lwn.net>
cc: linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>
Subject: Re: [PATCH/RFC] core: add a function to safely try to get device
 driver owner
In-Reply-To: <20101129131737.3dd6eb03@bike.lwn.net>
Message-ID: <Pine.LNX.4.64.1011292147540.27962@axis700.grange>
References: <Pine.LNX.4.64.1011292043000.27962@axis700.grange>
 <20101129131737.3dd6eb03@bike.lwn.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:q3UeGbT3Vf0P0dIPu57oHdVyJyZLeMmhaEiVTdNld10
 TViiQangwhqEOjKBcLdZcFeN10/9k7Fg/xDWXyKX78qXsAOmP0
 YOCyCkIaChA5XfP41O22edgrrWaTwF7EDlB1eeTBUbmsNgNuEX
 EOvgeKob40CEd2Y4tiS7+RxpoO4a7pxowIDAuVnLDXHZg24/qV
 jlDb7IepnkJKaPF6MAv0/UWBymON+KUhyIzHqhIfpg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jon

On Mon, 29 Nov 2010, Jonathan Corbet wrote:

> On Mon, 29 Nov 2010 20:43:28 +0100 (CET)
> Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:
> 
> > When two drivers interoperate without an explicit dependency, it is often
> > required to prevent one of them from being unloaded safely by dereferencing
> > dev->driver->owner. This patch provides a generic function to do this in a
> > race-free way.
> 
> I must ask: why not, instead, make the dependency explicit?  In
> particular, this looks like an application for the proposed media
> controller code, which is meant to model the connections between otherwise
> independent devices.  The fact that your example comes from V4L2 (which is
> the current domain of the media controller) also argues that way.

Sorry, don't see a good way to do this. This function is for a general 
dependency, where you don't have that driver, we are checking for register 
with us, so, the only way to get to it is via dev->driver->owner. And I 
also don't want to move registering the device into the dependant driver 
and then wait (with a timeout) for a driver to probe with it... I just 
want to verify, whether a driver has attached to that device and whether I 
can lock it down.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
