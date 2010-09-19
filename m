Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754365Ab0ISMy5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Sep 2010 08:54:57 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:44711 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754263Ab0ISMyy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Sep 2010 08:54:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=sHhTFL80BFjTFIxvrEuKhTP0xts0KDm5fF9KaqKQsYX8mmwjujOqzN9r95YR8vrb3A
         WtXERUr8LeV0FMMlOTnbyfGlzgIvnWOLTXzVDhyXwuMYS0qDhqqPeJjbMiCmgIzbnbEW
         pNtDxiYoXiq6878+cTC/ydZgPa5k3DCtmApbM=
From: Vasiliy Kulikov <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Jiri Slaby <jirislaby@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 04/14] memstick: core: fix device_register() error handling
Date: Sun, 19 Sep 2010 16:54:49 +0400
Message-Id: <1284900889-24369-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If device_register() fails then call put_device().
See comment to device_register.

Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
---
 compile tested.

 drivers/memstick/core/memstick.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/memstick/core/memstick.c b/drivers/memstick/core/memstick.c
index c00fe82..4303b7e 100644
--- a/drivers/memstick/core/memstick.c
+++ b/drivers/memstick/core/memstick.c
@@ -465,6 +465,7 @@ static void memstick_check(struct work_struct *work)
 		if (!host->card) {
 			host->card = card;
 			if (device_register(&card->dev)) {
+				put_device(&card->dev);
 				kfree(host->card);
 				host->card = NULL;
 			}
-- 
1.7.0.4

