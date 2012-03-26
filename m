Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757255Ab2CZUz6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 16:55:58 -0400
Received: from 206.83.70.73.ptr.us.xo.net ([206.83.70.73]:59637 "EHLO
	king.tilera.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757175Ab2CZUz5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 16:55:57 -0400
Message-Id: <201203262055.q2QKtusJ010481@farm-0012.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Mon, 26 Mar 2012 16:54:04 -0400
Subject: [PATCH] mkmakefile: add export of $ARCH if specified on command-line
To: Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-OriginalArrivalTime: 26 Mar 2012 20:55:56.0828 (UTC) FILETIME=[D743ADC0:01CD0B92]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If you create a new build tree and set "ARCH=foo" on the command
line, it makes sense for that build tree to remember the architecture
that it's meant to be built for.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 scripts/mkmakefile |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/scripts/mkmakefile b/scripts/mkmakefile
index 0cc0442..67682a8 100644
--- a/scripts/mkmakefile
+++ b/scripts/mkmakefile
@@ -57,3 +57,7 @@ Makefile:;
 %/: all
 	@:
 EOF
+
+if [ -n "$ARCH" ]; then
+	echo "export ARCH = $ARCH" >> $2/Makefile
+fi
-- 
1.6.5.2

