Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752506Ab0HIRxR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 13:53:17 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:44378 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750869Ab0HIRxG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 13:53:06 -0400
Message-ID: <4C60407C.2080608@austin.ibm.com>
Date: Mon, 09 Aug 2010 12:53:00 -0500
From: Nathan Fontenot <nfont@austin.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org, linuxppc-dev@ozlabs.org
CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>, Greg KH <greg@kroah.com>
Subject: [PATCH 0/8] v5 De-couple sysfs memory directories from memory sections
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

Updates for version 5 of the patchset include the following:

Patch 4/8 Add mutex for add/remove of memory blocks
- Define the mutex using DEFINE_MUTEX macro.

Patch 8/8 Update memory-hotplug documentation
- Add information concerning memory holes in phys_index..end_phys_index.
 
Thanks,

Nathan Fontenot
