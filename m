Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756805Ab1HVKjz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 06:39:55 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:33615 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756647Ab1HVKjv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 06:39:51 -0400
From: Pelle Windestam <iceaway@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Pelle Windestam <iceaway@gmail.com>
Subject: [PATCH 1/1] staging: comedi: changed local function prototype from extern to static.
Date: Mon, 22 Aug 2011 12:39:45 +0200
Message-Id: <1314009585-5025-1-git-send-email-iceaway@gmail.com>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed local function prototype do_become_nonbusy(...) from extern to
static, fixing the error from checkpatch.pl.

Signed-off-by: Pelle Windestam <iceaway@gmail.com>
---
 drivers/staging/comedi/comedi_fops.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/comedi/comedi_fops.c b/drivers/staging/comedi/comedi_fops.c
index e90e3cc..d7b6a28 100644
--- a/drivers/staging/comedi/comedi_fops.c
+++ b/drivers/staging/comedi/comedi_fops.c
@@ -101,7 +101,7 @@ static int do_insn_ioctl(struct comedi_device *dev,
 static int do_poll_ioctl(struct comedi_device *dev, unsigned int subd,
 			 void *file);
 
-extern void do_become_nonbusy(struct comedi_device *dev,
+static void do_become_nonbusy(struct comedi_device *dev,
 			      struct comedi_subdevice *s);
 static int do_cancel(struct comedi_device *dev, struct comedi_subdevice *s);
 
@@ -1786,7 +1786,8 @@ done:
 /*
    This function restores a subdevice to an idle state.
  */
-void do_become_nonbusy(struct comedi_device *dev, struct comedi_subdevice *s)
+static void do_become_nonbusy(struct comedi_device *dev,
+			      struct comedi_subdevice *s)
 {
 	struct comedi_async *async = s->async;
 
-- 
1.7.3.4

