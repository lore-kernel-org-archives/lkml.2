Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757175Ab0JLIZA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 04:25:00 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:55625 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757119Ab0JLIY5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 04:24:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=SbEqbiuceDpwWx8W1ZbgnwRw4iB3zNszN+HhpqGmvZ7xbrFQ4cLy61b8AW4DgnHv3d
         ki//XApcp+gg42I5z84INu/1QuTqqL92/EHqRnLkUr/bkFls6TYNpHdImjv0vrsBUdbv
         gap7lxAe01st93IP/Vvwf6xWeCzHUN5DoN3V0=
From: Marek Belisko <marek.belisko@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>,
        Marek Belisko <marek.belisko@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        Vasiliy Kulikov <segooon@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Cc: Marek Belisko <marek.belisko@gmail.com>
Subject: [PATCH 2/4] staging: ft1000: Fix memory leak when polling fail.
Date: Tue, 12 Oct 2010 10:26:41 +0200
Message-Id: <1286872003-12449-3-git-send-email-marek.belisko@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1286872003-12449-1-git-send-email-marek.belisko@gmail.com>
References: <1286872003-12449-1-git-send-email-marek.belisko@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marek Belisko <marek.belisko@gmail.com>
---
 drivers/staging/ft1000/ft1000-usb/ft1000_usb.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c
index cf041f3..dc2ef98 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c
@@ -200,7 +200,8 @@ static int ft1000_probe(struct usb_interface *interface, const struct usb_device
             {
                 kthread_stop(pft1000info->pPollThread );
             }
-            return 0;
+		ret = -EIO;
+		goto err_load;
         }
         msleep(100);
         DEBUG("ft1000_probe::Waiting for Card Ready\n");
-- 
1.7.1

