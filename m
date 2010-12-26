Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752077Ab0LZLre (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Dec 2010 06:47:34 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:52375 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752004Ab0LZLrc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Dec 2010 06:47:32 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Len Brown <lenb@kernel.org>
Subject: [PATCH] ACPI / ACPICA: Disable GPEs during initialization
Date: Sun, 26 Dec 2010 12:47:06 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc7+; KDE/4.4.4; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201012261247.06858.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

GPEs with corresponding _Lxx/_Exx control methods need to be disabled
during initialization in case they have been enabled by the BIOS, so
that they don't fire up until they are enabled by acpi_update_gpes().

References: https://bugzilla.kernel.org/show_bug.cgi?id=25412
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/acpi/acpica/evgpeinit.c |    3 +++
 1 file changed, 3 insertions(+)

Index: linux-2.6/drivers/acpi/acpica/evgpeinit.c
===================================================================
--- linux-2.6.orig/drivers/acpi/acpica/evgpeinit.c
+++ linux-2.6/drivers/acpi/acpica/evgpeinit.c
@@ -408,6 +408,9 @@ acpi_ev_match_gpe_method(acpi_handle obj
 		return_ACPI_STATUS(AE_OK);
 	}
 
+	/* Disable the GPE in case it's been enabled already. */
+	(void)acpi_hw_low_set_gpe(gpe_event_info, ACPI_GPE_DISABLE);
+
 	/*
 	 * Add the GPE information from above to the gpe_event_info block for
 	 * use during dispatch of this GPE.
