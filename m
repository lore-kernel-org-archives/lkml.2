Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934279Ab0EUQ6Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 12:58:25 -0400
Received: from kroah.org ([198.145.64.141]:39151 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934262Ab0EUQyd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 12:54:33 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 27/38] sysfs: Don't use enums in inline function declaration.
Date: Fri, 21 May 2010 09:53:57 -0700
Message-Id: <1274460848-11377-27-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.0.3
In-Reply-To: <20100521165106.GA11216@kroah.com>
References: <20100521165106.GA11216@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

It appears gcc can't cope with using an enum that is only declared in
an inline function declaration, that doesn't even use the variable
that is so declared.

Avoid the silliness and replace the enum with an int, and make gcc
happy.

Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
Acked-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 include/linux/sysfs.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/sysfs.h b/include/linux/sysfs.h
index 47f1c95..6903e92 100644
--- a/include/linux/sysfs.h
+++ b/include/linux/sysfs.h
@@ -328,7 +328,7 @@ static inline void sysfs_put(struct sysfs_dirent *sd)
 {
 }
 
-static inline void sysfs_exit_ns(enum kobj_ns_type type, const void *tag)
+static inline void sysfs_exit_ns(int type, const void *tag)
 {
 }
 
-- 
1.7.0.3

