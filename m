Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753758Ab1FNTpl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 15:45:41 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:20539 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753459Ab1FNTpk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 15:45:40 -0400
Date: Tue, 14 Jun 2011 12:45:10 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>, len.brown@intel.com
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andy Whitcroft <apw@canonical.com>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [patch] Re: Linux 3.0-rc3 (APM fix)
Message-Id: <20110614124510.e716bff1.randy.dunlap@oracle.com>
In-Reply-To: <BANLkTinCfV4owNBhJ+F-yfF3V+wg1o=PLA@mail.gmail.com>
References: <BANLkTinCfV4owNBhJ+F-yfF3V+wg1o=PLA@mail.gmail.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4DF7BA52.0100:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Jun 2011 16:01:26 -0700 Linus Torvalds wrote:

> .. and this time even with a timely tar-ball, since I'm not traveling any more.


ERROR: "pm_idle" [arch/x86/kernel/apm.ko] undefined!
ERROR: "default_idle" [arch/x86/kernel/apm.ko] undefined!


Fix was posted by Andy Whitcroft on June 8 and Ben Hutchings on June 9.
https://lkml.org/lkml/2011/6/8/170
https://lkml.org/lkml/2011/6/9/679

Below is Andy's patch since it was posted first.
Please merge some fix.


---
The commit below removed the export for pm_idle/default_idle unless the
apm module was modularised and CONFIG_APM_CPU_IDLE was set.  The apm
module uses pm_idle/default_idle unconditionally, CONFIG_APM_CPU_IDLE
only affects the bios idle threshold.  Adjust the export accordingly.

    commit 06ae40ce073daf233607a3c54a489f2c1e44683e
    Author: Len Brown <len.brown@intel.com>
    Date:   Fri Apr 1 15:28:09 2011 -0400

	x86 idle: EXPORT_SYMBOL(default_idle, pm_idle) only when APM demands it

Signed-off-by: Andy Whitcroft <apw@canonical.com>
---
 arch/x86/kernel/process.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 2e4928d..b8265d0 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -337,7 +337,7 @@ EXPORT_SYMBOL(boot_option_idle_override);
  * Powermanagement idle function, if any..
  */
 void (*pm_idle)(void);
-#if defined(CONFIG_APM_MODULE) && defined(CONFIG_APM_CPU_IDLE)
+#if defined(CONFIG_APM_MODULE)
 EXPORT_SYMBOL(pm_idle);
 #endif
 
@@ -399,7 +399,7 @@ void default_idle(void)
 		cpu_relax();
 	}
 }
-#if defined(CONFIG_APM_MODULE) && defined(CONFIG_APM_CPU_IDLE)
+#if defined(CONFIG_APM_MODULE)
 EXPORT_SYMBOL(default_idle);
 #endif
 
-- 
