Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753397Ab1HYLxr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 07:53:47 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47285 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753035Ab1HYLxq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 07:53:46 -0400
Date: Thu, 25 Aug 2011 13:53:45 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Michal Marek <mmarek@suse.cz>, Roland Stigge <stigge@antcom.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Revert "mkuboot.sh: Fail if mkimage is missing"
Message-ID: <alpine.LNX.2.00.1108251353050.13644@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit bc91c9f3.

It causes the whole build to fail when mkimage is not found. This doesn't
seem right, as the failure is not fatal for the rest of the build.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
---
 scripts/mkuboot.sh |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scripts/mkuboot.sh b/scripts/mkuboot.sh
index 446739c..2e3d3cd 100755
--- a/scripts/mkuboot.sh
+++ b/scripts/mkuboot.sh
@@ -11,7 +11,7 @@ if [ -z "${MKIMAGE}" ]; then
 	if [ -z "${MKIMAGE}" ]; then
 		# Doesn't exist
 		echo '"mkimage" command not found - U-Boot images will not be built' >&2
-		exit 1;
+		exit 0;
 	fi
 fi
 
-- 
1.7.5.4

