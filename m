Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756069Ab1KVOiB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 09:38:01 -0500
Received: from xyratex195.xyratex.com ([194.131.166.195]:49327 "EHLO
	XY01EX22.xy01.xyratex.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754174Ab1KVOiA convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 09:38:00 -0500
X-Greylist: delayed 832 seconds by postgrey-1.27 at vger.kernel.org; Tue, 22 Nov 2011 09:37:59 EST
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] [SCSI] aacraid: Use kmemdup rather than duplicating its implementation
Date: Tue, 22 Nov 2011 06:24:01 -0800
Message-ID: <FC1F9E38C0703341A1A750524E2525A901978CD9@XYUS-EX22.xyus.xyratex.com>
In-Reply-To: <1321569820.1624.290.camel@localhost.localdomain>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] [SCSI] aacraid: Use kmemdup rather than duplicating its implementation
Thread-Index: Acymr77G/TtqxpMsRzirD2wodiI1UwCccEHQ
References: <1321569820.1624.290.camel@localhost.localdomain>
From: "Mark Salyzyn" <mark_salyzyn@us.xyratex.com>
To: "Thomas Meyer" <thomas@m3y3r.de>, <JBottomley@parallels.com>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Cc: "Achim Leubner" <Achim_Leubner@pmc-sierra.com>,
        "Mahesh Rajashekhara" <Mahesh_Rajashekhara@pmc-sierra.com>
X-OriginalArrivalTime: 22 Nov 2011 14:24:04.0909 (UTC) FILETIME=[636ECDD0:01CCA922]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ack

This driver is maintained by Achim Leubner
<Achim_Leubner@pmc-sierra.com> and Mahesh Rajashekhara
<Mahesh_Rajashekhara@pmc-sierra.com>. I have added them so that either
one of them can have the opportunity to respond.

Sincerely -- Mark Salyzyn

-----Original Message-----
From: linux-scsi-owner@vger.kernel.org
[mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Thomas Meyer
Sent: Thursday, November 17, 2011 5:44 PM
To: JBottomley@parallels.com; linux-scsi@vger.kernel.org;
linux-kernel@vger.kernel.org
Subject: [PATCH] [SCSI] aacraid: Use kmemdup rather than duplicating its
implementation

The semantic patch that makes this change is available
in scripts/coccinelle/api/memdup.cocci.

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff -u -p a/drivers/scsi/aacraid/commctrl.c
b/drivers/scsi/aacraid/commctrl.c
--- a/drivers/scsi/aacraid/commctrl.c 2011-11-07 19:38:06.463566391
+0100
+++ b/drivers/scsi/aacraid/commctrl.c 2011-11-08 10:53:23.848146953
+0100
@@ -631,15 +631,14 @@ static int aac_send_raw_srb(struct aac_d
 			}
 		} else {
 			struct user_sgmap* usg;
-			usg = kmalloc(actual_fibsize - sizeof(struct
aac_srb)
-			  + sizeof(struct sgmap), GFP_KERNEL);
+			usg = kmemdup(upsg,
+				      actual_fibsize - sizeof(struct
aac_srb) + sizeof(struct sgmap),
+				      GFP_KERNEL);
 			if (!usg) {
 				dprintk((KERN_DEBUG"aacraid: Allocation
error in Raw SRB command\n"));
 				rcode = -ENOMEM;
 				goto cleanup;
 			}
-			memcpy (usg, upsg, actual_fibsize -
sizeof(struct aac_srb)
-			  + sizeof(struct sgmap));
 			actual_fibsize = actual_fibsize64;
 
 			for (i = 0; i < usg->count; i++) {
