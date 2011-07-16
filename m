Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753354Ab1GPBLg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 21:11:36 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:43785 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752702Ab1GPBLf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 21:11:35 -0400
From: Mariano Guerra <luismarianoguerra@gmail.com>
To: gregkh@suse.de, abbotti@mev.co.uk, fmhess@users.sourceforge.net
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Mariano Guerra <luismarianoguerra@gmail.com>
Subject: [PATCH] Staging: comedi: do not initialise statics to 0 or NULL
Date: Sat, 16 Jul 2011 02:11:23 +0100
Message-Id: <1310778683-3717-1-git-send-email-luismarianoguerra@gmail.com>
X-Mailer: git-send-email 1.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to adv_pci_dio.c that fixes an error initializing

static struct pci_dio_private *pci_priv to NULL

removed the initialization.
found by the checkpatch.pl tool.

	Signed-off-by: Mariano Guerra <luismarianoguerra@gmail.com>
---
 drivers/staging/comedi/drivers/adv_pci_dio.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/comedi/drivers/adv_pci_dio.c b/drivers/staging/comedi/drivers/adv_pci_dio.c
index d23799b..69334f6 100644
--- a/drivers/staging/comedi/drivers/adv_pci_dio.c
+++ b/drivers/staging/comedi/drivers/adv_pci_dio.c
@@ -422,7 +422,7 @@ struct pci_dio_private {
 	unsigned short IDIFiltrHigh[8];	/*  IDI's filter value high signal */
 };
 
-static struct pci_dio_private *pci_priv = NULL;	/* list of allocated cards */
+static struct pci_dio_private *pci_priv;	/* list of allocated cards */
 
 #define devpriv ((struct pci_dio_private *)dev->private)
 #define this_board ((const struct dio_boardtype *)dev->board_ptr)
-- 
1.7.6

