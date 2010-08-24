Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754780Ab0HXKJG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 06:09:06 -0400
Received: from novprvlin0050.provo.novell.com ([137.65.248.33]:29531 "EHLO
	novprvlin0050.provo.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751634Ab0HXKJC (ORCPT
	<rfc822;groupwise-jlee@novell.com:3:2>);
	Tue, 24 Aug 2010 06:09:02 -0400
Message-Id: <4C7426DB020000230001F3A8@novprvlin0050.provo.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.2 
Date: Tue, 24 Aug 2010 04:08:59 -0600
From: "Joey Lee" <jlee@novell.com>
To: <mjg59@srcf.ucam.org>, <trenn@suse.de>
Cc: <gregkh@suse.de>, <linux-acpi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <Dennis.Jansen@web.de>
Subject: Re: [PATCH] Add intel drm blacklist to intel_opregion_present
 detect
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=__PartE6CBD42B.2__="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME message. If you are reading this text, you may want to 
consider changing to a mail reader or gateway that understands how to 
properly handle MIME multipart messages.

--=__PartE6CBD42B.2__=
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Content-Disposition: inline

Hi Matthew, Thomas, 

於 二，2010-08-24 於 01:03 -0600，Joey Lee 提到：
> Hi Matthew, 
> 
> 於 一，2010-08-23 於 18:51 +0100，Matthew Garrett 提到：
> > On Mon, Aug 23, 2010 at 07:53:21PM +0200, Thomas Renninger wrote:
> > 
> > > Hm, needing a module option to get a system running is not what the user expects.
> > > By default, the system should run fine and a module option should be added
> > > as a workaround or for debugging only.
> > 
> > How about we do this instead: add a psb stub driver that does nothing 
> > other than call acpi_backlight_register()?
> > 
> 
> The attached file is a draft stub driver for poulsbo. Like you said, it
> will only call acpi_video_register and acpi_video_unregister when
> initial and exit.
> And I added the Poulsbo pci id in the module alias.
> 
> It's works to me, where can we put the driver? in driver/staging ? or
> put in driver/gpu/stub ?
> 

The attached file is the patch to add a poulsbo stub module in
drivers/gpu/stub.

Please kindly review it and give me any suggestions.


Thank's a lot!
Joey Lee


--=__PartE6CBD42B.2__=
Content-Type: text/plain; name="0001-Add-Intel-Poulsbo-Stub-Driver.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment; filename="0001-Add-Intel-Poulsbo-Stub-Driver.patch"

>From 18d66ed453e4052874280ff0c17b68f5ce3cbc3a Mon Sep 17 00:00:00 =
2001=0AFrom: Lee, Chun-Yi <jlee@novell.com>=0ADate: Tue, 24 Aug 2010 =
17:55:23 +0800=0ASubject: [PATCH] Add Intel Poulsbo Stub Driver=0A=0ACurren=
tly, there have no Poulsbo native video driver to support=0Aintel =
opregion. So, use this stub driver to call acpi_video_register=0Ato enable =
the acpi backlight control sysfs entry files.=0A=0ASigned-off-by: Lee, =
Chun-Yi <jlee@novell.com>=0A---=0A drivers/gpu/Makefile       |    2 +-=0A =
drivers/gpu/stub/Kconfig   |   13 +++++++++++++=0A drivers/gpu/stub/Makefil=
e  |    1 +=0A drivers/gpu/stub/poulsbo.c |   44 ++++++++++++++++++++++++++=
++++++++++++++++++=0A drivers/video/Kconfig      |    2 ++=0A 5 files =
changed, 61 insertions(+), 1 deletions(-)=0A create mode 100644 drivers/gpu=
/stub/Kconfig=0A create mode 100644 drivers/gpu/stub/Makefile=0A create =
mode 100644 drivers/gpu/stub/poulsbo.c=0A=0Adiff --git a/drivers/gpu/Makefi=
le b/drivers/gpu/Makefile=0Aindex 30879df..cc92778 100644=0A--- a/drivers/g=
pu/Makefile=0A+++ b/drivers/gpu/Makefile=0A@@ -1 +1 @@=0A-obj-y			=
+=3D drm/ vga/=0A+obj-y			+=3D drm/ vga/ stub/=0Adiff --git =
a/drivers/gpu/stub/Kconfig b/drivers/gpu/stub/Kconfig=0Anew file mode =
100644=0Aindex 0000000..88fd919=0A--- /dev/null=0A+++ b/drivers/gpu/stub/Kc=
onfig=0A@@ -0,0 +1,13 @@=0A+config STUB_POULSBO=0A+	tristate "Intel =
Poulsbo Stub Driver"=0A+        default m=0A+        # Poulsbo stub =
depends on ACPI_VIDEO when ACPI is enabled=0A+        # but for select to =
work, need to select ACPI_VIDEO's dependencies, ick=0A+        select =
ACPI_VIDEO if ACPI=0A+	help=0A+	  Choose this option if you have a =
system that has Intel Poulsbo=0A+	  integrated graphics. If M is =
selected, the module will be called=0A+	  Poulsbo. This driver is a stub =
driver for Poulsbo that will call=0A+	  acpi_video_register to enable =
the acpi backlight control sysfs=0A+	  entry file because there have no =
poulsbo native driver can support=0A+	  intel opregion.=0Adiff --git =
a/drivers/gpu/stub/Makefile b/drivers/gpu/stub/Makefile=0Anew file mode =
100644=0Aindex 0000000..cd940cc=0A--- /dev/null=0A+++ b/drivers/gpu/stub/Ma=
kefile=0A@@ -0,0 +1 @@=0A+obj-$(CONFIG_STUB_POULSBO) +=3D poulsbo.o=0Adiff =
--git a/drivers/gpu/stub/poulsbo.c b/drivers/gpu/stub/poulsbo.c=0Anew file =
mode 100644=0Aindex 0000000..c93cd67=0A--- /dev/null=0A+++ b/drivers/gpu/st=
ub/poulsbo.c=0A@@ -0,0 +1,44 @@=0A+/*=0A+ * Intel Poulsbo Stub=0A+ *=0A+ * =
Copyright (C) 2010 Novell <jlee@novell.com>=0A+ *=0A+ *  This program is =
free software; you can redistribute it and/or modify=0A+ *  it under the =
terms of the GNU General Public License as published by=0A+ *  the Free =
Software Foundation; either version 2 of the License, or=0A+ *  (at your =
option) any later version.=0A+ *=0A+ *  This program is distributed in the =
hope that it will be useful,=0A+ *  but WITHOUT ANY WARRANTY; without even =
the implied warranty of=0A+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR =
PURPOSE.  See the=0A+ *  GNU General Public License for more details.=0A+ =
*=0A+ *  You should have received a copy of the GNU General Public =
License=0A+ *  along with this program; if not, write to the Free =
Software=0A+ *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  =
02111-1307  USA=0A+ */=0A+=0A+#include <linux/module.h>=0A+#include =
<acpi/video.h>=0A+=0A+static int __init poulsbo_init(void)=0A+{=0A+	=
printk(KERN_INFO "poulsbo: stub driver load.\n");=0A+	return acpi_video_r=
egister();=0A+}=0A+=0A+static void __exit poulsbo_cleanup(void)=0A+{=0A+	=
acpi_video_unregister();=0A+	printk(KERN_INFO "poulsbo: stub driver =
unloaded.\n");=0A+}=0A+=0A+module_init(poulsbo_init);=0A+module_exit(poulsb=
o_cleanup);=0A+=0A+MODULE_AUTHOR("Lee, Chun-Yi <jlee@novell.com>");=0A+MODU=
LE_DESCRIPTION("Poulsbo Stub Driver");=0A+MODULE_LICENSE("GPL");=0A+=0A+MOD=
ULE_ALIAS("pci:v00008086d00008108sv*sd*bc*sc*i*");=0A+MODULE_ALIAS("pci:v00=
008086d00008109sv*sd*bc*sc*i*");=0Adiff --git a/drivers/video/Kconfig =
b/drivers/video/Kconfig=0Aindex 8b31fdf..8807ae5 100644=0A--- a/drivers/vid=
eo/Kconfig=0A+++ b/drivers/video/Kconfig=0A@@ -17,6 +17,8 @@ source =
"drivers/gpu/vga/Kconfig"=0A =0A source "drivers/gpu/drm/Kconfig"=0A =
=0A+source "drivers/gpu/stub/Kconfig"=0A+=0A config VGASTATE=0A        =
tristate=0A        default n=0A-- =0A1.6.0.2=0A=0A
--=__PartE6CBD42B.2__=--
