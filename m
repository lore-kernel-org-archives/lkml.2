Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758152Ab2JKCLb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 22:11:31 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:52872 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758085Ab2JKCL2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 22:11:28 -0400
X-Sasl-enc: e/n98bwT8Vygi5JgxuyEUIY/jrGDaTL8B5YjDJqbwTz9 1349921487
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Ben Hutchings <ben@decadent.org.uk>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [ 03/84] media: rc: ite-cir: Initialise ite_dev::rdev earlier
Date: Thu, 11 Oct 2012 11:02:47 +0900
Message-Id: <20121011015417.661641796@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121011015417.017144658@linuxfoundation.org>
References: <20121011015417.017144658@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1477,6 +1477,7 @@ static int ite_probe(struct pnp_dev *pde
 	rdev = rc_allocate_device();
 	if (!rdev)
 		goto failure;
+	itdev->rdev = rdev;
 
 	ret = -ENODEV;
 
@@ -1608,7 +1609,6 @@ static int ite_probe(struct pnp_dev *pde
 	if (ret)
 		goto failure;
 
-	itdev->rdev = rdev;
 	ite_pr(KERN_NOTICE, "driver has been successfully loaded\n");
 
 	return 0;


