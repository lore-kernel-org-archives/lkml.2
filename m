Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754946Ab1HZUeJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 16:34:09 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37015 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754852Ab1HZUeF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 16:34:05 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Arnaud Lacombe <lacombar@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 03/13] drivers/base/devtmpfs.c: correct annotation of `setup_done'
Date: Fri, 26 Aug 2011 13:33:44 -0700
Message-Id: <1314390834-3411-3-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.6.1
In-Reply-To: <1314390834-3411-1-git-send-email-gregkh@suse.de>
References: <20110826191130.GA5557@kroah.com>
 <1314390834-3411-1-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaud Lacombe <lacombar@gmail.com>

This fixes the following section mismatch issue:

WARNING: vmlinux.o(.text+0x1192bf): Section mismatch in reference from the function devtmpfsd() to the variable .init.data:setup_done
The function devtmpfsd() references the variable __initdata setup_done.
This is often because devtmpfsd lacks a __initdata annotation or the annotation of setup_done is wrong.

WARNING: vmlinux.o(.text+0x119342): Section mismatch in reference from the function devtmpfsd() to the variable .init.data:setup_done
The function devtmpfsd() references the variable __initdata setup_done.
This is often because devtmpfsd lacks a __initdata annotation or the annotation of setup_done is wrong.

Signed-off-by: Arnaud Lacombe <lacombar@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/devtmpfs.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/base/devtmpfs.c b/drivers/base/devtmpfs.c
index 33e1bed..a4760e0 100644
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
1.7.6.1

