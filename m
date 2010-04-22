Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757572Ab0DVTvN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 15:51:13 -0400
Received: from mx0b-000f0801.pphosted.com ([67.231.152.113]:60046 "EHLO
	mx0b-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757557Ab0DVTu6 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 15:50:58 -0400
From: Jing Huang <huangj@Brocade.COM>
To: Andrew Morton <akpm@linux-foundation.org>
CC: "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>,
       "James.Bottomley@suse.de" <James.Bottomley@suse.de>,
       "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
       Krishna Gudipati <kgudipat@Brocade.COM>,
       Ramkumar Vadivelu <rvadivel@Brocade.COM>,
       Vinodh Ravindran <vravindr@Brocade.COM>
Date: Thu, 22 Apr 2010 12:50:31 -0700
Subject: RE: [PATCH] bfa: fix compilation warning in powerpc (resend)
Thread-Topic: [PATCH] bfa: fix compilation warning in powerpc (resend)
Thread-Index: AcrhqDHoUzNc6wlFQbWscv2kkmCq+QArHs4w
Message-ID: <04391A4E90BB2149B010D22452FA1687B99CCFDD@HQ-EXCH-6.corp.brocade.com>
References: <1271186549-642-1-git-send-email-huangj@brocade.com>
 <20100421161217.60d5654b.akpm@linux-foundation.org>
In-Reply-To: <20100421161217.60d5654b.akpm@linux-foundation.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=1.12.8161:2.4.5,1.2.40,4.0.166
 definitions=2010-04-22_11:2010-02-06,2010-04-22,2010-04-21 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 ipscore=0 phishscore=0
 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 engine=6.0.2-0911030000 definitions=main-1004220178
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Fix the compilation warning in powerpc.
>
>When fixing a warning, please quote that warning in the patch description!
>
><does a cross-build>
>
>It seems that you're referring to this:
>
>drivers/scsi/bfa/bfa_ioc.c: In function 'bfa_ioc_msgget':
>drivers/scsi/bfa/bfa_ioc.c:1331: warning: value computed is not used
>drivers/scsi/bfa/bfa_ioc_ct.c: In function 'bfa_ioc_ct_notify_hbfail':
>drivers/scsi/bfa/bfa_ioc_ct.c:177: warning: value computed is not used
>drivers/scsi/bfa/bfa_ioc_ct.c:180: warning: value computed is not used
>drivers/scsi/bfa/bfa_ioc_ct.c: In function 'bfa_ioc_ct_pll_init':
>drivers/scsi/bfa/bfa_ioc_ct.c:381: warning: value computed is not used
>drivers/scsi/bfa/bfa_ioc_ct.c: In function 'bfa_ioc_ct_ownership_reset':
>drivers/scsi/bfa/bfa_ioc_ct.c:421: warning: value computed is not used
>drivers/scsi/bfa/bfa_ioc_cb.c: In function 'bfa_ioc_cb_notify_hbfail':
>drivers/scsi/bfa/bfa_ioc_cb.c:99: warning: value computed is not used
>drivers/scsi/bfa/bfa_ioc_cb.c: In function 'bfa_ioc_cb_ownership_reset':
>drivers/scsi/bfa/bfa_ioc_cb.c:272: warning: value computed is not used
>
>
>> The same change also fixes endian
>> issue we found in powerpc test.
>
>When fixing a bug, please fully describe the bug!
>
>If this driver has "endian issues" on powerpc then it's quite possible
>that this is a running-around-with-hair-on-fire,
>must-backport-to-2.6.33.x bugfix.
>
>But how would I know?  You didn't tell me!
>

Hi Andrew,

Sorry about the obscure description of the patch, I will provide detailed
description in the future patch submission.

Yes this patch is intended to fix the compilation warning you listed above.

Regarding the big endian issue I mentioned, basically I remove an
unnecessary word swap in bfa_os_reg_read() and bfa_os_reg_write()
because the kernel provided readl and writel are already doing so. The
compilation warning also goes away after this change. For
bfa_os_mem_read() and bfa_os_mem_write() macros, I add a swap since
these two macros are designed to read/write from/to a memory region
that is in BE format per ASIC spec.

Thanks

Jing

