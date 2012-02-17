Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754363Ab2BQT3h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 14:29:37 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:60913 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754310Ab2BQT3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 14:29:35 -0500
Date: Fri, 17 Feb 2012 20:29:28 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Kevin Hilman <khilman@ti.com>, jean.pihet@newoldbits.com
Subject: Re: [PATCH 4/7] PM / Domains: Rework system suspend callback
 routines
Message-ID: <20120217192928.GI2707@elf.ucw.cz>
References: <201111070101.33960.rjw@sisk.pl>
 <201111070108.11727.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201111070108.11727.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2011-11-07 01:08:11, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> The current generic PM domains code attempts to use the generic
> system suspend operations along with the domains' device stop/start
> routines, which requires device drivers to assume that their
> system suspend/resume (and hibernation/restore) callbacks will always
> be used with generic PM domains.  However, in theory, the same
> hardware may be used in devices that don't belong to any PM domain,
> in which case it would be necessary to add "fake" PM domains to
> satisfy the above assumption.  Also, the domain the hardware belongs
> to may not be handled with the help of the generic code.
> 
> To allow device drivers that may be used along with the generic PM
> domains code of more flexibility, add new device callbacks, .freeze(),
> .freeze_late(), .thaw_early() and .thaw(), that can be supplied by
> the drivers in addition to their "standard" system suspend and
> hibernation callbacks.  These new callbacks, if defined, will be used
> by the generic PM domains code for the handling of system suspend and
> hibernation instead of the "standard" ones.  This will allow drivers
> to be designed to work with generic PM domains as well as without
> them.

Should this go to Documentation/ somewhere? May concern is that we
have way too many callbacks these days. Why is fake PM domain such a
bad thing?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
