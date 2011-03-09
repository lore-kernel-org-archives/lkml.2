Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756785Ab1CIAcl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 19:32:41 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34610 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754905Ab1CIAck convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 19:32:40 -0500
From: Ben Hutchings <ben@decadent.org.uk>
To: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1299630111.4146.15.camel@localhost>
References: <1299630111.4146.15.camel@localhost>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 09 Mar 2011 00:32:36 +0000
Message-ID: <1299630756.4146.25.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: [PATCH 4/5] avr32: Fix .size directive for cpu_enter_idle
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.i.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

gas used to accept (and ignore?) .size directives which referred to
undefined symbols, as this does.  In binutils 2.21 these are treated
as errors.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/avr32/mach-at32ap/pm-at32ap700x.S |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/avr32/mach-at32ap/pm-at32ap700x.S b/arch/avr32/mach-at32ap/pm-at32ap700x.S
index 17503b0..f868f4c 100644
--- a/arch/avr32/mach-at32ap/pm-at32ap700x.S
+++ b/arch/avr32/mach-at32ap/pm-at32ap700x.S
@@ -53,7 +53,7 @@ cpu_enter_idle:
 	st.w	r8[TI_flags], r9
 	unmask_interrupts
 	sleep	CPU_SLEEP_IDLE
-	.size	cpu_idle_sleep, . - cpu_idle_sleep
+	.size	cpu_enter_idle, . - cpu_enter_idle
 
 	/*
 	 * Common return path for PM functions that don't run from
-- 
1.7.4.1



