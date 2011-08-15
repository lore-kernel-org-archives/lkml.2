Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752188Ab1HOFIG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 01:08:06 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:37521 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751986Ab1HOFID (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 01:08:03 -0400
From: Arnaud Lacombe <lacombar@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Arnaud Lacombe <lacombar@gmail.com>, Sam Ravnborg <sam@ravnborg.org>,
        kxie@chelsio.com, James Bottomley <James.Bottomley@suse.de>
Subject: [PATCH 08/11] drivers/scsi: do not use EXTRA_CFLAGS
Date: Mon, 15 Aug 2011 01:07:11 -0400
Message-Id: <1313384834-24433-9-git-send-email-lacombar@gmail.com>
X-Mailer: git-send-email 1.7.6.153.g78432
In-Reply-To: <1313384834-24433-1-git-send-email-lacombar@gmail.com>
References: <1313384834-24433-1-git-send-email-lacombar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Usage of these flags has been deprecated for nearly 4 years by:

    commit f77bf01425b11947eeb3b5b54685212c302741b8
    Author: Sam Ravnborg <sam@neptun.(none)>
    Date:   Mon Oct 15 22:25:06 2007 +0200

        kbuild: introduce ccflags-y, asflags-y and ldflags-y

Moreover, these flags (at least EXTRA_CFLAGS) have been documented for command
line use. By default, gmake(1) do not override command line setting, so this is
likely to result in build failure or unexpected behavior.

Replace their usage by Kbuild's `{as,cc,ld}flags-y'.

In the same time, do not needlessly reference $(srctree) in the -I argument.

Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: kxie@chelsio.com
Cc: James Bottomley <James.Bottomley@suse.de>
---
 drivers/scsi/cxgbi/cxgb3i/Kbuild |    2 +-
 drivers/scsi/cxgbi/cxgb4i/Kbuild |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/cxgbi/cxgb3i/Kbuild b/drivers/scsi/cxgbi/cxgb3i/Kbuild
index 09dbf9e..b3197c9 100644
--- a/drivers/scsi/cxgbi/cxgb3i/Kbuild
+++ b/drivers/scsi/cxgbi/cxgb3i/Kbuild
@@ -1,3 +1,3 @@
-EXTRA_CFLAGS += -I$(srctree)/drivers/net/cxgb3
+ccflags-y += -Idrivers/net/cxgb3
 
 obj-$(CONFIG_SCSI_CXGB3_ISCSI) += cxgb3i.o
diff --git a/drivers/scsi/cxgbi/cxgb4i/Kbuild b/drivers/scsi/cxgbi/cxgb4i/Kbuild
index b9f4af7..4873a25 100644
--- a/drivers/scsi/cxgbi/cxgb4i/Kbuild
+++ b/drivers/scsi/cxgbi/cxgb4i/Kbuild
@@ -1,3 +1,3 @@
-EXTRA_CFLAGS += -I$(srctree)/drivers/net/cxgb4
+ccflags-y += -Idrivers/net/cxgb4
 
 obj-$(CONFIG_SCSI_CXGB4_ISCSI) += cxgb4i.o
-- 
1.7.6.153.g78432

