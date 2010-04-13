Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752128Ab0DMHbN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 03:31:13 -0400
Received: from mx0b-000f0801.pphosted.com ([67.231.152.113]:34926 "EHLO
	mx0b-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751420Ab0DMHbL convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 03:31:11 -0400
From: Jing Huang <huangj@Brocade.COM>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Krishna Gudipati <kgudipat@Brocade.COM>
CC: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 13 Apr 2010 00:30:52 -0700
Subject: RE: linux-next: build warnings after merge of the final tree (scsi
 tree related)
Thread-Topic: linux-next: build warnings after merge of the final tree (scsi
 tree related)
Thread-Index: Acra0ZNYwVHFp572R4SrdOxH9cuSvwACWnwQ
Message-ID: <04391A4E90BB2149B010D22452FA1687B99CC5C1@HQ-EXCH-6.corp.brocade.com>
References: <20100413162129.d913af53.sfr@canb.auug.org.au>
In-Reply-To: <20100413162129.d913af53.sfr@canb.auug.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=1.12.8161:2.4.5,1.2.40,4.0.166
 definitions=2010-04-13_03:2010-02-06,2010-04-13,2010-04-13 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 ipscore=0 phishscore=0
 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 engine=6.0.2-0911030000 definitions=main-1004130005
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is indeed introduced by this commit. I have reproduced the issue in a powerpc machine, and I will provide a fix soon.

Jing
-----Original Message-----
From: Stephen Rothwell [mailto:sfr@canb.auug.org.au] 
Sent: Monday, April 12, 2010 11:21 PM
To: James Bottomley
Cc: linux-next@vger.kernel.org; linux-kernel@vger.kernel.org; Jing Huang
Subject: linux-next: build warnings after merge of the final tree (scsi tree related)

Hi James,

After merging the final tree, today's linux-next build (powerpc
allyesconfig) produced these warnings:

drivers/scsi/bfa/bfa_ioc.c: In function 'bfa_ioc_msgget':
drivers/scsi/bfa/bfa_ioc.c:1331: warning: value computed is not used
drivers/scsi/bfa/bfa_ioc_ct.c: In function 'bfa_ioc_ct_notify_hbfail':
drivers/scsi/bfa/bfa_ioc_ct.c:177: warning: value computed is not used
drivers/scsi/bfa/bfa_ioc_ct.c:180: warning: value computed is not used
drivers/scsi/bfa/bfa_ioc_ct.c: In function 'bfa_ioc_ct_pll_init':
drivers/scsi/bfa/bfa_ioc_ct.c:381: warning: value computed is not used
drivers/scsi/bfa/bfa_ioc_ct.c: In function 'bfa_ioc_ct_ownership_reset':
drivers/scsi/bfa/bfa_ioc_ct.c:421: warning: value computed is not used
drivers/scsi/bfa/bfa_ioc_cb.c: In function 'bfa_ioc_cb_notify_hbfail':
drivers/scsi/bfa/bfa_ioc_cb.c:99: warning: value computed is not used
drivers/scsi/bfa/bfa_ioc_cb.c: In function 'bfa_ioc_cb_ownership_reset':
drivers/scsi/bfa/bfa_ioc_cb.c:272: warning: value computed is not used

Presumably introduced by commit 077424e2e2c97c830d903891dfcd1532068b85b7
("[SCSI] bfa: sg addr big endian fix") from the scsi tree.

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
