Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753657Ab2HTP4m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 11:56:42 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54137 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752038Ab2HTP4j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 11:56:39 -0400
Date: Mon, 20 Aug 2012 10:56:33 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Dave Airlie <airlied@gmail.com>, Daniel Vetter <daniel@ffwll.ch>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, Andreas Heider <andreas@meetr.de>
Subject: Re: [RFC PATCH 7/7] drm/pci: Defer initialization of secondary
 graphics devices until switcheroo is ready
Message-ID: <20120820155633.GF11013@thinkpad-t410>
Mail-Followup-To: Matthew Garrett <mjg59@srcf.ucam.org>,
	Dave Airlie <airlied@gmail.com>, Daniel Vetter <daniel@ffwll.ch>,
	David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org, Andreas Heider <andreas@meetr.de>
References: <20120806045150.GA23652@thinkpad-t410>
 <1345476664-22066-1-git-send-email-seth.forshee@canonical.com>
 <1345476664-22066-8-git-send-email-seth.forshee@canonical.com>
 <20120820153640.GA29614@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120820153640.GA29614@srcf.ucam.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 20, 2012 at 04:36:40PM +0100, Matthew Garrett wrote:
> On Mon, Aug 20, 2012 at 10:31:04AM -0500, Seth Forshee wrote:
> > +	/*
> > +	 * For secondary graphics devices shouldn't be initialized
> > +	 * until the handler and primary graphics device have been
> > +	 * registered with vga_switcheroo.
> > +	 *
> > +	 * FIXME: Is vga_default_device() reliable enough for this
> > +	 * purpose?
> > +	 *
> > +	 * FIXME: If vga_switcheroo is disabled secondary devices
> > +	 * never gets initialized. Is this okay? Maybe it is, since
> > +	 * we can't switch to the secondary GPU anyway.
> > +	 */
> 
> Won't this break the multiple cards with independent outputs case?

Yes, if they don't have a switcheroo handler. I only have experience
with one such machine, which had optimus graphics. My recollection is
that it did have a switcheroo handler, which was only capable of
controlling power to the discrete card.

