Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755938Ab0F1DBI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jun 2010 23:01:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46920 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754103Ab0F1DBF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jun 2010 23:01:05 -0400
Date: Sun, 27 Jun 2010 23:00:57 -0400
From: Amerigo Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Michal Marek <mmarek@suse.cz>, David Rientjes <rientjes@google.com>,
       Amerigo Wang <amwang@redhat.com>, linux-kbuild@vger.kernel.org
Message-Id: <20100628030507.5187.95903.sendpatchset@localhost.localdomain>
Subject: [PATCH 1/2] Makefile: fix missing dash when using make LOCALVERSION=xxx
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Amerigo Wang <amwang@redhat.com>
Date: Mon, 28 Jun 2010 10:42:28 +0800

When I use make LOCALVERSION=local and LOCALVERSION_AUTO is not set,
I got "2.6.35-rc3local". It is supposed to be "2.6.35-rc3-local".

Cc: Michal Marek <mmarek@suse.cz>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Amerigo Wang <amwang@redhat.com>

---
 Makefile |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/Makefile b/Makefile
index 662e820..710f91c 100644
--- a/Makefile
+++ b/Makefile
@@ -950,7 +950,11 @@ else
 	endif
 endif
 
-localver-full = $(localver)$(LOCALVERSION)$(localver-extra)
+ifneq ($(LOCALVERSION),)
+	localver-full = $(localver)-$(LOCALVERSION)$(localver-extra)
+else
+	localver-full = $(localver)$(LOCALVERSION)$(localver-extra)
+endif
 
 # Store (new) KERNELRELASE string in include/config/kernel.release
 kernelrelease = $(KERNELVERSION)$(localver-full)
-- 
1.6.5.2

