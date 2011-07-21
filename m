Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753330Ab1GURQm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 13:16:42 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:54428 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751949Ab1GURQc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 13:16:32 -0400
From: Arnaud Lacombe <lacombar@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Arnaud Lacombe <lacombar@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 2/4] drivers/base/devtmpfs.c: correct annotation of `setup_done'
Date: Thu, 21 Jul 2011 13:16:19 -0400
Message-Id: <1311268581-20405-2-git-send-email-lacombar@gmail.com>
X-Mailer: git-send-email 1.7.6.153.g78432
In-Reply-To: <1311268581-20405-1-git-send-email-lacombar@gmail.com>
References: <1311268581-20405-1-git-send-email-lacombar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes the following section mismatch issue:

WARNING: vmlinux.o(.text+0x1192bf): Section mismatch in reference from the function devtmpfsd() to the variable .init.data:setup_done
The function devtmpfsd() references the variable __initdata setup_done.
This is often because devtmpfsd lacks a __initdata annotation or the annotation of setup_done is wrong.

WARNING: vmlinux.o(.text+0x119342): Section mismatch in reference from the function devtmpfsd() to the variable .init.data:setup_done
The function devtmpfsd() references the variable __initdata setup_done.
This is often because devtmpfsd lacks a __initdata annotation or the annotation of setup_done is wrong.

Cc: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Arnaud Lacombe <lacombar@gmail.com>
---
 drivers/base/devtmpfs.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/base/devtmpfs.c b/drivers/base/devtmpfs.c
index 6d678c9..38e6464 100644
--- a/drivers/base/devtmpfs.c
+++ b/drivers/base/devtmpfs.c
@@ -376,7 +376,7 @@ int devtmpfs_mount(const char *mntdir)
 	return err;
 }
 
-static __initdata DECLARE_COMPLETION(setup_done);
+static DECLARE_COMPLETION(setup_done);
 
 static int handle(const char *name, mode_t mode, struct device *dev)
 {
-- 
1.7.6.153.g78432

