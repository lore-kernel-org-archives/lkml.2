Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754531Ab1ABHnx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 02:43:53 -0500
Received: from mail.windriver.com ([147.11.1.11]:36381 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754299Ab1ABHYa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:24:30 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Kenneth Waters <kwwaters@gmail.com>,
        Dmitry Torokhov <dtor@mail.ru>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 178/260] Input: joydev - fix JSIOCSAXMAP ioctl
Date: Sun,  2 Jan 2011 02:17:54 -0500
Message-Id: <1293952756-15010-179-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:23:25.0619 (UTC) FILETIME=[F1CDC830:01CBAA4D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kenneth Waters <kwwaters@gmail.com>

commit d2520a426dc3033c00077e923a553fc6c98c7564 upstream.

Fixed JSIOCSAXMAP ioctl to update absmap, the map from hardware axis to
event axis in addition to abspam.  This fixes a regression introduced
by 999b874f.

Signed-off-by: Kenneth Waters <kwwaters@gmail.com>
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/input/joydev.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/input/joydev.c b/drivers/input/joydev.c
index 423e0e6..0325480 100644
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
1.7.3.3

