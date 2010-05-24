Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758224Ab0EXSbe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 14:31:34 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:6992 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757653Ab0EXSbc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 14:31:32 -0400
X-IronPort-AV: E=Sophos;i="4.53,292,1272844800"; 
   d="scan'208";a="61740"
Date: Mon, 24 May 2010 19:25:27 +0100
From: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
       "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
       Don Dutile <ddutile@redhat.com>, Sheng Yang <sheng@linux.intel.com>,
       Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
Subject: [PATCH 0 of 12] PV on HVM Xen
Message-ID: <alpine.DEB.2.00.1005241615300.25605@kaball-desktop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,
this is another update of the PV on HVM Xen series that addresses
Jeremy's comments.
The platform_pci hooks have been removed, suspend/resume for HVM
domains is now much more similar to the PV case and shares the same
do_suspend function.
Alloc_xen_mmio_hook has been removed has well, now the memory allocation for
the grant table is done by the xen platform pci driver directly.
The per_cpu xen_vcpu variable is set by a cpu_notifier function so that
secondary vcpus have the variable set correctly no matter what the xen
features are on the host.
The kernel command line option xen_unplug has been renamed to
xen_emul_unplug and the code that makes use of it has been moved to a
separate file (arch/x86/xen/platform-pci-unplug.c).
Xen_unplug_emulated_devices is now able to detect if blkfront, netfront
and the Xen platform PCI driver have been compiled, and set the default
value of xen_emul_unplug accordingly.
The patch "Initialize xenbus device structs with ENODEV as
default" has been removed from the series and it will be sent
separately.
Finally the comments on most of the patches have been improved.

The series is based on 2.6.34 and supports Xen PV frontends running
in a HVM domain, including netfront, blkfront and the VIRQ_TIMER.

In order to be able to use VIRQ_TIMER and to improve performances you
need a patch to Xen to implement the vector callback mechanism
for event channel delivery.

A git tree is also available here:

git://xenbits.xen.org/people/sstabellini/linux-pvhvm.git

branch name 2.6.34-pvhvm-v2.

Cheers,

Stefano
