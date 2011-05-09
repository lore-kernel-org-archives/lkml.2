Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754359Ab1EITkE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 15:40:04 -0400
Received: from ch1outboundpool.messaging.microsoft.com ([216.32.181.183]:35126
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754250Ab1EITkB convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 15:40:01 -0400
X-SpamScore: -21
X-BigFish: VPS-21(zz9371O1447R542Mzz1202hzz8275bh8275dhz2ei2a8h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:avexcashub1.qlogic.com;RD:avexcashub2.qlogic.com;EFVD:NLI
From: Mike Marciniszyn <mike.marciniszyn@qlogic.com>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
CC: "roland@kernel.org" <roland@kernel.org>,
        "sean.hefty@intel.com" <sean.hefty@intel.com>,
        "hal.rosenstock@gmail.com" <hal.rosenstock@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Mon, 9 May 2011 12:39:56 -0700
Subject: RE: [PATCH 2/2] qib: use pci_dev->revision
Thread-Topic: [PATCH 2/2] qib: use pci_dev->revision
Thread-Index: AcwM3ldJO66u96weRye5Qauir6A2CABolo8A
Message-ID: <35AAF1E4A771E142979F27B51793A4888838BCBDB9@AVEXMB1.qlogic.org>
References: <201105072141.56328.sshtylyov@ru.mvista.com>
In-Reply-To: <201105072141.56328.sshtylyov@ru.mvista.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: qlogic.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The driver reads PCI revision ID from the PCI configuration register while it's
> already stored by PCI subsystem in the 'revision' field of 'struct pci_dev'...

Thanks for the patch.

qib: use pci_dev->revision

Acked-by: Mike Marciniszyn <mike.marciniszyn@qlogic.com>


-----Original Message-----
From: linux-rdma-owner@vger.kernel.org [mailto:linux-rdma-owner@vger.kernel.org] On Behalf Of Sergei Shtylyov
Sent: Saturday, May 07, 2011 1:42 PM
To: linux-rdma@vger.kernel.org
Cc: roland@kernel.org; sean.hefty@intel.com; hal.rosenstock@gmail.com; linux-kernel
Subject: [PATCH 2/2] qib: use pci_dev->revision

The driver reads PCI revision ID from the PCI configuration register while it's
already stored by PCI subsystem in the 'revision' field of 'struct pci_dev'...

Signed-off-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

---
The patch is against the recent Linus' tree.

 drivers/infiniband/hw/qib/qib_pcie.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

Index: linux-2.6/drivers/infiniband/hw/qib/qib_pcie.c
===================================================================
--- linux-2.6.orig/drivers/infiniband/hw/qib/qib_pcie.c
+++ linux-2.6/drivers/infiniband/hw/qib/qib_pcie.c
@@ -526,11 +526,8 @@ static int qib_tune_pcie_coalesce(struct
         */
        devid = parent->device;
        if (devid >= 0x25e2 && devid <= 0x25fa) {
-               u8 rev;
-
                /* 5000 P/V/X/Z */
-               pci_read_config_byte(parent, PCI_REVISION_ID, &rev);
-               if (rev <= 0xb2)
+               if (parent->revision <= 0xb2)
                        bits = 1U << 10;
                else
                        bits = 7U << 10;
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html


This message and any attached documents contain information from QLogic Corporation or its wholly-owned subsidiaries that may be confidential. If you are not the intended recipient, you may not read, copy, distribute, or use this information. If you have received this transmission in error, please notify the sender immediately by reply e-mail and then delete this message.

