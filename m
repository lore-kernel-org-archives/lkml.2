Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760659Ab2EKPAC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 11:00:02 -0400
Received: from pasky.or.cz ([84.242.80.195]:38122 "EHLO machine.or.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758262Ab2EKPAA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 11:00:00 -0400
X-Greylist: delayed 607 seconds by postgrey-1.27 at vger.kernel.org; Fri, 11 May 2012 11:00:00 EDT
Date: Fri, 11 May 2012 16:49:49 +0200
From: Petr Baudis <pasky@ucw.cz>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] deb-pkg: Fix packaging with non-standard umask
Message-ID: <20120511144949.GL24321@machine.or.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When building with a different umask than 022 (e.g. umask 027),
the packaged files would carry the non-standard rights over,
wreaking havoc especially in case of linux-libc-dev.

This patch fixes the problem for sane umasks.

Signed-off-by: Petr Baudis <pasky@ucw.cz>

--- scripts/package/builddeb~	2012-03-01 02:28:15.571721530 +0100
+++ scripts/package/builddeb	2012-03-15 20:04:49.497938508 +0100
@@ -23,7 +23,7 @@
 
 	# Fix ownership and permissions
 	chown -R root:root "$pdir"
-	chmod -R go-w "$pdir"
+	chmod -R u+rwX,go+rX-w "$pdir"
 
 	# Attempt to find the correct Debian architecture
 	local forcearch="" debarch=""
