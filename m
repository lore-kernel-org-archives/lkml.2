Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756695Ab0LMD0O (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 22:26:14 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:47991 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756649Ab0LMD0N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 22:26:13 -0500
Date: Mon, 13 Dec 2010 14:26:09 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Gerd Hoffmann <kraxel@redhat.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Xen Devel <Xen-devel@lists.xensource.com>,
        Ian Campbell <ian.campbell@citrix.com>
Subject: linux-next: manual merge of the swiotlb-xen tree with the xen tree
Message-Id: <20101213142609.3ad004cf.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Konrad,

Today's linux-next merge of the swiotlb-xen tree got a conflict in
drivers/xen/Kconfig drivers/xen/Makefile between commit
56385560d6d8fd4c89c4f328d3ff0ecc9c44c52d ("xen/gntdev: allow usermode to
map granted pages") from the xen tree and commits
06acb015d341946c83ab127f5ab9ba291678d226 ("xen: separate out frontend
xenbus") and 721657d92623cfcf2f6f68c14abf97eb40fa6b20 ("xen-pciback:
Enable Xen-PCI-back to be compiled") from the swiotlb-xen tree.

I fixed then up (see below) and can carry the fixes as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/xen/Kconfig
index 0c6d2a1,9b61561..0000000
--- a/drivers/xen/Kconfig
+++ b/drivers/xen/Kconfig
@@@ -62,13 -134,9 +134,16 @@@ config XEN_SYS_HYPERVISO
  	 virtual environment, /sys/hypervisor will still be present,
  	 but will have no xen contents.
  
 +config XEN_GNTDEV
 +	tristate "userspace grant access device driver"
 +	depends on XEN
 +	select MMU_NOTIFIER
 +	help
 +	  Allows userspace processes use grants.
 +	  
+ config XEN_XENBUS_FRONTEND
+        tristate
+ 
  config XEN_PLATFORM_PCI
  	tristate "xen platform pci device driver"
  	depends on XEN_PVHVM
diff --cc drivers/xen/Makefile
index 674fdb5,b813d46..0000000
--- a/drivers/xen/Makefile
+++ b/drivers/xen/Makefile
@@@ -9,7 -9,7 +9,8 @@@ obj-$(CONFIG_HOTPLUG_CPU)	+= cpu_hotplu
  obj-$(CONFIG_XEN_XENCOMM)	+= xencomm.o
  obj-$(CONFIG_XEN_BALLOON)	+= balloon.o
  obj-$(CONFIG_XEN_DEV_EVTCHN)	+= xen-evtchn.o
 +obj-$(CONFIG_XEN_GNTDEV)	+= xen-gntdev.o
+ obj-$(CONFIG_XEN_PCIDEV_BACKEND)	+= pciback/
  obj-$(CONFIG_XENFS)		+= xenfs/
  obj-$(CONFIG_XEN_SYS_HYPERVISOR)	+= sys-hypervisor.o
  obj-$(CONFIG_XEN_PLATFORM_PCI)	+= platform-pci.o
