Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755192Ab2BEW2p (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 17:28:45 -0500
Received: from 1wt.eu ([62.212.114.60]:62171 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754981Ab2BEW2a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 17:28:30 -0500
Message-Id: <20120205220951.376453886@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Sun, 05 Feb 2012 23:10:34 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Vasily Averin <vvs@sw.ru>, Mark Salyzyn <mark_salyzyn@us.xyratex.com>,
        James Bottomley <JBottomley@Parallels.com>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: [PATCH 45/91] aacraid: reset should disable MSI interrupt
In-Reply-To: <0635750f5f06ed2ca212b91fcb5c4483@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-longterm review patch.  If anyone has any objections, please let us know.

------------------

commit d0efab26f89506387a1bde898556660e06d7eb15 upstream.

scsi reset on hardware with enabled MSI interrupts generates WARNING message

[11027.798722] aacraid: Host adapter abort request (0,0,0,0)
[11027.798814] aacraid: Host adapter reset request. SCSI hang ?
[11087.762237] aacraid: SCSI bus appears hung
[11135.082543] ------------[ cut here ]------------
[11135.082646] WARNING: at drivers/pci/msi.c:658 pci_enable_msi_block+0x251/0x290()

Signed-off-by: Vasily Averin <vvs@sw.ru>
Acked-by: Mark Salyzyn <mark_salyzyn@us.xyratex.com>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/scsi/aacraid/commsup.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

Index: longterm-2.6.27/drivers/scsi/aacraid/commsup.c
===================================================================
--- longterm-2.6.27.orig/drivers/scsi/aacraid/commsup.c	2012-02-05 22:34:33.642915831 +0100
+++ longterm-2.6.27/drivers/scsi/aacraid/commsup.c	2012-02-05 22:34:41.243915381 +0100
@@ -1202,6 +1202,8 @@
 	kfree(aac->queues);
 	aac->queues = NULL;
 	free_irq(aac->pdev->irq, aac);
+	if (aac->msi)
+		pci_disable_msi(aac->pdev);
 	kfree(aac->fsa_dev);
 	aac->fsa_dev = NULL;
 	quirks = aac_get_driver_ident(index)->quirks;


