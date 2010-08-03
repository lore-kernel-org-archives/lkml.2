Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756490Ab0HCNcx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 09:32:53 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:55278 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756379Ab0HCNch (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 09:32:37 -0400
Message-ID: <4C581A6D.9030908@austin.ibm.com>
Date: Tue, 03 Aug 2010 08:32:29 -0500
From: Nathan Fontenot <nfont@austin.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org, linuxppc-dev@ozlabs.org
CC: Greg KH <greg@kroah.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>
Subject: [PATCH 0/9] v4  De-couple sysfs memory directories from memory sections
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This set of patches de-couples the idea that there is a single
directory in sysfs for each memory section.  The intent of the
patches is to reduce the number of sysfs directories created to
resolve a boot-time performance issue.  On very large systems
boot time are getting very long (as seen on powerpc hardware)
due to the enormous number of sysfs directories being created.
On a system with 1 TB of memory we create ~63,000 directories.
For even larger systems boot times are being measured in hours.

This set of patches allows for each directory created in sysfs
to cover more than one memory section.  The default behavior for
sysfs directory creation is the same, in that each directory
represents a single memory section.  A new file 'end_phys_index'
in each directory contains the physical_id of the last memory
section covered by the directory so that users can easily
determine the memory section range of a directory.

Updates for version 4 of the patchset includes an additional
patch [4/9] that introduces a new mutex to be taken for any
add or remove (not hotplug) of memory.  The following updates
are also included.
 
Patch 2/9 Add new phys_index properties
- The start_phys_index property was reverted to the original
  phys_index name.

Patch 3/9 Add section count to memory_block
- Use atomic_dec_and_test()

Patch 7/9 Update the node sysfs code
- Update the inline definition of unregister_mem_sects_under_nodes
  for !CONFIG_NUMA builds.

Patch 8/9 Define memory_block_size_bytes() for ppc/pseries
- Use an unsigned long for getting property value.

Patch 9/9 Update memory-hotplug documentation
- Minor updates for reversion of phys_index property name.

Thanks,

Nathan Fontenot
