Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753466Ab1FTJpn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 05:45:43 -0400
Received: from mx1.melware.net ([78.47.171.162]:35946 "EHLO mx1.melware.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753353Ab1FTJpl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 05:45:41 -0400
Date: Mon, 20 Jun 2011 11:45:39 +0200 (CEST)
From: Armin Schindler <armin@melware.de>
To: Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>
Subject: Map PCI resource to user space problem.
Message-ID: <alpine.DEB.2.00.1106201132170.14886@justus.melware.de>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
Organization: Cytronics & Melware
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

when I try to map PCI resource of size < PAGE_SIZE to user space
with e.g. remap_pfn_range() the mapping seems to be created,
but the access to the PCI device just doesn't work (read returns 0xff).

The same happens when using sysfs. The device has
# ls -al /sys/bus/pci/devices/0000\:02\:09.0/resource*
-rw------- 1 root root     512 Jun 20 11:33 /sys/bus/pci/devices/0000:02:09.0/resource0
-rw------- 1 root root     256 Jun 20 11:33 /sys/bus/pci/devices/0000:02:09.0/resource1
-rw------- 1 root root 8388608 Jun 20 11:33 /sys/bus/pci/devices/0000:02:09.0/resource2
-rw------- 1 root root  262144 Jun 20 11:33 /sys/bus/pci/devices/0000:02:09.0/resource3

and when I mmap() resource0, a valid address is returned, but reading the 
area always returns 0xff.

Since a kernel driver can access resource0 here without problems when using
ioremap(), I'm not sure what is wrong with the sysfs entry for user space
(or using remap_pfn_range() in own mmap function).
The only hint I have so far is the size, which is smaller than PAGE_SIZE.

What would be the correct way to map this area to user space?

Thanks,
Armin
