Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754892Ab0CWP4G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 11:56:06 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:57352 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752545Ab0CWP4E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 11:56:04 -0400
Message-ID: <4BA8E484.3000509@ti.com>
Date: Tue, 23 Mar 2010 10:55:48 -0500
From: Pavan Savoy <pavan_savoy@ti.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.8) Gecko/20100227 Thunderbird/3.0.3
MIME-Version: 1.0
To: randy.dunlap@oracle.com, pavan_savoy@ti.com, gregkh@suse.de,
       linux-kernel@vger.kernel.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCH 2/6] drivers:misc: Kconfig, Makefile for TI's ST ldisc
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Mar 2010 10:10:35 -0500 Pavan Savoy wrote:

 > On Mon, 22 Mar 2010 18:45:42 -0500 Pavan Savoy wrote:
 >
 >
 > [pavan]>>>>>>>
 > How about this ?
 >
 >  From 7304d21df4c11244651754976f662d301bef5361 Mon Sep 17 00:00:00 2001
 > From: Pavan Savoy <pavan_savoy@ti.com>
 > Date: Mon, 22 Mar 2010 16:40:19 -0400
 > Subject: [PATCH 2/7] drivers:misc: Kconfig, Makefile for TI's ST ldisc
 >
 > This change adds the Kconfig and Make file for TI's
 > ST line discipline driver and the BlueZ driver for BT
 > core of the TI BT/FM/GPS combo chip.
 >
 > Signed-off-by: Pavan Savoy <pavan_savoy@ti.com>
 > ---
 >   drivers/misc/Kconfig        |    1 +
 >   drivers/misc/Makefile       |    1 +
 >   drivers/misc/ti-st/Kconfig  |   24 ++++++++++++++++++++++++
 >   drivers/misc/ti-st/Makefile |    7 +++++++
 >   4 files changed, 33 insertions(+), 0 deletions(-)
 >   create mode 100644 drivers/misc/ti-st/Kconfig
 >   create mode 100644 drivers/misc/ti-st/Makefile
 >
 > diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
 > index 625e3a6..c059bca 100644
 > --- a/drivers/misc/Kconfig
 > +++ b/drivers/misc/Kconfig
 > @@ -344,5 +344,6 @@ source "drivers/misc/c2port/Kconfig"
 >   source "drivers/misc/eeprom/Kconfig"
 >   source "drivers/misc/cb710/Kconfig"
 >   source "drivers/misc/iwmc3200top/Kconfig"
 > +source "drivers/misc/ti-st/Kconfig"

 >Too many spaces "  " before "source" in the 3 preceding lines,
 >so it does not apply cleanly.  Same for the Makefile below.

 > patch -p1 --dry-run < ~/misc-tist-kconfig.patch
patching file drivers/misc/Kconfig
Hunk #1 FAILED at 344.
1 out of 1 hunk FAILED -- saving rejects to file drivers/misc/Kconfig.rej
patching file drivers/misc/Makefile
Hunk #1 FAILED at 30.
1 out of 1 hunk FAILED -- saving rejects to file drivers/misc/Makefile.rej
patching file drivers/misc/ti-st/Kconfig
patching file drivers/misc/ti-st/Makefile

[pavan]
Try git apply. I gave it a try with patch/diff, doesn't seem to work.

 >
 >   endif # MISC_DEVICES
 > diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
 > index c221917..021f282 100644
 > --- a/drivers/misc/Makefile
 > +++ b/drivers/misc/Makefile
 > @@ -30,3 +30,4 @@ obj-$(CONFIG_IWMC3200TOP)      += iwmc3200top/
 >   obj-$(CONFIG_HWLAT_DETECTOR)        += hwlat_detector.o
 >   obj-y                               += eeprom/
 >   obj-y                               += cb710/
 > +obj-y                                += ti-st/
 > diff --git a/drivers/misc/ti-st/Kconfig b/drivers/misc/ti-st/Kconfig
 > new file mode 100644
 > index 0000000..55fc054
 > --- /dev/null
 > +++ b/drivers/misc/ti-st/Kconfig
 > @@ -0,0 +1,24 @@
 > +#
 > +# TI's shared transport line discipline and the protocol
 > +# drivers (BT, FM and GPS)
 > +#
 > +menu "Texas Instruments shared transport line discipline"
 > +config TI_ST
 > +     tristate "shared transport core driver"
 > +     select FW_LOADER
 > +     help
 > +       This enables the shared transport core driver for TI
 > +       BT / FM and GPS combo chips.This enables protocol drivers

 >Sigh.  Put a space after "chips."

