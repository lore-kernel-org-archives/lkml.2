Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757996Ab1BPBlk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 20:41:40 -0500
Received: from kroah.org ([198.145.64.141]:38945 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756961Ab1BPATu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:19:50 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:14:32 2011
Message-Id: <20110216001431.921626641@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:12:05 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Felix Beck <felix.beck@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [068/272] [S390] zcrypt: Fix check to look for facility bits 2 & 65
In-Reply-To: <20110216001559.GA31413@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Felix Beck <felix.beck@de.ibm.com>

commit 53ec24b1e6c7118a127cf029a1519a2ce55268ec upstream.

Fix the check for ap interupts to look for facility bits 2 and 65.
Make sure that we only register interrupts for aps, if the machine
has ap interrupt support.

This patch is relevant only for the 2.6.37 stable series.

Signed-off-by: Felix Beck <felix.beck@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/s390/crypto/ap_bus.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/s390/crypto/ap_bus.c
+++ b/drivers/s390/crypto/ap_bus.c
@@ -154,7 +154,7 @@ static inline int ap_instructions_availa
  */
 static int ap_interrupts_available(void)
 {
-	return test_facility(1) && test_facility(2);
+	return test_facility(2) && test_facility(65);
 }
 
 /**


