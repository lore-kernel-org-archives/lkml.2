Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946122Ab2JDVYM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 17:24:12 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:57562 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946101Ab2JDVYE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 17:24:04 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Ian Abbott <abbotti@mev.co.uk>
Subject: [ 14/52] staging: comedi: jr3_pci: fix iomem dereference
Date: Thu,  4 Oct 2012 14:21:05 -0700
Message-Id: <20121004210637.128041936@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.2.421.g261b511
In-Reply-To: <20121004210635.372689554@linuxfoundation.org>
References: <20121004210635.372689554@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Abbott <abbotti@mev.co.uk>

commit e1878957b4676a17cf398f7f5723b365e9a2ca48 upstream.

Correct a direct dereference of I/O memory to use an appropriate I/O
memory access function.  Note that the pointer being dereferenced is not
currently tagged with `__iomem` but I plan to correct that for 3.7.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/comedi/drivers/jr3_pci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/staging/comedi/drivers/jr3_pci.c
+++ b/drivers/staging/comedi/drivers/jr3_pci.c
@@ -905,7 +905,7 @@ static int jr3_pci_attach(struct comedi_
 	}
 
 	/*  Reset DSP card */
-	devpriv->iobase->channel[0].reset = 0;
+	writel(0, &devpriv->iobase->channel[0].reset);
 
 	result = comedi_load_firmware(dev, "jr3pci.idm", jr3_download_firmware);
 	dev_dbg(dev->hw_dev, "Firmare load %d\n", result);


