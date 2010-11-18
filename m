Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755864Ab0KRIrL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 03:47:11 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:64234 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755828Ab0KRIrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 03:47:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=iQR9MLa5wNx1uSuEe2vz3YPK/mkBoaXEuxibj+Ff2ybFVJ4Mic9T3WJLDRZpZT7kr3
         yrUr5SzKo7WNMxO+dbYP72fdV8wZIeYOnP0vYtQywXITb3ILJ+NjOTVBsY/bq+n3AAYk
         Wleali/gwgTM7yYKhffTYAE1tpBkG1tz/N9Po=
From: Marek Belisko <marek.belisko@open-nandra.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@gmail.com>
Subject: [PATCH resend] staging: ft1000: Fix compilation warning.
Date: Thu, 18 Nov 2010 09:49:09 +0100
Message-Id: <1290070149-12604-1-git-send-email-marek.belisko@open-nandra.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marek Belisko <marek.belisko@gmail.com>

This patch fix following warning:
drivers/staging/ft1000/ft1000-usb/ft1000_usb.c:67:22:
warning: ‘pft1000info’ may be used uninitialized in this function

Signed-off-by: Marek Belisko <marek.belisko@gmail.com>
---
 drivers/staging/ft1000/ft1000-usb/ft1000_usb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c
index 1369f06..f88ff86 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c
@@ -64,7 +64,7 @@ static int ft1000_probe(struct usb_interface *interface,
 	int i, ret = 0, size;
 
 	struct ft1000_device *ft1000dev;
-	struct ft1000_info *pft1000info;
+	struct ft1000_info *pft1000info = NULL;
 	const struct firmware *dsp_fw;
 
 	ft1000dev = kmalloc(sizeof(struct ft1000_device), GFP_KERNEL);
-- 
1.7.1

