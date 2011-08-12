Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754859Ab1HNQKs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 12:10:48 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36988 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754823Ab1HNQKl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 12:10:41 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Aug 12 14:06:00 2011
Message-Id: <20110812210559.936984388@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 12 Aug 2011 14:05:14 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "David S. Miller" <davem@davemloft.net>
Subject: [89/90] sparc: Dont do hypervisor calls on non-sun4v in DS driver.
In-Reply-To: <20110812210626.GA4725@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: "David S. Miller" <davem@davemloft.net>

commit c92761fd9efcbbcb59e7bf4db88e29ce03229889 upstream.

Reported-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/sparc/kernel/ds.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/arch/sparc/kernel/ds.c
+++ b/arch/sparc/kernel/ds.c
@@ -1256,13 +1256,14 @@ static int __init ds_init(void)
 {
 	unsigned long hv_ret, major, minor;
 
-	hv_ret = sun4v_get_version(HV_GRP_REBOOT_DATA, &major, &minor);
-	if (hv_ret == HV_EOK) {
-		pr_info("SUN4V: Reboot data supported (maj=%lu,min=%lu).\n",
-			major, minor);
-		reboot_data_supported = 1;
+	if (tlb_type == hypervisor) {
+		hv_ret = sun4v_get_version(HV_GRP_REBOOT_DATA, &major, &minor);
+		if (hv_ret == HV_EOK) {
+			pr_info("SUN4V: Reboot data supported (maj=%lu,min=%lu).\n",
+				major, minor);
+			reboot_data_supported = 1;
+		}
 	}
-
 	kthread_run(ds_thread, NULL, "kldomd");
 
 	return vio_register_driver(&ds_driver);


