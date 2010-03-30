Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757764Ab0CaAaq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 20:30:46 -0400
Received: from kroah.org ([198.145.64.141]:48850 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756393Ab0C3XML (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:12:11 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:58:22 2010
Message-Id: <20100330225821.872106049@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:57:24 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Chris McDermott <lcm@linux.vnet.ibm.com>,
       Yinghai Lu <yinghai@kernel.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [22/89] x86, apic: use physical mode for IBM summit platforms
In-Reply-To: <20100330230520.GA28779@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Suresh Siddha <suresh.b.siddha@intel.com>

commit dfea91d5a7c795fd6f4e1a97489a98e4e767463e upstream.

Chris McDermott from IBM confirmed that hurricane chipset in IBM summit
platforms doesn't support logical flat mode.  Irrespective of the other
things like apic_id's, total number of logical cpu's, Linux kernel
should default to physical mode for this system.

The 32-bit kernel does so using the OEM checks for the IBM summit
platform.  Add a similar OEM platform check for the 64bit kernel too.

Otherwise the linux kernel boot can hang on this platform under certain
bios/platform settings.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Tested-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Chris McDermott <lcm@linux.vnet.ibm.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/apic/apic_flat_64.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/arch/x86/kernel/apic/apic_flat_64.c
+++ b/arch/x86/kernel/apic/apic_flat_64.c
@@ -240,6 +240,11 @@ static int physflat_acpi_madt_oem_check(
 		printk(KERN_DEBUG "system APIC only can use physical flat");
 		return 1;
 	}
+
+	if (!strncmp(oem_id, "IBM", 3) && !strncmp(oem_table_id, "EXA", 3)) {
+		printk(KERN_DEBUG "IBM Summit detected, will use apic physical");
+		return 1;
+	}
 #endif
 
 	return 0;


