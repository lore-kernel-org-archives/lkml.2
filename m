Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753792Ab2HMUnk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 16:43:40 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:51310 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753576Ab2HMUUv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 16:20:51 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Luis Henriques <luis.henriques@canonical.com>,
        Jarod Wilson <jarod@redhat.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [ 12/82] media: ene_ir: Fix driver initialisation
Date: Mon, 13 Aug 2012 13:18:48 -0700
Message-Id: <20120813201747.503720230@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120813201746.448504360@linuxfoundation.org>
References: <20120813201746.448504360@linuxfoundation.org>
User-Agent: quilt/0.60-20.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luis Henriques <luis.henriques@canonical.com>

commit b31b021988fed9e3741a46918f14ba9b063811db upstream.

commit 9ef449c6b31bb6a8e6dedc24de475a3b8c79be20 ("[media] rc: Postpone ISR
registration") fixed an early ISR registration on several drivers.  It did
however also introduced a bug by moving the invocation of pnp_port_start()
to the end of the probe function.

This patch fixes this issue by moving the invocation of pnp_port_start() to
an earlier stage in the probe function.

Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
Cc: Jarod Wilson <jarod@redhat.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/rc/ene_ir.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/media/rc/ene_ir.c
+++ b/drivers/media/rc/ene_ir.c
@@ -1018,6 +1018,8 @@ static int ene_probe(struct pnp_dev *pnp
 
 	spin_lock_init(&dev->hw_lock);
 
+	dev->hw_io = pnp_port_start(pnp_dev, 0);
+
 	pnp_set_drvdata(pnp_dev, dev);
 	dev->pnp_dev = pnp_dev;
 
@@ -1072,7 +1074,6 @@ static int ene_probe(struct pnp_dev *pnp
 
 	/* claim the resources */
 	error = -EBUSY;
-	dev->hw_io = pnp_port_start(pnp_dev, 0);
 	if (!request_region(dev->hw_io, ENE_IO_SIZE, ENE_DRIVER_NAME)) {
 		dev->hw_io = -1;
 		dev->irq = -1;


