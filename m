Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754507Ab2HTQYv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 12:24:51 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54288 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753789Ab2HTQYt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 12:24:49 -0400
Date: Mon, 20 Aug 2012 11:24:44 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Dave Airlie <airlied@gmail.com>, Daniel Vetter <daniel@ffwll.ch>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, Andreas Heider <andreas@meetr.de>
Subject: Re: [RFC PATCH 7/7] drm/pci: Defer initialization of secondary
 graphics devices until switcheroo is ready
Message-ID: <20120820162444.GG11013@thinkpad-t410>
Mail-Followup-To: Matthew Garrett <mjg59@srcf.ucam.org>,
	Dave Airlie <airlied@gmail.com>, Daniel Vetter <daniel@ffwll.ch>,
	David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org, Andreas Heider <andreas@meetr.de>
References: <20120806045150.GA23652@thinkpad-t410>
 <1345476664-22066-1-git-send-email-seth.forshee@canonical.com>
 <1345476664-22066-8-git-send-email-seth.forshee@canonical.com>
 <20120820153640.GA29614@srcf.ucam.org>
 <20120820155633.GF11013@thinkpad-t410>
 <20120820155740.GA30611@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120820155740.GA30611@srcf.ucam.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 20, 2012 at 04:57:41PM +0100, Matthew Garrett wrote:
> On Mon, Aug 20, 2012 at 10:56:33AM -0500, Seth Forshee wrote:
> > On Mon, Aug 20, 2012 at 04:36:40PM +0100, Matthew Garrett wrote:
> > > Won't this break the multiple cards with independent outputs case?
> > 
> > Yes, if they don't have a switcheroo handler. I only have experience
> > with one such machine, which had optimus graphics. My recollection is
> > that it did have a switcheroo handler, which was only capable of
> > controlling power to the discrete card.
> 
> So if I have a desktop machine and install two graphics cards?

Yeah, that would likely be broken.

I'm not sure how we support both of these cases without doing something
more like what I originally proposed, i.e. registering the LVDS
connector even if it doesn't look like a panel is attached. I still
honestly favor that approach, although it does come with its own set of
challenges.

The only other option I can come up with is to reprobe LVDS after
switcheroo and add the connector at that time. I haven't investigated
this option in detail, but at first glance it looks like there are at
least some places where DRM isn't prepared to cope with adding
connectors after initialization.

