Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753904Ab1APUMq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jan 2011 15:12:46 -0500
Received: from amavis-outgoing2.knology.net ([24.214.64.231]:58854 "EHLO
	amavis-outgoing2.knology.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752978Ab1APUMo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jan 2011 15:12:44 -0500
Subject: scsi: include linux/scatterlist.h to pick up ARCH_HAS_SG_CHAIN
From: David Dillow <dillowda@ornl.gov>
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, James.Bottomley@suse.de
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 16 Jan 2011 15:12:39 -0500
Message-ID: <1295208759.2574.14.camel@obelisk.thedillows.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the compiled object doesn't include linux/scatterlist.h before
scsi/scsi.h, it will get an incorrect definition of
SCSI_MAX_SG_CHAIN_SEGMENTS.

Signed-off-by: David Dillow <dillowda@ornl.gov>
--
This fixes an issue I found while working on the SRP initiator, where
linux/scatterlist.h was being pulled in by scsi/scsi_device.h. It's not
clear if I'm supposed to include linux/scatterlist.h myself, or if I'm
including the scsi headers in the wrong order. It makes sense for me
that scsi.h would pickup the needed headers itself to prevent confusion.

Another option is to potentially get rid of the ARCH_HAS_SG_CHAIN define
as all archs have it save m68knommu.


diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
index 648d233..b76d400 100644
--- a/include/scsi/scsi.h
+++ b/include/scsi/scsi.h
@@ -9,6 +9,7 @@
 #define _SCSI_SCSI_H
 
 #include <linux/types.h>
+#include <linux/scatterlist.h>
 
 struct scsi_cmnd;
 


