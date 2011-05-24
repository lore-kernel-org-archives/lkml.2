Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756791Ab1EXSNW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 14:13:22 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:37219 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753122Ab1EXSNU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 14:13:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:message-id:x-mailer;
        b=RfgNAlEVg1NZEgWepnrYoi7qmwVr/jnH57AM9G5DaUiJagvtAvLccSszjrZ9SzwLm/
         udlekrWi2n4z7l58/BjR8ObWSHe++A+SVMwdA864/0jTqjYApLuSeXaWPBWhMRDC5H0F
         gZO9bcflHGC7B+jn1qcc37duBi8XAk6ijOILg=
From: Jonas Gorski <jonas.gorski@gmail.com>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] exportfs: reallow building as a module
Date: Tue, 24 May 2011 20:12:08 +0200
Message-Id: <1306260728-12031-1-git-send-email-jonas.gorski@gmail.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 990d6c2d7aee921e3bce22b2d6a750fd552262be ("vfs: Add name to file
handle conversion support") changed EXPORTFS to be a bool.
This was needed for earlier revisions of the original patch, but the actual
commit put the code needing it into its own file that only gets compiled
when FHANDLE is selected which in turn selects EXPORTFS.
So EXPORTFS can be safely compiled as a module when not selecting FHANDLE.

Signed-off-by: Jonas Gorski <jonas.gorski@gmail.com>
---
 fs/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/Kconfig b/fs/Kconfig
index f3aa9b0..efb7d4e 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -47,7 +47,7 @@ config FS_POSIX_ACL
 	def_bool n
 
 config EXPORTFS
-	bool
+	tristate
 
 config FILE_LOCKING
 	bool "Enable POSIX file locking API" if EXPERT
-- 
1.7.2.5

