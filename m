Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756217Ab0DVT2H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 15:28:07 -0400
Received: from kroah.org ([198.145.64.141]:37361 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756155Ab0DVT14 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 15:27:56 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:09:10 2010
Message-Id: <20100422190910.771421544@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:08:09 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Thomas Mingarelli <Thomas.Mingarelli@hp.com>,
       Wim Van Sebroeck <wim@iguana.be>
Subject: [038/197] WATCHDOG: hpwdt - fix lower timeout limit
In-Reply-To: <20100422191857.GA13268@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Thomas Mingarelli <Thomas.Mingarelli@hp.com>

commit 8ba42bd88c6982fe224b09c33151c797b0fdf1a5 upstream.

[Novell Bug 581103] HP Watchdog driver has arbitrary (wrong) timeout limits.
Fix the lower timeout limit to a more appropriate value.

Signed-off-by: Thomas Mingarelli <Thomas.Mingarelli@hp.com>
Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/watchdog/hpwdt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/watchdog/hpwdt.c
+++ b/drivers/watchdog/hpwdt.c
@@ -443,7 +443,7 @@ static void hpwdt_ping(void)
 static int hpwdt_change_timer(int new_margin)
 {
 	/* Arbitrary, can't find the card's limits */
-	if (new_margin < 30 || new_margin > 600) {
+	if (new_margin < 5 || new_margin > 600) {
 		printk(KERN_WARNING
 			"hpwdt: New value passed in is invalid: %d seconds.\n",
 			new_margin);


