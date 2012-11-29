Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754824Ab2K2Spp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 13:45:45 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:34001 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754696Ab2K2SpO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 13:45:14 -0500
Date: Thu, 29 Nov 2012 10:43:28 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
        Jim Cromie <jim.cromie@gmail.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <ak@linux.intel.com>, Michal Marek <mmarek@suse.cz>,
        Tony Lindgren <tony@atomide.com>,
        Jonathan Kliegman <kliegs@chromium.org>,
        Chris Zankel <chris@zankel.net>
Cc: Bill Pemberton <wfp5p@viridian.itc.virginia.edu>,
        Fengguang Wu <fengguang.wu@intel.com>, Sam Ravnborg <sam@ravnborg.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>
Subject: [PATCH 1/2] init.h: Remove __dev* sections from the kernel
Message-ID: <20121129184328.GB15110@kroah.com>
References: <20121129184133.GA15110@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121129184133.GA15110@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

With the recent work to remove CONFIG_HOTPLUG, we are starting to get a
bunch of __devinit section warnings, despite CONFIG_HOTPLUG always being
enabled.  So, stop marking the sections entirely, by defining them away
the section markings in init.h

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/init.h |   18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)

diff --git a/include/linux/init.h b/include/linux/init.h
index e59041e..f63692d 100644
--- a/include/linux/init.h
+++ b/include/linux/init.h
@@ -93,13 +93,13 @@
 
 #define __exit          __section(.exit.text) __exitused __cold notrace
 
-/* Used for HOTPLUG */
-#define __devinit        __section(.devinit.text) __cold notrace
-#define __devinitdata    __section(.devinit.data)
-#define __devinitconst   __constsection(.devinit.rodata)
-#define __devexit        __section(.devexit.text) __exitused __cold notrace
-#define __devexitdata    __section(.devexit.data)
-#define __devexitconst   __constsection(.devexit.rodata)
+/* Used for HOTPLUG, but that is always enabled now, so just make them noops */
+#define __devinit
+#define __devinitdata
+#define __devinitconst
+#define __devexit
+#define __devexitdata
+#define __devexitconst
 
 /* Used for HOTPLUG_CPU */
 #define __cpuinit        __section(.cpuinit.text) __cold notrace
@@ -126,10 +126,6 @@
 #define __INITRODATA	.section	".init.rodata","a",%progbits
 #define __FINITDATA	.previous
 
-#define __DEVINIT        .section	".devinit.text", "ax"
-#define __DEVINITDATA    .section	".devinit.data", "aw"
-#define __DEVINITRODATA  .section	".devinit.rodata", "a"
-
 #define __CPUINIT        .section	".cpuinit.text", "ax"
 #define __CPUINITDATA    .section	".cpuinit.data", "aw"
 #define __CPUINITRODATA  .section	".cpuinit.rodata", "a"
