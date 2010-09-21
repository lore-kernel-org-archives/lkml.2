Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756101Ab0IUGvu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 02:51:50 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:56050 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755497Ab0IUGvs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 02:51:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=MXs3NLsEnWRt21dqEXKGW+5vUQXYWX7NSyMX5t8yvQnkpDtWJImt0ooOaNnokPTeep
         fTPVaxMROT+FxXCpvuk9+QBRA3lJg+CDWWxdal5DjxIPvhWDxXtq5vRR7Jt/gvZEns3f
         CLqNcePMAVNKKo1Kpz4/VEG0up0c6I+D62Uyw=
From: Kenneth Waters <kwwaters@gmail.com>
To: dmitry.torokhov@gmail.com
Cc: steve@sk2.org, linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kenneth Waters <kwwaters@gmail.com>
Subject: [PATCH] input: joydev: Fix JSIOCSAXMAP ioctl.
Date: Mon, 20 Sep 2010 23:51:25 -0700
Message-Id: <1285051885-20417-1-git-send-email-kwwaters@gmail.com>
X-Mailer: git-send-email 1.7.2.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed JSIOCSAXMAP ioctl to update absmap, the map from hardware axis to
event axis in addition to abspam.  This fixes a regression introduced
by 999b874f.

Signed-off-by: Kenneth Waters <kwwaters@gmail.com>
---
 drivers/input/joydev.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/input/joydev.c b/drivers/input/joydev.c
index d85bd8a..22239e9 100644
--- a/drivers/input/joydev.c
+++ b/drivers/input/joydev.c
@@ -483,6 +483,9 @@ static int joydev_handle_JSIOCSAXMAP(struct joydev *joydev,
 
 	memcpy(joydev->abspam, abspam, len);
 
+	for (i = 0; i < joydev->nabs; i++)
+		joydev->absmap[joydev->abspam[i]] = i;
+
  out:
 	kfree(abspam);
 	return retval;
-- 
1.7.2.2

