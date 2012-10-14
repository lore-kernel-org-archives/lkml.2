Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755013Ab2JNO5z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 10:57:55 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46521 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932199Ab2JNOn1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 10:43:27 -0400
Message-Id: <20121014143543.958562615@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 14 Oct 2012 15:36:48 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ian Abbott <abbotti@mev.co.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 075/147] staging: comedi: jr3_pci: fix iomem dereference
In-Reply-To: <20121014143533.742627615@decadent.org.uk>
X-SA-Exim-Connect-IP: 77.75.106.1
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Abbott <abbotti@mev.co.uk>

commit e1878957b4676a17cf398f7f5723b365e9a2ca48 upstream.

Correct a direct dereference of I/O memory to use an appropriate I/O
memory access function.  Note that the pointer being dereferenced is not
currently tagged with `__iomem` but I plan to correct that for 3.7.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/staging/comedi/drivers/jr3_pci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/staging/comedi/drivers/jr3_pci.c
+++ b/drivers/staging/comedi/drivers/jr3_pci.c
@@ -913,7 +913,7 @@ static int jr3_pci_attach(struct comedi_
 	}
 
 	/*  Reset DSP card */
-	devpriv->iobase->channel[0].reset = 0;
+	writel(0, &devpriv->iobase->channel[0].reset);
 
 	result = comedi_load_firmware(dev, "jr3pci.idm", jr3_download_firmware);
 	printk("Firmare load %d\n", result);


