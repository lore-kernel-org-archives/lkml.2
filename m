Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756101Ab1FEVCg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jun 2011 17:02:36 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:40928 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755763Ab1FEVCe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jun 2011 17:02:34 -0400
X-Originating-IP: 217.70.178.137
X-Originating-IP: 50.43.15.19
Date: Sun, 5 Jun 2011 14:02:25 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Sam Ravnborg <sam@ravnborg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Make CONFIG_EXPERT select CONFIG_DEBUG_KERNEL to unhide
 debug options
Message-ID: <20110605210223.GA7595@leaf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Several debugging options currently default to y, such as
CONFIG_DEBUG_BUGVERBOSE and CONFIG_DEBUG_RODATA.  Embedded users might
want to turn those options off to save space; however, turning them off
requires turning on CONFIG_DEBUG_KERNEL to unhide them.  Since
CONFIG_DEBUG_KERNEL exists specifically to unhide debugging options, and
CONFIG_EXPERT exists specifically to unhide options potentially needed
by experts and/or embedded users, make CONFIG_EXPERT automatically imply
CONFIG_DEBUG_KERNEL.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---

Revised as requested by Ingo Molnar.

 init/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index ebafac4..5e482a3 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -909,6 +909,7 @@ config ANON_INODES
 
 menuconfig EXPERT
 	bool "Configure standard kernel features (expert users)"
+	select DEBUG_KERNEL
 	help
 	  This option allows certain base kernel options and settings
           to be disabled or tweaked. This is for specialized
-- 
1.7.5.3

