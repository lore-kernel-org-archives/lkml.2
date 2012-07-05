Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757423Ab2GEUMS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 16:12:18 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:55012 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757349Ab2GEUMP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 16:12:15 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [RFD] PM: Device tree representation of power domains
Date: Thu, 5 Jul 2012 22:17:47 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0-rc5+; KDE/4.6.0; x86_64; ; )
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Magnus Damm <magnus.damm@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        Grant Likely <grant.likely@secretlab.ca>
References: <201207032302.17805.rjw@sisk.pl> <20120704115637.GS4111@opensource.wolfsonmicro.com>
In-Reply-To: <20120704115637.GS4111@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201207052217.48086.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, July 04, 2012, Mark Brown wrote:
> On Tue, Jul 03, 2012 at 11:02:17PM +0200, Rafael J. Wysocki wrote:
> 
> > I actually don't have any ideas how to do that at the moment, but I wonder
> > if anyone has already thought about it?
> 
> > For one, I don't think that representing a power domain as a platform device
> > would be a good approach and I'm not sure how to represent the relationships
> > between devices and the domains they belong to.
> 
> I guess the OMAP hwmod stuff is the closest thing we've got at the
> minute (I don't recall seeing any other implementations in mainline) but
> the hwmods themselves don't appear in the DTS right now.  They have a
> ti,hwmods property on each device naming the hwmod it's in, something
> like that seems like a reasonable approach, possibly a reference to
> another DT node rather than or as well as a string?  That seems fairly
> easy.

Well, it looks like (and please tell me if I'm wrong) the hwmons are just
string attributes that are parsed by the platform-specific code through
a platform bus type notifier.

We could do that for power domains too, but then each platform wanting to
use them would need to implement such a notifier and add its own routine
for parsing those strings.  Would that be acceptable to everyone concerned?

Rafael
