Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932930Ab1ELWWF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 18:22:05 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:36843 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932786Ab1ELWWD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 18:22:03 -0400
Date: Thu, 12 May 2011 23:21:57 +0100
From: Jamie Iles <jamie@jamieiles.com>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Jamie Iles <jamie@jamieiles.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        grant.likely@secretlab.ca
Subject: Re: [RFC PATCH 0/3] Use basic_mmio_gpio to implement a generic gpio
 chip
Message-ID: <20110512222157.GH8718@pulham.picochip.com>
References: <0D753D10438DA54287A00B027084269764D2D09197@AUSP01VMBX24.collaborationhost.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0D753D10438DA54287A00B027084269764D2D09197@AUSP01VMBX24.collaborationhost.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hartley,

On Thu, May 12, 2011 at 12:35:06PM -0500, H Hartley Sweeten wrote:
> On Wed May 05 2011, Jamie Iles wrote:
> > This series is based on my earlier set of GPIO patches[1] to extend the
> > basic_mmio_driver to be used as a library to implement a more generic gpio
> > chip as initially implemented by Anton Vorontsov[2].
> > 
> > I've modified Anton's patch slightly to allow the bgpio_chip to be embedded
> > into another structure and converted two drivers over - bt8xxgpio and
> > langwell. bt8xxgpio seems to play nicely, but langwell not so much as it
> > didn't previously use a gpio_chip per bank but it is a nice illustration.
> > 
> > Note that this is the same set of patches as attached in "Re: [PATCHv3 0/7]
> > gpio: extend basic_mmio_gpio for different controllers" but reposted as a set
> > of patches for convenience.
> > 
> > 1. http://article.gmane.org/gmane.linux.kernel/1124700
> > 2. http://lkml.org/lkml/2011/4/19/401
> > 
> > Jamie Iles (3):
> > basic_mmio_gpio: split into a gpio library and platform device
> > gpio/bt8xxgpio: convert to use basic_mmio_gpio library
> > gpio/langwell: convert to use basic_mmio_gpio library
> > 
> > drivers/gpio/Kconfig | 8 +
> > drivers/gpio/Makefile | 1 +
> > drivers/gpio/basic_mmio_gpio.c | 317 +++++++++++++++++++++------------------
> > drivers/gpio/bt8xxgpio.c | 119 +++------------
> > drivers/gpio/langwell_gpio.c | 253 +++++++++++++++----------------
> > include/linux/basic_mmio_gpio.h | 55 +++++++
> > 6 files changed, 381 insertions(+), 372 deletions(-)
> 
> Hello Jamie,
> 
> I was wondering on the status of this patch series, and Anton's for that matter.
> 
> I think I can convert the ep93xx gpio support to use this basic_mmio_gpio library
> but would like to make sure I have seen all the relevant patches.  Is there any
> plan on someone getting this into linux-next?

I'm not too sure - I think Grant has taken the patches that this was 
dependent on, and there is still the issue that both yourself and Anton 
noticed (not actually adding the gpio_chip [Doh]), but other than that I 
haven't seen any other feedback.

If this made a positive difference for ep93xx then I'm sure this would 
help!

Jamie
