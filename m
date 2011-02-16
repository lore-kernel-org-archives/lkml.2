Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751047Ab1BPBNC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 20:13:02 -0500
Received: from kroah.org ([198.145.64.141]:45589 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933028Ab1BPAtE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:49:04 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:21:05 2011
Message-Id: <20110216002105.753594263@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:20:34 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        David Dillow <dillowda@ornl.gov>,
        James Bottomley <James.Bottomley@suse.de>
Subject: [patch 066/176] [SCSI] fix incorrect value of SCSI_MAX_SG_CHAIN_SEGMENTS due to include file ordering
In-Reply-To: <20110216002212.GA9246@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: David Dillow <dillowda@ornl.gov>

commit ac61c46f4f7665ab4548e90430c37b2529e16cff upstream.

If the compiled object doesn't include linux/scatterlist.h before
scsi/scsi.h, it will get an incorrect definition of
SCSI_MAX_SG_CHAIN_SEGMENTS.

Signed-off-by: David Dillow <dillowda@ornl.gov>
Signed-off-by: James Bottomley <James.Bottomley@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/scsi/scsi.h |    1 +
 1 file changed, 1 insertion(+)

--- a/include/scsi/scsi.h
+++ b/include/scsi/scsi.h
@@ -9,6 +9,7 @@
 #define _SCSI_SCSI_H
 
 #include <linux/types.h>
+#include <linux/scatterlist.h>
 
 struct scsi_cmnd;
 


