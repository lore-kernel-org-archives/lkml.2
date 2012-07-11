Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933306Ab2GKVtW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 17:49:22 -0400
Received: from mail131.messagelabs.com ([216.82.242.99]:6547 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933242Ab2GKVtV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 17:49:21 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-5.tower-131.messagelabs.com!1342043330!24798556!5
X-Originating-IP: [216.166.12.97]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 01/30] staging: comedi: add pci_dev pointer to comedi_device
Date: Wed, 11 Jul 2012 14:49:14 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207111449.15203.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The pci_dev pointer in the private driver data is used by every
comedi pci driver. Some of them only have the need for the
private data because of this pointer.

Introduce the pci_dev pointer in the comedi_device struct so it
can be used instead of needing it in the private data.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/comedidev.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/staging/comedi/comedidev.h b/drivers/staging/comedi/comedidev.h
index de8c99c..55f2373 100644
--- a/drivers/staging/comedi/comedidev.h
+++ b/drivers/staging/comedi/comedidev.h
@@ -212,6 +212,8 @@ struct comedi_device {
 	 * DMA_NONE */
 	struct device *hw_dev;
 
+	struct pci_dev *pcidev;
+
 	const char *board_name;
 	const void *board_ptr;
 	int attached;
-- 
1.7.11

