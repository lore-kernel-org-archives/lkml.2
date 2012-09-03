Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755545Ab2ICAEU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2012 20:04:20 -0400
Received: from caiajhbdcaid.dreamhost.com ([208.97.132.83]:50211 "EHLO
	homiemail-a2.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755322Ab2ICADe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2012 20:03:34 -0400
Subject: [PATCH 2/5] sonypi: remove acpi_bus_generate_proc_event
From: Davidlohr Bueso <dave@gnu.org>
Reply-To: dave@gnu.org
To: Len Brown <lenb@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Zhang Rui <rui.zhang@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mattia Dongili <malattia@linux.it>, Arnd Bergmann <arnd@arndb.de>
Cc: platform-driver-x86@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        linux-acpi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Organization: GNU
Date: Mon, 03 Sep 2012 02:03:24 +0200
Message-ID: <1346630604.3170.30.camel@offbook>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Calling this function no longer makes sense as /proc/acpi/event
is being removed.

Signed-off-by: Davidlohr Bueso <dave@gnu.org>
---
 drivers/char/sonypi.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/drivers/char/sonypi.c b/drivers/char/sonypi.c
index f877805..4543473 100644
--- a/drivers/char/sonypi.c
+++ b/drivers/char/sonypi.c
@@ -876,11 +876,6 @@ found:
 	if (useinput)
 		sonypi_report_input_event(event);
 
-#ifdef CONFIG_ACPI
-	if (sonypi_acpi_device)
-		acpi_bus_generate_proc_event(sonypi_acpi_device, 1, event);
-#endif
-
 	kfifo_in_locked(&sonypi_device.fifo, (unsigned char *)&event,
 			sizeof(event), &sonypi_device.fifo_lock);
 	kill_fasync(&sonypi_device.fifo_async, SIGIO, POLL_IN);
-- 
1.7.4.1




