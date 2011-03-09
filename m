Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757069Ab1CIAyf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 19:54:35 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:37526 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756834Ab1CIAyX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 19:54:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=dEy6EbfteRXj7Ag0QDJ19jJvl7RQ4vHohDVxwpxYjLd1KDgEVkoYb0M/T2jMEKWwqp
         RsInznvzt2sx3o5HHG1XUFa4tUablvTy+bCGmhVl+Q315s9tWwjc3YowsRrks4nfNb91
         czEmCPiKTQ49mP0Ab04UvCbZRrW1CGWTDwizg=
From: Alexander Beregalov <a.beregalov@gmail.com>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, Alexander Beregalov <a.beregalov@gmail.com>
Subject: [PATCH next 5/5] staging: rts_pstor: optimize kmalloc to kzalloc
Date: Wed,  9 Mar 2011 03:53:38 +0300
Message-Id: <1299632018-6774-5-git-send-email-a.beregalov@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1299632018-6774-1-git-send-email-a.beregalov@gmail.com>
References: <1299632018-6774-1-git-send-email-a.beregalov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use kzalloc rather than kmalloc followed by memset with 0.
Found by coccinelle.

Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
---
 drivers/staging/rts_pstor/rtsx.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/rts_pstor/rtsx.c b/drivers/staging/rts_pstor/rtsx.c
index c3f33d1..db3470e 100644
--- a/drivers/staging/rts_pstor/rtsx.c
+++ b/drivers/staging/rts_pstor/rtsx.c
@@ -931,11 +931,10 @@ static int __devinit rtsx_probe(struct pci_dev *pci, const struct pci_device_id
 	dev = host_to_rtsx(host);
 	memset(dev, 0, sizeof(struct rtsx_dev));
 
-	dev->chip = (struct rtsx_chip *)kmalloc(sizeof(struct rtsx_chip), GFP_KERNEL);
+	dev->chip = kzalloc(sizeof(struct rtsx_chip), GFP_KERNEL);
 	if (dev->chip == NULL) {
 		goto errout;
 	}
-	memset(dev->chip, 0, sizeof(struct rtsx_chip));
 
 	spin_lock_init(&dev->reg_lock);
 	mutex_init(&(dev->dev_mutex));
-- 
1.7.4.1

