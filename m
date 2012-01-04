Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753597Ab2ADIxz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 03:53:55 -0500
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:41479 "EHLO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751275Ab2ADIxx convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 03:53:53 -0500
From: "Nandigama, Nagalakshmi" <Nagalakshmi.Nandigama@lsi.com>
To: Greg KH <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
CC: "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Moore, Eric" <Eric.Moore@lsi.com>
Date: Wed, 4 Jan 2012 14:23:27 +0530
Subject: RE: [50/75] mpt2sas crashes on shutdown
Thread-Topic: [50/75] mpt2sas crashes on shutdown
Thread-Index: AczKaM8dxz2kkUQ/SnyutxP+XxAYGgAVWzlQ
Message-ID: <A6888A6805518E4EA4AF7072A28264A60481D5AAEC@inbmail02.lsi.com>
References: <20120103223332.GA4112@kroah.com>
 <20120103223325.206012007@clark.kroah.org>
In-Reply-To: <20120103223325.206012007@clark.kroah.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-cr-hashedpuzzle: AA92 Bl5h IJbc To4e js8Q o0KT pOXG uiGs 2G0y 3Yvh
 ABZ47A== ABekKQ== ADAzRw== AErhFg== AGE5Gg==
 AGug8Q==;8;YQBrAHAAbQBAAGwAaQBuAHUAeAAtAGYAbwB1AG4AZABhAHQAaQBvAG4ALgBvAHIAZwA7AGEAbABhAG4AQABsAHgAbwByAGcAdQBrAC4AdQBrAHUAdQAuAG8AcgBnAC4AdQBrADsAZABhAHYAZQBtAEAAZABhAHYAZQBtAGwAbwBmAHQALgBuAGUAdAA7AGcAcgBlAGcAawBoAEAAcwB1AHMAZQAuAGQAZQA7AGwAaQBuAHUAeAAtAGsAZQByAG4AZQBsAEAAdgBnAGUAcgAuAGsAZQByAG4AZQBsAC4AbwByAGcAOwBsAGkAbgB1AHgALQBzAGMAcwBpAEAAdgBnAGUAcgAuAGsAZQByAG4AZQBsAC4AbwByAGcAOwBzAHQAYQBiAGwAZQBAAHYAZwBlAHIALgBrAGUAcgBuAGUAbAAuAG8AcgBnADsAdABvAHIAdgBhAGwAZABzAEAAbABpAG4AdQB4AC0AZgBvAHUAbgBkAGEAdABpAG8AbgAuAG8AcgBnAA==;Sosha1_v1;7;{8E3EA131-7E33-4D26-B14C-E2880603CF85};bgBhAGcAYQBsAGEAawBzAGgAbQBpAC4AbgBhAG4AZABpAGcAYQBtAGEAQABsAHMAaQAuAGMAbwBtAA==;Wed,
 04 Jan 2012 08:53:27
 GMT;UgBFADoAIABbADUAMAAvADcANQBdACAAbQBwAHQAMgBzAGEAcwAgAGMAcgBhAHMAaABlAHMAIABvAG4AIABzAGgAdQB0AGQAbwB3AG4A
x-cr-puzzleid: {8E3EA131-7E33-4D26-B14C-E2880603CF85}
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg,
As a fix to this issue, I posted the patch "[PATCH] mpt2sas: Remove msix_table_backup which is required only for preproduction boards". The patch in this mail will not address the complete issue. 

Please revert back this patch and add the patch "[PATCH] mpt2sas: Remove msix_table_backup which is required only for preproduction boards" to the stable kernels 3.0 and 3.1.

Regards,
Nagalakshmi


-----Original Message-----
From: Greg KH [mailto:gregkh@suse.de] 
Sent: Wednesday, January 04, 2012 4:03 AM
To: linux-kernel@vger.kernel.org; stable@vger.kernel.org
Cc: torvalds@linux-foundation.org; akpm@linux-foundation.org; alan@lxorguk.ukuu.org.uk; linux-scsi@vger.kernel.org; Nandigama, Nagalakshmi; David S. Miller; Moore, Eric
Subject: [50/75] mpt2sas crashes on shutdown

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Miller <davem@davemloft.net>

[Fixed differently in 3.2]

The mpt2sas driver accesses I/O space as virtual addresses when
saving and restoring the MSIX table, this only works by luck on x86.

One needs to use the appropriate {read,write}{b,w,l}() APIs.

This is fixed in v3.2.x because all of this code got rewritten for
NUMA I/O support.

But both 3.0.x and 3.1.x still have this bug, and my Niagara sparc
machines crash on shutdown every single time due to this bug making my
-stable work more difficult than it needs to be.


Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: Eric Moore <Eric.Moore@lsi.com>
Cc: Nagalakshmi Nandigama <nagalakshmi.nandigama@lsi.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/mpt2sas/mpt2sas_base.c |    6 +++---
 drivers/scsi/mpt2sas/mpt2sas_base.h |    2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -1096,7 +1096,7 @@ _base_save_msix_table(struct MPT2SAS_ADA
 		return;
 
 	for (i = 0; i < ioc->msix_vector_count; i++)
-		ioc->msix_table_backup[i] = ioc->msix_table[i];
+		ioc->msix_table_backup[i] = readl(&ioc->msix_table[i]);
 }
 
 /**
@@ -1113,7 +1113,7 @@ _base_restore_msix_table(struct MPT2SAS_
 		return;
 
 	for (i = 0; i < ioc->msix_vector_count; i++)
-		ioc->msix_table[i] = ioc->msix_table_backup[i];
+		writel(ioc->msix_table_backup[i], &ioc->msix_table[i]);
 }
 
 /**
@@ -1144,7 +1144,7 @@ _base_check_enable_msix(struct MPT2SAS_A
 	/* get msix table  */
 	pci_read_config_dword(ioc->pdev, base + 4, &msix_table_offset);
 	msix_table_offset &= 0xFFFFFFF8;
-	ioc->msix_table = (u32 *)((void *)ioc->chip + msix_table_offset);
+	ioc->msix_table = ((void __iomem *)ioc->chip + msix_table_offset);
 
 	dinitprintk(ioc, printk(MPT2SAS_INFO_FMT "msix is supported, "
 	    "vector_count(%d), table_offset(0x%08x), table(%p)\n", ioc->name,
--- a/drivers/scsi/mpt2sas/mpt2sas_base.h
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.h
@@ -779,7 +779,7 @@ struct MPT2SAS_ADAPTER {
 
 	u8		msix_enable;
 	u16		msix_vector_count;
-	u32		*msix_table;
+	u32 __iomem	*msix_table;
 	u32		*msix_table_backup;
 	u32		ioc_reset_count;
 


