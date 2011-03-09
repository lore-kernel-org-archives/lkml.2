Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757040Ab1CIAyY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 19:54:24 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:41583 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757018Ab1CIAyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 19:54:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=vW+vNigdcBW7EMSDkOZqZbEZVKYwP4RYm4DIVyd+rVCPriauFI3SG+L23M8jU1TO31
         ne4uymVNG0SsiYyKWcIJk+LfVEbGlrSB9oRH4VIZCg19ExVga8ismSs0EM+NCZpKrOnx
         aO++XUHkUPlMnvKNaH1h4BB8+YO8gMks5kCQw=
From: Alexander Beregalov <a.beregalov@gmail.com>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, Alexander Beregalov <a.beregalov@gmail.com>
Subject: [PATCH next 4/5] staging: ft1000: optimize kmalloc to kzalloc
Date: Wed,  9 Mar 2011 03:53:37 +0300
Message-Id: <1299632018-6774-4-git-send-email-a.beregalov@gmail.com>
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
 drivers/staging/ft1000/ft1000-pcmcia/ft1000_cs.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_cs.c b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_cs.c
index 874919c..10af477 100644
--- a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_cs.c
+++ b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_cs.c
@@ -120,11 +120,10 @@ static int ft1000_attach(struct pcmcia_device *link)
 
 	DEBUG(0, "ft1000_cs: ft1000_attach()\n");
 
-	local = kmalloc(sizeof(local_info_t), GFP_KERNEL);
+	local = kzalloc(sizeof(local_info_t), GFP_KERNEL);
 	if (!local) {
 		return -ENOMEM;
 	}
-	memset(local, 0, sizeof(local_info_t));
 	local->link = link;
 
 	link->priv = local;
-- 
1.7.4.1

