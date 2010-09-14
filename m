Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755490Ab0INUYx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 16:24:53 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:49572 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755300Ab0INUXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 16:23:20 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 09/15] viotape: use noop_llseek
Date: Tue, 14 Sep 2010 22:22:37 +0200
Message-Id: <1284495763-7506-10-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1284495763-7506-1-git-send-email-arnd@arndb.de>
References: <1284495763-7506-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:3d6nYEz2IcL7dnHD6Xs3dPZarGrc+V1dnpc6U1YMxWM
 0pImh/NPj6yFAbpjqklA/zgzjWn6awQcIQLbqTytbZ3olkLMmb
 JK5BHj6y12LDgugzfNGfsBYbVy1dqTyXbSFSwashMnY3uv91IW
 o3jc9TTXAYNmtj0l5PoV1lnbLuHqiqgkXI4iDN1ej9P3e2D0Uh
 WcZ3v0au/EOlkZtQaN0ng==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some applications try to seek on tape devices
and fail if they return an error. Since we
want to change the default llseek action to
no_llseek, viotape needs to be changed to use
noop_llseek explicitly.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/char/viotape.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/char/viotape.c b/drivers/char/viotape.c
index 42f7fa4..442c3f5 100644
--- a/drivers/char/viotape.c
+++ b/drivers/char/viotape.c
@@ -804,6 +804,7 @@ const struct file_operations viotap_fops = {
 	.unlocked_ioctl =	viotap_unlocked_ioctl,
 	.open =			viotap_open,
 	.release =		viotap_release,
+	.llseek = 		noop_llseek,
 };
 
 /* Handle interrupt events for tape */
-- 
1.7.1

