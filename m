Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932277Ab1DYUYs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 16:24:48 -0400
Received: from 1wt.eu ([62.212.114.60]:34276 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932250Ab1DYUYn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 16:24:43 -0400
Message-Id: <20110425200236.861826666@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Mon, 25 Apr 2011 22:04:01 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: Andreas Herrmann <andreas.herrmann3@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 089/173] x86, quirk: Fix SB600 revision check
In-Reply-To: <46075c3a3ef08be6d70339617d6afc98@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27.59-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Andreas Herrmann <andreas.herrmann3@amd.com>

commit 1d3e09a304e6c4e004ca06356578b171e8735d3c upstream.

Commit 7f74f8f28a2bd9db9404f7d364e2097a0c42cc12
(x86 quirk: Fix polarity for IRQ0 pin2 override on SB800
systems) introduced a regression. It removed some SB600 specific
code to determine the revision ID without adapting a
corresponding revision ID check for SB600.

See this mail thread:

  http://marc.info/?l=linux-kernel&m=129980296006380&w=2

This patch adapts the corresponding check to cover all SB600
revisions.

Tested-by: Wang Lei <f3d27b@gmail.com>
Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
LKML-Reference: <20110315143137.GD29499@alberich.amd.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/early-quirks.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

Index: longterm-2.6.27/arch/x86/kernel/early-quirks.c
===================================================================
--- longterm-2.6.27.orig/arch/x86/kernel/early-quirks.c	2011-01-23 10:52:13.000000000 +0100
+++ longterm-2.6.27/arch/x86/kernel/early-quirks.c	2011-04-25 15:45:17.351278162 +0200
@@ -163,7 +163,12 @@
 		return;
 
 	rev = ati_sbx00_rev(num, slot, func);
-	if (rev > 0x13)
+	/*
+	 * SB600: revisions 0x11, 0x12, 0x13, 0x14, ...
+	 * SB700: revisions 0x39, 0x3a, ...
+	 * SB800: revisions 0x40, 0x41, ...
+	 */
+	if (rev >= 0x39)
 		return;
 
 	/* check for IRQ0 interrupt swap */


