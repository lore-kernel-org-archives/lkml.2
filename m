Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758219Ab2JKBD6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 21:03:58 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:59072 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758184Ab2JKBDn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 21:03:43 -0400
X-Sasl-enc: 1SQW98jGPtBLkyNdcmNNj1WEJHZUqeeWc13360UnzYOh 1349917422
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Ben Hutchings <ben@decadent.org.uk>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [ 006/120] media: rc: ite-cir: Initialise ite_dev::rdev earlier
Date: Thu, 11 Oct 2012 09:59:18 +0900
Message-Id: <20121011005826.516815785@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121011005825.364610894@linuxfoundation.org>
References: <20121011005825.364610894@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Hutchings <ben@decadent.org.uk>

commit 4b961180ef275035b1538317ffd0e21e80e63e77 upstream.

ite_dev::rdev is currently initialised in ite_probe() after
rc_register_device() returns.  If a newly registered device is opened
quickly enough, we may enable interrupts and try to use ite_dev::rdev
before it has been initialised.  Move it up to the earliest point we
can, right after calling rc_allocate_device().

Reported-and-tested-by: YunQiang Su <wzssyqa@gmail.com>

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/rc/ite-cir.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/rc/ite-cir.c
+++ b/drivers/media/rc/ite-cir.c
@@ -1473,6 +1473,7 @@ static int ite_probe(struct pnp_dev *pde
 	rdev = rc_allocate_device();
 	if (!rdev)
 		goto failure;
+	itdev->rdev = rdev;
 
 	ret = -ENODEV;
 
@@ -1604,7 +1605,6 @@ static int ite_probe(struct pnp_dev *pde
 	if (ret)
 		goto failure;
 
-	itdev->rdev = rdev;
 	ite_pr(KERN_NOTICE, "driver has been successfully loaded\n");
 
 	return 0;


