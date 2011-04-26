Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758517Ab1DZVNc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 17:13:32 -0400
Received: from mga14.intel.com ([143.182.124.37]:9957 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758472Ab1DZVN3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 17:13:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,270,1301900400"; 
   d="scan'208";a="425950788"
From: Andi Kleen <andi@firstfloor.org>
References: <20110426212.641772347@firstfloor.org>
In-Reply-To: <20110426212.641772347@firstfloor.org>
To: andrew.vasquez@qlogic.com, giridhar.malavali@qlogic.com,
        James.Bottomley@suse.de, Madhu.Iyengar@qlogic.com, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [2/106] qla2xxx: Make the FC port capability mutual exclusive.
Message-Id: <20110426211239.CA2CE3E1887@tassilo.jf.intel.com>
Date: Tue, 26 Apr 2011 14:12:39 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Andrew Vasquez <andrew.vasquez@qlogic.com>

[ upstream commit b0cd579cde8ee0c7ed52239531ba09bcbc5b54c2 ]

In case of both target and initiator capabilities reported by fc port,
the fc port port capability is made mutualy exclusive with priority given
for target capabilities.

Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
Signed-off-by: James Bottomley <James.Bottomley@suse.de>
Acked-by: Madhuranath Iyengar <Madhu.Iyengar@qlogic.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

Index: linux-2.6.35.y/drivers/scsi/qla2xxx/qla_isr.c
===================================================================
--- linux-2.6.35.y.orig/drivers/scsi/qla2xxx/qla_isr.c
+++ linux-2.6.35.y/drivers/scsi/qla2xxx/qla_isr.c
@@ -1119,9 +1119,9 @@ qla24xx_logio_entry(scsi_qla_host_t *vha
 			fcport->port_type = FCT_TARGET;
 			if (iop[0] & BIT_8)
 				fcport->flags |= FCF_FCP2_DEVICE;
-		}
-		if (iop[0] & BIT_5)
+		} else if (iop[0] & BIT_5)
 			fcport->port_type = FCT_INITIATOR;
+
 		if (logio->io_parameter[7] || logio->io_parameter[8])
 			fcport->supported_classes |= FC_COS_CLASS2;
 		if (logio->io_parameter[9] || logio->io_parameter[10])
