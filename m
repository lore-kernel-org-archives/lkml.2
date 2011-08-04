Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755245Ab1HDQWO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 12:22:14 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:18154 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755148Ab1HDQWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 12:22:04 -0400
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+zrwiavkK6tmQaLfmwtM48/ll2c7pEOUO
X-RZG-CLASS-ID: mo00
Message-Id: <20110804162053.723541930@aepfle.de>
User-Agent: quilt/0.48-16.4
Date: Thu, 04 Aug 2011 18:20:53 +0200
From: Olaf Hering <olaf@aepfle.de>
To: linux-kernel@vger.kernel.org, Jeremy Fitzhardinge <jeremy@goop.org>,
        Konrad <konrad.wilk@oracle.com>
Cc: xen-devel@lists.xensource.com
Subject: [PATCH 0/3] [v4] kexec and kdump for Xen PVonHVM guests
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



The following series implements kexec and kdump in a Xen PVonHVM guest.

It is (should be) available via git:

 git://github.com/olafhering/linux.git xen-kexec-3.0

The kexec or kdump kernel has to take care of already allocated virqs,
PV devices in Closed or Connected state, and of registered watches in
the old kernel. With the three patches these conditions are checked
during boot of the new kernel rather than in the reboot/crash path.

A fixed kexec-tools-2.0.2 package is required:
http://lists.infradead.org/pipermail/kexec/2011-May/005026.html
http://lists.infradead.org/pipermail/kexec/2011-August/005339.html

Another fix is for xenstored, it has to accept the XS_INTRODUCE from a guest:
http://lists.xensource.com/archives/html/xen-devel/2011-08/msg00007.html

One open issue is the balloon driver. It removes pages from the guest
and gives them back to the hypervisor. The kexec kernel is not aware of
the fact that some pages are unavailable, and hangs or crashes.
The workaround for the time being is:

if test -f /sys/devices/system/xen_memory/xen_memory0/target -a \
        -f /sys/devices/system/xen_memory/xen_memory0/target_kb
then
    cat /sys/devices/system/xen_memory/xen_memory0/target > \
        /sys/devices/system/xen_memory/xen_memory0/target_kb
fi
kexec -e

This has to be resolved with another series of changes.

Olaf


