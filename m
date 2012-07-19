Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753899Ab2GSBY1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 21:24:27 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:43987 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751729Ab2GSBYX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 21:24:23 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-11.tower-209.messagelabs.com!1342661062!6247806!1
X-Originating-IP: [216.166.12.97]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 01/90] staging: comedi: comedidev.h: introduce comedi_to_pci_dev() helper
Date: Wed, 18 Jul 2012 18:24:15 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207181824.15722.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce a wrapper for to_pci_dev() to allow the comedi pci drivers
to store the pci_dev pointer in the comedi_device hw_dev variable and
retrieve it easily.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/comedidev.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/staging/comedi/comedidev.h b/drivers/staging/comedi/comedidev.h
index de8c99c..620222d 100644
--- a/drivers/staging/comedi/comedidev.h
+++ b/drivers/staging/comedi/comedidev.h
@@ -446,6 +446,11 @@ static inline void comedi_set_hw_dev(struct comedi_device *dev,
 	}
 }
 
+static inline struct pci_dev *comedi_to_pci_dev(struct comedi_device *dev)
+{
+	return to_pci_dev(dev->hw_dev);
+}
+
 int comedi_buf_put(struct comedi_async *async, short x);
 int comedi_buf_get(struct comedi_async *async, short *x);
 
-- 
1.7.11

