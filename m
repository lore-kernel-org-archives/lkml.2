Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933400Ab1ERR1a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 13:27:30 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:34292 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933269Ab1ERR13 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 13:27:29 -0400
Date: Wed, 18 May 2011 19:27:17 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: [RFC][PATCH] PM / Hibernate: Add sysfs knob to control size of
 memory for drivers
Message-ID: <20110518172717.GA5734@elf.ucw.cz>
References: <201105100059.25372.rjw@sisk.pl>
 <201105150056.55601.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201105150056.55601.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > From: Rafael J. Wysocki <rjw@sisk.pl>
> > 
> > Martin reports that on his system hibernation occasionally fails due
> > to the lack of memory, because the radeon driver apparently allocates
> > too much of it during the device freeze stage.  It turns out that the
> > amount of memory allocated by radeon during hibernation (and
> > presumably during system suspend too) depends on the utilization of
> > the GPU (e.g. hibernating while there are two KDE 4 sessions with
> > compositing enabled causes radeon to allocate more memory than for
> > one KDE 4 session).
> > 
> > In principle it should be possible to use image_size to make the
> > memory preallocation mechanism free enough memory for the radeon
> > driver, but in practice it is not easy to guess the right value
> > because of the way the preallocation code uses image_size.  For this
> > reason, it seems reasonable to allow users to control the amount of
> > memory reserved for driver allocations made after the preallocation,
> > which currently is constant and amounts to 1 MB.
> > 
> > Introduce a new sysfs file, /sys/power/reserved_size, whose value
> > will be used as the amount of memory to reserve for the
> > post-preallocation reservations made by device drivers, in bytes.
> > For backwards compatibility, set its default (and initial) value to
> > the currently used number (1 MB).
> > 
> > References: https://bugzilla.kernel.org/show_bug.cgi?id=34102
> > Reported-by: Martin Steigerwald <Martin@Lichtvoll.de>
> > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> 
> OK, there are no comments, so my understanding is that everyone is fine
> with this patch and I can add it to my linux-next branch.

Actually no, I don't like it. Yes, knob might be useful for debugging,
but having it as part of official kernel interface...

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