[pavan]
done, pasted below.

 > +       to register themselves with core and send data, the responses
 > +       are returned to relevant protocol drivers based on their
 > +       packet types.
 > +
 > +config ST_BT
 > +     tristate "BlueZ bluetooth driver for ST"
 > +     depends on BT
 > +     select TI_ST
 > +     help
 > +       This enables the Bluetooth driver for TI BT/FM/GPS combo devices.
 > +       This makes use of shared transport line discipline core driver to
 > +       communicate with the BT core of the combo chip.
 > +endmenu

 >Aside from the typo above, this drivers/misc/ti-st/Kconfig file looks 
 >OK now.

[pavan]
Really want some piece of it to make it.

 > diff --git a/drivers/misc/ti-st/Makefile b/drivers/misc/ti-st/Makefile
 > new file mode 100644
 > index 0000000..0167d1d
 > --- /dev/null
 > +++ b/drivers/misc/ti-st/Makefile
 > @@ -0,0 +1,7 @@
 > +#
 > +# Makefile for TI's shared transport line discipline
 > +# and its protocol drivers (BT, FM, GPS)
 > +#
 > +obj-$(CONFIG_TI_ST)           += st_drv.o
 > +st_drv-objs                  := st_core.o st_kim.o st_ll.o
 > +obj-$(CONFIG_ST_BT)           += bt_drv.o
 > --
---
~Randy

[pavan]
Hopefully this should be fine,


 From c8dbc8047e5139e7912dc8c519fa62866c98b64b Mon Sep 17 00:00:00 2001
From: Pavan Savoy <pavan_savoy@ti.com>
Date: Mon, 22 Mar 2010 16:40:19 -0400
Subject: [PATCH 2/7] drivers:misc: Kconfig, Makefile for TI's ST ldisc

This change adds the Kconfig and Make file for TI's
ST line discipline driver and the BlueZ driver for BT
core of the TI BT/FM/GPS combo chip.

Signed-off-by: Pavan Savoy <pavan_savoy@ti.com>
---
  drivers/misc/Kconfig        |    1 +
  drivers/misc/Makefile       |    1 +
  drivers/misc/ti-st/Kconfig  |   24 ++++++++++++++++++++++++
  drivers/misc/ti-st/Makefile |    7 +++++++
  4 files changed, 33 insertions(+), 0 deletions(-)
  create mode 100644 drivers/misc/ti-st/Kconfig
  create mode 100644 drivers/misc/ti-st/Makefile

diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index 625e3a6..c059bca 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -344,5 +344,6 @@ source "drivers/misc/c2port/Kconfig"
  source "drivers/misc/eeprom/Kconfig"
  source "drivers/misc/cb710/Kconfig"
  source "drivers/misc/iwmc3200top/Kconfig"
+source "drivers/misc/ti-st/Kconfig"

  endif # MISC_DEVICES
diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
index c221917..021f282 100644
--- a/drivers/misc/Makefile
+++ b/drivers/misc/Makefile
@@ -30,3 +30,4 @@ obj-$(CONFIG_IWMC3200TOP)      += iwmc3200top/
  obj-$(CONFIG_HWLAT_DETECTOR)	+= hwlat_detector.o
  obj-y				+= eeprom/
  obj-y				+= cb710/
+obj-y				+= ti-st/
diff --git a/drivers/misc/ti-st/Kconfig b/drivers/misc/ti-st/Kconfig
new file mode 100644
index 0000000..120e8db
--- /dev/null
+++ b/drivers/misc/ti-st/Kconfig
@@ -0,0 +1,24 @@
+#
+# TI's shared transport line discipline and the protocol
+# drivers (BT, FM and GPS)
+#
+menu "Texas Instruments shared transport line discipline"
+config TI_ST
+	tristate "shared transport core driver"
+	select FW_LOADER
+	help
+	  This enables the shared transport core driver for TI
+	  BT / FM and GPS combo chips. This enables protocol drivers
+	  to register themselves with core and send data, the responses
+	  are returned to relevant protocol drivers based on their
+	  packet types.
+
+config ST_BT
+	tristate "BlueZ bluetooth driver for ST"
+	depends on BT
+	select TI_ST
+	help
+	  This enables the Bluetooth driver for TI BT/FM/GPS combo devices.
+	  This makes use of shared transport line discipline core driver to
+	  communicate with the BT core of the combo chip.
+endmenu
diff --git a/drivers/misc/ti-st/Makefile b/drivers/misc/ti-st/Makefile
new file mode 100644
index 0000000..0167d1d
--- /dev/null
+++ b/drivers/misc/ti-st/Makefile
@@ -0,0 +1,7 @@
+#
+# Makefile for TI's shared transport line discipline
+# and its protocol drivers (BT, FM, GPS)
+#
+obj-$(CONFIG_TI_ST) 		+= st_drv.o
+st_drv-objs			:= st_core.o st_kim.o st_ll.o
+obj-$(CONFIG_ST_BT) 		+= bt_drv.o
-- 
1.5.4.3










