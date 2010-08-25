Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753143Ab0HYJwu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 05:52:50 -0400
Received: from novprvlin0050.provo.novell.com ([137.65.248.33]:27714 "EHLO
	novprvlin0050.provo.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752853Ab0HYJwr (ORCPT
	<rfc822;groupwise-jlee@novell.com:3:2>);
	Wed, 25 Aug 2010 05:52:47 -0400
Message-Id: <4C75748B020000230001F4F0@novprvlin0050.provo.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.2 
Date: Wed, 25 Aug 2010 03:52:43 -0600
From: "Joey Lee" <jlee@novell.com>
To: <mjg59@srcf.ucam.org>, <gregkh@suse.de>
Cc: <trenn@suse.de>, <linux-acpi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <Dennis.Jansen@web.de>
Subject: Re: [PATCH] Add intel drm blacklist to intel_opregion_present
 detect
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=__Part4C6179FB.2__="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME message. If you are reading this text, you may want to 
consider changing to a mail reader or gateway that understands how to 
properly handle MIME multipart messages.

--=__Part4C6179FB.2__=
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi Matthew, Greg,=20

The attached file is new patch to add Intel Poulsbo Stub driver.
Follow your suggestion, I changed:=20
 - Add pci id list and direct register it as a pci driver.
 - Removed printk in init/exit functions.
 - Change the wording in Kconfig.
 - Modified the Copyright. Removed "or any later version" and 2=20
   redundant paragraphs.

Please kindly help to review the patch again. Appreciate for any
suggestions.


Thank's a lot!
Joey Lee


--=__Part4C6179FB.2__=
Content-Type: text/plain; name="0001-Add-Intel-Poulsbo-Stub-Driver.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment; filename="0001-Add-Intel-Poulsbo-Stub-Driver.patch"

>From cd5bc5c3d4f7c614a706152d248466bc72b03f99 Mon Sep 17 00:00:00 =
2001=0AFrom: Lee, Chun-Yi <jlee@novell.com>=0ADate: Wed, 25 Aug 2010 =
16:28:04 +0800=0ASubject: [PATCH] Add Intel Poulsbo Stub Driver=0A=0ACurren=
tly, there have no Poulsbo native video driver to support=0Aintel =
opregion. So, use this stub driver to enable the acpi backlight=0Acontrol =
sysfs entry files by requrest acpi_video_register.=0A=0ASigned-off-by: =
Lee, Chun-Yi <jlee@novell.com>=0A---=0A drivers/gpu/Makefile       |    2 =
+-=0A drivers/gpu/stub/Kconfig   |   13 +++++++++=0A drivers/gpu/stub/Makef=
ile  |    1 +=0A drivers/gpu/stub/poulsbo.c |   64 ++++++++++++++++++++++++=
++++++++++++++++++++=0A drivers/video/Kconfig      |    2 +=0A 5 files =
changed, 81 insertions(+), 1 deletions(-)=0A create mode 100644 drivers/gpu=
/stub/Kconfig=0A create mode 100644 drivers/gpu/stub/Makefile=0A create =
mode 100644 drivers/gpu/stub/poulsbo.c=0A=0Adiff --git a/drivers/gpu/Makefi=
le b/drivers/gpu/Makefile=0Aindex 30879df..cc92778 100644=0A--- a/drivers/g=
pu/Makefile=0A+++ b/drivers/gpu/Makefile=0A@@ -1 +1 @@=0A-obj-y			=
+=3D drm/ vga/=0A+obj-y			+=3D drm/ vga/ stub/=0Adiff --git =
a/drivers/gpu/stub/Kconfig b/drivers/gpu/stub/Kconfig=0Anew file mode =
100644=0Aindex 0000000..c564140=0A--- /dev/null=0A+++ b/drivers/gpu/stub/Kc=
onfig=0A@@ -0,0 +1,13 @@=0A+config STUB_POULSBO=0A+	tristate "Intel =
Poulsbo Stub Driver"=0A+        default m=0A+        # Poulsbo stub =
depends on ACPI_VIDEO when ACPI is enabled=0A+        # but for select to =
work, need to select ACPI_VIDEO's dependencies, ick=0A+        select =
ACPI_VIDEO if ACPI=0A+	help=0A+	  Choose this option if you have a =
system that has Intel Poulsbo=0A+	  integrated graphics. If M is =
selected, the module will be called=0A+	  Poulsbo. This driver is a stub =
driver for Poulsbo that will call=0A+	  poulsbo.ko to enable the acpi =
backlight control sysfs entry file=0A+	  because there have no poulsbo =
native driver can support intel=0A+	  opregion.=0Adiff --git a/drivers/=
gpu/stub/Makefile b/drivers/gpu/stub/Makefile=0Anew file mode 100644=0Ainde=
x 0000000..cd940cc=0A--- /dev/null=0A+++ b/drivers/gpu/stub/Makefile=0A@@ =
-0,0 +1 @@=0A+obj-$(CONFIG_STUB_POULSBO) +=3D poulsbo.o=0Adiff --git =
a/drivers/gpu/stub/poulsbo.c b/drivers/gpu/stub/poulsbo.c=0Anew file mode =
100644=0Aindex 0000000..e18dc24=0A--- /dev/null=0A+++ b/drivers/gpu/stub/po=
ulsbo.c=0A@@ -0,0 +1,64 @@=0A+/*=0A+ * Intel Poulsbo Stub driver=0A+ *=0A+ =
* Copyright (C) 2010 Novell <jlee@novell.com>=0A+ *=0A+ * This program is =
free software; you can redistribute it and/or modify it=0A+ * under the =
terms of the GNU General Public License version 2 as published by=0A+ * =
the Free Software Foundation.=0A+ *=0A+ */=0A+=0A+#include <linux/module.h>=
=0A+#include <linux/pci.h>=0A+#include <acpi/video.h>=0A+=0A+#define =
DRIVER_NAME "poulsbo"=0A+=0A+enum {=0A+	CHIP_PSB_8108 =3D 0,=0A+	=
CHIP_PSB_8109 =3D 1,=0A+};=0A+=0A+static struct pci_device_id pciidlist[] =
=3D {=0A+	{0x8086, 0x8108, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_PSB_810=
8}, \=0A+	{0x8086, 0x8109, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_PSB_810=
9}, \=0A+	{0, 0, 0}=0A+};=0A+=0A+static int poulsbo_probe(struct =
pci_dev *pdev, const struct pci_device_id *id)=0A+{=0A+	return acpi_video_r=
egister();=0A+}=0A+=0A+static void poulsbo_remove(struct pci_dev *pdev)=0A+=
{=0A+	acpi_video_unregister();=0A+}=0A+=0A+static struct pci_driver =
poulsbo_driver =3D {=0A+	.name =3D DRIVER_NAME,=0A+	.id_table =
=3D pciidlist,=0A+	.probe =3D poulsbo_probe,=0A+	.remove =3D =
poulsbo_remove,=0A+};=0A+=0A+static int __init poulsbo_init(void)=0A+{=0A+	=
return pci_register_driver(&poulsbo_driver);=0A+}=0A+=0A+static void =
__exit poulsbo_exit(void)=0A+{=0A+	pci_unregister_driver(&poulsbo_driv=
er);=0A+}=0A+=0A+module_init(poulsbo_init);=0A+module_exit(poulsbo_exit);=
=0A+=0A+MODULE_AUTHOR("Lee, Chun-Yi <jlee@novell.com>");=0A+MODULE_DESCRIPT=
ION("Poulsbo Stub Driver");=0A+MODULE_LICENSE("GPL");=0A+=0A+MODULE_ALIAS("=
pci:v00008086d00008108sv*sd*bc*sc*i*");=0A+MODULE_ALIAS("pci:v00008086d0000=
8109sv*sd*bc*sc*i*");=0Adiff --git a/drivers/video/Kconfig b/drivers/video/=
Kconfig=0Aindex 8b31fdf..8807ae5 100644=0A--- a/drivers/video/Kconfig=0A+++=
 b/drivers/video/Kconfig=0A@@ -17,6 +17,8 @@ source "drivers/gpu/vga/Kconfi=
g"=0A =0A source "drivers/gpu/drm/Kconfig"=0A =0A+source "drivers/gpu/stub/=
Kconfig"=0A+=0A config VGASTATE=0A        tristate=0A        default =
n=0A-- =0A1.6.0.2=0A=0A
--=__Part4C6179FB.2__=--
