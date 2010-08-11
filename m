Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759447Ab0HLAAA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 20:00:00 -0400
Received: from kroah.org ([198.145.64.141]:43761 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759349Ab0HKX7h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 19:59:37 -0400
X-Mailbox-Line: From gregkh@clark.site Wed Aug 11 16:55:05 2010
Message-Id: <20100811235505.627758241@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 11 Aug 2010 16:55:30 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Brian King <brking@linux.vnet.ibm.com>,
        James Bottomley <James.Bottomley@suse.de>
Subject: [109/111] [SCSI] ibmvfc: Reduce error recovery timeout
In-Reply-To: <20100811235623.GA24440@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Brian King <brking@linux.vnet.ibm.com>

commit daa142d1773dd3a986f02a8a4da929608d24daaa upstream.

If a command times out resulting in EH getting invoked, we wait for the
aborted commands to come back after sending the abort. Shorten
the amount of time we wait for these responses, to ensure we don't
get stuck in EH for several minutes.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
Signed-off-by: James Bottomley <James.Bottomley@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/ibmvscsi/ibmvfc.c |    2 +-
 drivers/scsi/ibmvscsi/ibmvfc.h |    1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -1969,7 +1969,7 @@ static int ibmvfc_wait_for_ops(struct ib
 	DECLARE_COMPLETION_ONSTACK(comp);
 	int wait;
 	unsigned long flags;
-	signed long timeout = init_timeout * HZ;
+	signed long timeout = IBMVFC_ABORT_WAIT_TIMEOUT * HZ;
 
 	ENTER;
 	do {
--- a/drivers/scsi/ibmvscsi/ibmvfc.h
+++ b/drivers/scsi/ibmvscsi/ibmvfc.h
@@ -38,6 +38,7 @@
 #define IBMVFC_ADISC_PLUS_CANCEL_TIMEOUT	\
 		(IBMVFC_ADISC_TIMEOUT + IBMVFC_ADISC_CANCEL_TIMEOUT)
 #define IBMVFC_INIT_TIMEOUT		120
+#define IBMVFC_ABORT_WAIT_TIMEOUT	40
 #define IBMVFC_MAX_REQUESTS_DEFAULT	100
 
 #define IBMVFC_DEBUG			0


