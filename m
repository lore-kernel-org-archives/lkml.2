Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932609Ab2JNOqh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 10:46:37 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46787 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932456Ab2JNOoS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 10:44:18 -0400
Message-Id: <20121014143537.486043451@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 14 Oct 2012 15:36:00 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [ 027/147] [media] rc: ite-cir: Initialise ite_dev::rdev earlier
In-Reply-To: <20121014143533.742627615@decadent.org.uk>
X-SA-Exim-Connect-IP: 77.75.106.1
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
---
 drivers/media/rc/ite-cir.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/rc/ite-cir.c b/drivers/media/rc/ite-cir.c
index 36fe5a3..24c77a4 100644
--- a/drivers/media/rc/ite-cir.c
+++ b/drivers/media/rc/ite-cir.c
@@ -1473,6 +1473,7 @@ static int ite_probe(struct pnp_dev *pdev, const struct pnp_device_id
 	rdev = rc_allocate_device();
 	if (!rdev)
 		goto failure;
+	itdev->rdev = rdev;
 
 	ret = -ENODEV;
 
@@ -1604,7 +1605,6 @@ static int ite_probe(struct pnp_dev *pdev, const struct pnp_device_id
 	if (ret)
 		goto failure;
 
-	itdev->rdev = rdev;
 	ite_pr(KERN_NOTICE, "driver has been successfully loaded\n");
 
 	return 0;


