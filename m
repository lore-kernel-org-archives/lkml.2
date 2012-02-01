Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754694Ab2BATNO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 14:13:14 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:48476 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753197Ab2BATNN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 14:13:13 -0500
X-Sasl-enc: PjuT2UBRTALEszZoK4rl4aPKKchjZTIczpt+CLpxajZ0 1328123591
Date: Wed, 1 Feb 2012 11:09:40 -0800
From: Greg Kroah-Hartman <greg@kroah.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        Tobias Klauser <tklauser@distanz.ch>,
        Frederic Lambert <frdrc66@gmail.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Mark Brown <broonie@sirena.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH] drivercore: Output common devicetree information in
 uevent
Message-ID: <20120201190940.GC20358@kroah.com>
References: <1328121545-21955-1-git-send-email-grant.likely@secretlab.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328121545-21955-1-git-send-email-grant.likely@secretlab.ca>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 01, 2012 at 11:39:04AM -0700, Grant Likely wrote:
> When userspace needs to find a specific device, it currently isn't easy to
> resolve a /sys/devices/ path from a specific device tree node.  Nor is it
> easy to obtain the compatible list for devices.
> 
> This patch generalizes the code that inserts OF_* values into the uevent
> device attribute so that any device that is attached to an OF node will
> have that information exported to userspace.  Without this patch only
> platform devices and some powerpc-specific busses have access to this
> data.
> 
> The original function also creates a MODALIAS property for the compatible
> list, but that code has not been generalized into the common case because
> it has the potential to break module loading on a lot of bus types.  Bus
> types are still responsible for their own MODALIAS properties.

So you are only adding new properties to be exported, not removing any
from any existing devices, right?

If so, I have no objection to this at all, if you want to take this
through your tree for 3.4, please feel free to add:

	Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Or I can take it through my driver-core tree, which ever is easiest for
you.

thanks,

greg k-h
