Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932285Ab1I3NuG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 09:50:06 -0400
Received: from filtteri2.pp.htv.fi ([213.243.153.185]:57734 "EHLO
	filtteri2.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757119Ab1I3NuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 09:50:04 -0400
X-Greylist: delayed 435 seconds by postgrey-1.27 at vger.kernel.org; Fri, 30 Sep 2011 09:50:04 EDT
Date: Fri, 30 Sep 2011 16:42:45 +0300
From: Adrian Bunk <bunk@stusta.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Josh Triplett <josh@joshtriplett.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Sam Ravnborg <sam@ravnborg.org>
Subject: Please revert "debug: Make CONFIG_EXPERT select CONFIG_DEBUG_KERNEL
 to unhide debug options"
Message-ID: <20110930134245.GB21474@localhost.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I was just wondering why I was asked about all the debug options when I 
tried 3.1-rc8, and that was due to commit f505c553 (debug: Make 
CONFIG_EXPERT select CONFIG_DEBUG_KERNEL to unhide debug options),
the full commit is below.

It is wrong, and the author does not seem to understand how Kconfig works.

The commit message is:

    Several debugging options currently default to y, such as
    CONFIG_DEBUG_BUGVERBOSE and CONFIG_DEBUG_RODATA.  Embedded users
    might want to turn those options off to save space; however,
    turning them off requires turning on CONFIG_DEBUG_KERNEL to
    unhide them.  Since CONFIG_DEBUG_KERNEL exists specifically to
    unhide debugging options, and CONFIG_EXPERT exists specifically
    to unhide options potentially needed by experts and/or embedded
    users, make CONFIG_EXPERT automatically imply
    CONFIG_DEBUG_KERNEL.


Let me point at the obvious fact that both CONFIG_DEBUG_BUGVERBOSE and 
CONFIG_DEBUG_RODATA do depend on DEBUG_KERNEL, and are contrary to the 
claim of the author of this patch never enabled with 
CONFIG_DEBUG_KERNEL=n. [1]

Linus, please revert this commit.

Thanks
Adrian

[1] Select abuse would be an exception, but that doesn't seem to be
    the case for these options.
