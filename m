Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932218Ab1HCXbW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 19:31:22 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34091 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932172Ab1HCXaU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 19:30:20 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Aug  3 15:12:53 2011
Message-Id: <20110803221253.867272438@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 03 Aug 2011 15:01:57 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        David Engraf <david.engraf@sysgo.com>,
        Paul Mundt <lethal@linux-sh.org>, Wim Van sebroeck <wim@iguana.be>
Subject: [097/102] watchdog: shwdt: fix usage of mod_timer
In-Reply-To: <20110803221345.GA10346@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: David Engraf <david.engraf@sysgo.com>

commit bea1906620ce72b63f83735c4cc2642b25ec54ae upstream.

Fix the usage of mod_timer() and make the driver usable. mod_timer() must
be called with an absolute timeout in jiffies. The old implementation
used a relative timeout thus the hardware watchdog was never triggered.

Signed-off-by: David Engraf <david.engraf@sysgo.com>
Signed-off-by: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Wim Van sebroeck <wim@iguana.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/watchdog/shwdt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/watchdog/shwdt.c
+++ b/drivers/watchdog/shwdt.c
@@ -64,7 +64,7 @@
  * misses its deadline, the kernel timer will allow the WDT to overflow.
  */
 static int clock_division_ratio = WTCSR_CKS_4096;
-#define next_ping_period(cks)	msecs_to_jiffies(cks - 4)
+#define next_ping_period(cks)	(jiffies + msecs_to_jiffies(cks - 4))
 
 static const struct watchdog_info sh_wdt_info;
 static struct platform_device *sh_wdt_dev;


