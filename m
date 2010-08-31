Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757337Ab0HaNXV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 09:23:21 -0400
Received: from mail.schmid-telecom.ch ([213.173.183.22]:36364 "EHLO
	mail.schmid-telecom.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753345Ab0HaNXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 09:23:20 -0400
X-Greylist: delayed 1818 seconds by postgrey-1.27 at vger.kernel.org; Tue, 31 Aug 2010 09:23:19 EDT
From: Daniel Hobi <daniel.hobi@schmid-telecom.ch>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, Michael Roth <mroth@nessie.de>,
        Albin Tonnerre <albin.tonnerre@free-electrons.com>,
        Russell King <linux@arm.linux.org.uk>,
        Daniel Hobi <daniel.hobi@schmid-telecom.ch>
Subject: [PATCH] [ARM] .gitignore: Ignore piggy.gzip, lib1funcs.S and vmlinux
Date: Tue, 31 Aug 2010 14:52:17 +0200
Message-Id: <1283259137-28480-1-git-send-email-daniel.hobi@schmid-telecom.ch>
X-Mailer: git-send-email 1.7.2.1
References: <1272015498-10749-1-git-send-email-mroth@nessie.de>
X-OriginalArrivalTime: 31 Aug 2010 12:53:17.0656 (UTC) FILETIME=[7B8DF580:01CB490B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit e7db7b42 (arm: add support for LZO-compressed kernels) added
intermediate files piggy.gzip and lib1funcs.S without adding them to
.gitignore.

Commit 6db823c (Fix up .gitignore for top-level file patterns) changed
vmlinux to /vmlinux in the top-level .gitignore, thus making
arch/arm/boot/compressed/vmlinux visible.

Signed-off-by: Daniel Hobi <daniel.hobi@schmid-telecom.ch>
---
This patch revives https://patchwork.kernel.org/patch/94654/
([ARM] .gitignore: Ignore piggy.lzo, lib1funcs.S and vmlinux)
by Michael Roth with the following changes:
 - do not add piggy.lzo because it is now covered by *.lzo rule
   from top-level .gitignore
 - Ignore piggy.gzip (instead of piggy.gz)

Please keep me on CC since I am not a subscriber.

 arch/arm/boot/compressed/.gitignore |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/arch/arm/boot/compressed/.gitignore b/arch/arm/boot/compressed/.gitignore
index ab204db..e02c52e 100644
--- a/arch/arm/boot/compressed/.gitignore
+++ b/arch/arm/boot/compressed/.gitignore
@@ -1,3 +1,5 @@
 font.c
-piggy.gz
+lib1funcs.S
+piggy.gzip
+vmlinux
 vmlinux.lds
-- 
1.7.2.1

