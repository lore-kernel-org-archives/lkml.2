Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760605Ab0J0AC7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 20:02:59 -0400
Received: from LUNGE.MIT.EDU ([18.54.1.69]:49073 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760561Ab0J0AC6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 20:02:58 -0400
Date: Tue, 26 Oct 2010 17:02:54 -0700
From: Andres Salomon <dilinger@queued.net>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: linux-doc@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] Documentation: document the staging directory and
 submission process
Message-ID: <20101026170254.372820eb@queued.net>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Document things that I would've liked to have known when submitting a driver
to gregkh for staging.

Signed-off-by: Andres Salomon <dilinger@queued.net>
---
 Documentation/development-process/2.Process |   25 +++++++++++++++++++------
 1 files changed, 19 insertions(+), 6 deletions(-)

diff --git a/Documentation/development-process/2.Process b/Documentation/development-process/2.Process
index ae8127c..911a451 100644
--- a/Documentation/development-process/2.Process
+++ b/Documentation/development-process/2.Process
@@ -303,12 +303,25 @@ volatility of linux-next tends to make it a difficult development target.
 See http://lwn.net/Articles/289013/ for more information on this topic, and
 stay tuned; much is still in flux where linux-next is involved.
 
-Besides the mmotm and linux-next trees, the kernel source tree now contains
-the drivers/staging/ directory and many sub-directories for drivers or
-filesystems that are on their way to being added to the kernel tree
-proper, but they remain in drivers/staging/ while they still need more
-work.
-
+2.4.1: STAGING TREES
+
+The kernel source tree now contains the drivers/staging/ directory, where
+many sub-directories for drivers or filesystems that are on their way to
+being added to the kernel tree live.  They remain in drivers/staging while
+they still need more work; once complete, they can be moved into the
+kernel proper.  This is a way to keep track of drivers that aren't
+up to Linux kernel coding or quality standards, but people may want to use
+them and track development.
+
+Greg Kroah-Hartman currently (as of 2.6.36) maintains the staging tree.
+Drivers that still need work are sent to him, with each driver having
+its own subdirectory in drivers/staging/.  Along with the driver source
+files, a TODO file should be present in the directory as well.  The TODO
+file lists the pending work that the driver needs for acceptance into
+the kernel proper, as well as a list of people that should be Cc'd for any
+patches to the driver.  Staging drivers that don't currently build should
+have their config entries depend upon CONFIG_BROKEN.  Once they can
+be successfully built without outside patches, CONFIG_BROKEN can be removed.
 
 2.5: TOOLS
 
-- 
1.7.1

