Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757456Ab0DBMGu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 08:06:50 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:59637 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756783Ab0DBMGo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 08:06:44 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Fri, 2 Apr 2010 14:06:33 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 3/3] firewire: ohci: fix nonstandard build without debug
 facility
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.32dda143dc8ebd6c@s5r6.in-berlin.de>
Message-ID: <tkrat.16de1773cf6f2a3a@s5r6.in-berlin.de>
References: <tkrat.4957c3a08e7013b1@s5r6.in-berlin.de>
 <tkrat.32dda143dc8ebd6c@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CONFIG_FIREWIRE_OHCI_DEBUG is currently a hidden kconfig variable, hence
is not going to be switched off by anybody.  Still, it can be switched
off but then compilation will fail in ohci_enable() at the expression
param_debug & OHCI_PARAM_DEBUG_BUSRESETS.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/ohci.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

Index: b/drivers/firewire/ohci.c
===================================================================
--- a/drivers/firewire/ohci.c
+++ b/drivers/firewire/ohci.c
@@ -259,13 +259,13 @@ MODULE_PARM_DESC(quirks, "Chip quirks (d
 	", AR/selfID endianess = "	__stringify(QUIRK_BE_HEADERS)
 	")");
 
-#ifdef CONFIG_FIREWIRE_OHCI_DEBUG
-
 #define OHCI_PARAM_DEBUG_AT_AR		1
 #define OHCI_PARAM_DEBUG_SELFIDS	2
 #define OHCI_PARAM_DEBUG_IRQS		4
 #define OHCI_PARAM_DEBUG_BUSRESETS	8 /* only effective before chip init */
 
+#ifdef CONFIG_FIREWIRE_OHCI_DEBUG
+
 static int param_debug;
 module_param_named(debug, param_debug, int, 0644);
 MODULE_PARM_DESC(debug, "Verbose logging (default = 0"
@@ -438,6 +438,7 @@ static void log_ar_at_event(char dir, in
 
 #else
 
+#define param_debug 0
 static inline void log_irqs(u32 evt) {}
 static inline void log_selfids(int node_id, int generation, int self_id_count, u32 *s) {}
 static inline void log_ar_at_event(char dir, int speed, u32 *header, int evt) {}

-- 
Stefan Richter
-=====-==-=- -=-- ---=-
http://arcgraph.de/sr/

