Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754350Ab1KPWRt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 17:17:49 -0500
Received: from mail-ey0-f202.google.com ([209.85.215.202]:38616 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753998Ab1KPWPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 17:15:37 -0500
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
Subject: [PATCH net-next v6 3/9] kbuild: document RPS/XPS network Kconfig options
Date: Wed, 16 Nov 2011 14:15:09 -0800
Message-Id: <c7e7b57596f9a06b1c40c8b6e671cc6ac69dd304.1321481064.git.david.decotigny@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <cover.1321481064.git.david.decotigny@google.com>
References: <cover.1321481064.git.david.decotigny@google.com>
In-Reply-To: <cover.1321481064.git.david.decotigny@google.com>
References: <cover.1321481064.git.david.decotigny@google.com>
Organization: Google, Inc.
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds a description of RPS/XPS options and allow them to be
changed at make menuconfig time.

It also fixes following checkpatch syntax warnings:
ERROR: trailing whitespace
+^I  $

ERROR: trailing whitespace
+^I$



Signed-off-by: David Decotigny <david.decotigny@google.com>
---
 net/Kconfig |   22 +++++++++++++++++-----
 1 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/net/Kconfig b/net/Kconfig
index a073148..8e2104e 100644
--- a/net/Kconfig
+++ b/net/Kconfig
@@ -10,7 +10,7 @@ menuconfig NET
 	  The reason is that some programs need kernel networking support even
 	  when running on a stand-alone machine that isn't connected to any
 	  other computer.
-	  
+
 	  If you are upgrading from an older kernel, you
 	  should consider updating your networking tools too because changes
 	  in the kernel and the tools often go hand in hand. The tools are
@@ -217,20 +217,33 @@ source "net/dns_resolver/Kconfig"
 source "net/batman-adv/Kconfig"
 
 config RPS
-	boolean
+	boolean "Enable Receive Packet Steering"
 	depends on SMP && SYSFS && USE_GENERIC_SMP_HELPERS
 	default y
+	help
+	  RPS distributes the load of received packet processing
+	  across multiple CPUs. If unsure, say Y.
 
 config RFS_ACCEL
-	boolean
+	boolean "Enable Hardware Acceleration of RFS"
 	depends on RPS && GENERIC_HARDIRQS
 	select CPU_RMAP
 	default y
+	help
+	  This is the hardware version of RPS. On multi-queue network
+	  devices, this configures the hardware to distribute the
+	  received packets across multiple CPUs. If unsure, say Y.
 
 config XPS
-	boolean
+	boolean "Enable Transmit Packet Steering"
 	depends on SMP && SYSFS && USE_GENERIC_SMP_HELPERS
 	default y
+	help
+	  For multiqueue devices, XPS selects a transmit queue during
+	  packet transmission based on configuration. This is done by
+	  mapping the CPU transmitting the packet to a queue. XPS can
+	  reduce transmit network latency on SMP systems. If unsure,
+	  say Y.
 
 config HAVE_BPF_JIT
 	bool
@@ -274,7 +287,6 @@ config NET_TCPPROBE
 
 	Documentation on how to use TCP connection probing can be found
 	at:
-	
 	  http://www.linuxfoundation.org/collaborate/workgroups/networking/tcpprobe
 
 	To compile this code as a module, choose M here: the
-- 
1.7.3.1

