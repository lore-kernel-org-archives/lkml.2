Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752228Ab0IJKD6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 06:03:58 -0400
Received: from novprvlin0050.provo.novell.com ([137.65.248.33]:13657 "EHLO
	novprvlin0050.provo.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751693Ab0IJKDs (ORCPT
	<rfc822;groupwise-jlee@novell.com:5:2>);
	Fri, 10 Sep 2010 06:03:48 -0400
Message-Id: <4C8A8F21020000230002027D@novprvlin0050.provo.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.2 
Date: Fri, 10 Sep 2010 04:03:45 -0600
From: "Joey Lee" <jlee@novell.com>
To: <mjg59@srcf.ucam.org>
Cc: <randy.dunlap@oracle.com>, <mjg@redhat.com>, <gregkh@suse.de>,
        <trenn@suse.de>, <linux-acpi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <Dennis.Jansen@web.de>
Subject: Re: [PATCH] Add Intel Poulsbo Stub Driver
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=__Part3D10F691.4__="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME message. If you are reading this text, you may want to 
consider changing to a mail reader or gateway that understands how to 
properly handle MIME multipart messages.

--=__Part3D10F691.4__=
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Content-Disposition: inline

Hi Matthew, 

於 四，2010-09-09 於 22:36 -0600，Joey Lee 提到：
> Hi Randy, 
> 
> First, thank's for your review!
> And, sorry I am late to reply the mail.
> 
> 於 三，2010-09-01 於 10:11 -0700，Randy Dunlap 提到：
> > On Wed,  1 Sep 2010 17:08:39 +0800 Lee, Chun-Yi wrote:
> > 
> > > Currently, there have no Poulsbo native video driver to support
> > > intel opregion. So, use this stub driver to enable the acpi backlight
> > > control sysfs entry files by requrest acpi_video_register.
> > > 
> > > Signed-off-by: Lee, Chun-Yi <jlee@novell.com>
> > > ---
> > >  drivers/gpu/Makefile       |    2 +-
> > >  drivers/gpu/stub/Kconfig   |   13 +++++++++
> > >  drivers/gpu/stub/Makefile  |    1 +
> > >  drivers/gpu/stub/poulsbo.c |   64 ++++++++++++++++++++++++++++++++++++++++++++
> > >  drivers/video/Kconfig      |    2 +
> > >  5 files changed, 81 insertions(+), 1 deletions(-)
> > >  create mode 100644 drivers/gpu/stub/Kconfig
> > >  create mode 100644 drivers/gpu/stub/Makefile
> > >  create mode 100644 drivers/gpu/stub/poulsbo.c
> > > 
> > > diff --git a/drivers/gpu/Makefile b/drivers/gpu/Makefile
> > > index 30879df..cc92778 100644
> > > --- a/drivers/gpu/Makefile
> > > +++ b/drivers/gpu/Makefile
> > > @@ -1 +1 @@
> > > -obj-y			+= drm/ vga/
> > > +obj-y			+= drm/ vga/ stub/
> > > diff --git a/drivers/gpu/stub/Kconfig b/drivers/gpu/stub/Kconfig
> > > new file mode 100644
> > > index 0000000..c564140
> > > --- /dev/null
> > > +++ b/drivers/gpu/stub/Kconfig
> > > @@ -0,0 +1,13 @@
> > > +config STUB_POULSBO
> > > +	tristate "Intel Poulsbo Stub Driver"
> > > +        default m
> > 
> > Drop the "default m".
> > 
> 
> Thank's! Will drop "default m".
> 
> > > +        # Poulsbo stub depends on ACPI_VIDEO when ACPI is enabled
> > > +        # but for select to work, need to select ACPI_VIDEO's dependencies, ick
> > > +        select ACPI_VIDEO if ACPI
> > 
> > What does it do when ACPI is not enabled?  Does the driver even build
> > when APCI is not enabled?  (given the acpi_video* calls in it)
> > 
> 
> This driver will not do anything if API is not enabled. It only call
> acpi_video_register/acpi_video_unregister, and acpi/video.h handle it
> like the following:
> 
> #if (defined CONFIG_ACPI_VIDEO || defined CONFIG_ACPI_VIDEO_MODULE)
> extern int acpi_video_register(void);
> extern void acpi_video_unregister(void);
> extern int acpi_video_get_edid(struct acpi_device *device, int type,
>                                int device_id, void **edid);
> #else
> static inline int acpi_video_register(void) { return 0; }
> static inline void acpi_video_unregister(void) { return; }
> static inline int acpi_video_get_edid(struct acpi_device *device, int
> type,
>                                       int device_id, void **edid)
> {
>         return -ENODEV;
> }
> #endif
> 
> So, I think don't need add "depends on ACPI_VIDEO". How do you think?
> 
> > It also has pci_* calls in it, so it looks like it needs to depend
> > on PCI && ACPI, or at least on PCI.
> > 
> > 
> Yes, thank's for your review, I will add:
> 	depends on PCI
> 

Thank's for Greg and Randy's review, and I follow their suggestions to
modified patch like the attacted file.

Please kindly help to review my attached patch.


Thank's a lot!
Joey Lee


--=__Part3D10F691.4__=
Content-Type: text/plain; name="0001-Add-Intel-Poulsbo-Stub-Driver.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment; filename="0001-Add-Intel-Poulsbo-Stub-Driver.patch"

>From ec59c5ccb9216c688641d51dcfdccc8a129dded5 Mon Sep 17 00:00:00 =
2001=0AFrom: Lee, Chun-Yi <jlee@novell.com>=0ADate: Fri, 10 Sep 2010 =
17:42:01 +0800=0ASubject: [PATCH] Add Intel Poulsbo Stub Driver=0A=0ACurren=
tly, there have no Poulsbo native video driver to support=0Aintel =
opregion. So, use this stub driver to enable the acpi backlight=0Acontrol =
sysfs entry files by requrest acpi_video_register.=0A=0ASigned-off-by: =
Lee, Chun-Yi <jlee@novell.com>=0A---=0A drivers/gpu/Makefile       |    2 =
+-=0A drivers/gpu/stub/Kconfig   |   13 +++++++++=0A drivers/gpu/stub/Makef=
ile  |    1 +=0A drivers/gpu/stub/poulsbo.c |   63 ++++++++++++++++++++++++=
++++++++++++++++++++=0A drivers/video/Kconfig      |    2 +=0A 5 files =
changed, 80 insertions(+), 1 deletions(-)=0A create mode 100644 drivers/gpu=
/stub/Kconfig=0A create mode 100644 drivers/gpu/stub/Makefile=0A create =
mode 100644 drivers/gpu/stub/poulsbo.c=0A=0Adiff --git a/drivers/gpu/Makefi=
le b/drivers/gpu/Makefile=0Aindex 30879df..cc92778 100644=0A--- a/drivers/g=
pu/Makefile=0A+++ b/drivers/gpu/Makefile=0A@@ -1 +1 @@=0A-obj-y			=
+=3D drm/ vga/=0A+obj-y			+=3D drm/ vga/ stub/=0Adiff --git =
a/drivers/gpu/stub/Kconfig b/drivers/gpu/stub/Kconfig=0Anew file mode =
100644=0Aindex 0000000..9795890=0A--- /dev/null=0A+++ b/drivers/gpu/stub/Kc=
onfig=0A@@ -0,0 +1,13 @@=0A+config STUB_POULSBO=0A+	tristate "Intel =
Poulsbo Stub Driver"=0A+	depends on PCI=0A+        # Poulsbo stub =
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
100644=0Aindex 0000000..d8aa636=0A--- /dev/null=0A+++ b/drivers/gpu/stub/po=
ulsbo.c=0A@@ -0,0 +1,63 @@=0A+/*=0A+ * Intel Poulsbo Stub driver=0A+ *=0A+ =
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
ION("Poulsbo Stub Driver");=0A+MODULE_LICENSE("GPL");=0A+=0A+MODULE_DEVICE_=
TABLE(pci, pciidlist);=0Adiff --git a/drivers/video/Kconfig b/drivers/video=
/Kconfig=0Aindex 8b31fdf..8807ae5 100644=0A--- a/drivers/video/Kconfig=0A++=
+ b/drivers/video/Kconfig=0A@@ -17,6 +17,8 @@ source "drivers/gpu/vga/Kconf=
ig"=0A =0A source "drivers/gpu/drm/Kconfig"=0A =0A+source "drivers/gpu/stub=
/Kconfig"=0A+=0A config VGASTATE=0A        tristate=0A        default =
n=0A-- =0A1.6.0.2=0A=0A
--=__Part3D10F691.4__=--
