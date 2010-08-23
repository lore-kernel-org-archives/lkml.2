Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754249Ab0HWQVY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 12:21:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44051 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752584Ab0HWQVW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 12:21:22 -0400
Message-ID: <4C729FE4.5@redhat.com>
Date: Mon, 23 Aug 2010 17:20:52 +0100
From: Niels de Vos <ndevos@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100806 Fedora/3.1.2-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.2
MIME-Version: 1.0
To: trivial@kernel.org
CC: linux-kernel@vger.kernel.org, Joe Krahn <krahn@niehs.nih.gov>
Subject: [PATCH] parport_pc: show the detection of a 2 serial port ITE8874
 chip
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The printk message for the 2 serial port version is obscured with a debug
macro, unlike all other versions of the card. It should be changed to make
the output equal for all detected models.

Reference: https://bugzilla.redhat.com/show_bug.cgi?id=578616#c1

CC: Joe Krahn <krahn@niehs.nih.gov>
Signed-off-by: Niels de Vos <ndevos@redhat.com>
---
 drivers/parport/parport_pc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/parport/parport_pc.c b/drivers/parport/parport_pc.c
index 0950fa4..8d62fb7 100644
--- a/drivers/parport/parport_pc.c
+++ b/drivers/parport/parport_pc.c
@@ -2599,7 +2599,7 @@ static int __devinit sio_ite_8872_probe(struct pci_dev *pdev, int autoirq,
 		printk(KERN_INFO "parport_pc: ITE8873 found (1S)\n");
 		return 0;
 	case 0x8:
-		DPRINTK(KERN_DEBUG "parport_pc: ITE8874 found (2S)\n");
+		printk(KERN_INFO "parport_pc: ITE8874 found (2S)\n");
 		return 0;
 	default:
 		printk(KERN_INFO "parport_pc: unknown ITE887x\n");
-- 
1.7.2.1
