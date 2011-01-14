Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753807Ab1ANWFU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 17:05:20 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:40823 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752811Ab1ANWFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 17:05:17 -0500
Date: Fri, 14 Jan 2011 21:48:24 +0000
From: Jamie Iles <jamie@jamieiles.com>
To: Alexander Clouter <alex@digriz.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCHv2] hwrng: add support for picoxcell TRNG
Message-ID: <20110114214824.GO2822@pulham.picochip.com>
References: <20110114181609.GN2822@pulham.picochip.com>
 <1295030661-16364-1-git-send-email-jamie@jamieiles.com>
 <v7p608-mqv.ln1@chipmunk.wormnet.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <v7p608-mqv.ln1@chipmunk.wormnet.eu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 14, 2011 at 08:45:19PM +0000, Alexander Clouter wrote:
> In gmane.linux.ports.arm.kernel Jamie Iles <jamie@jamieiles.com> wrote:
> >
> > This driver adds support for the True Random Number Generator in
> > the Picochip PC3X3 and later devices.
> > 
> > [snipped]
> >
> > +/*
> > + * Take the random number generator out of reset and make sure the interrupts
> > + * are masked. We shouldn't need to get large amounts of random bytes so just
> > + * poll the status register. The hardware generates 32 bits every 320ns so we
> > + * shouldn't have to wait long enough to warrant waiting for an IRQ.
> > + */
> >
> timeriomem-rng?  Example of usage in 
> arch/arm/mach-orion5x/ts78xx-setup.c.

No, that's not quite suitable for our hardware.  Although the hardware 
generates the data every 320ns, it also performs self test of the data 
in hardware to make sure it satisfies certain random qualities.  If the 
data doesn't pass the tests then it's rejected and not placed into the 
FIFO so we'd have the possibility of an underflow with the 
timeriomem-rng driver.

Jamie
