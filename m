Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753310Ab1CUMtR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 08:49:17 -0400
Received: from mxout1.idt.com ([157.165.5.25]:51062 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753187Ab1CUMtP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 08:49:15 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [patch] rapidio: potential null deref on failure path
Date: Mon, 21 Mar 2011 05:49:06 -0700
Message-ID: <0CE8B6BE3C4AD74AB97D9D29BD24E55201A588F5@CORPEXCH1.na.ads.idt.com>
In-Reply-To: <20110319044032.GC2008@bicker>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [patch] rapidio: potential null deref on failure path
Thread-Index: Acvl8NU6alY6lA+kRX2aAkODWhk8ygB1SgGA
References: <20110319044032.GC2008@bicker>
From: "Bounine, Alexandre" <Alexandre.Bounine@idt.com>
To: "Dan Carpenter" <error27@gmail.com>,
        "Matt Porter" <mporter@kernel.crashing.org>
Cc: <linux-kernel@vger.kernel.org>, <kernel-janitors@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Better to combine both conditions:

if (rio_is_switch(rdev) && rswitch->route_table))
 		kfree(rswitch->route_table);

Because there is situation when routine fails to allocate route_table
for a switch.

Alex. 


-----Original Message-----
From: Dan Carpenter [mailto:error27@gmail.com] 
Sent: Saturday, March 19, 2011 12:41 AM
To: Matt Porter
Cc: Bounine, Alexandre; linux-kernel@vger.kernel.org;
kernel-janitors@vger.kernel.org
Subject: [patch] rapidio: potential null deref on failure path

If rio is not a switch then "rswitch" is null.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/rapidio/rio-scan.c b/drivers/rapidio/rio-scan.c
index a50391b..3a59d5f 100644
--- a/drivers/rapidio/rio-scan.c
+++ b/drivers/rapidio/rio-scan.c
@@ -517,7 +517,7 @@ static struct rio_dev __devinit
*rio_setup_device(struct rio_net *net,
 	return rdev;
 
 cleanup:
-	if (rswitch->route_table)
+	if (rio_is_switch(rdev))
 		kfree(rswitch->route_table);
 
 	kfree(rdev);
