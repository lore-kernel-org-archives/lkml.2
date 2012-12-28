Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754442Ab2L1TRO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 14:17:14 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54947 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754079Ab2L1TRF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 14:17:05 -0500
Message-Id: <20121228190402.261165145@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 28 Dec 2012 20:06:17 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Malcolm Priestley <tvboxspy@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 167/173] staging: vt6656: [BUG] out of bound array reference in RFbSetPower.
In-Reply-To: <20121228190330.025298996@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.217.219.220
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Malcolm Priestley <tvboxspy@gmail.com>

commit ab1dd9963137a1e122004d5378a581bf16ae9bc8 upstream.

Calling RFbSetPower with uCH zero value will cause out of bound array reference.

This causes 64 bit kernels to oops on boot.

Note: Driver does not function on 64 bit kernels and should be
blacklisted on them.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/staging/vt6656/rf.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/staging/vt6656/rf.c b/drivers/staging/vt6656/rf.c
index 593cdc7..74c0598 100644
--- a/drivers/staging/vt6656/rf.c
+++ b/drivers/staging/vt6656/rf.c
@@ -769,6 +769,9 @@ BYTE    byPwr = pDevice->byCCKPwr;
         return TRUE;
     }
 
+	if (uCH == 0)
+		return -EINVAL;
+
     switch (uRATE) {
     case RATE_1M:
     case RATE_2M:


