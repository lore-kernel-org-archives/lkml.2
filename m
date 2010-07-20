Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751432Ab0GTEAW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 00:00:22 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:60973 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751166Ab0GTEAQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 00:00:16 -0400
Message-ID: <4C451F3F.8000207@austin.ibm.com>
Date: Mon, 19 Jul 2010 22:59:59 -0500
From: Nathan Fontenot <nfont@austin.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.10) Gecko/20100527 Thunderbird/3.0.5
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org, linuxppc-dev@ozlabs.org
CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, greg@kroah.com
Subject: [PATCH 8/8] v3 Update memory-hotplug documentation
References: <4C451BF5.50304@austin.ibm.com>
In-Reply-To: <4C451BF5.50304@austin.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Update the memory hotplug documentation to reflect the new behaviors of
memory blocks reflected in sysfs.

Signed-off-by: Nathan Fontent <nfont@austin.ibm.com>
---
 Documentation/memory-hotplug.txt |   40 +++++++++++++++++++++++----------------
 1 file changed, 24 insertions(+), 16 deletions(-)

Index: linux-2.6/Documentation/memory-hotplug.txt
===================================================================
--- linux-2.6.orig/Documentation/memory-hotplug.txt	2010-06-23 15:06:53.000000000 -0500
+++ linux-2.6/Documentation/memory-hotplug.txt	2010-07-19 21:00:11.000000000 -0500
@@ -126,36 +126,44 @@ config options.
 --------------------------------
 4 sysfs files for memory hotplug
 --------------------------------
-All sections have their device information under /sys/devices/system/memory as
+All sections have their device information in sysfs.  Each section is part of
+a memory block under /sys/devices/system/memory as
 
 /sys/devices/system/memory/memoryXXX
-(XXX is section id.)
+(XXX is the section id.)
 
-Now, XXX is defined as start_address_of_section / section_size.
+Now, XXX is defined as (start_address_of_section / section_size) of the first
+section conatined in the memory block.
 
 For example, assume 1GiB section size. A device for a memory starting at
 0x100000000 is /sys/device/system/memory/memory4
 (0x100000000 / 1Gib = 4)
 This device covers address range [0x100000000 ... 0x140000000)
 
-Under each section, you can see 4 files.
+Under each section, you can see 5 files.
 
-/sys/devices/system/memory/memoryXXX/phys_index
+/sys/devices/system/memory/memoryXXX/start_phys_index
+/sys/devices/system/memory/memoryXXX/end_phys_index
 /sys/devices/system/memory/memoryXXX/phys_device
 /sys/devices/system/memory/memoryXXX/state
 /sys/devices/system/memory/memoryXXX/removable
 
-'phys_index' : read-only and contains section id, same as XXX.
-'state'      : read-write
-               at read:  contains online/offline state of memory.
-               at write: user can specify "online", "offline" command
-'phys_device': read-only: designed to show the name of physical memory device.
-               This is not well implemented now.
-'removable'  : read-only: contains an integer value indicating
-               whether the memory section is removable or not
-               removable.  A value of 1 indicates that the memory
-               section is removable and a value of 0 indicates that
-               it is not removable.
+'start_phys_index' : read-only and contains section id of the first section
+		     in the memory block, same as XXX.
+'end_phys_index'   : read-only and contains section id of the last section
+		     in the memory block.
+'state'            : read-write
+                     at read:  contains online/offline state of memory.
+                     at write: user can specify "online", "offline" command
+                     which will be performed on al sections in the block.
+'phys_device'      : read-only: designed to show the name of physical memory
+                     device.  This is not well implemented now.
+'removable'        : read-only: contains an integer value indicating
+                     whether the memory block is removable or not
+                     removable.  A value of 1 indicates that the memory
+                     block is removable and a value of 0 indicates that
+                     it is not removable. A memory block is removable only if
+                     every section in the block is removable.
 
 NOTE:
   These directories/files appear after physical memory hotplug phase.
