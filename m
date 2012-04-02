Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752433Ab2DBOWn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 10:22:43 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:23547 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751755Ab2DBOWm convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:4:1>);
	Mon, 2 Apr 2012 10:22:42 -0400
Message-Id: <4F79D24F020000780007C040@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Mon, 02 Apr 2012 15:22:39 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>
Cc: "xen-devel" <xen-devel@lists.xen.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] xen/pcifront: avoid pci_frontend_enable_msix() falsely
 returning success
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The original XenoLinux code has always had things this way, and for
compatibility reasons (in particular with a subsequent pciback
adjustment) upstream Linux should behave the same way (allowing for two
distinct error indications to be returned by the backend).

Signed-off-by: Jan Beulich <jbeulich@suse.com>

---
 drivers/pci/xen-pcifront.c |    1 +
 1 file changed, 1 insertion(+)

--- 3.4-rc1/drivers/pci/xen-pcifront.c
+++ 3.4-rc1-xen-pcifront-enable-msix-retval/drivers/pci/xen-pcifront.c
@@ -290,6 +290,7 @@ static int pci_frontend_enable_msix(stru
 		} else {
 			printk(KERN_DEBUG "enable msix get value %x\n",
 				op.value);
+			err = op.value;
 		}
 	} else {
 		dev_err(&dev->dev, "enable msix get err %x\n", err);



