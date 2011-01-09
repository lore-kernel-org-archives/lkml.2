Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752450Ab1AIECn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jan 2011 23:02:43 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:55810 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751816Ab1AIECm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jan 2011 23:02:42 -0500
Date: Sat, 8 Jan 2011 19:59:14 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: x86@kernel.org
Subject: [PATCH] x86: fix sparse non-ANSI function warnings in smpboot.c
Message-Id: <20110108195914.95d366ea.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.14.4; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix sparse warning for non-ANSI function declaration:

arch/x86/kernel/smpboot.c:100:30: warning: non-ANSI function declaration of function 'cpu_hotplug_driver_lock'
arch/x86/kernel/smpboot.c:105:32: warning: non-ANSI function declaration of function 'cpu_hotplug_driver_unlock'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: x86@kernel.org
---
 arch/x86/kernel/smpboot.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- lnx0107.orig/arch/x86/kernel/smpboot.c
+++ lnx0107/arch/x86/kernel/smpboot.c
@@ -97,12 +97,12 @@ static DEFINE_PER_CPU(struct task_struct
  */
 static DEFINE_MUTEX(x86_cpu_hotplug_driver_mutex);
 
-void cpu_hotplug_driver_lock()
+void cpu_hotplug_driver_lock(void)
 {
         mutex_lock(&x86_cpu_hotplug_driver_mutex);
 }
 
-void cpu_hotplug_driver_unlock()
+void cpu_hotplug_driver_unlock(void)
 {
         mutex_unlock(&x86_cpu_hotplug_driver_mutex);
 }
