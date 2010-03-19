Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753287Ab0CSPV5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 11:21:57 -0400
Received: from kroah.org ([198.145.64.141]:45915 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752649Ab0CSPTE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 11:19:04 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Andi Kleen <andi@firstfloor.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 09/12] sysdev: the cpu probe/release attributes should be sysdev_class_attributes
Date: Fri, 19 Mar 2010 08:18:52 -0700
Message-Id: <1269011935-8886-9-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.0.2
In-Reply-To: <20100319151311.GA8541@kroah.com>
References: <20100319151311.GA8541@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>

This fixes these warnings:

drivers/base/cpu.c:264: warning: initialization from incompatible pointer type
drivers/base/cpu.c:265: warning: initialization from incompatible pointer type

Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/cpu.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

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
1.7.0.2

