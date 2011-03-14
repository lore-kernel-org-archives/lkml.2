Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757294Ab1CNVKm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 17:10:42 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:48463 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755056Ab1CNVKg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 17:10:36 -0400
Date: Mon, 14 Mar 2011 21:10:31 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Greg KH <greg@kroah.com>
Cc: andy.green@linaro.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        patches@linaro.org
Subject: Re: [RFC PATCH 3/4] PLATFORM: Introduce async platform_data attach
	api
Message-ID: <20110314211031.GB32150@sirena.org.uk>
References: <20110314205432.GA1856@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110314205432.GA1856@kroah.com>
X-Cookie: Cynic, n.:
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 14, 2011 at 01:54:32PM -0700, Greg KH wrote:
> On Mon, Mar 14, 2011 at 08:38:53AM +0000, Andy Green wrote:

> > For sure, in any other bus, we will never have this discussion about
> > if the device driver should use relevant platform_data to be guided
> > about what to do, that is what platform_data is for and it is very
> > widely used indeed.

> Are you sure?  Try me on one of the other "real" busses out there like
> PCI and see how all of these same arguments are identical :)

You were asking for concrete examples up thread, and this brings one to
mind - I used to work on a system where we had to modify the PCI ethernet
controller driver to tell it that while it did have two PHYs attached to
the MDIO bus they were nothing to do with the data interface of the
ethernet controller which was instead directly wired to a fixed
configuration device.  This sort of thing could be handled by the device
tree but...

> The abuse of platform_data today does not give you the right to persist
> in it.  Look at the work of the device tree developers to fix this
> problem as proof of this.

...the problem with device tree is that it's only available on a limited
subset of architectures at the minute, with progress towards deploying
it more widely being somewhat slow.
