Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757364Ab0D2A4O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 20:56:14 -0400
Received: from mail.gmx.net ([213.165.64.20]:32834 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755633Ab0D2A4K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 20:56:10 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1/Uh1FD3M3UDyn9wQnt8sBizTPkck6/veEuIvekpZ
	NrHo5fCdNkUfg+
From: Peter Huewe <PeterHuewe@gmx.de>
To: Paul Mundt <lethal@linux-sh.org>
Subject: [PATCH] arch/sh: Fix wrong function prototype for native_cpu_disable
Date: Thu, 29 Apr 2010 02:56:10 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.33.2; KDE/4.3.5; x86_64; ; )
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       Matt Fleming <matt@console-pimps.org>, Mike Travis <travis@sgi.com>,
       linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201004290256.10506.PeterHuewe@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.51000000000000001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Huewe <peterhuewe@gmx.de>

This patch fixes the prototype of native_cpu_disable if
CONFIG_HOTPLUG_CPU is not set, and thus fixes a build failure[1]

References:
[1] http://kisskb.ellerman.id.au/kisskb/buildresult/2536296/

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
KernelVersion: linux-next-20100429

 arch/sh/kernel/smp.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/sh/kernel/smp.c b/arch/sh/kernel/smp.c
index 86cd6f9..509b36b 100644
--- a/arch/sh/kernel/smp.c
+++ b/arch/sh/kernel/smp.c
@@ -161,7 +161,7 @@ int __cpu_disable(void)
 	return 0;
 }
 #else /* ... !CONFIG_HOTPLUG_CPU */
-int native_cpu_disable(void)
+int native_cpu_disable(unsigned int cpu)
 {
 	return -ENOSYS;
 }
-- 
1.6.4.4

