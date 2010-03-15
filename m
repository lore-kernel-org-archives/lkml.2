Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757246Ab0COXdh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 19:33:37 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:41689 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756651Ab0COXde (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 19:33:34 -0400
Date: Tue, 16 Mar 2010 10:33:32 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
       ppc-dev <linuxppc-dev@lists.ozlabs.org>
Subject: [PATCH] sysdev: the cpu probe/release attributes should be
 sysdev_class_attributes
Message-Id: <20100316103332.ade0b5d9.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0 (GTK+ 2.18.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes these warnings:

drivers/base/cpu.c:264: warning: initialization from incompatible pointer type
drivers/base/cpu.c:265: warning: initialization from incompatible pointer type

Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/base/cpu.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

Hi Greg,

Could you pleas send this on to Linuse as this is now a bug in mainline.

Thanks.

diff --git a/drivers/base/cpu.c b/drivers/base/cpu.c
index 7036e8e..b5242e1 100644
--- a/drivers/base/cpu.c
+++ b/drivers/base/cpu.c
@@ -79,24 +79,24 @@ void unregister_cpu(struct cpu *cpu)
 }
 
 #ifdef CONFIG_ARCH_CPU_PROBE_RELEASE
-static ssize_t cpu_probe_store(struct sys_device *dev,
-				struct sysdev_attribute *attr,
-				const char *buf,
+static ssize_t cpu_probe_store(struct sysdev_class *class,
+			       struct sysdev_class_attribute *attr,
+			       const char *buf,
 			       size_t count)
 {
 	return arch_cpu_probe(buf, count);
 }
 
-static ssize_t cpu_release_store(struct sys_device *dev,
-				struct sysdev_attribute *attr,
-				const char *buf,
+static ssize_t cpu_release_store(struct sysdev_class *class,
+				 struct sysdev_class_attribute *attr,
+				 const char *buf,
 				 size_t count)
 {
 	return arch_cpu_release(buf, count);
 }
 
-static SYSDEV_ATTR(probe, S_IWUSR, NULL, cpu_probe_store);
-static SYSDEV_ATTR(release, S_IWUSR, NULL, cpu_release_store);
+static SYSDEV_CLASS_ATTR(probe, S_IWUSR, NULL, cpu_probe_store);
+static SYSDEV_CLASS_ATTR(release, S_IWUSR, NULL, cpu_release_store);
 #endif /* CONFIG_ARCH_CPU_PROBE_RELEASE */
 
 #else /* ... !CONFIG_HOTPLUG_CPU */
-- 
1.7.0

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
