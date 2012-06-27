Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758489Ab2F0SOB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 14:14:01 -0400
Received: from mx0b-000f0801.pphosted.com ([67.231.152.113]:40163 "EHLO
	mx0b-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758404Ab2F0SN7 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 14:13:59 -0400
From: Krishna Gudipati <kgudipat@Brocade.com>
To: "'Dan Carpenter'" <dan.carpenter@oracle.com>,
        Jing Huang <huangj@Brocade.com>
CC: "'James E.J. Bottomley'" <JBottomley@parallels.com>,
        "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'kernel-janitors@vger.kernel.org'" <kernel-janitors@vger.kernel.org>
Date: Wed, 27 Jun 2012 10:44:56 -0700
Subject: RE: [patch -resend] [SCSI] bfa: off by one in bfa_ioc_mbox_isr()
Thread-Topic: [patch -resend] [SCSI] bfa: off by one in bfa_ioc_mbox_isr()
Thread-Index: Ac1UQzOctUI3tVz7Tj2NwGgfAZWPhQASShIg
Message-ID: <B5EE62D80D50B84BB9E5174F7FCCE80A28396BCE90@HQ1-EXCH02.corp.brocade.com>
References: <20120627085800.GA3007@mwanda>
 <20120627085936.GA31212@elgon.mountain>
In-Reply-To: <20120627085936.GA31212@elgon.mountain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.7.7855,1.0.260,0.0.0000
 definitions=2012-06-27_05:2012-06-27,2012-06-27,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 ipscore=0 suspectscore=1
 phishscore=0 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1112030000 definitions=main-1206270178
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----Original Message-----
From: Dan Carpenter [mailto:dan.carpenter@oracle.com] 
Sent: Wednesday, June 27, 2012 2:00 AM
To: Jing Huang
Cc: Krishna Gudipati; James E.J. Bottomley; linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org; kernel-janitors@vger.kernel.org
Subject: [patch -resend] [SCSI] bfa: off by one in bfa_ioc_mbox_isr()

If mc == BFI_MC_MAX then we're reading past the end of the
mod->mbhdlr[] array.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
Originally sent on Wed, 6 Jul 2011.

diff --git a/drivers/scsi/bfa/bfa_ioc.c b/drivers/scsi/bfa/bfa_ioc.c
index 14e6284..8cdb79c 100644
--- a/drivers/scsi/bfa/bfa_ioc.c
+++ b/drivers/scsi/bfa/bfa_ioc.c
@@ -2357,7 +2357,7 @@ bfa_ioc_mbox_isr(struct bfa_ioc_s *ioc)
 			return;
 		}
 
-		if ((mc > BFI_MC_MAX) || (mod->mbhdlr[mc].cbfn == NULL))
+		if ((mc >= BFI_MC_MAX) || (mod->mbhdlr[mc].cbfn == NULL))
 			return;
 
 		mod->mbhdlr[mc].cbfn(mod->mbhdlr[mc].cbarg, &m);


-----

Thanks for the patch.

Acked-by: Krishna Gudipati <kgudipat@brocade.com>
