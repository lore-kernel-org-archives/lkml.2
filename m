Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753384Ab1KPFRp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 00:17:45 -0500
Received: from mail-fx0-f74.google.com ([209.85.161.74]:60909 "EHLO
	mail-fx0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752825Ab1KPFQc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 00:16:32 -0500
From: David Decotigny <david.decotigny@google.com>
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>,
        Ian Campbell <ian.campbell@citrix.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Ben Hutchings <bhutchings@solarflare.com>,
        Jiri Pirko <jpirko@redhat.com>, Joe Perches <joe@perches.com>,
        Szymon Janc <szymon@janc.net.pl>, Richard Jones <rick.jones2@hp.com>,
        Ayaz Abdulla <AAbdulla@nvidia.com>,
        David Decotigny <david.decotigny@google.com>
Subject: [PATCH net-next v5 03/10] kbuild: document RPS/XPS network Kconfig options
Date: Tue, 15 Nov 2011 21:15:51 -0800
Message-Id: <e4bb76dfd9ddd0bd02d8897b15e7b4ee50af5b17.1321420513.git.david.decotigny@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <cover.1321420513.git.david.decotigny@google.com>
References: <cover.1321420513.git.david.decotigny@google.com>
In-Reply-To: <cover.1321420513.git.david.decotigny@google.com>
References: <cover.1321420513.git.david.decotigny@google.com>
Organization: Google, Inc.
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds a description of RPS/XPS options and allow them to be
changed at make menuconfig time.



Signed-off-by: David Decotigny <david.decotigny@google.com>
---
 net/Kconfig |   16 +++++++++++++---
 1 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/net/Kconfig b/net/Kconfig
index a073148..1422c34 100644
--- a/net/Kconfig
+++ b/net/Kconfig
@@ -217,20 +217,30 @@ source "net/dns_resolver/Kconfig"
 source "net/batman-adv/Kconfig"
 
 config RPS
-	boolean
+	boolean "Enable Receive Packet Steering"
 	depends on SMP && SYSFS && USE_GENERIC_SMP_HELPERS
 	default y
+	  RPS distributes the load of received packet processing
+	  across multiple CPUs. If unsure, say Y.
 
 config RFS_ACCEL
-	boolean
+	boolean "Enable Hardware Acceleration of RFS"
 	depends on RPS && GENERIC_HARDIRQS
 	select CPU_RMAP
 	default y
+	  This is the hardware version of RPS. On multi-queue network
+	  devices, this configures the hardware to distribute the
+	  received packets across multiple CPUs. If unsure, say Y.
 
 config XPS
-	boolean
+	boolean "Enable Transmit Packet Steering"
 	depends on SMP && SYSFS && USE_GENERIC_SMP_HELPERS
 	default y
+	  For multiqueue devices, XPS selects a transmit queue during
+	  packet transmission based on configuration. This is done by
+	  mapping the CPU transmitting the packet to a queue. XPS can
+	  reduce transmit network latency on SMP systems. If unsure,
+	  say Y.
 
 config HAVE_BPF_JIT
 	bool
-- 
1.7.3.1

