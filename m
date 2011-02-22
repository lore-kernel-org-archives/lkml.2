Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755466Ab1BVWcK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 17:32:10 -0500
Received: from kroah.org ([198.145.64.141]:46702 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754473Ab1BVWVl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 17:21:41 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 22 14:18:39 2011
Message-Id: <20110222221839.853712243@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 22 Feb 2011 14:17:07 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Roland Vossen <rvossen@broadcom.com>,
        Brett Rudley <brudley@broadcom.com>,
        Arend van Spriel <arend@broadcom.com>
Subject: [28/70] staging: brcm80211: bugfix for softmac crash on multi cpu configurations
In-Reply-To: <20110222222003.GA15831@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Roland Vossen <rvossen@broadcom.com>

commit 6a3be6e6e7feb4cb35275475d6a863b748d59cc3 upstream.

Solved a locking issue that resulted in driver crashes with the 43224 and 43225
chips. The problem has been reported on several fora. Root cause was two fold:
hardware was being manipulated by two unsynchronized threads, and a scan
operation could interfere with an ongoing dynamic calibration process. Fix was
to invoke a lock on wl_ops_config() operation and to set internal flags when a
scan operation is started and stopped.

Please add this to the staging-linus branch.

Signed-off-by: Roland Vossen <rvossen@broadcom.com>
Acked-by: Brett Rudley <brudley@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


---
 drivers/staging/brcm80211/sys/wlc_mac80211.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/staging/brcm80211/sys/wlc_mac80211.c
+++ b/drivers/staging/brcm80211/sys/wlc_mac80211.c
@@ -5336,7 +5336,6 @@ wlc_sendpkt_mac80211(wlc_info_t *wlc, vo
 	fifo = prio2fifo[prio];
 
 	ASSERT((uint) PKTHEADROOM(sdu) >= TXOFF);
-	ASSERT(!PKTSHARED(sdu));
 	ASSERT(!PKTNEXT(sdu));
 	ASSERT(!PKTLINK(sdu));
 	ASSERT(fifo < NFIFO);


