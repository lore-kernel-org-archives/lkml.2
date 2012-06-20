Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757047Ab2FTQIl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 12:08:41 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:39711 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751631Ab2FTQIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 12:08:39 -0400
Date: Wed, 20 Jun 2012 18:10:12 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>, daniel.vetter@ffwll.ch,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: Thunderbolt, Apple Monitor & MBA, and excess kworker load
Message-ID: <20120620161012.GK7170@phenom.ffwll.local>
Mail-Followup-To: Greg KH <gregkh@linuxfoundation.org>,
	Dominik Brodowski <linux@dominikbrodowski.net>,
	dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
References: <20120620154842.GA5788@air.dominikbrodowski.net>
 <20120620155626.GA3384@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120620155626.GA3384@kroah.com>
X-Operating-System: Linux phenom 3.4.0-rc3+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 20, 2012 at 08:56:26AM -0700, Greg KH wrote:
> On Wed, Jun 20, 2012 at 05:48:42PM +0200, Dominik Brodowski wrote:
> > Hi,
> > 
> > At work, I wish to attach a 27" Apple Display using thunderbolt to my Mac
> > Book Air 4,2 13". Using OS X, it works fine, but as I prefer using Linux, I
> > tested out Ubuntu's stock kernel and (among other) 3.5.0-rc3+ as of f40759e.
> > Hotplug doesn't work (known issue), but also with coldplug the display
> > reacts _very_ slow, way too slow for real use: The screen updates only every
> > half second or so. Is this a known bug? Might something go afoul with
> > kworker -- they need about 75% of the CPU with the large display attached,
> > and less than 1% _without_ the large display.
> 
> It's not really a known bug, but it is known that Thunderbolt doesn't
> work all that well, if at all, in Linux due to the BIOS issues that you
> have run into (the hotplug stuff.)
> 
> Once the device is seen, it should just work like any other PCI device,
> and so, that might be a DRM driver issue somehow.

A quick full-system profile would be a good start to tell where we're
burning through all these cycles exaclty. Also, anything special going on
with interrupts (if this excessive load is due to supurious display
hotplug events, drm/i915 should get _tons_ of interrupts).
-Daniel
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
