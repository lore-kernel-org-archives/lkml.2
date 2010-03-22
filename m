Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756124Ab0CVXok (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 19:44:40 -0400
Received: from mx0b-000f0801.pphosted.com ([67.231.152.113]:33703 "EHLO
	mx0b-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755831Ab0CVXoi convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 19:44:38 -0400
X-Greylist: delayed 1892 seconds by postgrey-1.27 at vger.kernel.org; Mon, 22 Mar 2010 19:44:38 EDT
From: Jing Huang <huangj@Brocade.COM>
To: Roel Kluin <roel.kluin@gmail.com>,
       "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Date: Mon, 22 Mar 2010 16:12:55 -0700
Subject: RE: [PATCH] bfa: wrong fcport H2I message tested in bfa_fcport_isr()
Thread-Topic: [PATCH] bfa: wrong fcport H2I message tested in
 bfa_fcport_isr()
Thread-Index: AcrKAM6VDDtN/iEWQC6EfV/m6fbMXwAE4XSg
Message-ID: <04391A4E90BB2149B010D22452FA16876F6C9279@HQ-EXCH-6.corp.brocade.com>
References: <4BA7D7BB.1080506@gmail.com>
In-Reply-To: <4BA7D7BB.1080506@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=1.12.8161:2.4.5,1.2.40,4.0.166
 definitions=2010-03-22_14:2010-02-06,2010-03-22,2010-03-22 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 ipscore=0 phishscore=0
 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 engine=6.0.2-0911030000 definitions=main-1003220281
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is not intended. Using penable_rsp or pdisable_rsp in this case doesn't have functional difference since it is a union, but it is confusing and should be fixed.

Thanks

Jing

-----Original Message-----
From: Roel Kluin [mailto:roel.kluin@gmail.com] 
Sent: Monday, March 22, 2010 1:49 PM
To: Jing Huang; linux-scsi@vger.kernel.org; Andrew Morton; LKML
Subject: [PATCH] bfa: wrong fcport H2I message tested in bfa_fcport_isr()

It appears that the wrong fcport H2I message was tested

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
Was this intended?

diff --git a/drivers/scsi/bfa/bfa_fcport.c b/drivers/scsi/bfa/bfa_fcport.c
index c589488..5e5e6fe 100644
--- a/drivers/scsi/bfa/bfa_fcport.c
+++ b/drivers/scsi/bfa/bfa_fcport.c
@@ -1281,7 +1281,7 @@ bfa_fcport_isr(struct bfa_s *bfa, struct bfi_msg_s *msg)
 		break;
 
 	case BFI_FCPORT_I2H_DISABLE_RSP:
-		if (fcport->msgtag == i2hmsg.penable_rsp->msgtag)
+		if (fcport->msgtag == i2hmsg.pdisable_rsp->msgtag)
 			bfa_sm_send_event(fcport, BFA_FCPORT_SM_FWRSP);
 		break;
 
