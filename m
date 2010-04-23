Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932101Ab0DWV5z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 17:57:55 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:42925 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757425Ab0DWV5x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 17:57:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=LekKwuwWy+DWAleo3H/sMcEUjeBs0dVN7LqE4ocjw9BNRRi0sPvGP8ds/mcGvOgeKo
         jLnVWYhx9Yas+otWTt5ogW8zv1FLJrjOC8HRFzy2d2Q5Ay82RwHJKEjNkz08FU3OIPkj
         Y8Tbd8V/3bvZVsGtr5epd7vtGaEN76vVmPi68=
MIME-Version: 1.0
Date: Fri, 23 Apr 2010 16:57:52 -0500
Message-ID: <h2he6bf505b1004231457h334413dfweb4f6d6d6bf7692@mail.gmail.com>
Subject: Patch to gianfar.c for 2.6.33.2-rt13
From: Xianghua Xiao <xiaoxianghua@gmail.com>
To: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas,
I found another gianfar.c issue under rt kernel, here is a small patch:

diff --git a/drivers/net/gianfar.c b/drivers/net/gianfar.c
index 453cfcf..5c85948 100644
--- a/drivers/net/gianfar.c
+++ b/drivers/net/gianfar.c
@@ -1553,7 +1553,7 @@ void stop_gfar(struct net_device *dev)


        /* Lock it down */
-       local_irq_save(flags);
+       local_irq_save_nort(flags);
        lock_tx_qs(priv);
        lock_rx_qs(priv);

@@ -1561,7 +1561,7 @@ void stop_gfar(struct net_device *dev)

        unlock_rx_qs(priv);
        unlock_tx_qs(priv);
-       local_irq_restore(flags);
+       local_irq_restore_nort(flags);

        /* Free the IRQs */
        if (priv->device_flags & FSL_GIANFAR_DEV_HAS_MULTI_INTR) {

thanks,
xianghua
