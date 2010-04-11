Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752228Ab0DKQq2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Apr 2010 12:46:28 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:37849 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752165Ab0DKQq1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Apr 2010 12:46:27 -0400
Date: Sun, 11 Apr 2010 18:47:01 +0200
From: Pavel Machek <pavel@ucw.cz>
To: kernel list <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@osdl.org>
Subject: LOCALVERSION_AUTO considered harmful
Message-ID: <20100411164701.GA7558@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

LOCALVERSION_AUTO has nasty interaction with modules, warn about it.

Signed-off-by: Pavel Machek <pavel@ucw.cz>

diff --git a/init/Kconfig b/init/Kconfig
index eb77e8c..5d33072 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -88,7 +88,6 @@ config LOCALVERSION
 
 config LOCALVERSION_AUTO
 	bool "Automatically append version information to the version string"
-	default y
 	help
 	  This will try to automatically determine if the current tree is a
 	  release tree by looking for git tags that belong to the current
@@ -99,6 +98,11 @@ config LOCALVERSION_AUTO
 	  appended after any matching localversion* files, and after the value
 	  set in CONFIG_LOCALVERSION.
 
+	  Unfortunately, such finegrained versioning will mean that you will
+	  not be able to use modules for development; even "make modules"
+	  will change module versions, making recompiled modules impossible
+	  to insert into old kernel. 
+
 	  (The actual string used here is the first eight characters produced
 	  by running the command:
 

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
