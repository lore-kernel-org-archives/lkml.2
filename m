Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758584Ab1GDR4z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 13:56:55 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49338 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758461Ab1GDR4y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 13:56:54 -0400
Date: Mon, 4 Jul 2011 10:56:49 -0700
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Greg KH <gregkh@suse.de>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] drivercore: Add driver probe deferral mechanism
Message-ID: <20110704175648.GJ28726@opensource.wolfsonmicro.com>
References: <20110704170949.11059.92774.stgit@ponder>
 <20110704174126.GA26533@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110704174126.GA26533@suse.de>
X-Cookie: You will have long and healthy life.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 04, 2011 at 10:41:26AM -0700, Greg KH wrote:

> And why would a driver not be able to get all of the proper resources?

If the resources are provided by another driver (for example, a clock,
GPIO or regulator) then the driver doing the providing needs to have
initialized before the resource can be used.  Currently we have no way
of ensuring that this happens.

> Why can't a bus, at a later time, just try to reprobe everything when it
> determines that it is a "later" time now, without having to do this
> added change to the core?

The buses can't do anything to help as they have no visibility of this
and the chances are that devices on several different buses are
involved.

> Why would drivers in modules be an issue?  If a driver depends on
> another driver, making it a module dependancy would solve the problem,
> right?

The general problem here is that the drivers depend on each other in
system-specific fashions that have nothing to do with the control
heirachy the device model uses - for example, a device may depend on
having a clock provided but the specific clock used could come from
essentially any device in a given system with the driver accessing that
clock via the clock API which matches devices up with their providers.
The API indirection means we can share code between systems but means
that the kernel infrastructure has no visibility of the relationships.
