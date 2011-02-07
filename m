Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755206Ab1BGWX6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 17:23:58 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:51712 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754772Ab1BGWXq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 17:23:46 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Len Brown <lenb@kernel.org>
Subject: [PATCH 2/6] ACPI / PM: Do not switch interrupts off/on in acpi_suspend_enter()
Date: Mon, 7 Feb 2011 23:19:10 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc3+; KDE/4.4.4; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>
References: <201102072316.41270.rjw@sisk.pl>
In-Reply-To: <201102072316.41270.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201102072319.10327.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

The function acpi_suspend_enter() is always called with interrupts
off, so it doesn't need to switch them off and on.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/acpi/sleep.c |    3 ---
 1 file changed, 3 deletions(-)

Index: linux-2.6/drivers/acpi/sleep.c
===================================================================
--- linux-2.6.orig/drivers/acpi/sleep.c
+++ linux-2.6/drivers/acpi/sleep.c
@@ -243,7 +243,6 @@ static int acpi_suspend_begin(suspend_st
 static int acpi_suspend_enter(suspend_state_t pm_state)
 {
 	acpi_status status = AE_OK;
-	unsigned long flags = 0;
 	u32 acpi_state = acpi_target_sleep_state;
 
 	ACPI_FLUSH_CPU_CACHE();
@@ -256,7 +255,6 @@ static int acpi_suspend_enter(suspend_st
 			return error;
 	}
 
-	local_irq_save(flags);
 	switch (acpi_state) {
 	case ACPI_STATE_S1:
 		barrier();
@@ -290,7 +288,6 @@ static int acpi_suspend_enter(suspend_st
 	/* Allow EC transactions to happen. */
 	acpi_ec_unblock_transactions_early();
 
-	local_irq_restore(flags);
 	printk(KERN_DEBUG "Back to C!\n");
 
 	suspend_nvs_restore();

