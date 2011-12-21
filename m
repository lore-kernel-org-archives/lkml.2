Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754318Ab1LUVnV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 16:43:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32800 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754235Ab1LUVmx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 16:42:53 -0500
From: Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH 5/5] vfio: VFIO core Kconfig and Makefile
To: chrisw@sous-sol.org, aik@ozlabs.ru, david@gibson.dropbear.id.au,
        joerg.roedel@amd.com, agraf@suse.de, benve@cisco.com,
        aafabbri@cisco.com, B08248@freescale.com, B07421@freescale.com,
        avi@redhat.com, kvm@vger.kernel.org, qemu-devel@nongnu.org,
        iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Wed, 21 Dec 2011 14:42:39 -0700
Message-ID: <20111221214239.27028.99601.stgit@bling.home>
In-Reply-To: <20111221213019.27028.26890.stgit@bling.home>
References: <20111221213019.27028.26890.stgit@bling.home>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable the base code.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---

 MAINTAINERS           |    8 ++++++++
 drivers/Kconfig       |    2 ++
 drivers/Makefile      |    1 +
 drivers/vfio/Kconfig  |    8 ++++++++
 drivers/vfio/Makefile |    3 +++
 5 files changed, 22 insertions(+), 0 deletions(-)
 create mode 100644 drivers/vfio/Kconfig
 create mode 100644 drivers/vfio/Makefile

diff --git a/MAINTAINERS b/MAINTAINERS
index 9f7b469..b1f7230 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7142,6 +7142,14 @@ S:	Maintained
 F:	Documentation/filesystems/vfat.txt
 F:	fs/fat/
 
+VFIO DRIVER
+M:	Alex Williamson <alex.williamson@redhat.com>
+L:	kvm@vger.kernel.org
+S:	Maintained
+F:	Documentation/vfio.txt
+F:	drivers/vfio/
+F:	include/linux/vfio.h
+
 VIDEOBUF2 FRAMEWORK
 M:	Pawel Osciak <pawel@osciak.com>
 M:	Marek Szyprowski <m.szyprowski@samsung.com>
diff --git a/drivers/Kconfig b/drivers/Kconfig
index d5138e6..f168bf3 100644
--- a/drivers/Kconfig
+++ b/drivers/Kconfig
@@ -114,6 +114,8 @@ source "drivers/auxdisplay/Kconfig"
 
 source "drivers/uio/Kconfig"
 
+source "drivers/vfio/Kconfig"
+
 source "drivers/vlynq/Kconfig"
 
 source "drivers/virtio/Kconfig"
diff --git a/drivers/Makefile b/drivers/Makefile
index 4ef810e..f715919 100644
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -59,6 +59,7 @@ obj-$(CONFIG_ATM)		+= atm/
 obj-$(CONFIG_FUSION)		+= message/
 obj-y				+= firewire/
 obj-$(CONFIG_UIO)		+= uio/
+obj-$(CONFIG_VFIO)		+= vfio/
 obj-y				+= cdrom/
 obj-y				+= auxdisplay/
 obj-$(CONFIG_PCCARD)		+= pcmcia/
diff --git a/drivers/vfio/Kconfig b/drivers/vfio/Kconfig
new file mode 100644
index 0000000..9acb1e7
--- /dev/null
+++ b/drivers/vfio/Kconfig
@@ -0,0 +1,8 @@
+menuconfig VFIO
+	tristate "VFIO Non-Privileged userspace driver framework"
+	depends on IOMMU_API
+	help
+	  VFIO provides a framework for secure userspace device drivers.
+	  See Documentation/vfio.txt for more details.
+
+	  If you don't know what to do here, say N.
diff --git a/drivers/vfio/Makefile b/drivers/vfio/Makefile
new file mode 100644
index 0000000..088faf1
--- /dev/null
+++ b/drivers/vfio/Makefile
@@ -0,0 +1,3 @@
+vfio-y := vfio_main.o vfio_iommu.o
+
+obj-$(CONFIG_VFIO) := vfio.o

