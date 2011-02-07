Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755159Ab1BGWXw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 17:23:52 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:51705 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753501Ab1BGWXl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 17:23:41 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Len Brown <lenb@kernel.org>
Subject: [PATCH 6/6] ACPI / PM: Do not switch interrupts off/on in acpi_hibernation_enter()
Date: Mon, 7 Feb 2011 23:22:46 +0100
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
Message-Id: <201102072322.47041.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

The function acpi_hibernation_enter() is always called with
interrupts off, so it doesn't need to switch them off and on.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/acpi/sleep.c |    3 ---
 1 file changed, 3 deletions(-)

Index: linux-2.6/drivers/acpi/sleep.c
===================================================================
--- linux-2.6.orig/drivers/acpi/sleep.c
+++ linux-2.6/drivers/acpi/sleep.c
@@ -457,16 +457,13 @@ static int acpi_hibernation_begin(void)
 static int acpi_hibernation_enter(void)
 {
 	acpi_status status = AE_OK;
-	unsigned long flags = 0;
 
 	ACPI_FLUSH_CPU_CACHE();
 
-	local_irq_save(flags);
 	/* This shouldn't return.  If it returns, we have a problem */
 	status = acpi_enter_sleep_state(ACPI_STATE_S4);
 	/* Reprogram control registers and execute _BFS */
 	acpi_leave_sleep_state_prep(ACPI_STATE_S4);
-	local_irq_restore(flags);
 
 	return ACPI_SUCCESS(status) ? 0 : -EFAULT;
 }

