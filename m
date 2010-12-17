Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752638Ab0LQDMR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 22:12:17 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:28597 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752014Ab0LQDMP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 22:12:15 -0500
Message-ID: <4D0AD464.2020408@kernel.org>
Date: Thu, 16 Dec 2010 19:09:24 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Nikanth Karthikesan <knikanth@suse.de>,
        David Rientjes <rientjes@google.com>,
        "Zheng, Shaohui" <shaohui.zheng@intel.com>,
        "linux-hotplug@vger.kernel.org" <linux-hotplug@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Bjorn Helgaas <bjorn.helgaas@hp.com>,
        Venkatesh Pallipadi <venki@google.com>, Nikhil Rao <ncrao@google.com>,
        Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
Subject: [PATCH 1/2] x86, acpi: add MAX_LOCAL_APIC for 32bit
References: <20101111100628.GA24728@localhost> <1289478978.2084.74.camel@laptop> <20101111124015.GA9706@localhost> <1289480656.2084.80.camel@laptop> <20101113084018.GA23098@localhost> <1289644224.2084.521.camel@laptop> <20101113120030.GA31517@localhost> <1289653078.2084.675.camel@laptop> <20101113131042.GA5522@localhost> <4CDEE314.6090107@kernel.org> <20101113235746.GA9458@localhost> <4CDF3DA1.2090806@kernel.org> <4D093ABB.4030206@zytor.com> <4D0943D5.1090404@kernel.org> <4D094703.7080701@zytor.com>
In-Reply-To: <4D094703.7080701@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We should use MAX_LOCAL_APIC for max apic ids
and MAX_APICS as number of local apics.

also apic_version[] array should max apic id related.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/include/asm/apicdef.h |    1 +
 arch/x86/include/asm/mpspec.h  |    2 +-
 arch/x86/kernel/apic/apic.c    |    2 +-
 3 files changed, 3 insertions(+), 2 deletions(-)

Index: linux-2.6/arch/x86/include/asm/apicdef.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/apicdef.h
+++ linux-2.6/arch/x86/include/asm/apicdef.h
@@ -145,6 +145,7 @@
 
 #ifdef CONFIG_X86_32
 # define MAX_IO_APICS 64
+# define MAX_LOCAL_APIC 256
 #else
 # define MAX_IO_APICS 128
 # define MAX_LOCAL_APIC 32768
Index: linux-2.6/arch/x86/kernel/apic/apic.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic/apic.c
+++ linux-2.6/arch/x86/kernel/apic/apic.c
@@ -1689,7 +1689,7 @@ void __init register_lapic_address(unsig
  * This initializes the IO-APIC and APIC hardware if this is
  * a UP kernel.
  */
-int apic_version[MAX_APICS];
+int apic_version[MAX_LOCAL_APIC];
 
 int __init APIC_init_uniprocessor(void)
 {
Index: linux-2.6/arch/x86/include/asm/mpspec.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/mpspec.h
+++ linux-2.6/arch/x86/include/asm/mpspec.h
@@ -6,7 +6,7 @@
 #include <asm/mpspec_def.h>
 #include <asm/x86_init.h>
 
-extern int apic_version[MAX_APICS];
+extern int apic_version[];
 extern int pic_mode;
 
 #ifdef CONFIG_X86_32
