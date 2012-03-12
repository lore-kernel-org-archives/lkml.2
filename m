Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757386Ab2CLWNy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 18:13:54 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:37462 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752942Ab2CLWNx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 18:13:53 -0400
From: Shawn Landden <shawnlandden@gmail.com>
To: mmarek@suse.cz, andi@lisas.de, shawnlandden@gmail.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH] scripts: scripts/patch-kernel should be able to digest kernel.org hosted .xz patches
Date: Mon, 12 Mar 2012 15:13:37 -0700
Message-Id: <1331590417-10050-1-git-send-email-shawnlandden@gmail.com>
X-Mailer: git-send-email 1.7.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kernel.org is hosting patches and kernel compressed with xz (lzma2+). Allow
scripts/patch-kernel to decompress these files.

Signed-off-by: Shawn Landden <shawnlandden@gmail.com>
---
 scripts/patch-kernel |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/scripts/patch-kernel b/scripts/patch-kernel
index 20fb25c..d000ea3 100755
--- a/scripts/patch-kernel
+++ b/scripts/patch-kernel
@@ -116,6 +116,10 @@ findFile () {
 		ext=".bz2"
 		name="bzip2"
 		uncomp="bunzip2 -dc"
+  elif [ -r ${filebase}.xz ]; then
+                ext=".xz"
+                name="xz"
+                uncomp="xz -dc"
   elif [ -r ${filebase}.zip ]; then
 		ext=".zip"
 		name="zip"
-- 
1.7.9.1

