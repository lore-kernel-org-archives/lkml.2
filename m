Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932139Ab0KNUIp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Nov 2010 15:08:45 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:37539 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756530Ab0KNUIl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Nov 2010 15:08:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=CQKeW+k4cCaJsAhS42RuL3tc9NtLLW0th+ivqGUMeHHJVs7GHg4dq6U7DQr22MirG7
         qz68DsInaMl6rrkZdE0UOrf50Lfjxa+J/7hiEm6av/KwD3wEVUpuALst4UTOTTyZv24v
         4LV9FoZh3euh1oQNar+gVF2dqVtKrXwsOb89k=
From: Vasiliy Kulikov <segoon@openwall.com>
To: kernel-janitors@vger.kernel.org
Cc: Eilon Greenstein <eilong@broadcom.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net: bnx2x: fix error value sign
Date: Sun, 14 Nov 2010 23:08:34 +0300
Message-Id: <1289765315-6028-1-git-send-email-segoon@openwall.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

bnx2x_init_one() should return negative value on error.
By mistake it returns ENODEV instead of -ENODEV.

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
---
 Compile tested.

 drivers/net/bnx2x/bnx2x_main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/bnx2x/bnx2x_main.c b/drivers/net/bnx2x/bnx2x_main.c
index 4a6f0ea..be52edc 100644
--- a/drivers/net/bnx2x/bnx2x_main.c
+++ b/drivers/net/bnx2x/bnx2x_main.c
@@ -9064,7 +9064,7 @@ static int __devinit bnx2x_init_one(struct pci_dev *pdev,
 	default:
 		pr_err("Unknown board_type (%ld), aborting\n",
 			   ent->driver_data);
-		return ENODEV;
+		return -ENODEV;
 	}
 
 	cid_count += CNIC_CONTEXT_USE;
-- 
1.7.0.4

