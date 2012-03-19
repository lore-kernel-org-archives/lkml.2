Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757527Ab2CSBzz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2012 21:55:55 -0400
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:27649
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757482Ab2CSBzu convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2012 21:55:50 -0400
X-SpamScore: -9
X-BigFish: VPS-9(zz9371I936eK542Mzz1202hzz8275bh8275dhz2dh668h839h944hd25h)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0M1400W-01-B2E-02
X-M-MSG: 
From: "Chen, Dennis (SRDC SW)" <Dennis1.Chen@amd.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "beattiem@uk.ibm.com" <beattiem@uk.ibm.com>,
        "holzheu@de.ibm.com" <holzheu@de.ibm.com>,
        "munzert@de.ibm.com" <munzert@de.ibm.com>,
        "linux390@de.ibm.com" <linux390@de.ibm.com>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "schwidefsky@de.ibm.com" <schwidefsky@de.ibm.com>,
        "heiko.carstens@de.ibm.com" <heiko.carstens@de.ibm.com>,
        "Chen, Dennis (SRDC SW)" <Dennis1.Chen@amd.com>
Subject: RE: [PATCH]s390/char/vmur.c: memory leak Fix in the driver
Thread-Topic: [PATCH]s390/char/vmur.c: memory leak Fix in the driver
Thread-Index: Ac0EddW23nEJHEP4TgOzkdjHvih49AA/Vbzw
Date: Mon, 19 Mar 2012 01:55:40 +0000
Message-ID: <491D6B4EAD0A714894D8AD22F4BDE04304FF5A@SCYBEXDAG04.amd.com>
References: <491D6B4EAD0A714894D8AD22F4BDE0430495F2@SCYBEXDAG04.amd.com>
In-Reply-To: <491D6B4EAD0A714894D8AD22F4BDE0430495F2@SCYBEXDAG04.amd.com>
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

CC'ing maintainer: Martin Schwidefsky &  Heiko Carstens...

-----Original Message-----
From: Chen, Dennis (SRDC SW) 
Sent: Sunday, March 18, 2012 3:41 AM
To: linux-kernel@vger.kernel.org
Cc: beattiem@uk.ibm.com; holzheu@de.ibm.com; munzert@de.ibm.com; linux390@de.ibm.com; linux-s390@vger.kernel.org; Chen, Dennis (SRDC SW)
Subject: [PATCH]s390/char/vmur.c: memory leak Fix in the driver

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

