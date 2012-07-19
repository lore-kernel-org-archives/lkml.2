Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752608Ab2GSRjv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 13:39:51 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:64054 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751419Ab2GSRju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 13:39:50 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-11.tower-127.messagelabs.com!1342719547!9065570!61
X-Originating-IP: [216.166.12.99]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 01/90 v2] staging: comedi: comedidev.h: introduce comedi_to_pci_dev() helper
Date: Thu, 19 Jul 2012 10:39:33 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207191039.34277.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce a wrapper for to_pci_dev() to allow the comedi_pci_drivers
to store the pci_dev pointer in the comedi_device hw_dev variable and
retrieve it easily.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbot <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
v2: Ian Abbott pointed out that the dev->hw_dev needs to be checked
    that it's non-NULL before passing it to to_pci_dev(). As Dan
    Carpenter pointed out, the container_of() just does pointer math
    with the offset. If you give it a NULL pointer it returns a
    bogus pointer back.

 drivers/staging/comedi/comedidev.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/staging/comedi/comedidev.h b/drivers/staging/comedi/comedidev.h
index de8c99c..f713783 100644
--- a/drivers/staging/comedi/comedidev.h
+++ b/drivers/staging/comedi/comedidev.h
@@ -446,6 +446,11 @@ static inline void comedi_set_hw_dev(struct comedi_device *dev,
 	}
 }
 
+static inline struct pci_dev *comedi_to_pci_dev(struct comedi_device *dev)
+{
+	return dev->hw_dev ? to_pci_dev(dev->hw_dev) : NULL;
+}
+
 int comedi_buf_put(struct comedi_async *async, short x);
 int comedi_buf_get(struct comedi_async *async, short *x);
 
-- 
1.7.11

