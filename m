Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751308Ab0DEGi3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 02:38:29 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:34181 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750818Ab0DEGiX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 02:38:23 -0400
Date: Mon, 5 Apr 2010 08:38:52 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "Leisner, Martin" <Martin.Leisner@xerox.com>,
       linux-pm@lists.linux-foundation.org, Andrew Morton <akpm@osdl.org>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: document open(/dev/snapshot) sideeffects -- was Re: [linux-pm]
 syncing the disks when entering sleep
Message-ID: <20100405063852.GA1924@elf.ucw.cz>
References: <76FA3B279DD9DA48896E2B404944957204E0B241@USA7061MS02.na.xerox.net>
 <201001272150.05846.rjw@sisk.pl>
 <20100128072658.GB25633@atrey.karlin.mff.cuni.cz>
 <201001281143.08993.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201001281143.08993.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > Please note that merely _opening_ /dev/snapshot has side effects, so that's
> > > not just "three ioctls".
> > 
> > I search Doc*/power/userland-swsusp.txt, and could not find mentions
> > of sideeffects. Perhaps that should be fixed?
> 
> Please feel free to make the docs more complete, then.

Yes, something like this?

Signed-off-by: Pavel Machek <pavel@ucw.cz>

--- a/Documentation/power/userland-swsusp.txt
+++ b/Documentation/power/userland-swsusp.txt
@@ -24,6 +24,10 @@ assumed to be in the resume mode.  The device cannot be open for simultaneous
 reading and writing.  It is also impossible to have the device open more than
 once at a time.
 
+Even opening the device has side effects. Data structures are
+allocated, and PM_HIBERNATION_PREPARE / PM_RESTORE_PREPARE chains are
+called.
+
 The ioctl() commands recognized by the device are:
 
 SNAPSHOT_FREEZE - freeze user space processes (the current process is



-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
