Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752027Ab1JMEMz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 00:12:55 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:50034 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736Ab1JMEMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 00:12:54 -0400
Date: Wed, 12 Oct 2011 22:12:50 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: "G, Manjunath Kondaiah" <manjugk@ti.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Dilan Lee <dilee@nvidia.com>,
        Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <greg@kroah.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Manjunath GKondaiah <manjunath.gkondaiah@linaro.org>,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 4/5] gpiolib: handle deferral probe error
Message-ID: <20111013041250.GG15829@ponder.secretlab.ca>
References: <1317963790-29426-1-git-send-email-manjugk@ti.com>
 <1317963790-29426-5-git-send-email-manjugk@ti.com>
 <20111007110615.7638e905@lxorguk.ukuu.org.uk>
 <CACxGe6tmjQGw77NMNYLWJHMAtmF9fk_9HnHtbrMhzkKEC1HG=Q@mail.gmail.com>
 <20111012061432.GA2080@manju-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111012061432.GA2080@manju-desktop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 12, 2011 at 11:44:32AM +0530, G, Manjunath Kondaiah wrote:
> On Fri, Oct 07, 2011 at 04:09:38PM -0600, Grant Likely wrote:
> > On Fri, Oct 7, 2011 at 4:06 AM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> > > On Fri, 07 Oct 2011 10:33:09 +0500
> > > "G, Manjunath Kondaiah" <manjugk@ti.com> wrote:
> > >
> > >>
> > >> The gpio library should return -EPROBE_DEFER in gpio_request
> > >> if gpio driver is not ready.
> > >
> > > Why not use the perfectly good existing error codes we have for this ?
> > >
> > > We have EAGAIN and EUNATCH both of which look sensible.
> > 
> > I want a distinct error code for probe deferral so that a) it doesn't
> > overlap with something a driver is already doing, and b) so that all
> > the users can be found again at a later date.
> > 
> > That said, I'm not in agreement with this patch.  It is fine for gpio
> > lib to have a code that means the pin doesn't exist (yet), but the
> > device driver needs to be the one to decide whether or not it is
> > appropriate to use probe deferral.
> 
> During gpio_request, driver gpio_request is not available. How can we expect
> driver to request deferred probe in this case?

If gpio_request fails, the driver can then explicitly make the
decision to return -EPROBE_DEFER.  It isn't forced to pass on the
error code from gpio_request().

g.
