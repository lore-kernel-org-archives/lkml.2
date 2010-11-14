Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752796Ab0KNFWB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Nov 2010 00:22:01 -0500
Received: from ksp.mff.cuni.cz ([195.113.26.206]:58419 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751458Ab0KNFWA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Nov 2010 00:22:00 -0500
Date: Sun, 14 Nov 2010 06:21:38 +0100
From: Pavel Machek <pavel@ucw.cz>
To: kernel list <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: 2.6.37-rc1+: hibernate regression, claims not enough swap space
Message-ID: <20101114052138.GB2189@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

...but there's enough -- or at least it was enough to fit previous
versions. 32-bit machine, so it has highmem.

System is in console mode, very lightly loaded.

Mem:   2054716k total,   736548k used,  1318168k free,    15368k buffers
Swap:   779148k total,     2360k used,   776788k free,   546388k cached

thinkpad_acpi: ACPI backlight control delay disabled
PM: thaw of devices complete after 539.577 msecs
PM: writing image.
PM: Free swap pages: 194166
PM: Not enough free swap
Restarting tasks ...

Aha, and it is the new default /sys/power/image_size .. setting it to
0 lets machine hibernate. I guess the new default is very wrong for
highmem machine...

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
