Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754592Ab2BQU5O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 15:57:14 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:58578 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752642Ab2BQU5N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 15:57:13 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH 4/7] PM / Domains: Rework system suspend callback routines
Date: Fri, 17 Feb 2012 22:01:07 +0100
User-Agent: KMail/1.13.6 (Linux/3.3.0-rc3+; KDE/4.6.0; x86_64; ; )
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Linux-sh list" <linux-sh@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Kevin Hilman <khilman@ti.com>, jean.pihet@newoldbits.com
References: <201111070101.33960.rjw@sisk.pl> <201111070108.11727.rjw@sisk.pl> <20120217192928.GI2707@elf.ucw.cz>
In-Reply-To: <20120217192928.GI2707@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201202172201.07274.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, February 17, 2012, Pavel Machek wrote:
> On Mon 2011-11-07 01:08:11, Rafael J. Wysocki wrote:
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> > 
> > The current generic PM domains code attempts to use the generic
> > system suspend operations along with the domains' device stop/start
> > routines, which requires device drivers to assume that their
> > system suspend/resume (and hibernation/restore) callbacks will always
> > be used with generic PM domains.  However, in theory, the same
> > hardware may be used in devices that don't belong to any PM domain,
> > in which case it would be necessary to add "fake" PM domains to
> > satisfy the above assumption.  Also, the domain the hardware belongs
> > to may not be handled with the help of the generic code.
> > 
> > To allow device drivers that may be used along with the generic PM
> > domains code of more flexibility, add new device callbacks, .freeze(),
> > .freeze_late(), .thaw_early() and .thaw(), that can be supplied by
> > the drivers in addition to their "standard" system suspend and
> > hibernation callbacks.  These new callbacks, if defined, will be used
> > by the generic PM domains code for the handling of system suspend and
> > hibernation instead of the "standard" ones.  This will allow drivers
> > to be designed to work with generic PM domains as well as without
> > them.
> 
> Should this go to Documentation/ somewhere? May concern is that we
> have way too many callbacks these days. Why is fake PM domain such a
> bad thing?

I'm not sure what you mean, really.  This particular patch only affects
the generic PM domains framework, which only has a few users now.

Thanks,
Rafael
