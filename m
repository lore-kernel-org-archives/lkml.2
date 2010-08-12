Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932838Ab0HLAG3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 20:06:29 -0400
Received: from kroah.org ([198.145.64.141]:60392 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932854Ab0HLAEr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 20:04:47 -0400
X-Mailbox-Line: From gregkh@clark.site Wed Aug 11 17:01:28 2010
Message-Id: <20100812000128.130276853@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 11 Aug 2010 17:01:08 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Brian King <brking@linux.vnet.ibm.com>,
        James Bottomley <James.Bottomley@suse.de>
Subject: [53/54] [SCSI] ibmvfc: Reduce error recovery timeout
In-Reply-To: <20100812000249.GA30948@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

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
@@ -2245,7 +2245,7 @@ static int ibmvfc_wait_for_ops(struct ib
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


