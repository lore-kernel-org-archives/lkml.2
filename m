Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757283Ab0EBP5J (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 May 2010 11:57:09 -0400
Received: from mail-qy0-f189.google.com ([209.85.221.189]:64086 "EHLO
	mail-qy0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755133Ab0EBP5G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 May 2010 11:57:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:content-type:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=JR4rqR8uwGfFJREyhEPm8e6hhuy5YPKMQkTq3FrsJf8Do99SKYSS5dOYYrTWpxYbCs
         6PwUgqeI78fLTDwn9XCn9WVdhQffwYA12tMxQ4fk+2ber9zlRM3MrUM+oqH1UBhpTp9Z
         eT5L4AwigqzSrJhl2500U/exh5eScP+WPATpM=
Subject: [PATCH] Staging: cxt1e1: Fix build error
From: Javier Martinez Canillas <martinez.javier@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>, Bob Beers <bob.beers@gmail.com>,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 02 May 2010 11:56:53 -0400
Message-ID: <1272815813.16886.5.camel@lenovo>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With today linux-next I got this compilation error:

drivers/staging/cxt1e1/linux.c: In function ‘c4_add_dev’:
drivers/staging/cxt1e1/linux.c:1195: error: ‘struct net_device’ has no member named ‘priv’

I think this patch solves the issue

Signed-off-by: Javier Martinez Canillas <martinez.javier@gmail.com>
---
 drivers/staging/cxt1e1/linux.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/cxt1e1/linux.c b/drivers/staging/cxt1e1/linux.c
index 23e184d..d8ef006 100644
--- a/drivers/staging/cxt1e1/linux.c
+++ b/drivers/staging/cxt1e1/linux.c
@@ -1192,7 +1192,7 @@ c4_add_dev (hdw_info_t * hi, int brdno, unsigned long f0, unsigned long f1,
                 hi->devname, irq1);
         unregister_netdev (ndev);
         free_irq (irq0, ndev);
-        OS_kfree (ndev->priv);
+	OS_kfree(netdev_priv(ndev));
         OS_kfree (ndev);
         error_flag = EIO;
         return 0;
-- 
1.7.0.4





