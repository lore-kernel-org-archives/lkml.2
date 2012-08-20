Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757317Ab2HTQ2i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 12:28:38 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:60777 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755548Ab2HTQ2c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 12:28:32 -0400
Date: Mon, 20 Aug 2012 17:28:28 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Dave Airlie <airlied@gmail.com>, Daniel Vetter <daniel@ffwll.ch>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, Andreas Heider <andreas@meetr.de>
Subject: Re: [RFC PATCH 7/7] drm/pci: Defer initialization of secondary
 graphics devices until switcheroo is ready
Message-ID: <20120820162827.GA31270@srcf.ucam.org>
References: <20120806045150.GA23652@thinkpad-t410>
 <1345476664-22066-1-git-send-email-seth.forshee@canonical.com>
 <1345476664-22066-8-git-send-email-seth.forshee@canonical.com>
 <20120820153640.GA29614@srcf.ucam.org>
 <20120820155633.GF11013@thinkpad-t410>
 <20120820155740.GA30611@srcf.ucam.org>
 <20120820162444.GG11013@thinkpad-t410>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120820162444.GG11013@thinkpad-t410>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 20, 2012 at 11:24:44AM -0500, Seth Forshee wrote:

> I'm not sure how we support both of these cases without doing something
> more like what I originally proposed, i.e. registering the LVDS
> connector even if it doesn't look like a panel is attached. I still
> honestly favor that approach, although it does come with its own set of
> challenges.
> 
> The only other option I can come up with is to reprobe LVDS after
> switcheroo and add the connector at that time. I haven't investigated
> this option in detail, but at first glance it looks like there are at
> least some places where DRM isn't prepared to cope with adding
> connectors after initialization.

Well, one option is to identify whether the hardware is switcheroo 
capable without the use of the switcheroo driver. It looks like we can 
do that in the majority of cases - Apple is the only special case I can 
see, and that one's a fairly easy workaround.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
