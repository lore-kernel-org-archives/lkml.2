Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757393Ab0KMTXf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Nov 2010 14:23:35 -0500
Received: from toccata.ens-lyon.fr ([140.77.166.68]:57582 "EHLO
	toccata.ens-lyon.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756060Ab0KMTXd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Nov 2010 14:23:33 -0500
Date: Sat, 13 Nov 2010 20:22:56 +0100
From: =?iso-8859-1?Q?Sh=E9rab?= <Sebastien.Hinderer@ens-lyon.org>
To: Valdis.Kletnieks@vt.edu
Cc: Samuel Thibault <Samuel.Thibault@ens-lyon.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Len Brown <lenb@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andres Salomon <dilinger@queued.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: EuroBraille/Iris power off
Message-ID: <20101113192256.GB5030@pema>
References: <20100826210815.GA18131@pema>
 <4C76D9A0.2010907@zytor.com>
 <20100829205929.GA3309@pema>
 <20100913100719.GA3903@pema>
 <54870.1284390647@localhost>
 <20100913152249.GC5364@const.bordeaux.inria.fr>
 <7925.1284428749@localhost>
 <20100920082241.GA4128@pema>
 <20100926175434.GA23573@pema>
 <20101010162236.GA3320@pema>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="qDbXVdCdHGoSgWSk"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20101010162236.GA3320@pema>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qDbXVdCdHGoSgWSk
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

Dear all,

I am resending this patch which got no criticisms and has stillnot been
integrated so far.

Many thanks in advance for examining it.

Cheers,

Shérab.

Shérab (2010/10/10 18:22 +0200):
> Hi,
> 
> I'm resending and would appreciate it very much if someone good have a
> lookto it.
> Thanks,
> Shérab.
> 
> Shérab (2010/09/26 19:54 +0200):
> > Hello,
> > 
> > Shérab (2010/09/20 10:22 +0200):
> > > Dear all,
> > > 
> > > Valdis.Kletnieks@vt.edu (2010/09/13 21:45 -0400):
> > > > On Mon, 13 Sep 2010 17:22:49 +0200, Samuel Thibault said:
> > > > 
> > > > > Again, I'm not sure we really should try hard to make it automatically
> > > > > detected (and thus always enabled).  Having to pass a kernel parameter
> > > > > to enable the functionality is completely fine, since installing Linux
> > > > > on this device requires quite some tinkering already.
> > > > 
> > > > I'm agreeing that if iris_init() checks that the user passed 'irisinit.force=1'
> > > > on the command line or as a module parameter, and bailed immediately if it
> > > > wasn't passed, then doing the inb() and testing it should be safe
> > > > enough. [...]
> > > 
> > > Please find below a revised version of the module that does what has
> > > been asked.
> > 
> > The previous patch had a few style problem and the moduleparam.h header
> > was not included whereas it should have been.
> > The version below passes ./script/checkpatch and the missing header has
> > been included, so the patch should be correct now.
> > Moreover the patch has been updated to apply on top of current master.
> > 
> > Shérab.
> > 
> > From 2af50581bb591cd25ac59a7cf16902ea50f766db Mon Sep 17 00:00:00 2001
> > From: =?UTF-8?q?Sh=C3=A9rab?= <Sebastien.Hinderer@ens-lyon.org>
> > Date: Sat, 25 Sep 2010 06:06:57 +0200
> > Subject: [PATCH] Eurobraille/Iris power off.
> > MIME-Version: 1.0
> > Content-Type: text/plain; charset=UTF-8
> > Content-Transfer-Encoding: 8bit
> > Content-Type: text/plain; charset="utf-8"
> > 
> > The Iris machines from Eurobraille do not have APM or ACPI support
> > to shut themselves down properly.  A special I/O sequence is
> > needed to do so.  This modle runs this I/O sequence at
> > kernel shutdown when its force parameter is set to 1.
> > Signed-off-by: Shérab <Sebastien.Hinderer@ens-lyon.org>
> > ---
> >  arch/x86/Kconfig         |   13 +++++++
> >  arch/x86/kernel/Makefile |    1 +
> >  arch/x86/kernel/iris.c   |   90 ++++++++++++++++++++++++++++++++++++++++++++++
> >  3 files changed, 104 insertions(+), 0 deletions(-)
> >  create mode 100644 arch/x86/kernel/iris.c
> > 
> > diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> > index cea0cd9..7c8e261 100644
> > --- a/arch/x86/Kconfig
> > +++ b/arch/x86/Kconfig
> > @@ -493,6 +493,19 @@ config X86_ES7000
> >  	  Support for Unisys ES7000 systems.  Say 'Y' here if this kernel is
> >  	  supposed to run on an IA32-based Unisys ES7000 system.
> >  
> > +config X86_32_IRIS
> > +	tristate "Eurobraille/Iris poweroff module"
> > +	depends on X86_32
> > +	---help---
> > +	  The Iris machines from EuroBraille do not have APM or ACPI support
> > +	  to shut themselves down properly.  A special I/O sequence is
> > +	  needed to do so, which is what this module does at
> > +	  kernel shutdown.
> > +
> > +	  This is only for Iris machines from EuroBraille.
> > +
> > +	  If unused, say N.
> > +
> >  config SCHED_OMIT_FRAME_POINTER
> >  	def_bool y
> >  	prompt "Single-depth WCHAN output"
> > diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
> > index 0925676..98dd1c8 100644
> > --- a/arch/x86/kernel/Makefile
> > +++ b/arch/x86/kernel/Makefile
> > @@ -115,6 +115,7 @@ obj-$(CONFIG_MICROCODE)			+= microcode.o
> >  obj-$(CONFIG_X86_CHECK_BIOS_CORRUPTION) += check.o
> >  
> >  obj-$(CONFIG_SWIOTLB)			+= pci-swiotlb.o
> > +obj-$(CONFIG_X86_32_IRIS)		+= iris.o
> >  
> >  ###
> >  # 64 bit specific files
> > diff --git a/arch/x86/kernel/iris.c b/arch/x86/kernel/iris.c
> > new file mode 100644
> > index 0000000..c6d8137
> > --- /dev/null
> > +++ b/arch/x86/kernel/iris.c
> > @@ -0,0 +1,90 @@
> > +/*
> > + * Eurobraille/Iris power off support.
> > + *
> > + * Eurobraille's Iris machine is a PC with no APM or ACPI support.
> > + * It is shutdown by a special I/O sequence which this module provides.
> > + *
> > + *  Copyright (C) Shérab <Sebastien.Hinderer@ens-lyon.org>
> > + *
> > + * This program is free software ; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License as published by
> > + * the Free Software Foundation ; either version 2 of the License, or
> > + * (at your option) any later version.
> > + *
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY ; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
> > + * GNU General Public License for more details.
> > + *
> > + * You should have received a copy of the GNU General Public License
> > + * along with the program ; if not, write to the Free Software
> > + * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
> > + */
> > +
> > +#include <linux/module.h>
> > +#include <linux/moduleparam.h>
> > +#include <linux/kernel.h>
> > +#include <linux/errno.h>
> > +#include <linux/init.h>
> > +#include <linux/pm.h>
> > +#include <linux/delay.h>
> > +#include <asm/io.h>
> > +
> > +#define IRIS_GIO_BASE 0x340
> > +#define IRIS_GIO_INPUT IRIS_GIO_BASE
> > +#define IRIS_GIO_OUTPUT (IRIS_GIO_BASE + 1)
> > +#define IRIS_GIO_PULSE 0x80 /* First byte to send */
> > +#define IRIS_GIO_REST 0x0 /* Second byte to send */
> > +#define IRIS_GIO_NODEV 0xff /* Likely not an Iris */
> > +
> > +MODULE_LICENSE("GPL");
> > +MODULE_AUTHOR("Sébastien Hinderer <Sebastien.Hinderer@ens-lyon.org>");
> > +MODULE_DESCRIPTION("A power_off handler for Iris devices from EuroBraille");
> > +MODULE_SUPPORTED_DEVICE("Eurobraille/Iris");
> > +
> > +static int force;
> > +module_param(force, bool, 0);
> > +MODULE_PARM_DESC(force, "Set to one to force poweroff handler installation.");
> > +
> > +static void (*old_pm_power_off)(void);
> > +
> > +static void iris_power_off(void)
> > +{
> > +	outb(IRIS_GIO_PULSE, IRIS_GIO_OUTPUT);
> > +	msleep(850);
> > +	outb(IRIS_GIO_REST, IRIS_GIO_OUTPUT);
> > +}
> > +
> > +/*
> > + * Before installing the power_off handler, try to make sure the OS is
> > + * running on an Iris.  Since Iris does not support DMI, this is done
> > + * by reading its input port and seeing whether the read value is
> > + * meaningful.
> > + */
> > +static int iris_init(void)
> > +{
> > +	unsigned char status;
> > +	if (force != 1) {
> > +		printk(KERN_ERR "The force parameter has not been set to 1 so the Iris poweroff handler will not be installed.\n");
> > +		return -ENODEV;
> > +	}
> > +	status = inb(IRIS_GIO_INPUT);
> > +	if (status == IRIS_GIO_NODEV) {
> > +		printk(KERN_ERR "This machine does not seem to be an Iris. Power_off handler not installed.\n");
> > +		return -ENODEV;
> > +	}
> > +	old_pm_power_off = pm_power_off;
> > +	pm_power_off = &iris_power_off;
> > +	printk(KERN_INFO "Iris power_off handler installed.\n");
> > +	return 0;
> > +}
> > +
> > +static void iris_exit(void)
> > +{
> > +	pm_power_off = old_pm_power_off;
> > +	printk(KERN_INFO "Iris power_off handler uninstalled.\n");
> > +}
> > +
> > +module_init(iris_init);
> > +module_exit(iris_exit);
> > +

--qDbXVdCdHGoSgWSk
Content-Type: text/x-diff; charset=iso-8859-1
Content-Disposition: attachment; filename="0001-Eurobraille-Iris-power-off.patch"
Content-Transfer-Encoding: 8bit

>From 2af50581bb591cd25ac59a7cf16902ea50f766db Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Sh=C3=A9rab?= <Sebastien.Hinderer@ens-lyon.org>
Date: Sat, 25 Sep 2010 06:06:57 +0200
Subject: [PATCH] Eurobraille/Iris power off.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"

The Iris machines from Eurobraille do not have APM or ACPI support
to shut themselves down properly.  A special I/O sequence is
needed to do so.  This modle runs this I/O sequence at
kernel shutdown when its force parameter is set to 1.
Signed-off-by: Shérab <Sebastien.Hinderer@ens-lyon.org>
---
 arch/x86/Kconfig         |   13 +++++++
 arch/x86/kernel/Makefile |    1 +
 arch/x86/kernel/iris.c   |   90 ++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 104 insertions(+), 0 deletions(-)
 create mode 100644 arch/x86/kernel/iris.c

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index cea0cd9..7c8e261 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -493,6 +493,19 @@ config X86_ES7000
 	  Support for Unisys ES7000 systems.  Say 'Y' here if this kernel is
 	  supposed to run on an IA32-based Unisys ES7000 system.
 
+config X86_32_IRIS
+	tristate "Eurobraille/Iris poweroff module"
+	depends on X86_32
+	---help---
+	  The Iris machines from EuroBraille do not have APM or ACPI support
+	  to shut themselves down properly.  A special I/O sequence is
+	  needed to do so, which is what this module does at
+	  kernel shutdown.
+
+	  This is only for Iris machines from EuroBraille.
+
+	  If unused, say N.
+
 config SCHED_OMIT_FRAME_POINTER
 	def_bool y
 	prompt "Single-depth WCHAN output"
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 0925676..98dd1c8 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -115,6 +115,7 @@ obj-$(CONFIG_MICROCODE)			+= microcode.o
 obj-$(CONFIG_X86_CHECK_BIOS_CORRUPTION) += check.o
 
 obj-$(CONFIG_SWIOTLB)			+= pci-swiotlb.o
+obj-$(CONFIG_X86_32_IRIS)		+= iris.o
 
 ###
 # 64 bit specific files
diff --git a/arch/x86/kernel/iris.c b/arch/x86/kernel/iris.c
new file mode 100644
index 0000000..c6d8137
--- /dev/null
+++ b/arch/x86/kernel/iris.c
@@ -0,0 +1,90 @@
+/*
+ * Eurobraille/Iris power off support.
+ *
+ * Eurobraille's Iris machine is a PC with no APM or ACPI support.
+ * It is shutdown by a special I/O sequence which this module provides.
+ *
+ *  Copyright (C) Shérab <Sebastien.Hinderer@ens-lyon.org>
+ *
+ * This program is free software ; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation ; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY ; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with the program ; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/kernel.h>
+#include <linux/errno.h>
+#include <linux/init.h>
+#include <linux/pm.h>
+#include <linux/delay.h>
+#include <asm/io.h>
+
+#define IRIS_GIO_BASE 0x340
+#define IRIS_GIO_INPUT IRIS_GIO_BASE
+#define IRIS_GIO_OUTPUT (IRIS_GIO_BASE + 1)
+#define IRIS_GIO_PULSE 0x80 /* First byte to send */
+#define IRIS_GIO_REST 0x0 /* Second byte to send */
+#define IRIS_GIO_NODEV 0xff /* Likely not an Iris */
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Sébastien Hinderer <Sebastien.Hinderer@ens-lyon.org>");
+MODULE_DESCRIPTION("A power_off handler for Iris devices from EuroBraille");
+MODULE_SUPPORTED_DEVICE("Eurobraille/Iris");
+
+static int force;
+module_param(force, bool, 0);
+MODULE_PARM_DESC(force, "Set to one to force poweroff handler installation.");
+
+static void (*old_pm_power_off)(void);
+
+static void iris_power_off(void)
+{
+	outb(IRIS_GIO_PULSE, IRIS_GIO_OUTPUT);
+	msleep(850);
+	outb(IRIS_GIO_REST, IRIS_GIO_OUTPUT);
+}
+
+/*
+ * Before installing the power_off handler, try to make sure the OS is
+ * running on an Iris.  Since Iris does not support DMI, this is done
+ * by reading its input port and seeing whether the read value is
+ * meaningful.
+ */
+static int iris_init(void)
+{
+	unsigned char status;
+	if (force != 1) {
+		printk(KERN_ERR "The force parameter has not been set to 1 so the Iris poweroff handler will not be installed.\n");
+		return -ENODEV;
+	}
+	status = inb(IRIS_GIO_INPUT);
+	if (status == IRIS_GIO_NODEV) {
+		printk(KERN_ERR "This machine does not seem to be an Iris. Power_off handler not installed.\n");
+		return -ENODEV;
+	}
+	old_pm_power_off = pm_power_off;
+	pm_power_off = &iris_power_off;
+	printk(KERN_INFO "Iris power_off handler installed.\n");
+	return 0;
+}
+
+static void iris_exit(void)
+{
+	pm_power_off = old_pm_power_off;
+	printk(KERN_INFO "Iris power_off handler uninstalled.\n");
+}
+
+module_init(iris_init);
+module_exit(iris_exit);
+
-- 
1.7.1


--qDbXVdCdHGoSgWSk--
