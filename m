Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753863Ab2GPV16 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 17:27:58 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:43016 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751337Ab2GPV1y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 17:27:54 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM list <linux-pm@vger.kernel.org>
Subject: [RFC][PATCH 0/14] PM / shmobile: Pass power domain information via DT (was: Re: [RFD] PM: Device tree representation of power domains)
Date: Mon, 16 Jul 2012 23:15:48 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0-rc5+; KDE/4.6.0; x86_64; ; )
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Magnus Damm <magnus.damm@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        "Linux-sh list" <linux-sh@vger.kernel.org>
References: <201207032302.17805.rjw@sisk.pl> <20120704115637.GS4111@opensource.wolfsonmicro.com> <201207052217.48086.rjw@sisk.pl>
In-Reply-To: <201207052217.48086.rjw@sisk.pl>
MIME-Version: 1.0
Message-Id: <201207162315.49073.rjw@sisk.pl>
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, July 05, 2012, Rafael J. Wysocki wrote:
> On Wednesday, July 04, 2012, Mark Brown wrote:
> > On Tue, Jul 03, 2012 at 11:02:17PM +0200, Rafael J. Wysocki wrote:
> > 
> > > I actually don't have any ideas how to do that at the moment, but I wonder
> > > if anyone has already thought about it?
> > 
> > > For one, I don't think that representing a power domain as a platform device
> > > would be a good approach and I'm not sure how to represent the relationships
> > > between devices and the domains they belong to.
> > 
> > I guess the OMAP hwmod stuff is the closest thing we've got at the
> > minute (I don't recall seeing any other implementations in mainline) but
> > the hwmods themselves don't appear in the DTS right now.  They have a
> > ti,hwmods property on each device naming the hwmod it's in, something
> > like that seems like a reasonable approach, possibly a reference to
> > another DT node rather than or as well as a string?  That seems fairly
> > easy.
> 
> Well, it looks like (and please tell me if I'm wrong) the hwmons are just
> string attributes that are parsed by the platform-specific code through
> a platform bus type notifier.
> 
> We could do that for power domains too, but then each platform wanting to
> use them would need to implement such a notifier and add its own routine
> for parsing those strings.  Would that be acceptable to everyone concerned?

I tried to follow the above suggestion and prepared the following patchset
that allows power domain information for Renesas platforms to be passed as
"renesas,pmdomain" string attribute of device nodes.  It adds functions
allowing the generic PM domains framework to use names for domain
identification in various situations and reworks the ARM/shmobile power domains
support code to used those functions instead of the "raw" ones that take
domain pointers as their arguments.  Finally, it defines a platform bus type
notifier that will add devices whose DT nodes contain the "renesas,pmdomain"
attribute to the power domains indicated by it (the value of that attribute
should be the name of the PM domain to add the device to after it's been
registered).  All of this should allow platform devices to be added to
appropriate power domains automatically based on the information read from
a DT.

The patches are on top of the current linux-next tree.

I've tested the patches that could be tested on the Mackerel board, except
for the last one (I'm still working on testing it).

Thanks,
Rafael

