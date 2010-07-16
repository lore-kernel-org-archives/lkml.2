Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965955Ab0GPQQE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 12:16:04 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:54805 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966012Ab0GPQP7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 12:15:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=ay5WocsRNagHdaM5jKHS30uCHLiXUHwOoqL1G8wkFNkCBeHGkESkgFxIfp3p5ZQGKB
         Xv/d9MXHp96fa88gdyLPfizX/Ufoxy2wdnd9BQHNc1IIPv9w6XEI9qmXq7cvU3upn6ey
         lesVcLatPYu2aDy80uDD8QzKPbBG7+acM92qQ=
From: Kulikov Vasiliy <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Giuliano Pochini <pochini@shiny.it>, Julia Lawall <julia@diku.dk>,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org
Subject: [PATCH 11/15] pci: echoaudio: check kmalloc() result
Date: Fri, 16 Jul 2010 20:15:43 +0400
Message-Id: <1279296943-25187-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If kmalloc() fails exit with -ENOMEM.

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 sound/pci/echoaudio/echoaudio.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/sound/pci/echoaudio/echoaudio.c b/sound/pci/echoaudio/echoaudio.c
index 668a5ec..20763dd 100644
--- a/sound/pci/echoaudio/echoaudio.c
+++ b/sound/pci/echoaudio/echoaudio.c
@@ -2250,6 +2250,8 @@ static int snd_echo_resume(struct pci_dev *pci)
 	DE_INIT(("resume start\n"));
 	pci_restore_state(pci);
 	commpage_bak = kmalloc(sizeof(struct echoaudio), GFP_KERNEL);
+	if (commpage_bak == NULL)
+		return -ENOMEM;
 	commpage = chip->comm_page;
 	memcpy(commpage_bak, commpage, sizeof(struct comm_page));
 
-- 
1.7.0.4

