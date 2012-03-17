Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757270Ab2CQTk7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2012 15:40:59 -0400
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:25589
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753511Ab2CQTk4 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2012 15:40:56 -0400
X-SpamScore: -3
X-BigFish: VPS-3(zz936eKzz1202hzz8275bhz2dh668h839h944hd25h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0M11NZT-02-0XV-02
X-M-MSG: 
From: "Chen, Dennis (SRDC SW)" <Dennis1.Chen@amd.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "beattiem@uk.ibm.com" <beattiem@uk.ibm.com>,
        "holzheu@de.ibm.com" <holzheu@de.ibm.com>,
        "munzert@de.ibm.com" <munzert@de.ibm.com>,
        "linux390@de.ibm.com" <linux390@de.ibm.com>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "Chen, Dennis (SRDC SW)" <Dennis1.Chen@amd.com>
Subject: [PATCH]s390/char/vmur.c: memory leak Fix in the driver
Thread-Topic: [PATCH]s390/char/vmur.c: memory leak Fix in the driver
Thread-Index: Ac0EddW23nEJHEP4TgOzkdjHvih49A==
Date: Sat, 17 Mar 2012 19:40:41 +0000
Message-ID: <491D6B4EAD0A714894D8AD22F4BDE0430495F2@SCYBEXDAG04.amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.237.74.102]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is used to fix a memory leak issue in s390/char/vmur.c: a character device instance is 
allocated by cdev_alloc, the cdev_del will not free that space if cdev_init is applied before. 

Signed-off-by: dennis1.chen@amd.com
--- a/s390/char/vmur.c  2012-03-18 02:50:47.950963949 +0800
+++ b/s390/char/vmur.c  2012-03-18 03:12:04.790936740 +0800
@@ -903,7 +903,7 @@ static int ur_set_online(struct ccw_devi
                goto fail_urdev_put;
        }

-       cdev_init(urd->char_device, &ur_fops);
+       urd->char_device->ops = &ur_fops;
        urd->char_device->dev = MKDEV(major, minor);
        urd->char_device->owner = ur_fops.owner;

