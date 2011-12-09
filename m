Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754192Ab1LIPZd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 10:25:33 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:64378 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752353Ab1LIPZa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 10:25:30 -0500
Message-ID: <1323444321.979.39.camel@mop>
Subject: Re: [PATCH-WIP] convert CPU sysdev class to a real subsytem (needed
 for CPU modaliases)
From: Kay Sievers <kay.sievers@vrfy.org>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, ak@linux.intel.com, trenn@suse.de,
        davej@redhat.com
Date: Fri, 09 Dec 2011 16:25:21 +0100
In-Reply-To: <CAPXgP12tds9gPKie+B6358XkhyP1K2fLFGw698-wwsuKx_bcew@mail.gmail.com>
References: <1323309517.979.8.camel@mop> <20111209001145.GB9550@kroah.com>
	 <CAPXgP12tds9gPKie+B6358XkhyP1K2fLFGw698-wwsuKx_bcew@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2 (3.2.2-1.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-12-09 at 05:20 +0100, Kay Sievers wrote:
> On Fri, Dec 9, 2011 at 01:11, Greg KH <greg@kroah.com> wrote:

> > So, what do I need to do here?  Your patch looks good at first glance,
> > the interface logic looks sane, is that all that we really need to do to
> > the core?
> 
> Yeah, it seems to work out well. I converted all generic and the x86
> code, and after removing drivers/base/sys.c and include/linux/sysdev.h
> it looks like this:
>    53 files changed, 1014 insertions(+), 1256 deletions(-)
> Which could be a sign of doing the right thing.
> 
> I'll finish what I have now, then split out the driver-core changes
> which we can possibly merge without affecting anything else. I should
> get that ready next week.

Here is the current version with the sysdev code entirely removed. It
only works for x86 at the moment. It boots my box and the patch looks
like:
  58 files changed, 1121 insertions(+), 1368 deletions(-)

Greg, would be nice, if you can take a quick look a the driver core (not
the sysdev) bits in core.c, bus.c, device.h, ... and its interaction, if
they look sane to you. I'll then split the driver core stuff out, so we
can merge that before we port the individual drivers over.

73 files in !x86 architectures are left to port over. Some of them can
be converted independently after the driver core bits merge; but some
need to be updated at the same time the generic system code is ported
over.

If anybody would be interested to help out, it would be more than
welcome. It's mostly a string replace job, with a few API changes, no
logic changes should be really needed. The pattern what to change should
be pretty obvious from the stuff in the patch.

Thanks,
Kay

----------------------

  arch/arm/kernel/leds.c
  arch/arm/mach-exynos/cpu.c
  arch/arm/mach-exynos/pm.c
  arch/arm/mach-s3c2410/cpu-freq.c
  arch/arm/mach-s3c2410/dma.c
  arch/arm/mach-s3c2410/include/mach/dma.h
  arch/arm/mach-s3c2410/pll.c
  arch/arm/mach-s3c2410/pm.c
  arch/arm/mach-s3c2410/s3c2410.c
  arch/arm/mach-s3c2412/cpu-freq.c
  arch/arm/mach-s3c2412/dma.c
  arch/arm/mach-s3c2412/irq.c
  arch/arm/mach-s3c2412/pm.c
  arch/arm/mach-s3c2412/s3c2412.c
  arch/arm/mach-s3c2416/irq.c
  arch/arm/mach-s3c2416/pm.c
  arch/arm/mach-s3c2416/s3c2416.c
  arch/arm/mach-s3c2440/clock.c
  arch/arm/mach-s3c2440/dma.c
  arch/arm/mach-s3c2440/irq.c
  arch/arm/mach-s3c2440/s3c2440.c
  arch/arm/mach-s3c2440/s3c2440-cpufreq.c
  arch/arm/mach-s3c2440/s3c2440-pll-12000000.c
  arch/arm/mach-s3c2440/s3c2440-pll-16934400.c
  arch/arm/mach-s3c2440/s3c2442.c
  arch/arm/mach-s3c2440/s3c244x.c
  arch/arm/mach-s3c2440/s3c244x-clock.c
  arch/arm/mach-s3c2440/s3c244x-irq.c
  arch/arm/mach-s3c2443/dma.c
  arch/arm/mach-s3c2443/irq.c
  arch/arm/mach-s3c2443/s3c2443.c
  arch/arm/mach-s3c64xx/cpu.c
  arch/arm/mach-s3c64xx/dma.c
  arch/arm/mach-s3c64xx/s3c6400.c
  arch/arm/mach-s3c64xx/s3c6410.c
  arch/arm/mach-s5p64x0/cpu.c
  arch/arm/mach-s5p64x0/pm.c
  arch/arm/mach-s5pc100/cpu.c
  arch/arm/mach-s5pv210/cpu.c
  arch/arm/mach-s5pv210/pm.c
  arch/arm/plat-samsung/include/plat/cpu.h
  arch/arm/plat-samsung/include/plat/dma-s3c24xx.h
  arch/arm/plat-samsung/include/plat/pm.h
  arch/avr32/kernel/cpu.c
  arch/ia64/kernel/err_inject.c
  arch/ia64/kernel/topology.c
  arch/m68k/platform/coldfire/gpio.c
  arch/mips/txx9/generic/7segled.c
  arch/mips/txx9/generic/setup.c
  arch/powerpc/include/asm/spu.h
  arch/powerpc/include/asm/topology.h
  arch/powerpc/kernel/cacheinfo.c
  arch/powerpc/kernel/sysfs.c
  arch/powerpc/mm/numa.c
  arch/powerpc/platforms/cell/cbe_thermal.c
  arch/powerpc/platforms/cell/spu_base.c
  arch/powerpc/platforms/pseries/cmm.c
  arch/powerpc/platforms/pseries/pseries_energy.c
  arch/powerpc/platforms/pseries/suspend.c
  arch/powerpc/sysdev/ppc4xx_cpm.c
  arch/powerpc/sysdev/qe_lib/qe_ic.c
  arch/s390/kernel/smp.c
  arch/s390/kernel/time.c
  arch/s390/kernel/topology.c
  arch/sh/drivers/dma/dma-sysfs.c
  arch/sh/include/asm/dma.h
  arch/sh/kernel/cpu/sh4/sq.c
  arch/sparc/kernel/sysfs.c
  arch/tile/kernel/sysfs.c
  drivers/s390/char/sclp_config.c
  drivers/sh/intc/core.c
  drivers/sh/intc/internals.h
  drivers/sh/intc/userimask.c


----------------------


diff --git a/arch/x86/include/asm/mce.h b/arch/x86/include/asm/mce.h
index 0e8ae57..7f06a19 100644
--- a/arch/x86/include/asm/mce.h
+++ b/arch/x86/include/asm/mce.h
@@ -149,7 +149,7 @@ static inline void enable_p5_mce(void) {}
 
 void mce_setup(struct mce *m);
 void mce_log(struct mce *m);
-DECLARE_PER_CPU(struct sys_device, mce_sysdev);
+DECLARE_PER_CPU(struct device, mce_device);
 
 /*
  * Maximum banks number.
diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
index a3b0811..6b45e5e 100644
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -844,8 +844,7 @@ static int __cpuinit detect_cache_attributes(unsigned int cpu)
 
 #include <linux/kobject.h>
 #include <linux/sysfs.h>
-
-extern struct sysdev_class cpu_sysdev_class; /* from drivers/base/cpu.c */
+#include <linux/cpu.h>
 
 /* pointer to kobject for cpuX/cache */
 static DEFINE_PER_CPU(struct kobject *, ici_cache_kobject);
@@ -1073,9 +1072,9 @@ err_out:
 static DECLARE_BITMAP(cache_dev_map, NR_CPUS);
 
 /* Add/Remove cache interface for CPU device */
-static int __cpuinit cache_add_dev(struct sys_device * sys_dev)
+static int __cpuinit cache_add_dev(struct device *dev)
 {
-	unsigned int cpu = sys_dev->id;
+	unsigned int cpu = dev->id;
 	unsigned long i, j;
 	struct _index_kobject *this_object;
 	struct _cpuid4_info   *this_leaf;
@@ -1087,7 +1086,7 @@ static int __cpuinit cache_add_dev(struct sys_device * sys_dev)
 
 	retval = kobject_init_and_add(per_cpu(ici_cache_kobject, cpu),
 				      &ktype_percpu_entry,
-				      &sys_dev->kobj, "%s", "cache");
+				      &dev->kobj, "%s", "cache");
 	if (retval < 0) {
 		cpuid4_cache_sysfs_exit(cpu);
 		return retval;
@@ -1124,9 +1123,9 @@ static int __cpuinit cache_add_dev(struct sys_device * sys_dev)
 	return 0;
 }
 
-static void __cpuinit cache_remove_dev(struct sys_device * sys_dev)
+static void __cpuinit cache_remove_dev(struct device *dev)
 {
-	unsigned int cpu = sys_dev->id;
+	unsigned int cpu = dev->id;
 	unsigned long i;
 
 	if (per_cpu(ici_cpuid4_info, cpu) == NULL)
@@ -1145,17 +1144,17 @@ static int __cpuinit cacheinfo_cpu_callback(struct notifier_block *nfb,
 					unsigned long action, void *hcpu)
 {
 	unsigned int cpu = (unsigned long)hcpu;
-	struct sys_device *sys_dev;
+	struct device *dev;
 
-	sys_dev = get_cpu_sysdev(cpu);
+	dev = get_cpu_device(cpu);
 	switch (action) {
 	case CPU_ONLINE:
 	case CPU_ONLINE_FROZEN:
-		cache_add_dev(sys_dev);
+		cache_add_dev(dev);
 		break;
 	case CPU_DEAD:
 	case CPU_DEAD_FROZEN:
-		cache_remove_dev(sys_dev);
+		cache_remove_dev(dev);
 		break;
 	}
 	return NOTIFY_OK;
@@ -1174,9 +1173,9 @@ static int __cpuinit cache_sysfs_init(void)
 
 	for_each_online_cpu(i) {
 		int err;
-		struct sys_device *sys_dev = get_cpu_sysdev(i);
+		struct device *dev = get_cpu_device(i);
 
-		err = cache_add_dev(sys_dev);
+		err = cache_add_dev(dev);
 		if (err)
 			return err;
 	}
diff --git a/arch/x86/kernel/cpu/mcheck/mce-internal.h b/arch/x86/kernel/cpu/mcheck/mce-internal.h
index fefcc69..ed44c8a 100644
--- a/arch/x86/kernel/cpu/mcheck/mce-internal.h
+++ b/arch/x86/kernel/cpu/mcheck/mce-internal.h
@@ -1,4 +1,4 @@
-#include <linux/sysdev.h>
+#include <linux/device.h>
 #include <asm/mce.h>
 
 enum severity_level {
@@ -17,7 +17,7 @@ enum severity_level {
 struct mce_bank {
 	u64			ctl;			/* subevents to enable */
 	unsigned char init;				/* initialise bank? */
-	struct sysdev_attribute attr;			/* sysdev attribute */
+	struct device_attribute attr;			/* device attribute */
 	char			attrname[ATTR_LEN];	/* attribute name */
 };
 
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 2af127d..dc6bc14 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -19,7 +19,7 @@
 #include <linux/kernel.h>
 #include <linux/percpu.h>
 #include <linux/string.h>
-#include <linux/sysdev.h>
+#include <linux/device.h>
 #include <linux/syscore_ops.h>
 #include <linux/delay.h>
 #include <linux/ctype.h>
@@ -1770,7 +1770,7 @@ static struct syscore_ops mce_syscore_ops = {
 };
 
 /*
- * mce_sysdev: Sysfs support
+ * mce_device: Sysfs support
  */
 
 static void mce_cpu_restart(void *data)
@@ -1806,27 +1806,28 @@ static void mce_enable_ce(void *all)
 		__mcheck_cpu_init_timer();
 }
 
-static struct sysdev_class mce_sysdev_class = {
+static struct bus_type mce_subsys = {
 	.name		= "machinecheck",
+	.dev_name	= "machinecheck",
 };
 
-DEFINE_PER_CPU(struct sys_device, mce_sysdev);
+DEFINE_PER_CPU(struct device, mce_device);
 
 __cpuinitdata
 void (*threshold_cpu_callback)(unsigned long action, unsigned int cpu);
 
-static inline struct mce_bank *attr_to_bank(struct sysdev_attribute *attr)
+static inline struct mce_bank *attr_to_bank(struct device_attribute *attr)
 {
 	return container_of(attr, struct mce_bank, attr);
 }
 
-static ssize_t show_bank(struct sys_device *s, struct sysdev_attribute *attr,
+static ssize_t show_bank(struct device *s, struct device_attribute *attr,
 			 char *buf)
 {
 	return sprintf(buf, "%llx\n", attr_to_bank(attr)->ctl);
 }
 
-static ssize_t set_bank(struct sys_device *s, struct sysdev_attribute *attr,
+static ssize_t set_bank(struct device *s, struct device_attribute *attr,
 			const char *buf, size_t size)
 {
 	u64 new;
@@ -1841,14 +1842,14 @@ static ssize_t set_bank(struct sys_device *s, struct sysdev_attribute *attr,
 }
 
 static ssize_t
-show_trigger(struct sys_device *s, struct sysdev_attribute *attr, char *buf)
+show_trigger(struct device *s, struct device_attribute *attr, char *buf)
 {
 	strcpy(buf, mce_helper);
 	strcat(buf, "\n");
 	return strlen(mce_helper) + 1;
 }
 
-static ssize_t set_trigger(struct sys_device *s, struct sysdev_attribute *attr,
+static ssize_t set_trigger(struct device *s, struct device_attribute *attr,
 				const char *buf, size_t siz)
 {
 	char *p;
@@ -1863,8 +1864,8 @@ static ssize_t set_trigger(struct sys_device *s, struct sysdev_attribute *attr,
 	return strlen(mce_helper) + !!p;
 }
 
-static ssize_t set_ignore_ce(struct sys_device *s,
-			     struct sysdev_attribute *attr,
+static ssize_t set_ignore_ce(struct device *s,
+			     struct device_attribute *attr,
 			     const char *buf, size_t size)
 {
 	u64 new;
@@ -1887,8 +1888,8 @@ static ssize_t set_ignore_ce(struct sys_device *s,
 	return size;
 }
 
-static ssize_t set_cmci_disabled(struct sys_device *s,
-				 struct sysdev_attribute *attr,
+static ssize_t set_cmci_disabled(struct device *s,
+				 struct device_attribute *attr,
 				 const char *buf, size_t size)
 {
 	u64 new;
@@ -1910,108 +1911,107 @@ static ssize_t set_cmci_disabled(struct sys_device *s,
 	return size;
 }
 
-static ssize_t store_int_with_restart(struct sys_device *s,
-				      struct sysdev_attribute *attr,
+static ssize_t store_int_with_restart(struct device *s,
+				      struct device_attribute *attr,
 				      const char *buf, size_t size)
 {
-	ssize_t ret = sysdev_store_int(s, attr, buf, size);
+	ssize_t ret = device_store_int(s, attr, buf, size);
 	mce_restart();
 	return ret;
 }
 
-static SYSDEV_ATTR(trigger, 0644, show_trigger, set_trigger);
-static SYSDEV_INT_ATTR(tolerant, 0644, tolerant);
-static SYSDEV_INT_ATTR(monarch_timeout, 0644, monarch_timeout);
-static SYSDEV_INT_ATTR(dont_log_ce, 0644, mce_dont_log_ce);
+static DEVICE_ATTR(trigger, 0644, show_trigger, set_trigger);
+static DEVICE_INT_ATTR(tolerant, 0644, tolerant);
+static DEVICE_INT_ATTR(monarch_timeout, 0644, monarch_timeout);
+static DEVICE_INT_ATTR(dont_log_ce, 0644, mce_dont_log_ce);
 
-static struct sysdev_ext_attribute attr_check_interval = {
-	_SYSDEV_ATTR(check_interval, 0644, sysdev_show_int,
-		     store_int_with_restart),
+static struct dev_ext_attribute dev_attr_check_interval = {
+	__ATTR(check_interval, 0644, device_show_int, store_int_with_restart),
 	&check_interval
 };
 
-static struct sysdev_ext_attribute attr_ignore_ce = {
-	_SYSDEV_ATTR(ignore_ce, 0644, sysdev_show_int, set_ignore_ce),
+static struct dev_ext_attribute dev_attr_ignore_ce = {
+	__ATTR(ignore_ce, 0644, device_show_int, set_ignore_ce),
 	&mce_ignore_ce
 };
 
-static struct sysdev_ext_attribute attr_cmci_disabled = {
-	_SYSDEV_ATTR(cmci_disabled, 0644, sysdev_show_int, set_cmci_disabled),
+static struct dev_ext_attribute dev_attr_cmci_disabled = {
+	__ATTR(cmci_disabled, 0644, device_show_int, set_cmci_disabled),
 	&mce_cmci_disabled
 };
 
-static struct sysdev_attribute *mce_sysdev_attrs[] = {
-	&attr_tolerant.attr,
-	&attr_check_interval.attr,
-	&attr_trigger,
-	&attr_monarch_timeout.attr,
-	&attr_dont_log_ce.attr,
-	&attr_ignore_ce.attr,
-	&attr_cmci_disabled.attr,
+static struct device_attribute *mce_device_attrs[] = {
+	&dev_attr_tolerant.attr,
+	&dev_attr_check_interval.attr,
+	&dev_attr_trigger,
+	&dev_attr_monarch_timeout.attr,
+	&dev_attr_dont_log_ce.attr,
+	&dev_attr_ignore_ce.attr,
+	&dev_attr_cmci_disabled.attr,
 	NULL
 };
 
-static cpumask_var_t mce_sysdev_initialized;
+static cpumask_var_t mce_device_initialized;
 
-/* Per cpu sysdev init. All of the cpus still share the same ctrl bank: */
-static __cpuinit int mce_sysdev_create(unsigned int cpu)
+/* Per cpu device init. All of the cpus still share the same ctrl bank: */
+static __cpuinit int mce_device_create(unsigned int cpu)
 {
-	struct sys_device *sysdev = &per_cpu(mce_sysdev, cpu);
+	struct device *dev = &per_cpu(mce_device, cpu);
 	int err;
 	int i, j;
 
 	if (!mce_available(&boot_cpu_data))
 		return -EIO;
 
-	memset(&sysdev->kobj, 0, sizeof(struct kobject));
-	sysdev->id  = cpu;
-	sysdev->cls = &mce_sysdev_class;
+	memset(&dev->kobj, 0, sizeof(struct kobject));
+	dev->id  = cpu;
+	dev->bus = &mce_subsys;
 
-	err = sysdev_register(sysdev);
+	err = device_register(dev);
 	if (err)
 		return err;
 
-	for (i = 0; mce_sysdev_attrs[i]; i++) {
-		err = sysdev_create_file(sysdev, mce_sysdev_attrs[i]);
+	for (i = 0; mce_device_attrs[i]; i++) {
+		err = device_create_file(dev, mce_device_attrs[i]);
 		if (err)
 			goto error;
 	}
 	for (j = 0; j < banks; j++) {
-		err = sysdev_create_file(sysdev, &mce_banks[j].attr);
+		err = device_create_file(dev, &mce_banks[j].attr);
 		if (err)
 			goto error2;
 	}
-	cpumask_set_cpu(cpu, mce_sysdev_initialized);
+	cpumask_set_cpu(cpu, mce_device_initialized);
 
 	return 0;
 error2:
 	while (--j >= 0)
-		sysdev_remove_file(sysdev, &mce_banks[j].attr);
+		device_remove_file(dev, &mce_banks[j].attr);
 error:
 	while (--i >= 0)
-		sysdev_remove_file(sysdev, mce_sysdev_attrs[i]);
+		device_remove_file(dev, mce_device_attrs[i]);
 
-	sysdev_unregister(sysdev);
+	device_unregister(dev);
 
 	return err;
 }
 
-static __cpuinit void mce_sysdev_remove(unsigned int cpu)
+static __cpuinit void mce_device_remove(unsigned int cpu)
 {
-	struct sys_device *sysdev = &per_cpu(mce_sysdev, cpu);
+	struct device *dev = &per_cpu(mce_device, cpu);
 	int i;
 
-	if (!cpumask_test_cpu(cpu, mce_sysdev_initialized))
+	if (!cpumask_test_cpu(cpu, mce_device_initialized))
 		return;
 
-	for (i = 0; mce_sysdev_attrs[i]; i++)
-		sysdev_remove_file(sysdev, mce_sysdev_attrs[i]);
+	for (i = 0; mce_device_attrs[i]; i++)
+		device_remove_file(dev, mce_device_attrs[i]);
 
 	for (i = 0; i < banks; i++)
-		sysdev_remove_file(sysdev, &mce_banks[i].attr);
+		device_remove_file(dev, &mce_banks[i].attr);
 
-	sysdev_unregister(sysdev);
-	cpumask_clear_cpu(cpu, mce_sysdev_initialized);
+	device_unregister(dev);
+	cpumask_clear_cpu(cpu, mce_device_initialized);
 }
 
 /* Make sure there are no machine checks on offlined CPUs. */
@@ -2061,7 +2061,7 @@ mce_cpu_callback(struct notifier_block *nfb, unsigned long action, void *hcpu)
 	switch (action) {
 	case CPU_ONLINE:
 	case CPU_ONLINE_FROZEN:
-		mce_sysdev_create(cpu);
+		mce_device_create(cpu);
 		if (threshold_cpu_callback)
 			threshold_cpu_callback(action, cpu);
 		break;
@@ -2069,7 +2069,7 @@ mce_cpu_callback(struct notifier_block *nfb, unsigned long action, void *hcpu)
 	case CPU_DEAD_FROZEN:
 		if (threshold_cpu_callback)
 			threshold_cpu_callback(action, cpu);
-		mce_sysdev_remove(cpu);
+		mce_device_remove(cpu);
 		break;
 	case CPU_DOWN_PREPARE:
 	case CPU_DOWN_PREPARE_FROZEN:
@@ -2103,7 +2103,7 @@ static __init void mce_init_banks(void)
 
 	for (i = 0; i < banks; i++) {
 		struct mce_bank *b = &mce_banks[i];
-		struct sysdev_attribute *a = &b->attr;
+		struct device_attribute *a = &b->attr;
 
 		sysfs_attr_init(&a->attr);
 		a->attr.name	= b->attrname;
@@ -2123,16 +2123,16 @@ static __init int mcheck_init_device(void)
 	if (!mce_available(&boot_cpu_data))
 		return -EIO;
 
-	zalloc_cpumask_var(&mce_sysdev_initialized, GFP_KERNEL);
+	zalloc_cpumask_var(&mce_device_initialized, GFP_KERNEL);
 
 	mce_init_banks();
 
-	err = sysdev_class_register(&mce_sysdev_class);
+	err = bus_register(&mce_subsys);
 	if (err)
 		return err;
 
 	for_each_online_cpu(i) {
-		err = mce_sysdev_create(i);
+		err = mce_device_create(i);
 		if (err)
 			return err;
 	}
diff --git a/arch/x86/kernel/cpu/mcheck/mce_amd.c b/arch/x86/kernel/cpu/mcheck/mce_amd.c
index f547421..56d2aa1 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_amd.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_amd.c
@@ -17,7 +17,6 @@
 #include <linux/notifier.h>
 #include <linux/kobject.h>
 #include <linux/percpu.h>
-#include <linux/sysdev.h>
 #include <linux/errno.h>
 #include <linux/sched.h>
 #include <linux/sysfs.h>
@@ -548,7 +547,7 @@ static __cpuinit int threshold_create_bank(unsigned int cpu, unsigned int bank)
 		if (!b)
 			goto out;
 
-		err = sysfs_create_link(&per_cpu(mce_sysdev, cpu).kobj,
+		err = sysfs_create_link(&per_cpu(mce_device, cpu).kobj,
 					b->kobj, name);
 		if (err)
 			goto out;
@@ -571,7 +570,7 @@ static __cpuinit int threshold_create_bank(unsigned int cpu, unsigned int bank)
 		goto out;
 	}
 
-	b->kobj = kobject_create_and_add(name, &per_cpu(mce_sysdev, cpu).kobj);
+	b->kobj = kobject_create_and_add(name, &per_cpu(mce_device, cpu).kobj);
 	if (!b->kobj)
 		goto out_free;
 
@@ -591,7 +590,7 @@ static __cpuinit int threshold_create_bank(unsigned int cpu, unsigned int bank)
 		if (i == cpu)
 			continue;
 
-		err = sysfs_create_link(&per_cpu(mce_sysdev, i).kobj,
+		err = sysfs_create_link(&per_cpu(mce_device, i).kobj,
 					b->kobj, name);
 		if (err)
 			goto out;
@@ -669,7 +668,7 @@ static void threshold_remove_bank(unsigned int cpu, int bank)
 #ifdef CONFIG_SMP
 	/* sibling symlink */
 	if (shared_bank[bank] && b->blocks->cpu != cpu) {
-		sysfs_remove_link(&per_cpu(mce_sysdev, cpu).kobj, name);
+		sysfs_remove_link(&per_cpu(mce_device, cpu).kobj, name);
 		per_cpu(threshold_banks, cpu)[bank] = NULL;
 
 		return;
@@ -681,7 +680,7 @@ static void threshold_remove_bank(unsigned int cpu, int bank)
 		if (i == cpu)
 			continue;
 
-		sysfs_remove_link(&per_cpu(mce_sysdev, i).kobj, name);
+		sysfs_remove_link(&per_cpu(mce_device, i).kobj, name);
 		per_cpu(threshold_banks, i)[bank] = NULL;
 	}
 
diff --git a/arch/x86/kernel/cpu/mcheck/therm_throt.c b/arch/x86/kernel/cpu/mcheck/therm_throt.c
index 787e06c..59e3f6e 100644
--- a/arch/x86/kernel/cpu/mcheck/therm_throt.c
+++ b/arch/x86/kernel/cpu/mcheck/therm_throt.c
@@ -19,7 +19,6 @@
 #include <linux/kernel.h>
 #include <linux/percpu.h>
 #include <linux/export.h>
-#include <linux/sysdev.h>
 #include <linux/types.h>
 #include <linux/init.h>
 #include <linux/smp.h>
@@ -69,16 +68,16 @@ static atomic_t therm_throt_en	= ATOMIC_INIT(0);
 static u32 lvtthmr_init __read_mostly;
 
 #ifdef CONFIG_SYSFS
-#define define_therm_throt_sysdev_one_ro(_name)				\
-	static SYSDEV_ATTR(_name, 0444,					\
-			   therm_throt_sysdev_show_##_name,		\
+#define define_therm_throt_device_one_ro(_name)				\
+	static DEVICE_ATTR(_name, 0444,					\
+			   therm_throt_device_show_##_name,		\
 				   NULL)				\
 
-#define define_therm_throt_sysdev_show_func(event, name)		\
+#define define_therm_throt_device_show_func(event, name)		\
 									\
-static ssize_t therm_throt_sysdev_show_##event##_##name(		\
-			struct sys_device *dev,				\
-			struct sysdev_attribute *attr,			\
+static ssize_t therm_throt_device_show_##event##_##name(		\
+			struct device *dev,				\
+			struct device_attribute *attr,			\
 			char *buf)					\
 {									\
 	unsigned int cpu = dev->id;					\
@@ -95,20 +94,20 @@ static ssize_t therm_throt_sysdev_show_##event##_##name(		\
 	return ret;							\
 }
 
-define_therm_throt_sysdev_show_func(core_throttle, count);
-define_therm_throt_sysdev_one_ro(core_throttle_count);
+define_therm_throt_device_show_func(core_throttle, count);
+define_therm_throt_device_one_ro(core_throttle_count);
 
-define_therm_throt_sysdev_show_func(core_power_limit, count);
-define_therm_throt_sysdev_one_ro(core_power_limit_count);
+define_therm_throt_device_show_func(core_power_limit, count);
+define_therm_throt_device_one_ro(core_power_limit_count);
 
-define_therm_throt_sysdev_show_func(package_throttle, count);
-define_therm_throt_sysdev_one_ro(package_throttle_count);
+define_therm_throt_device_show_func(package_throttle, count);
+define_therm_throt_device_one_ro(package_throttle_count);
 
-define_therm_throt_sysdev_show_func(package_power_limit, count);
-define_therm_throt_sysdev_one_ro(package_power_limit_count);
+define_therm_throt_device_show_func(package_power_limit, count);
+define_therm_throt_device_one_ro(package_power_limit_count);
 
 static struct attribute *thermal_throttle_attrs[] = {
-	&attr_core_throttle_count.attr,
+	&dev_attr_core_throttle_count.attr,
 	NULL
 };
 
@@ -223,36 +222,36 @@ static int thresh_event_valid(int event)
 
 #ifdef CONFIG_SYSFS
 /* Add/Remove thermal_throttle interface for CPU device: */
-static __cpuinit int thermal_throttle_add_dev(struct sys_device *sys_dev,
+static __cpuinit int thermal_throttle_add_dev(struct device *dev,
 				unsigned int cpu)
 {
 	int err;
 	struct cpuinfo_x86 *c = &cpu_data(cpu);
 
-	err = sysfs_create_group(&sys_dev->kobj, &thermal_attr_group);
+	err = sysfs_create_group(&dev->kobj, &thermal_attr_group);
 	if (err)
 		return err;
 
 	if (cpu_has(c, X86_FEATURE_PLN))
-		err = sysfs_add_file_to_group(&sys_dev->kobj,
-					      &attr_core_power_limit_count.attr,
+		err = sysfs_add_file_to_group(&dev->kobj,
+					      &dev_attr_core_power_limit_count.attr,
 					      thermal_attr_group.name);
 	if (cpu_has(c, X86_FEATURE_PTS)) {
-		err = sysfs_add_file_to_group(&sys_dev->kobj,
-					      &attr_package_throttle_count.attr,
+		err = sysfs_add_file_to_group(&dev->kobj,
+					      &dev_attr_package_throttle_count.attr,
 					      thermal_attr_group.name);
 		if (cpu_has(c, X86_FEATURE_PLN))
-			err = sysfs_add_file_to_group(&sys_dev->kobj,
-					&attr_package_power_limit_count.attr,
+			err = sysfs_add_file_to_group(&dev->kobj,
+					&dev_attr_package_power_limit_count.attr,
 					thermal_attr_group.name);
 	}
 
 	return err;
 }
 
-static __cpuinit void thermal_throttle_remove_dev(struct sys_device *sys_dev)
+static __cpuinit void thermal_throttle_remove_dev(struct device *dev)
 {
-	sysfs_remove_group(&sys_dev->kobj, &thermal_attr_group);
+	sysfs_remove_group(&dev->kobj, &thermal_attr_group);
 }
 
 /* Mutex protecting device creation against CPU hotplug: */
@@ -265,16 +264,16 @@ thermal_throttle_cpu_callback(struct notifier_block *nfb,
 			      void *hcpu)
 {
 	unsigned int cpu = (unsigned long)hcpu;
-	struct sys_device *sys_dev;
+	struct device *dev;
 	int err = 0;
 
-	sys_dev = get_cpu_sysdev(cpu);
+	dev = get_cpu_device(cpu);
 
 	switch (action) {
 	case CPU_UP_PREPARE:
 	case CPU_UP_PREPARE_FROZEN:
 		mutex_lock(&therm_cpu_lock);
-		err = thermal_throttle_add_dev(sys_dev, cpu);
+		err = thermal_throttle_add_dev(dev, cpu);
 		mutex_unlock(&therm_cpu_lock);
 		WARN_ON(err);
 		break;
@@ -283,7 +282,7 @@ thermal_throttle_cpu_callback(struct notifier_block *nfb,
 	case CPU_DEAD:
 	case CPU_DEAD_FROZEN:
 		mutex_lock(&therm_cpu_lock);
-		thermal_throttle_remove_dev(sys_dev);
+		thermal_throttle_remove_dev(dev);
 		mutex_unlock(&therm_cpu_lock);
 		break;
 	}
@@ -310,7 +309,7 @@ static __init int thermal_throttle_init_device(void)
 #endif
 	/* connect live CPUs to sysfs */
 	for_each_online_cpu(cpu) {
-		err = thermal_throttle_add_dev(get_cpu_sysdev(cpu), cpu);
+		err = thermal_throttle_add_dev(get_cpu_device(cpu), cpu);
 		WARN_ON(err);
 	}
 #ifdef CONFIG_HOTPLUG_CPU
diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index b946a9e..98094a9 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -2,7 +2,6 @@
 #include <linux/clockchips.h>
 #include <linux/interrupt.h>
 #include <linux/export.h>
-#include <linux/sysdev.h>
 #include <linux/delay.h>
 #include <linux/errno.h>
 #include <linux/i8253.h>
diff --git a/arch/x86/kernel/irqinit.c b/arch/x86/kernel/irqinit.c
index b3300e6..313fb5c 100644
--- a/arch/x86/kernel/irqinit.c
+++ b/arch/x86/kernel/irqinit.c
@@ -9,7 +9,7 @@
 #include <linux/kprobes.h>
 #include <linux/init.h>
 #include <linux/kernel_stat.h>
-#include <linux/sysdev.h>
+#include <linux/device.h>
 #include <linux/bitops.h>
 #include <linux/acpi.h>
 #include <linux/io.h>
diff --git a/arch/x86/kernel/microcode_core.c b/arch/x86/kernel/microcode_core.c
index 9d46f5e..4fe1320 100644
--- a/arch/x86/kernel/microcode_core.c
+++ b/arch/x86/kernel/microcode_core.c
@@ -292,8 +292,8 @@ static int reload_for_cpu(int cpu)
 	return err;
 }
 
-static ssize_t reload_store(struct sys_device *dev,
-			    struct sysdev_attribute *attr,
+static ssize_t reload_store(struct device *dev,
+			    struct device_attribute *attr,
 			    const char *buf, size_t size)
 {
 	unsigned long val;
@@ -318,30 +318,30 @@ static ssize_t reload_store(struct sys_device *dev,
 	return ret;
 }
 
-static ssize_t version_show(struct sys_device *dev,
-			struct sysdev_attribute *attr, char *buf)
+static ssize_t version_show(struct device *dev,
+			struct device_attribute *attr, char *buf)
 {
 	struct ucode_cpu_info *uci = ucode_cpu_info + dev->id;
 
 	return sprintf(buf, "0x%x\n", uci->cpu_sig.rev);
 }
 
-static ssize_t pf_show(struct sys_device *dev,
-			struct sysdev_attribute *attr, char *buf)
+static ssize_t pf_show(struct device *dev,
+			struct device_attribute *attr, char *buf)
 {
 	struct ucode_cpu_info *uci = ucode_cpu_info + dev->id;
 
 	return sprintf(buf, "0x%x\n", uci->cpu_sig.pf);
 }
 
-static SYSDEV_ATTR(reload, 0200, NULL, reload_store);
-static SYSDEV_ATTR(version, 0400, version_show, NULL);
-static SYSDEV_ATTR(processor_flags, 0400, pf_show, NULL);
+static DEVICE_ATTR(reload, 0200, NULL, reload_store);
+static DEVICE_ATTR(version, 0400, version_show, NULL);
+static DEVICE_ATTR(processor_flags, 0400, pf_show, NULL);
 
 static struct attribute *mc_default_attrs[] = {
-	&attr_reload.attr,
-	&attr_version.attr,
-	&attr_processor_flags.attr,
+	&dev_attr_reload.attr,
+	&dev_attr_version.attr,
+	&dev_attr_processor_flags.attr,
 	NULL
 };
 
@@ -405,43 +405,45 @@ static enum ucode_state microcode_update_cpu(int cpu)
 	return ustate;
 }
 
-static int mc_sysdev_add(struct sys_device *sys_dev)
+static int mc_device_add(struct device *dev, struct subsys_interface *sif)
 {
-	int err, cpu = sys_dev->id;
+	int err, cpu = dev->id;
 
 	if (!cpu_online(cpu))
 		return 0;
 
 	pr_debug("CPU%d added\n", cpu);
 
-	err = sysfs_create_group(&sys_dev->kobj, &mc_attr_group);
+	err = sysfs_create_group(&dev->kobj, &mc_attr_group);
 	if (err)
 		return err;
 
 	if (microcode_init_cpu(cpu) == UCODE_ERROR) {
-		sysfs_remove_group(&sys_dev->kobj, &mc_attr_group);
+		sysfs_remove_group(&dev->kobj, &mc_attr_group);
 		return -EINVAL;
 	}
 
 	return err;
 }
 
-static int mc_sysdev_remove(struct sys_device *sys_dev)
+static int mc_device_remove(struct device *dev, struct subsys_interface *sif)
 {
-	int cpu = sys_dev->id;
+	int cpu = dev->id;
 
 	if (!cpu_online(cpu))
 		return 0;
 
 	pr_debug("CPU%d removed\n", cpu);
 	microcode_fini_cpu(cpu);
-	sysfs_remove_group(&sys_dev->kobj, &mc_attr_group);
+	sysfs_remove_group(&dev->kobj, &mc_attr_group);
 	return 0;
 }
 
-static struct sysdev_driver mc_sysdev_driver = {
-	.add			= mc_sysdev_add,
-	.remove			= mc_sysdev_remove,
+static struct subsys_interface mc_cpu_interface = {
+	.name			= "microcode",
+	.subsys			= &cpu_subsys,
+	.add_dev		= mc_device_add,
+	.remove_dev		= mc_device_remove,
 };
 
 /**
@@ -464,9 +466,9 @@ static __cpuinit int
 mc_cpu_callback(struct notifier_block *nb, unsigned long action, void *hcpu)
 {
 	unsigned int cpu = (unsigned long)hcpu;
-	struct sys_device *sys_dev;
+	struct device *dev;
 
-	sys_dev = get_cpu_sysdev(cpu);
+	dev = get_cpu_device(cpu);
 	switch (action) {
 	case CPU_ONLINE:
 	case CPU_ONLINE_FROZEN:
@@ -474,13 +476,13 @@ mc_cpu_callback(struct notifier_block *nb, unsigned long action, void *hcpu)
 	case CPU_DOWN_FAILED:
 	case CPU_DOWN_FAILED_FROZEN:
 		pr_debug("CPU%d added\n", cpu);
-		if (sysfs_create_group(&sys_dev->kobj, &mc_attr_group))
+		if (sysfs_create_group(&dev->kobj, &mc_attr_group))
 			pr_err("Failed to create group for CPU%d\n", cpu);
 		break;
 	case CPU_DOWN_PREPARE:
 	case CPU_DOWN_PREPARE_FROZEN:
 		/* Suspend is in progress, only remove the interface */
-		sysfs_remove_group(&sys_dev->kobj, &mc_attr_group);
+		sysfs_remove_group(&dev->kobj, &mc_attr_group);
 		pr_debug("CPU%d removed\n", cpu);
 		break;
 
@@ -525,7 +527,7 @@ static int __init microcode_init(void)
 	get_online_cpus();
 	mutex_lock(&microcode_mutex);
 
-	error = sysdev_driver_register(&cpu_sysdev_class, &mc_sysdev_driver);
+	error = subsys_interface_register(&mc_cpu_interface);
 
 	mutex_unlock(&microcode_mutex);
 	put_online_cpus();
@@ -535,7 +537,7 @@ static int __init microcode_init(void)
 
 	error = microcode_dev_init();
 	if (error)
-		goto out_sysdev_driver;
+		goto out_subsys_interface;
 
 	register_syscore_ops(&mc_syscore_ops);
 	register_hotcpu_notifier(&mc_cpu_notifier);
@@ -545,11 +547,11 @@ static int __init microcode_init(void)
 
 	return 0;
 
-out_sysdev_driver:
+out_subsys_interface:
 	get_online_cpus();
 	mutex_lock(&microcode_mutex);
 
-	sysdev_driver_unregister(&cpu_sysdev_class, &mc_sysdev_driver);
+	subsys_interface_unregister(&mc_cpu_interface);
 
 	mutex_unlock(&microcode_mutex);
 	put_online_cpus();
@@ -571,7 +573,7 @@ static void __exit microcode_exit(void)
 	get_online_cpus();
 	mutex_lock(&microcode_mutex);
 
-	sysdev_driver_unregister(&cpu_sysdev_class, &mc_sysdev_driver);
+	subsys_interface_unregister(&mc_cpu_interface);
 
 	mutex_unlock(&microcode_mutex);
 	put_online_cpus();
diff --git a/arch/x86/platform/uv/uv_sysfs.c b/arch/x86/platform/uv/uv_sysfs.c
index 309c70f..5d4ba30 100644
--- a/arch/x86/platform/uv/uv_sysfs.c
+++ b/arch/x86/platform/uv/uv_sysfs.c
@@ -19,7 +19,7 @@
  *  Copyright (c) Russ Anderson
  */
 
-#include <linux/sysdev.h>
+#include <linux/device.h>
 #include <asm/uv/bios.h>
 #include <asm/uv/uv.h>
 
diff --git a/drivers/acpi/processor_driver.c b/drivers/acpi/processor_driver.c
index 9d7bc9f..20a68ca 100644
--- a/drivers/acpi/processor_driver.c
+++ b/drivers/acpi/processor_driver.c
@@ -446,7 +446,7 @@ static int __cpuinit acpi_processor_add(struct acpi_device *device)
 {
 	struct acpi_processor *pr = NULL;
 	int result = 0;
-	struct sys_device *sysdev;
+	struct device *dev;
 
 	pr = kzalloc(sizeof(struct acpi_processor), GFP_KERNEL);
 	if (!pr)
@@ -491,8 +491,8 @@ static int __cpuinit acpi_processor_add(struct acpi_device *device)
 
 	per_cpu(processors, pr->id) = pr;
 
-	sysdev = get_cpu_sysdev(pr->id);
-	if (sysfs_create_link(&device->dev.kobj, &sysdev->kobj, "sysdev")) {
+	dev = get_cpu_device(pr->id);
+	if (sysfs_create_link(&device->dev.kobj, &dev->kobj, "sysdev")) {
 		result = -EFAULT;
 		goto err_free_cpumask;
 	}
diff --git a/drivers/acpi/processor_thermal.c b/drivers/acpi/processor_thermal.c
index 870550d..3b599ab 100644
--- a/drivers/acpi/processor_thermal.c
+++ b/drivers/acpi/processor_thermal.c
@@ -30,7 +30,6 @@
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/cpufreq.h>
-#include <linux/sysdev.h>
 
 #include <asm/uaccess.h>
 
diff --git a/drivers/base/Makefile b/drivers/base/Makefile
index 99a375a..16bbbcf 100644
--- a/drivers/base/Makefile
+++ b/drivers/base/Makefile
@@ -1,6 +1,6 @@
 # Makefile for the Linux device tree
 
-obj-y			:= core.o sys.o bus.o dd.o syscore.o \
+obj-y			:= core.o bus.o dd.o syscore.o \
 			   driver.o class.o platform.o \
 			   cpu.o firmware.o init.o map.o devres.o \
 			   attribute_container.o transport_class.o
diff --git a/drivers/base/base.h b/drivers/base/base.h
index 21c1b96..37319ca 100644
--- a/drivers/base/base.h
+++ b/drivers/base/base.h
@@ -5,6 +5,8 @@
  *
  * @subsys - the struct kset that defines this subsystem
  * @devices_kset - the list of devices associated
+ * @interfaces - list of subsystem interfaces associated
+ * @mutex - protect the devices, and interfaces lists.
  *
  * @drivers_kset - the list of drivers associated
  * @klist_devices - the klist to iterate over the @devices_kset
@@ -14,10 +16,8 @@
  * @bus - pointer back to the struct bus_type that this structure is associated
  *        with.
  *
- * @class_interfaces - list of class_interfaces associated
  * @glue_dirs - "glue" directory to put in-between the parent device to
  *              avoid namespace conflicts
- * @class_mutex - mutex to protect the children, devices, and interfaces lists.
  * @class - pointer back to the struct class that this structure is associated
  *          with.
  *
@@ -28,6 +28,8 @@
 struct subsys_private {
 	struct kset subsys;
 	struct kset *devices_kset;
+	struct list_head interfaces;
+	struct mutex mutex;
 
 	struct kset *drivers_kset;
 	struct klist klist_devices;
@@ -36,9 +38,7 @@ struct subsys_private {
 	unsigned int drivers_autoprobe:1;
 	struct bus_type *bus;
 
-	struct list_head class_interfaces;
 	struct kset glue_dirs;
-	struct mutex class_mutex;
 	struct class *class;
 };
 #define to_subsys_private(obj) container_of(obj, struct subsys_private, subsys.kobj)
@@ -94,7 +94,6 @@ extern int hypervisor_init(void);
 static inline int hypervisor_init(void) { return 0; }
 #endif
 extern int platform_bus_init(void);
-extern int system_bus_init(void);
 extern int cpu_dev_init(void);
 
 extern int bus_add_device(struct device *dev);
@@ -116,6 +115,7 @@ extern char *make_class_name(const char *name, struct kobject *kobj);
 
 extern int devres_release_all(struct device *dev);
 
+/* /sys/devices directory */
 extern struct kset *devices_kset;
 
 #if defined(CONFIG_MODULES) && defined(CONFIG_SYSFS)
diff --git a/drivers/base/bus.c b/drivers/base/bus.c
index 000e7b2..d17e612 100644
--- a/drivers/base/bus.c
+++ b/drivers/base/bus.c
@@ -16,9 +16,13 @@
 #include <linux/slab.h>
 #include <linux/init.h>
 #include <linux/string.h>
+#include <linux/mutex.h>
 #include "base.h"
 #include "power/power.h"
 
+/* /sys/devices/system */
+static struct kset *system_kset;
+
 #define to_bus_attr(_attr) container_of(_attr, struct bus_attribute, attr)
 
 /*
@@ -487,38 +491,59 @@ out_put:
 void bus_probe_device(struct device *dev)
 {
 	struct bus_type *bus = dev->bus;
+	struct subsys_interface *sif;
 	int ret;
 
-	if (bus && bus->p->drivers_autoprobe) {
+	if (!bus)
+		return;
+
+	if (bus->p->drivers_autoprobe) {
 		ret = device_attach(dev);
 		WARN_ON(ret < 0);
 	}
+
+	mutex_lock(&bus->p->mutex);
+	list_for_each_entry(sif, &bus->p->interfaces, node)
+		if (sif->add_dev)
+			sif->add_dev(dev, sif);
+	mutex_unlock(&bus->p->mutex);
 }
 
 /**
  * bus_remove_device - remove device from bus
  * @dev: device to be removed
  *
- * - Remove symlink from bus's directory.
+ * - Remove device from all interfaces.
+ * - Remove symlink from bus' directory.
  * - Delete device from bus's list.
  * - Detach from its driver.
  * - Drop reference taken in bus_add_device().
  */
 void bus_remove_device(struct device *dev)
 {
-	if (dev->bus) {
-		sysfs_remove_link(&dev->kobj, "subsystem");
-		sysfs_remove_link(&dev->bus->p->devices_kset->kobj,
-				  dev_name(dev));
-		device_remove_attrs(dev->bus, dev);
-		if (klist_node_attached(&dev->p->knode_bus))
-			klist_del(&dev->p->knode_bus);
-
-		pr_debug("bus: '%s': remove device %s\n",
-			 dev->bus->name, dev_name(dev));
-		device_release_driver(dev);
-		bus_put(dev->bus);
-	}
+	struct bus_type *bus = dev->bus;
+	struct subsys_interface *sif;
+
+	if (!bus)
+		return;
+
+	mutex_lock(&bus->p->mutex);
+	list_for_each_entry(sif, &bus->p->interfaces, node)
+		if (sif->remove_dev)
+			sif->remove_dev(dev, sif);
+	mutex_unlock(&bus->p->mutex);
+
+	sysfs_remove_link(&dev->kobj, "subsystem");
+	sysfs_remove_link(&dev->bus->p->devices_kset->kobj,
+			  dev_name(dev));
+	device_remove_attrs(dev->bus, dev);
+	if (klist_node_attached(&dev->p->knode_bus))
+		klist_del(&dev->p->knode_bus);
+
+	pr_debug("bus: '%s': remove device %s\n",
+		 dev->bus->name, dev_name(dev));
+	device_release_driver(dev);
+	bus_put(dev->bus);
 }
 
 static int driver_add_attrs(struct bus_type *bus, struct device_driver *drv)
@@ -847,14 +872,14 @@ static ssize_t bus_uevent_store(struct bus_type *bus,
 static BUS_ATTR(uevent, S_IWUSR, NULL, bus_uevent_store);
 
 /**
- * bus_register - register a bus with the system.
+ * __bus_register - register a driver-core subsystem
  * @bus: bus.
  *
  * Once we have that, we registered the bus with the kobject
  * infrastructure, then register the children subsystems it has:
- * the devices and drivers that belong to the bus.
+ * the devices and drivers that belong to the subsystem.
  */
-int bus_register(struct bus_type *bus)
+int __bus_register(struct bus_type *bus, struct lock_class_key *key)
 {
 	int retval;
 	struct subsys_private *priv;
@@ -898,6 +923,8 @@ int bus_register(struct bus_type *bus)
 		goto bus_drivers_fail;
 	}
 
+	INIT_LIST_HEAD(&priv->interfaces);
+	__mutex_init(&priv->mutex, "subsys mutex", key);
 	klist_init(&priv->klist_devices, klist_devices_get, klist_devices_put);
 	klist_init(&priv->klist_drivers, NULL, NULL);
 
@@ -927,7 +954,7 @@ out:
 	bus->p = NULL;
 	return retval;
 }
-EXPORT_SYMBOL_GPL(bus_register);
+EXPORT_SYMBOL_GPL(__bus_register);
 
 /**
  * bus_unregister - remove a bus from the system
@@ -939,6 +966,8 @@ EXPORT_SYMBOL_GPL(bus_register);
 void bus_unregister(struct bus_type *bus)
 {
 	pr_debug("bus: '%s': unregistering\n", bus->name);
+	if (bus->dev_root)
+		device_unregister(bus->dev_root);
 	bus_remove_attrs(bus);
 	remove_probe_files(bus);
 	kset_unregister(bus->p->drivers_kset);
@@ -1028,10 +1057,194 @@ void bus_sort_breadthfirst(struct bus_type *bus,
 }
 EXPORT_SYMBOL_GPL(bus_sort_breadthfirst);
 
+/**
+ * subsys_dev_iter_init - initialize subsys device iterator
+ * @iter: subsys iterator to initialize
+ * @subsys: the subsys we wanna iterate over
+ * @start: the device to start iterating from, if any
+ * @type: device_type of the devices to iterate over, NULL for all
+ *
+ * Initialize subsys iterator @iter such that it iterates over devices
+ * of @subsys.  If @start is set, the list iteration will start there,
+ * otherwise if it is NULL, the iteration starts at the beginning of
+ * the list.
+ */
+void subsys_dev_iter_init(struct subsys_dev_iter *iter, struct bus_type *subsys,
+			  struct device *start, const struct device_type *type)
+{
+	struct klist_node *start_knode = NULL;
+
+	if (start)
+		start_knode = &start->p->knode_bus;
+	klist_iter_init_node(&subsys->p->klist_devices, &iter->ki, start_knode);
+	iter->type = type;
+}
+EXPORT_SYMBOL_GPL(subsys_dev_iter_init);
+
+/**
+ * subsys_dev_iter_next - iterate to the next device
+ * @iter: subsys iterator to proceed
+ *
+ * Proceed @iter to the next device and return it.  Returns NULL if
+ * iteration is complete.
+ *
+ * The returned device is referenced and won't be released till
+ * iterator is proceed to the next device or exited.  The caller is
+ * free to do whatever it wants to do with the device including
+ * calling back into subsys code.
+ */
+struct device *subsys_dev_iter_next(struct subsys_dev_iter *iter)
+{
+	struct klist_node *knode;
+	struct device *dev;
+
+	for(;;) {
+		knode = klist_next(&iter->ki);
+		if (!knode)
+			return NULL;
+		dev = container_of(knode, struct device_private, knode_bus)->device;
+		if (!iter->type || iter->type == dev->type)
+			return dev;
+	}
+}
+EXPORT_SYMBOL_GPL(subsys_dev_iter_next);
+
+/**
+ * subsys_dev_iter_exit - finish iteration
+ * @iter: subsys iterator to finish
+ *
+ * Finish an iteration.  Always call this function after iteration is
+ * complete whether the iteration ran till the end or not.
+ */
+void subsys_dev_iter_exit(struct subsys_dev_iter *iter)
+{
+	klist_iter_exit(&iter->ki);
+}
+EXPORT_SYMBOL_GPL(subsys_dev_iter_exit);
+
+int subsys_interface_register(struct subsys_interface *sif)
+{
+	struct bus_type *subsys;
+	struct subsys_dev_iter iter;
+	struct device *dev;
+
+	if (!sif || !sif->subsys)
+		return -ENODEV;
+
+	subsys = bus_get(sif->subsys);
+	if (!subsys)
+		return -EINVAL;
+
+	mutex_lock(&subsys->p->mutex);
+	list_add_tail(&sif->node, &subsys->p->interfaces);
+	if (sif->add_dev) {
+		subsys_dev_iter_init(&iter, subsys, NULL, NULL);
+		while ((dev = subsys_dev_iter_next(&iter)))
+			sif->add_dev(dev, sif);
+		subsys_dev_iter_exit(&iter);
+	}
+	mutex_unlock(&subsys->p->mutex);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(subsys_interface_register);
+
+void subsys_interface_unregister(struct subsys_interface *sif)
+{
+	struct bus_type *subsys = sif->subsys;
+	struct subsys_dev_iter iter;
+	struct device *dev;
+
+	if (!sif)
+		return;
+
+	mutex_lock(&subsys->p->mutex);
+	list_del_init(&sif->node);
+	if (sif->remove_dev) {
+		subsys_dev_iter_init(&iter, subsys, NULL, NULL);
+		while ((dev = subsys_dev_iter_next(&iter)))
+			sif->remove_dev(dev, sif);
+		subsys_dev_iter_exit(&iter);
+	}
+	mutex_unlock(&subsys->p->mutex);
+
+	bus_put(subsys);
+}
+EXPORT_SYMBOL_GPL(subsys_interface_unregister);
+
+static void system_root_device_release(struct device *dev)
+{
+	kfree(dev);
+}
+/**
+ * subsys_system_register - register a subsystem at /sys/devices/system/
+ * @subsys - system subsystem
+ * @groups - default attributes for the root device
+ *
+ * All 'system' subsystems have a /sys/devices/system/<name> root device
+ * with the name of the subsystem. The root device can carry subsystem-
+ * wide attributes. All registered devices are below this single root
+ * device and are named after the subsystem with a simple enumeration
+ * number appended. The registered devices are not explicitely named;
+ * only 'id' in the device needs to be set.
+ *
+ * Do not use this interface for anything new, it exists for compatibility
+ * with bad ideas only. New subsystems should use plain subsystems; and
+ * add the subsystem-wide attributes should be added to the subsystem
+ * directory itself and not some create fake root-device placed in
+ * /sys/devices/system/<name>.
+ */
+int subsys_system_register(struct bus_type *subsys,
+		           const struct attribute_group **groups)
+{
+	struct device *dev;
+	int err;
+
+	err = bus_register(subsys);
+	if (err < 0)
+		return err;
+
+	dev = kzalloc(sizeof(struct device), GFP_KERNEL);
+	if (!dev) {
+		err = -ENOMEM;
+		goto err_dev;
+	}
+
+	err = dev_set_name(dev, "%s", subsys->name);
+	if (err < 0)
+		goto err_name;
+
+	dev->kobj.parent = &system_kset->kobj;
+	dev->groups = groups;
+	dev->release = system_root_device_release;
+
+	err = device_register(dev);
+	if (err < 0)
+		goto err_dev_reg;
+
+	subsys->dev_root = dev;
+	return 0;
+
+err_dev_reg:
+	put_device(dev);
+	dev = NULL;
+err_name:
+	kfree(dev);
+err_dev:
+	bus_unregister(subsys);
+	return err;
+}
+EXPORT_SYMBOL_GPL(subsys_system_register);
+
 int __init buses_init(void)
 {
 	bus_kset = kset_create_and_add("bus", &bus_uevent_ops, NULL);
 	if (!bus_kset)
 		return -ENOMEM;
+
+	system_kset = kset_create_and_add("system", NULL, &devices_kset->kobj);
+	if (!system_kset)
+		return -ENOMEM;
+
 	return 0;
 }
diff --git a/drivers/base/class.c b/drivers/base/class.c
index b80d91c..03243d4 100644
--- a/drivers/base/class.c
+++ b/drivers/base/class.c
@@ -184,9 +184,9 @@ int __class_register(struct class *cls, struct lock_class_key *key)
 	if (!cp)
 		return -ENOMEM;
 	klist_init(&cp->klist_devices, klist_class_dev_get, klist_class_dev_put);
-	INIT_LIST_HEAD(&cp->class_interfaces);
+	INIT_LIST_HEAD(&cp->interfaces);
 	kset_init(&cp->glue_dirs);
-	__mutex_init(&cp->class_mutex, "struct class mutex", key);
+	__mutex_init(&cp->mutex, "subsys mutex", key);
 	error = kobject_set_name(&cp->subsys.kobj, "%s", cls->name);
 	if (error) {
 		kfree(cp);
@@ -460,15 +460,15 @@ int class_interface_register(struct class_interface *class_intf)
 	if (!parent)
 		return -EINVAL;
 
-	mutex_lock(&parent->p->class_mutex);
-	list_add_tail(&class_intf->node, &parent->p->class_interfaces);
+	mutex_lock(&parent->p->mutex);
+	list_add_tail(&class_intf->node, &parent->p->interfaces);
 	if (class_intf->add_dev) {
 		class_dev_iter_init(&iter, parent, NULL, NULL);
 		while ((dev = class_dev_iter_next(&iter)))
 			class_intf->add_dev(dev, class_intf);
 		class_dev_iter_exit(&iter);
 	}
-	mutex_unlock(&parent->p->class_mutex);
+	mutex_unlock(&parent->p->mutex);
 
 	return 0;
 }
@@ -482,7 +482,7 @@ void class_interface_unregister(struct class_interface *class_intf)
 	if (!parent)
 		return;
 
-	mutex_lock(&parent->p->class_mutex);
+	mutex_lock(&parent->p->mutex);
 	list_del_init(&class_intf->node);
 	if (class_intf->remove_dev) {
 		class_dev_iter_init(&iter, parent, NULL, NULL);
@@ -490,7 +490,7 @@ void class_interface_unregister(struct class_interface *class_intf)
 			class_intf->remove_dev(dev, class_intf);
 		class_dev_iter_exit(&iter);
 	}
-	mutex_unlock(&parent->p->class_mutex);
+	mutex_unlock(&parent->p->mutex);
 
 	class_put(parent);
 }
diff --git a/drivers/base/core.c b/drivers/base/core.c
index d8b3d89..2dbe801 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -118,6 +118,56 @@ static const struct sysfs_ops dev_sysfs_ops = {
 	.store	= dev_attr_store,
 };
 
+#define to_ext_attr(x) container_of(x, struct dev_ext_attribute, attr)
+
+ssize_t device_store_ulong(struct device *dev,
+			   struct device_attribute *attr,
+			   const char *buf, size_t size)
+{
+	struct dev_ext_attribute *ea = to_ext_attr(attr);
+	char *end;
+	unsigned long new = simple_strtoul(buf, &end, 0);
+	if (end == buf)
+		return -EINVAL;
+	*(unsigned long *)(ea->var) = new;
+	/* Always return full write size even if we didn't consume all */
+	return size;
+}
+EXPORT_SYMBOL_GPL(device_store_ulong);
+
+ssize_t device_show_ulong(struct device *dev,
+			  struct device_attribute *attr,
+			  char *buf)
+{
+	struct dev_ext_attribute *ea = to_ext_attr(attr);
+	return snprintf(buf, PAGE_SIZE, "%lx\n", *(unsigned long *)(ea->var));
+}
+EXPORT_SYMBOL_GPL(device_show_ulong);
+
+ssize_t device_store_int(struct device *dev,
+			 struct device_attribute *attr,
+			 const char *buf, size_t size)
+{
+	struct dev_ext_attribute *ea = to_ext_attr(attr);
+	char *end;
+	long new = simple_strtol(buf, &end, 0);
+	if (end == buf || new > INT_MAX || new < INT_MIN)
+		return -EINVAL;
+	*(int *)(ea->var) = new;
+	/* Always return full write size even if we didn't consume all */
+	return size;
+}
+EXPORT_SYMBOL_GPL(device_store_int);
+
+ssize_t device_show_int(struct device *dev,
+			struct device_attribute *attr,
+			char *buf)
+{
+	struct dev_ext_attribute *ea = to_ext_attr(attr);
+
+	return snprintf(buf, PAGE_SIZE, "%d\n", *(int *)(ea->var));
+}
+EXPORT_SYMBOL_GPL(device_show_int);
 
 /**
  *	device_release - free device structure.
@@ -464,7 +514,7 @@ static ssize_t show_dev(struct device *dev, struct device_attribute *attr,
 static struct device_attribute devt_attr =
 	__ATTR(dev, S_IRUGO, show_dev, NULL);
 
-/* kset to create /sys/devices/  */
+/* /sys/devices/ */
 struct kset *devices_kset;
 
 /**
@@ -711,6 +761,10 @@ static struct kobject *get_device_parent(struct device *dev,
 		return k;
 	}
 
+	/* subsystems can specify a default root directory for their devices */
+	if (!parent && dev->bus && dev->bus->dev_root)
+		return &dev->bus->dev_root->kobj;
+
 	if (parent)
 		return &parent->kobj;
 	return NULL;
@@ -731,14 +785,6 @@ static void cleanup_device_parent(struct device *dev)
 	cleanup_glue_dir(dev, dev->kobj.parent);
 }
 
-static void setup_parent(struct device *dev, struct device *parent)
-{
-	struct kobject *kobj;
-	kobj = get_device_parent(dev, parent);
-	if (kobj)
-		dev->kobj.parent = kobj;
-}
-
 static int device_add_class_symlinks(struct device *dev)
 {
 	int error;
@@ -891,6 +937,7 @@ int device_private_init(struct device *dev)
 int device_add(struct device *dev)
 {
 	struct device *parent = NULL;
+	struct kobject *kobj;
 	struct class_interface *class_intf;
 	int error = -EINVAL;
 
@@ -914,6 +961,10 @@ int device_add(struct device *dev)
 		dev->init_name = NULL;
 	}
 
+	/* subsystems can specify simple device enumeration */
+	if (!dev_name(dev) && dev->bus && dev->bus->dev_name)
+		dev_set_name(dev, "%s%u", dev->bus->dev_name, dev->id);
+
 	if (!dev_name(dev)) {
 		error = -EINVAL;
 		goto name_error;
@@ -922,7 +973,9 @@ int device_add(struct device *dev)
 	pr_debug("device: '%s': %s\n", dev_name(dev), __func__);
 
 	parent = get_device(dev->parent);
-	setup_parent(dev, parent);
+	kobj = get_device_parent(dev, parent);
+	if (kobj)
+		dev->kobj.parent = kobj;
 
 	/* use parent numa_node */
 	if (parent)
@@ -982,17 +1035,17 @@ int device_add(struct device *dev)
 			       &parent->p->klist_children);
 
 	if (dev->class) {
-		mutex_lock(&dev->class->p->class_mutex);
+		mutex_lock(&dev->class->p->mutex);
 		/* tie the class to the device */
 		klist_add_tail(&dev->knode_class,
 			       &dev->class->p->klist_devices);
 
 		/* notify any interfaces that the device is here */
 		list_for_each_entry(class_intf,
-				    &dev->class->p->class_interfaces, node)
+				    &dev->class->p->interfaces, node)
 			if (class_intf->add_dev)
 				class_intf->add_dev(dev, class_intf);
-		mutex_unlock(&dev->class->p->class_mutex);
+		mutex_unlock(&dev->class->p->mutex);
 	}
 done:
 	put_device(dev);
@@ -1107,15 +1160,15 @@ void device_del(struct device *dev)
 	if (dev->class) {
 		device_remove_class_symlinks(dev);
 
-		mutex_lock(&dev->class->p->class_mutex);
+		mutex_lock(&dev->class->p->mutex);
 		/* notify any interfaces that the device is now gone */
 		list_for_each_entry(class_intf,
-				    &dev->class->p->class_interfaces, node)
+				    &dev->class->p->interfaces, node)
 			if (class_intf->remove_dev)
 				class_intf->remove_dev(dev, class_intf);
 		/* remove the device from the class list */
 		klist_del(&dev->knode_class);
-		mutex_unlock(&dev->class->p->class_mutex);
+		mutex_unlock(&dev->class->p->mutex);
 	}
 	device_remove_file(dev, &uevent_attr);
 	device_remove_attrs(dev);
diff --git a/drivers/base/cpu.c b/drivers/base/cpu.c
index 251acea..5bb0298 100644
--- a/drivers/base/cpu.c
+++ b/drivers/base/cpu.c
@@ -1,8 +1,7 @@
 /*
- * drivers/base/cpu.c - basic CPU class support
+ * CPU subsystem support
  */
 
-#include <linux/sysdev.h>
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/sched.h>
@@ -14,40 +13,40 @@
 
 #include "base.h"
 
-static struct sysdev_class_attribute *cpu_sysdev_class_attrs[];
-
-struct sysdev_class cpu_sysdev_class = {
+struct bus_type cpu_subsys = {
 	.name = "cpu",
-	.attrs = cpu_sysdev_class_attrs,
+	.dev_name = "cpu",
 };
-EXPORT_SYMBOL(cpu_sysdev_class);
+EXPORT_SYMBOL_GPL(cpu_subsys);
 
-static DEFINE_PER_CPU(struct sys_device *, cpu_sys_devices);
+static DEFINE_PER_CPU(struct device *, cpu_sys_devices);
 
 #ifdef CONFIG_HOTPLUG_CPU
-static ssize_t show_online(struct sys_device *dev, struct sysdev_attribute *attr,
+static ssize_t show_online(struct device *dev,
+			   struct device_attribute *attr,
 			   char *buf)
 {
-	struct cpu *cpu = container_of(dev, struct cpu, sysdev);
+	struct cpu *cpu = container_of(dev, struct cpu, dev);
 
-	return sprintf(buf, "%u\n", !!cpu_online(cpu->sysdev.id));
+	return sprintf(buf, "%u\n", !!cpu_online(cpu->dev.id));
 }
 
-static ssize_t __ref store_online(struct sys_device *dev, struct sysdev_attribute *attr,
-				 const char *buf, size_t count)
+static ssize_t __ref store_online(struct device *dev,
+				  struct device_attribute *attr,
+				  const char *buf, size_t count)
 {
-	struct cpu *cpu = container_of(dev, struct cpu, sysdev);
+	struct cpu *cpu = container_of(dev, struct cpu, dev);
 	ssize_t ret;
 
 	cpu_hotplug_driver_lock();
 	switch (buf[0]) {
 	case '0':
-		ret = cpu_down(cpu->sysdev.id);
+		ret = cpu_down(cpu->dev.id);
 		if (!ret)
 			kobject_uevent(&dev->kobj, KOBJ_OFFLINE);
 		break;
 	case '1':
-		ret = cpu_up(cpu->sysdev.id);
+		ret = cpu_up(cpu->dev.id);
 		if (!ret)
 			kobject_uevent(&dev->kobj, KOBJ_ONLINE);
 		break;
@@ -60,44 +59,44 @@ static ssize_t __ref store_online(struct sys_device *dev, struct sysdev_attribut
 		ret = count;
 	return ret;
 }
-static SYSDEV_ATTR(online, 0644, show_online, store_online);
+static DEVICE_ATTR(online, 0644, show_online, store_online);
 
 static void __cpuinit register_cpu_control(struct cpu *cpu)
 {
-	sysdev_create_file(&cpu->sysdev, &attr_online);
+	device_create_file(&cpu->dev, &dev_attr_online);
 }
 void unregister_cpu(struct cpu *cpu)
 {
-	int logical_cpu = cpu->sysdev.id;
+	int logical_cpu = cpu->dev.id;
 
 	unregister_cpu_under_node(logical_cpu, cpu_to_node(logical_cpu));
 
-	sysdev_remove_file(&cpu->sysdev, &attr_online);
+	device_remove_file(&cpu->dev, &dev_attr_online);
 
-	sysdev_unregister(&cpu->sysdev);
+	device_unregister(&cpu->dev);
 	per_cpu(cpu_sys_devices, logical_cpu) = NULL;
 	return;
 }
 
 #ifdef CONFIG_ARCH_CPU_PROBE_RELEASE
-static ssize_t cpu_probe_store(struct sysdev_class *class,
-			       struct sysdev_class_attribute *attr,
+static ssize_t cpu_probe_store(struct device *dev,
+			       struct device_attribute *attr,
 			       const char *buf,
 			       size_t count)
 {
 	return arch_cpu_probe(buf, count);
 }
 
-static ssize_t cpu_release_store(struct sysdev_class *class,
-				 struct sysdev_class_attribute *attr,
+static ssize_t cpu_release_store(struct device *dev,
+				 struct device_attribute *attr,
 				 const char *buf,
 				 size_t count)
 {
 	return arch_cpu_release(buf, count);
 }
 
-static SYSDEV_CLASS_ATTR(probe, S_IWUSR, NULL, cpu_probe_store);
-static SYSDEV_CLASS_ATTR(release, S_IWUSR, NULL, cpu_release_store);
+static DEVICE_ATTR(probe, S_IWUSR, NULL, cpu_probe_store);
+static DEVICE_ATTR(release, S_IWUSR, NULL, cpu_release_store);
 #endif /* CONFIG_ARCH_CPU_PROBE_RELEASE */
 
 #else /* ... !CONFIG_HOTPLUG_CPU */
@@ -109,15 +108,15 @@ static inline void register_cpu_control(struct cpu *cpu)
 #ifdef CONFIG_KEXEC
 #include <linux/kexec.h>
 
-static ssize_t show_crash_notes(struct sys_device *dev, struct sysdev_attribute *attr,
+static ssize_t show_crash_notes(struct device *dev, struct device_attribute *attr,
 				char *buf)
 {
-	struct cpu *cpu = container_of(dev, struct cpu, sysdev);
+	struct cpu *cpu = container_of(dev, struct cpu, dev);
 	ssize_t rc;
 	unsigned long long addr;
 	int cpunum;
 
-	cpunum = cpu->sysdev.id;
+	cpunum = cpu->dev.id;
 
 	/*
 	 * Might be reading other cpu's data based on which cpu read thread
@@ -129,7 +128,7 @@ static ssize_t show_crash_notes(struct sys_device *dev, struct sysdev_attribute
 	rc = sprintf(buf, "%Lx\n", addr);
 	return rc;
 }
-static SYSDEV_ATTR(crash_notes, 0400, show_crash_notes, NULL);
+static DEVICE_ATTR(crash_notes, 0400, show_crash_notes, NULL);
 #endif
 
 /*
@@ -137,12 +136,12 @@ static SYSDEV_ATTR(crash_notes, 0400, show_crash_notes, NULL);
  */
 
 struct cpu_attr {
-	struct sysdev_class_attribute attr;
+	struct device_attribute attr;
 	const struct cpumask *const * const map;
 };
 
-static ssize_t show_cpus_attr(struct sysdev_class *class,
-			      struct sysdev_class_attribute *attr,
+static ssize_t show_cpus_attr(struct device *dev,
+			      struct device_attribute *attr,
 			      char *buf)
 {
 	struct cpu_attr *ca = container_of(attr, struct cpu_attr, attr);
@@ -153,10 +152,10 @@ static ssize_t show_cpus_attr(struct sysdev_class *class,
 	return n;
 }
 
-#define _CPU_ATTR(name, map)						\
-	{ _SYSDEV_CLASS_ATTR(name, 0444, show_cpus_attr, NULL), map }
+#define _CPU_ATTR(name, map) \
+	{ __ATTR(name, 0444, show_cpus_attr, NULL), map }
 
-/* Keep in sync with cpu_sysdev_class_attrs */
+/* Keep in sync with cpu_subsys_attrs */
 static struct cpu_attr cpu_attrs[] = {
 	_CPU_ATTR(online, &cpu_online_mask),
 	_CPU_ATTR(possible, &cpu_possible_mask),
@@ -166,19 +165,19 @@ static struct cpu_attr cpu_attrs[] = {
 /*
  * Print values for NR_CPUS and offlined cpus
  */
-static ssize_t print_cpus_kernel_max(struct sysdev_class *class,
-				     struct sysdev_class_attribute *attr, char *buf)
+static ssize_t print_cpus_kernel_max(struct device *dev,
+				     struct device_attribute *attr, char *buf)
 {
 	int n = snprintf(buf, PAGE_SIZE-2, "%d\n", NR_CPUS - 1);
 	return n;
 }
-static SYSDEV_CLASS_ATTR(kernel_max, 0444, print_cpus_kernel_max, NULL);
+static DEVICE_ATTR(kernel_max, 0444, print_cpus_kernel_max, NULL);
 
 /* arch-optional setting to enable display of offline cpus >= nr_cpu_ids */
 unsigned int total_cpus;
 
-static ssize_t print_cpus_offline(struct sysdev_class *class,
-				  struct sysdev_class_attribute *attr, char *buf)
+static ssize_t print_cpus_offline(struct device *dev,
+				  struct device_attribute *attr, char *buf)
 {
 	int n = 0, len = PAGE_SIZE-2;
 	cpumask_var_t offline;
@@ -205,7 +204,7 @@ static ssize_t print_cpus_offline(struct sysdev_class *class,
 	n += snprintf(&buf[n], len - n, "\n");
 	return n;
 }
-static SYSDEV_CLASS_ATTR(offline, 0444, print_cpus_offline, NULL);
+static DEVICE_ATTR(offline, 0444, print_cpus_offline, NULL);
 
 /*
  * register_cpu - Setup a sysfs device for a CPU.
@@ -218,57 +217,66 @@ static SYSDEV_CLASS_ATTR(offline, 0444, print_cpus_offline, NULL);
 int __cpuinit register_cpu(struct cpu *cpu, int num)
 {
 	int error;
-	cpu->node_id = cpu_to_node(num);
-	cpu->sysdev.id = num;
-	cpu->sysdev.cls = &cpu_sysdev_class;
-
-	error = sysdev_register(&cpu->sysdev);
 
+	cpu->node_id = cpu_to_node(num);
+	cpu->dev.id = num;
+	cpu->dev.bus = &cpu_subsys;
+	error = device_register(&cpu->dev);
 	if (!error && cpu->hotpluggable)
 		register_cpu_control(cpu);
 	if (!error)
-		per_cpu(cpu_sys_devices, num) = &cpu->sysdev;
+		per_cpu(cpu_sys_devices, num) = &cpu->dev;
 	if (!error)
 		register_cpu_under_node(num, cpu_to_node(num));
 
 #ifdef CONFIG_KEXEC
 	if (!error)
-		error = sysdev_create_file(&cpu->sysdev, &attr_crash_notes);
+		error = device_create_file(&cpu->dev, &dev_attr_crash_notes);
 #endif
 	return error;
 }
 
-struct sys_device *get_cpu_sysdev(unsigned cpu)
+struct device *get_cpu_device(unsigned cpu)
 {
 	if (cpu < nr_cpu_ids && cpu_possible(cpu))
 		return per_cpu(cpu_sys_devices, cpu);
 	else
 		return NULL;
 }
-EXPORT_SYMBOL_GPL(get_cpu_sysdev);
+EXPORT_SYMBOL_GPL(get_cpu_device);
+
+static struct attribute *cpu_root_attrs[] = {
+#ifdef CONFIG_ARCH_CPU_PROBE_RELEASE
+	&dev_attr_probe.attr,
+	&dev_attr_release.attr,
+#endif
+	&cpu_attrs[0].attr.attr,
+	&cpu_attrs[1].attr.attr,
+	&cpu_attrs[2].attr.attr,
+	&dev_attr_kernel_max.attr,
+	&dev_attr_offline.attr,
+	NULL
+};
+
+static struct attribute_group cpu_root_attr_group = {
+	.attrs = cpu_root_attrs,
+};
+
+static const struct attribute_group *cpu_root_attr_groups[] = {
+	&cpu_root_attr_group,
+	NULL,
+};
 
 int __init cpu_dev_init(void)
 {
 	int err;
 
-	err = sysdev_class_register(&cpu_sysdev_class);
+	err = subsys_system_register(&cpu_subsys, cpu_root_attr_groups);
+	if (err)
+		return err;
+
 #if defined(CONFIG_SCHED_MC) || defined(CONFIG_SCHED_SMT)
-	if (!err)
-		err = sched_create_sysfs_power_savings_entries(&cpu_sysdev_class);
+	err = sched_create_sysfs_power_savings_entries(cpu_subsys.dev_root);
 #endif
-
 	return err;
 }
-
-static struct sysdev_class_attribute *cpu_sysdev_class_attrs[] = {
-#ifdef CONFIG_ARCH_CPU_PROBE_RELEASE
-	&attr_probe,
-	&attr_release,
-#endif
-	&cpu_attrs[0].attr,
-	&cpu_attrs[1].attr,
-	&cpu_attrs[2].attr,
-	&attr_kernel_max,
-	&attr_offline,
-	NULL
-};
diff --git a/drivers/base/init.c b/drivers/base/init.c
index c8a934e..c16f0b8 100644
--- a/drivers/base/init.c
+++ b/drivers/base/init.c
@@ -31,7 +31,6 @@ void __init driver_init(void)
 	 * core core pieces.
 	 */
 	platform_bus_init();
-	system_bus_init();
 	cpu_dev_init();
 	memory_dev_init();
 }
diff --git a/drivers/base/memory.c b/drivers/base/memory.c
index 8272d92..3edb9c9 100644
--- a/drivers/base/memory.c
+++ b/drivers/base/memory.c
@@ -1,5 +1,5 @@
 /*
- * drivers/base/memory.c - basic Memory class support
+ * Memory subsystem support
  *
  * Written by Matt Tolentino <matthew.e.tolentino@intel.com>
  *            Dave Hansen <haveblue@us.ibm.com>
@@ -10,7 +10,6 @@
  * SPARSEMEM should be contained here, or in mm/memory_hotplug.c.
  */
 
-#include <linux/sysdev.h>
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/topology.h>
@@ -38,26 +37,9 @@ static inline int base_memory_block_id(int section_nr)
 	return section_nr / sections_per_block;
 }
 
-static struct sysdev_class memory_sysdev_class = {
+static struct bus_type memory_subsys = {
 	.name = MEMORY_CLASS_NAME,
-};
-
-static const char *memory_uevent_name(struct kset *kset, struct kobject *kobj)
-{
-	return MEMORY_CLASS_NAME;
-}
-
-static int memory_uevent(struct kset *kset, struct kobject *obj,
-			struct kobj_uevent_env *env)
-{
-	int retval = 0;
-
-	return retval;
-}
-
-static const struct kset_uevent_ops memory_uevent_ops = {
-	.name		= memory_uevent_name,
-	.uevent		= memory_uevent,
+	.dev_name = MEMORY_CLASS_NAME,
 };
 
 static BLOCKING_NOTIFIER_HEAD(memory_chain);
@@ -96,21 +78,21 @@ int register_memory(struct memory_block *memory)
 {
 	int error;
 
-	memory->sysdev.cls = &memory_sysdev_class;
-	memory->sysdev.id = memory->start_section_nr / sections_per_block;
+	memory->dev.bus = &memory_subsys;
+	memory->dev.id = memory->start_section_nr / sections_per_block;
 
-	error = sysdev_register(&memory->sysdev);
+	error = device_register(&memory->dev);
 	return error;
 }
 
 static void
 unregister_memory(struct memory_block *memory)
 {
-	BUG_ON(memory->sysdev.cls != &memory_sysdev_class);
+	BUG_ON(memory->dev.bus != &memory_subsys);
 
 	/* drop the ref. we got in remove_memory_block() */
-	kobject_put(&memory->sysdev.kobj);
-	sysdev_unregister(&memory->sysdev);
+	kobject_put(&memory->dev.kobj);
+	device_unregister(&memory->dev);
 }
 
 unsigned long __weak memory_block_size_bytes(void)
@@ -138,22 +120,22 @@ static unsigned long get_memory_block_size(void)
  * uses.
  */
 
-static ssize_t show_mem_start_phys_index(struct sys_device *dev,
-			struct sysdev_attribute *attr, char *buf)
+static ssize_t show_mem_start_phys_index(struct device *dev,
+			struct device_attribute *attr, char *buf)
 {
 	struct memory_block *mem =
-		container_of(dev, struct memory_block, sysdev);
+		container_of(dev, struct memory_block, dev);
 	unsigned long phys_index;
 
 	phys_index = mem->start_section_nr / sections_per_block;
 	return sprintf(buf, "%08lx\n", phys_index);
 }
 
-static ssize_t show_mem_end_phys_index(struct sys_device *dev,
-			struct sysdev_attribute *attr, char *buf)
+static ssize_t show_mem_end_phys_index(struct device *dev,
+			struct device_attribute *attr, char *buf)
 {
 	struct memory_block *mem =
-		container_of(dev, struct memory_block, sysdev);
+		container_of(dev, struct memory_block, dev);
 	unsigned long phys_index;
 
 	phys_index = mem->end_section_nr / sections_per_block;
@@ -163,13 +145,13 @@ static ssize_t show_mem_end_phys_index(struct sys_device *dev,
 /*
  * Show whether the section of memory is likely to be hot-removable
  */
-static ssize_t show_mem_removable(struct sys_device *dev,
-			struct sysdev_attribute *attr, char *buf)
+static ssize_t show_mem_removable(struct device *dev,
+			struct device_attribute *attr, char *buf)
 {
 	unsigned long i, pfn;
 	int ret = 1;
 	struct memory_block *mem =
-		container_of(dev, struct memory_block, sysdev);
+		container_of(dev, struct memory_block, dev);
 
 	for (i = 0; i < sections_per_block; i++) {
 		pfn = section_nr_to_pfn(mem->start_section_nr + i);
@@ -182,11 +164,11 @@ static ssize_t show_mem_removable(struct sys_device *dev,
 /*
  * online, offline, going offline, etc.
  */
-static ssize_t show_mem_state(struct sys_device *dev,
-			struct sysdev_attribute *attr, char *buf)
+static ssize_t show_mem_state(struct device *dev,
+			struct device_attribute *attr, char *buf)
 {
 	struct memory_block *mem =
-		container_of(dev, struct memory_block, sysdev);
+		container_of(dev, struct memory_block, dev);
 	ssize_t len = 0;
 
 	/*
@@ -324,13 +306,13 @@ out:
 }
 
 static ssize_t
-store_mem_state(struct sys_device *dev,
-		struct sysdev_attribute *attr, const char *buf, size_t count)
+store_mem_state(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count)
 {
 	struct memory_block *mem;
 	int ret = -EINVAL;
 
-	mem = container_of(dev, struct memory_block, sysdev);
+	mem = container_of(dev, struct memory_block, dev);
 
 	if (!strncmp(buf, "online", min((int)count, 6)))
 		ret = memory_block_change_state(mem, MEM_ONLINE, MEM_OFFLINE);
@@ -351,41 +333,41 @@ store_mem_state(struct sys_device *dev,
  * s.t. if I offline all of these sections I can then
  * remove the physical device?
  */
-static ssize_t show_phys_device(struct sys_device *dev,
-				struct sysdev_attribute *attr, char *buf)
+static ssize_t show_phys_device(struct device *dev,
+				struct device_attribute *attr, char *buf)
 {
 	struct memory_block *mem =
-		container_of(dev, struct memory_block, sysdev);
+		container_of(dev, struct memory_block, dev);
 	return sprintf(buf, "%d\n", mem->phys_device);
 }
 
-static SYSDEV_ATTR(phys_index, 0444, show_mem_start_phys_index, NULL);
-static SYSDEV_ATTR(end_phys_index, 0444, show_mem_end_phys_index, NULL);
-static SYSDEV_ATTR(state, 0644, show_mem_state, store_mem_state);
-static SYSDEV_ATTR(phys_device, 0444, show_phys_device, NULL);
-static SYSDEV_ATTR(removable, 0444, show_mem_removable, NULL);
+static DEVICE_ATTR(phys_index, 0444, show_mem_start_phys_index, NULL);
+static DEVICE_ATTR(end_phys_index, 0444, show_mem_end_phys_index, NULL);
+static DEVICE_ATTR(state, 0644, show_mem_state, store_mem_state);
+static DEVICE_ATTR(phys_device, 0444, show_phys_device, NULL);
+static DEVICE_ATTR(removable, 0444, show_mem_removable, NULL);
 
 #define mem_create_simple_file(mem, attr_name)	\
-	sysdev_create_file(&mem->sysdev, &attr_##attr_name)
+	device_create_file(&mem->dev, &dev_attr_##attr_name)
 #define mem_remove_simple_file(mem, attr_name)	\
-	sysdev_remove_file(&mem->sysdev, &attr_##attr_name)
+	device_remove_file(&mem->dev, &dev_attr_##attr_name)
 
 /*
  * Block size attribute stuff
  */
 static ssize_t
-print_block_size(struct sysdev_class *class, struct sysdev_class_attribute *attr,
+print_block_size(struct device *dev, struct device_attribute *attr,
 		 char *buf)
 {
 	return sprintf(buf, "%lx\n", get_memory_block_size());
 }
 
-static SYSDEV_CLASS_ATTR(block_size_bytes, 0444, print_block_size, NULL);
+static DEVICE_ATTR(block_size_bytes, 0444, print_block_size, NULL);
 
 static int block_size_init(void)
 {
-	return sysfs_create_file(&memory_sysdev_class.kset.kobj,
-				&attr_block_size_bytes.attr);
+	return device_create_file(memory_subsys.dev_root,
+				  &dev_attr_block_size_bytes);
 }
 
 /*
@@ -396,7 +378,7 @@ static int block_size_init(void)
  */
 #ifdef CONFIG_ARCH_MEMORY_PROBE
 static ssize_t
-memory_probe_store(struct class *class, struct class_attribute *attr,
+memory_probe_store(struct device *dev, struct device_attribute *attr,
 		   const char *buf, size_t count)
 {
 	u64 phys_addr;
@@ -423,12 +405,11 @@ memory_probe_store(struct class *class, struct class_attribute *attr,
 out:
 	return ret;
 }
-static CLASS_ATTR(probe, S_IWUSR, NULL, memory_probe_store);
+static DEVICE_ATTR(probe, S_IWUSR, NULL, memory_probe_store);
 
 static int memory_probe_init(void)
 {
-	return sysfs_create_file(&memory_sysdev_class.kset.kobj,
-				&class_attr_probe.attr);
+	return device_create_file(memory_subsys.dev_root, &dev_attr_probe);
 }
 #else
 static inline int memory_probe_init(void)
@@ -444,8 +425,8 @@ static inline int memory_probe_init(void)
 
 /* Soft offline a page */
 static ssize_t
-store_soft_offline_page(struct class *class,
-			struct class_attribute *attr,
+store_soft_offline_page(struct device *dev,
+			struct device_attribute *attr,
 			const char *buf, size_t count)
 {
 	int ret;
@@ -463,8 +444,8 @@ store_soft_offline_page(struct class *class,
 
 /* Forcibly offline a page, including killing processes. */
 static ssize_t
-store_hard_offline_page(struct class *class,
-			struct class_attribute *attr,
+store_hard_offline_page(struct device *dev,
+			struct device_attribute *attr,
 			const char *buf, size_t count)
 {
 	int ret;
@@ -478,18 +459,18 @@ store_hard_offline_page(struct class *class,
 	return ret ? ret : count;
 }
 
-static CLASS_ATTR(soft_offline_page, 0644, NULL, store_soft_offline_page);
-static CLASS_ATTR(hard_offline_page, 0644, NULL, store_hard_offline_page);
+static DEVICE_ATTR(soft_offline_page, 0644, NULL, store_soft_offline_page);
+static DEVICE_ATTR(hard_offline_page, 0644, NULL, store_hard_offline_page);
 
 static __init int memory_fail_init(void)
 {
 	int err;
 
-	err = sysfs_create_file(&memory_sysdev_class.kset.kobj,
-				&class_attr_soft_offline_page.attr);
+	err = device_create_file(memory_susbsy.dev_root,
+				&dev_attr_soft_offline_page.attr);
 	if (!err)
-		err = sysfs_create_file(&memory_sysdev_class.kset.kobj,
-				&class_attr_hard_offline_page.attr);
+		err = device_create_file(memory_subsys.dev_root,
+				&dev_attr_hard_offline_page.attr);
 	return err;
 }
 #else
@@ -513,25 +494,26 @@ struct memory_block *find_memory_block_hinted(struct mem_section *section,
 					      struct memory_block *hint)
 {
 	struct kobject *kobj;
-	struct sys_device *sysdev;
+	struct device *dev;
 	struct memory_block *mem;
 	char name[sizeof(MEMORY_CLASS_NAME) + 9 + 1];
 	int block_id = base_memory_block_id(__section_nr(section));
 
-	kobj = hint ? &hint->sysdev.kobj : NULL;
+	kobj = hint ? &hint->dev.kobj : NULL;
 
 	/*
-	 * This only works because we know that section == sysdev->id
+	 * This only works because we know that section == dev->id
 	 * slightly redundant with sysdev_register()
 	 */
 	sprintf(&name[0], "%s%d", MEMORY_CLASS_NAME, block_id);
 
-	kobj = kset_find_obj_hinted(&memory_sysdev_class.kset, name, kobj);
+	//FIXME
+	//kobj = kset_find_obj_hinted(memory_subsys, name, kobj);
 	if (!kobj)
 		return NULL;
 
-	sysdev = container_of(kobj, struct sys_device, kobj);
-	mem = container_of(sysdev, struct memory_block, sysdev);
+	dev = container_of(kobj, struct device, kobj);
+	mem = container_of(dev, struct memory_block, dev);
 
 	return mem;
 }
@@ -542,7 +524,7 @@ struct memory_block *find_memory_block_hinted(struct mem_section *section,
  * this gets to be a real problem, we can always use a radix
  * tree or something here.
  *
- * This could be made generic for all sysdev classes.
+ * This could be made generic for all device subsystems.
  */
 struct memory_block *find_memory_block(struct mem_section *section)
 {
@@ -598,7 +580,7 @@ static int add_memory_section(int nid, struct mem_section *section,
 	mem = find_memory_block(section);
 	if (mem) {
 		mem->section_count++;
-		kobject_put(&mem->sysdev.kobj);
+		kobject_put(&mem->dev.kobj);
 	} else
 		ret = init_memory_block(&mem, section, state);
 
@@ -631,7 +613,7 @@ int remove_memory_block(unsigned long node_id, struct mem_section *section,
 		unregister_memory(mem);
 		kfree(mem);
 	} else
-		kobject_put(&mem->sysdev.kobj);
+		kobject_put(&mem->dev.kobj);
 
 	mutex_unlock(&mem_sysfs_mutex);
 	return 0;
@@ -664,8 +646,7 @@ int __init memory_dev_init(void)
 	int err;
 	unsigned long block_sz;
 
-	memory_sysdev_class.kset.uevent_ops = &memory_uevent_ops;
-	ret = sysdev_class_register(&memory_sysdev_class);
+	ret = subsys_system_register(&memory_subsys, NULL);
 	if (ret)
 		goto out;
 
diff --git a/drivers/base/node.c b/drivers/base/node.c
index 5693ece..340ba6e 100644
--- a/drivers/base/node.c
+++ b/drivers/base/node.c
@@ -1,8 +1,7 @@
 /*
- * drivers/base/node.c - basic Node class support
+ * Basic Node interface support
  */
 
-#include <linux/sysdev.h>
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/mm.h>
@@ -19,18 +18,16 @@
 #include <linux/swap.h>
 #include <linux/slab.h>
 
-static struct sysdev_class_attribute *node_state_attrs[];
-
-static struct sysdev_class node_class = {
+static struct bus_type node_subsys = {
 	.name = "node",
-	.attrs = node_state_attrs,
+	.dev_name = "node",
 };
 
 
-static ssize_t node_read_cpumap(struct sys_device *dev, int type, char *buf)
+static ssize_t node_read_cpumap(struct device *dev, int type, char *buf)
 {
 	struct node *node_dev = to_node(dev);
-	const struct cpumask *mask = cpumask_of_node(node_dev->sysdev.id);
+	const struct cpumask *mask = cpumask_of_node(node_dev->dev.id);
 	int len;
 
 	/* 2008/04/07: buf currently PAGE_SIZE, need 9 chars per 32 bits. */
@@ -44,23 +41,23 @@ static ssize_t node_read_cpumap(struct sys_device *dev, int type, char *buf)
 	return len;
 }
 
-static inline ssize_t node_read_cpumask(struct sys_device *dev,
-				struct sysdev_attribute *attr, char *buf)
+static inline ssize_t node_read_cpumask(struct device *dev,
+				struct device_attribute *attr, char *buf)
 {
 	return node_read_cpumap(dev, 0, buf);
 }
-static inline ssize_t node_read_cpulist(struct sys_device *dev,
-				struct sysdev_attribute *attr, char *buf)
+static inline ssize_t node_read_cpulist(struct device *dev,
+				struct device_attribute *attr, char *buf)
 {
 	return node_read_cpumap(dev, 1, buf);
 }
 
-static SYSDEV_ATTR(cpumap,  S_IRUGO, node_read_cpumask, NULL);
-static SYSDEV_ATTR(cpulist, S_IRUGO, node_read_cpulist, NULL);
+static DEVICE_ATTR(cpumap,  S_IRUGO, node_read_cpumask, NULL);
+static DEVICE_ATTR(cpulist, S_IRUGO, node_read_cpulist, NULL);
 
 #define K(x) ((x) << (PAGE_SHIFT - 10))
-static ssize_t node_read_meminfo(struct sys_device * dev,
-			struct sysdev_attribute *attr, char * buf)
+static ssize_t node_read_meminfo(struct device * dev,
+			struct device_attribute *attr, char * buf)
 {
 	int n;
 	int nid = dev->id;
@@ -157,10 +154,10 @@ static ssize_t node_read_meminfo(struct sys_device * dev,
 }
 
 #undef K
-static SYSDEV_ATTR(meminfo, S_IRUGO, node_read_meminfo, NULL);
+static DEVICE_ATTR(meminfo, S_IRUGO, node_read_meminfo, NULL);
 
-static ssize_t node_read_numastat(struct sys_device * dev,
-				struct sysdev_attribute *attr, char * buf)
+static ssize_t node_read_numastat(struct device * dev,
+				struct device_attribute *attr, char * buf)
 {
 	return sprintf(buf,
 		       "numa_hit %lu\n"
@@ -176,10 +173,10 @@ static ssize_t node_read_numastat(struct sys_device * dev,
 		       node_page_state(dev->id, NUMA_LOCAL),
 		       node_page_state(dev->id, NUMA_OTHER));
 }
-static SYSDEV_ATTR(numastat, S_IRUGO, node_read_numastat, NULL);
+static DEVICE_ATTR(numastat, S_IRUGO, node_read_numastat, NULL);
 
-static ssize_t node_read_vmstat(struct sys_device *dev,
-				struct sysdev_attribute *attr, char *buf)
+static ssize_t node_read_vmstat(struct device *dev,
+				struct device_attribute *attr, char *buf)
 {
 	int nid = dev->id;
 	int i;
@@ -191,10 +188,10 @@ static ssize_t node_read_vmstat(struct sys_device *dev,
 
 	return n;
 }
-static SYSDEV_ATTR(vmstat, S_IRUGO, node_read_vmstat, NULL);
+static DEVICE_ATTR(vmstat, S_IRUGO, node_read_vmstat, NULL);
 
-static ssize_t node_read_distance(struct sys_device * dev,
-			struct sysdev_attribute *attr, char * buf)
+static ssize_t node_read_distance(struct device * dev,
+			struct device_attribute *attr, char * buf)
 {
 	int nid = dev->id;
 	int len = 0;
@@ -212,7 +209,7 @@ static ssize_t node_read_distance(struct sys_device * dev,
 	len += sprintf(buf + len, "\n");
 	return len;
 }
-static SYSDEV_ATTR(distance, S_IRUGO, node_read_distance, NULL);
+static DEVICE_ATTR(distance, S_IRUGO, node_read_distance, NULL);
 
 #ifdef CONFIG_HUGETLBFS
 /*
@@ -230,7 +227,7 @@ static node_registration_func_t __hugetlb_unregister_node;
 static inline bool hugetlb_register_node(struct node *node)
 {
 	if (__hugetlb_register_node &&
-			node_state(node->sysdev.id, N_HIGH_MEMORY)) {
+			node_state(node->dev.id, N_HIGH_MEMORY)) {
 		__hugetlb_register_node(node);
 		return true;
 	}
@@ -266,17 +263,17 @@ int register_node(struct node *node, int num, struct node *parent)
 {
 	int error;
 
-	node->sysdev.id = num;
-	node->sysdev.cls = &node_class;
-	error = sysdev_register(&node->sysdev);
+	node->dev.id = num;
+	node->dev.bus = &node_subsys;
+	error = device_register(&node->dev);
 
 	if (!error){
-		sysdev_create_file(&node->sysdev, &attr_cpumap);
-		sysdev_create_file(&node->sysdev, &attr_cpulist);
-		sysdev_create_file(&node->sysdev, &attr_meminfo);
-		sysdev_create_file(&node->sysdev, &attr_numastat);
-		sysdev_create_file(&node->sysdev, &attr_distance);
-		sysdev_create_file(&node->sysdev, &attr_vmstat);
+		device_create_file(&node->dev, &dev_attr_cpumap);
+		device_create_file(&node->dev, &dev_attr_cpulist);
+		device_create_file(&node->dev, &dev_attr_meminfo);
+		device_create_file(&node->dev, &dev_attr_numastat);
+		device_create_file(&node->dev, &dev_attr_distance);
+		device_create_file(&node->dev, &dev_attr_vmstat);
 
 		scan_unevictable_register_node(node);
 
@@ -296,17 +293,17 @@ int register_node(struct node *node, int num, struct node *parent)
  */
 void unregister_node(struct node *node)
 {
-	sysdev_remove_file(&node->sysdev, &attr_cpumap);
-	sysdev_remove_file(&node->sysdev, &attr_cpulist);
-	sysdev_remove_file(&node->sysdev, &attr_meminfo);
-	sysdev_remove_file(&node->sysdev, &attr_numastat);
-	sysdev_remove_file(&node->sysdev, &attr_distance);
-	sysdev_remove_file(&node->sysdev, &attr_vmstat);
+	device_remove_file(&node->dev, &dev_attr_cpumap);
+	device_remove_file(&node->dev, &dev_attr_cpulist);
+	device_remove_file(&node->dev, &dev_attr_meminfo);
+	device_remove_file(&node->dev, &dev_attr_numastat);
+	device_remove_file(&node->dev, &dev_attr_distance);
+	device_remove_file(&node->dev, &dev_attr_vmstat);
 
 	scan_unevictable_unregister_node(node);
 	hugetlb_unregister_node(node);		/* no-op, if memoryless node */
 
-	sysdev_unregister(&node->sysdev);
+	device_unregister(&node->dev);
 }
 
 struct node node_devices[MAX_NUMNODES];
@@ -317,41 +314,41 @@ struct node node_devices[MAX_NUMNODES];
 int register_cpu_under_node(unsigned int cpu, unsigned int nid)
 {
 	int ret;
-	struct sys_device *obj;
+	struct device *obj;
 
 	if (!node_online(nid))
 		return 0;
 
-	obj = get_cpu_sysdev(cpu);
+	obj = get_cpu_device(cpu);
 	if (!obj)
 		return 0;
 
-	ret = sysfs_create_link(&node_devices[nid].sysdev.kobj,
+	ret = sysfs_create_link(&node_devices[nid].dev.kobj,
 				&obj->kobj,
 				kobject_name(&obj->kobj));
 	if (ret)
 		return ret;
 
 	return sysfs_create_link(&obj->kobj,
-				 &node_devices[nid].sysdev.kobj,
-				 kobject_name(&node_devices[nid].sysdev.kobj));
+				 &node_devices[nid].dev.kobj,
+				 kobject_name(&node_devices[nid].dev.kobj));
 }
 
 int unregister_cpu_under_node(unsigned int cpu, unsigned int nid)
 {
-	struct sys_device *obj;
+	struct device *obj;
 
 	if (!node_online(nid))
 		return 0;
 
-	obj = get_cpu_sysdev(cpu);
+	obj = get_cpu_device(cpu);
 	if (!obj)
 		return 0;
 
-	sysfs_remove_link(&node_devices[nid].sysdev.kobj,
+	sysfs_remove_link(&node_devices[nid].dev.kobj,
 			  kobject_name(&obj->kobj));
 	sysfs_remove_link(&obj->kobj,
-			  kobject_name(&node_devices[nid].sysdev.kobj));
+			  kobject_name(&node_devices[nid].dev.kobj));
 
 	return 0;
 }
@@ -393,15 +390,15 @@ int register_mem_sect_under_node(struct memory_block *mem_blk, int nid)
 			continue;
 		if (page_nid != nid)
 			continue;
-		ret = sysfs_create_link_nowarn(&node_devices[nid].sysdev.kobj,
-					&mem_blk->sysdev.kobj,
-					kobject_name(&mem_blk->sysdev.kobj));
+		ret = sysfs_create_link_nowarn(&node_devices[nid].dev.kobj,
+					&mem_blk->dev.kobj,
+					kobject_name(&mem_blk->dev.kobj));
 		if (ret)
 			return ret;
 
-		return sysfs_create_link_nowarn(&mem_blk->sysdev.kobj,
-				&node_devices[nid].sysdev.kobj,
-				kobject_name(&node_devices[nid].sysdev.kobj));
+		return sysfs_create_link_nowarn(&mem_blk->dev.kobj,
+				&node_devices[nid].dev.kobj,
+				kobject_name(&node_devices[nid].dev.kobj));
 	}
 	/* mem section does not span the specified node */
 	return 0;
@@ -434,10 +431,10 @@ int unregister_mem_sect_under_nodes(struct memory_block *mem_blk,
 			continue;
 		if (node_test_and_set(nid, *unlinked_nodes))
 			continue;
-		sysfs_remove_link(&node_devices[nid].sysdev.kobj,
-			 kobject_name(&mem_blk->sysdev.kobj));
-		sysfs_remove_link(&mem_blk->sysdev.kobj,
-			 kobject_name(&node_devices[nid].sysdev.kobj));
+		sysfs_remove_link(&node_devices[nid].dev.kobj,
+			 kobject_name(&mem_blk->dev.kobj));
+		sysfs_remove_link(&mem_blk->dev.kobj,
+			 kobject_name(&node_devices[nid].dev.kobj));
 	}
 	NODEMASK_FREE(unlinked_nodes);
 	return 0;
@@ -468,7 +465,7 @@ static int link_mem_sections(int nid)
 	}
 
 	if (mem_blk)
-		kobject_put(&mem_blk->sysdev.kobj);
+		kobject_put(&mem_blk->dev.kobj);
 	return err;
 }
 
@@ -596,19 +593,19 @@ static ssize_t print_nodes_state(enum node_states state, char *buf)
 }
 
 struct node_attr {
-	struct sysdev_class_attribute attr;
+	struct device_attribute attr;
 	enum node_states state;
 };
 
-static ssize_t show_node_state(struct sysdev_class *class,
-			       struct sysdev_class_attribute *attr, char *buf)
+static ssize_t show_node_state(struct device *dev,
+			       struct device_attribute *attr, char *buf)
 {
 	struct node_attr *na = container_of(attr, struct node_attr, attr);
 	return print_nodes_state(na->state, buf);
 }
 
 #define _NODE_ATTR(name, state) \
-	{ _SYSDEV_CLASS_ATTR(name, 0444, show_node_state, NULL), state }
+	{ __ATTR(name, 0444, show_node_state, NULL), state }
 
 static struct node_attr node_state_attr[] = {
 	_NODE_ATTR(possible, N_POSSIBLE),
@@ -620,17 +617,26 @@ static struct node_attr node_state_attr[] = {
 #endif
 };
 
-static struct sysdev_class_attribute *node_state_attrs[] = {
-	&node_state_attr[0].attr,
-	&node_state_attr[1].attr,
-	&node_state_attr[2].attr,
-	&node_state_attr[3].attr,
+static struct attribute *node_state_attrs[] = {
+	&node_state_attr[0].attr.attr,
+	&node_state_attr[1].attr.attr,
+	&node_state_attr[2].attr.attr,
+	&node_state_attr[3].attr.attr,
 #ifdef CONFIG_HIGHMEM
-	&node_state_attr[4].attr,
+	&node_state_attr[4].attr.attr,
 #endif
 	NULL
 };
 
+static struct attribute_group memory_root_attr_group = {
+	.attrs = node_state_attrs,
+};
+
+static const struct attribute_group *cpu_root_attr_groups[] = {
+	&memory_root_attr_group,
+	NULL,
+};
+
 #define NODE_CALLBACK_PRI	2	/* lower than SLAB */
 static int __init register_node_type(void)
 {
@@ -639,7 +645,7 @@ static int __init register_node_type(void)
  	BUILD_BUG_ON(ARRAY_SIZE(node_state_attr) != NR_NODE_STATES);
  	BUILD_BUG_ON(ARRAY_SIZE(node_state_attrs)-1 != NR_NODE_STATES);
 
-	ret = sysdev_class_register(&node_class);
+	ret = subsys_system_register(&node_subsys, cpu_root_attr_groups);
 	if (!ret) {
 		hotplug_memory_notifier(node_memory_callback,
 					NODE_CALLBACK_PRI);
diff --git a/drivers/base/sys.c b/drivers/base/sys.c
index 9dff77b..e69de29 100644
--- a/drivers/base/sys.c
+++ b/drivers/base/sys.c
@@ -1,391 +0,0 @@
-/*
- * sys.c - pseudo-bus for system 'devices' (cpus, PICs, timers, etc)
- *
- * Copyright (c) 2002-3 Patrick Mochel
- *               2002-3 Open Source Development Lab
- *
- * This file is released under the GPLv2
- *
- * This exports a 'system' bus type.
- * By default, a 'sys' bus gets added to the root of the system. There will
- * always be core system devices. Devices can use sysdev_register() to
- * add themselves as children of the system bus.
- */
-
-#include <linux/sysdev.h>
-#include <linux/err.h>
-#include <linux/module.h>
-#include <linux/kernel.h>
-#include <linux/init.h>
-#include <linux/string.h>
-#include <linux/pm.h>
-#include <linux/device.h>
-#include <linux/mutex.h>
-#include <linux/interrupt.h>
-
-#include "base.h"
-
-#define to_sysdev(k) container_of(k, struct sys_device, kobj)
-#define to_sysdev_attr(a) container_of(a, struct sysdev_attribute, attr)
-
-
-static ssize_t
-sysdev_show(struct kobject *kobj, struct attribute *attr, char *buffer)
-{
-	struct sys_device *sysdev = to_sysdev(kobj);
-	struct sysdev_attribute *sysdev_attr = to_sysdev_attr(attr);
-
-	if (sysdev_attr->show)
-		return sysdev_attr->show(sysdev, sysdev_attr, buffer);
-	return -EIO;
-}
-
-
-static ssize_t
-sysdev_store(struct kobject *kobj, struct attribute *attr,
-	     const char *buffer, size_t count)
-{
-	struct sys_device *sysdev = to_sysdev(kobj);
-	struct sysdev_attribute *sysdev_attr = to_sysdev_attr(attr);
-
-	if (sysdev_attr->store)
-		return sysdev_attr->store(sysdev, sysdev_attr, buffer, count);
-	return -EIO;
-}
-
-static const struct sysfs_ops sysfs_ops = {
-	.show	= sysdev_show,
-	.store	= sysdev_store,
-};
-
-static struct kobj_type ktype_sysdev = {
-	.sysfs_ops	= &sysfs_ops,
-};
-
-
-int sysdev_create_file(struct sys_device *s, struct sysdev_attribute *a)
-{
-	return sysfs_create_file(&s->kobj, &a->attr);
-}
-
-
-void sysdev_remove_file(struct sys_device *s, struct sysdev_attribute *a)
-{
-	sysfs_remove_file(&s->kobj, &a->attr);
-}
-
-EXPORT_SYMBOL_GPL(sysdev_create_file);
-EXPORT_SYMBOL_GPL(sysdev_remove_file);
-
-#define to_sysdev_class(k) container_of(k, struct sysdev_class, kset.kobj)
-#define to_sysdev_class_attr(a) container_of(a, \
-	struct sysdev_class_attribute, attr)
-
-static ssize_t sysdev_class_show(struct kobject *kobj, struct attribute *attr,
-				 char *buffer)
-{
-	struct sysdev_class *class = to_sysdev_class(kobj);
-	struct sysdev_class_attribute *class_attr = to_sysdev_class_attr(attr);
-
-	if (class_attr->show)
-		return class_attr->show(class, class_attr, buffer);
-	return -EIO;
-}
-
-static ssize_t sysdev_class_store(struct kobject *kobj, struct attribute *attr,
-				  const char *buffer, size_t count)
-{
-	struct sysdev_class *class = to_sysdev_class(kobj);
-	struct sysdev_class_attribute *class_attr = to_sysdev_class_attr(attr);
-
-	if (class_attr->store)
-		return class_attr->store(class, class_attr, buffer, count);
-	return -EIO;
-}
-
-static const struct sysfs_ops sysfs_class_ops = {
-	.show	= sysdev_class_show,
-	.store	= sysdev_class_store,
-};
-
-static struct kobj_type ktype_sysdev_class = {
-	.sysfs_ops	= &sysfs_class_ops,
-};
-
-int sysdev_class_create_file(struct sysdev_class *c,
-			     struct sysdev_class_attribute *a)
-{
-	return sysfs_create_file(&c->kset.kobj, &a->attr);
-}
-EXPORT_SYMBOL_GPL(sysdev_class_create_file);
-
-void sysdev_class_remove_file(struct sysdev_class *c,
-			      struct sysdev_class_attribute *a)
-{
-	sysfs_remove_file(&c->kset.kobj, &a->attr);
-}
-EXPORT_SYMBOL_GPL(sysdev_class_remove_file);
-
-static struct kset *system_kset;
-
-int sysdev_class_register(struct sysdev_class *cls)
-{
-	int retval;
-
-	pr_debug("Registering sysdev class '%s'\n", cls->name);
-
-	INIT_LIST_HEAD(&cls->drivers);
-	memset(&cls->kset.kobj, 0x00, sizeof(struct kobject));
-	cls->kset.kobj.parent = &system_kset->kobj;
-	cls->kset.kobj.ktype = &ktype_sysdev_class;
-	cls->kset.kobj.kset = system_kset;
-
-	retval = kobject_set_name(&cls->kset.kobj, "%s", cls->name);
-	if (retval)
-		return retval;
-
-	retval = kset_register(&cls->kset);
-	if (!retval && cls->attrs)
-		retval = sysfs_create_files(&cls->kset.kobj,
-					    (const struct attribute **)cls->attrs);
-	return retval;
-}
-
-void sysdev_class_unregister(struct sysdev_class *cls)
-{
-	pr_debug("Unregistering sysdev class '%s'\n",
-		 kobject_name(&cls->kset.kobj));
-	if (cls->attrs)
-		sysfs_remove_files(&cls->kset.kobj,
-				   (const struct attribute **)cls->attrs);
-	kset_unregister(&cls->kset);
-}
-
-EXPORT_SYMBOL_GPL(sysdev_class_register);
-EXPORT_SYMBOL_GPL(sysdev_class_unregister);
-
-static DEFINE_MUTEX(sysdev_drivers_lock);
-
-/*
- * @dev != NULL means that we're unwinding because some drv->add()
- * failed for some reason. You need to grab sysdev_drivers_lock before
- * calling this.
- */
-static void __sysdev_driver_remove(struct sysdev_class *cls,
-				   struct sysdev_driver *drv,
-				   struct sys_device *from_dev)
-{
-	struct sys_device *dev = from_dev;
-
-	list_del_init(&drv->entry);
-	if (!cls)
-		return;
-
-	if (!drv->remove)
-		goto kset_put;
-
-	if (dev)
-		list_for_each_entry_continue_reverse(dev, &cls->kset.list,
-						     kobj.entry)
-			drv->remove(dev);
-	else
-		list_for_each_entry(dev, &cls->kset.list, kobj.entry)
-			drv->remove(dev);
-
-kset_put:
-	kset_put(&cls->kset);
-}
-
-/**
- *	sysdev_driver_register - Register auxiliary driver
- *	@cls:	Device class driver belongs to.
- *	@drv:	Driver.
- *
- *	@drv is inserted into @cls->drivers to be
- *	called on each operation on devices of that class. The refcount
- *	of @cls is incremented.
- */
-int sysdev_driver_register(struct sysdev_class *cls, struct sysdev_driver *drv)
-{
-	struct sys_device *dev = NULL;
-	int err = 0;
-
-	if (!cls) {
-		WARN(1, KERN_WARNING "sysdev: invalid class passed to %s!\n",
-			__func__);
-		return -EINVAL;
-	}
-
-	/* Check whether this driver has already been added to a class. */
-	if (drv->entry.next && !list_empty(&drv->entry))
-		WARN(1, KERN_WARNING "sysdev: class %s: driver (%p) has already"
-			" been registered to a class, something is wrong, but "
-			"will forge on!\n", cls->name, drv);
-
-	mutex_lock(&sysdev_drivers_lock);
-	if (cls && kset_get(&cls->kset)) {
-		list_add_tail(&drv->entry, &cls->drivers);
-
-		/* If devices of this class already exist, tell the driver */
-		if (drv->add) {
-			list_for_each_entry(dev, &cls->kset.list, kobj.entry) {
-				err = drv->add(dev);
-				if (err)
-					goto unwind;
-			}
-		}
-	} else {
-		err = -EINVAL;
-		WARN(1, KERN_ERR "%s: invalid device class\n", __func__);
-	}
-
-	goto unlock;
-
-unwind:
-	__sysdev_driver_remove(cls, drv, dev);
-
-unlock:
-	mutex_unlock(&sysdev_drivers_lock);
-	return err;
-}
-
-/**
- *	sysdev_driver_unregister - Remove an auxiliary driver.
- *	@cls:	Class driver belongs to.
- *	@drv:	Driver.
- */
-void sysdev_driver_unregister(struct sysdev_class *cls,
-			      struct sysdev_driver *drv)
-{
-	mutex_lock(&sysdev_drivers_lock);
-	__sysdev_driver_remove(cls, drv, NULL);
-	mutex_unlock(&sysdev_drivers_lock);
-}
-EXPORT_SYMBOL_GPL(sysdev_driver_register);
-EXPORT_SYMBOL_GPL(sysdev_driver_unregister);
-
-/**
- *	sysdev_register - add a system device to the tree
- *	@sysdev:	device in question
- *
- */
-int sysdev_register(struct sys_device *sysdev)
-{
-	int error;
-	struct sysdev_class *cls = sysdev->cls;
-
-	if (!cls)
-		return -EINVAL;
-
-	pr_debug("Registering sys device of class '%s'\n",
-		 kobject_name(&cls->kset.kobj));
-
-	/* initialize the kobject to 0, in case it had previously been used */
-	memset(&sysdev->kobj, 0x00, sizeof(struct kobject));
-
-	/* Make sure the kset is set */
-	sysdev->kobj.kset = &cls->kset;
-
-	/* Register the object */
-	error = kobject_init_and_add(&sysdev->kobj, &ktype_sysdev, NULL,
-				     "%s%d", kobject_name(&cls->kset.kobj),
-				     sysdev->id);
-
-	if (!error) {
-		struct sysdev_driver *drv;
-
-		pr_debug("Registering sys device '%s'\n",
-			 kobject_name(&sysdev->kobj));
-
-		mutex_lock(&sysdev_drivers_lock);
-		/* Generic notification is implicit, because it's that
-		 * code that should have called us.
-		 */
-
-		/* Notify class auxiliary drivers */
-		list_for_each_entry(drv, &cls->drivers, entry) {
-			if (drv->add)
-				drv->add(sysdev);
-		}
-		mutex_unlock(&sysdev_drivers_lock);
-		kobject_uevent(&sysdev->kobj, KOBJ_ADD);
-	}
-
-	return error;
-}
-
-void sysdev_unregister(struct sys_device *sysdev)
-{
-	struct sysdev_driver *drv;
-
-	mutex_lock(&sysdev_drivers_lock);
-	list_for_each_entry(drv, &sysdev->cls->drivers, entry) {
-		if (drv->remove)
-			drv->remove(sysdev);
-	}
-	mutex_unlock(&sysdev_drivers_lock);
-
-	kobject_put(&sysdev->kobj);
-}
-
-EXPORT_SYMBOL_GPL(sysdev_register);
-EXPORT_SYMBOL_GPL(sysdev_unregister);
-
-int __init system_bus_init(void)
-{
-	system_kset = kset_create_and_add("system", NULL, &devices_kset->kobj);
-	if (!system_kset)
-		return -ENOMEM;
-	return 0;
-}
-
-#define to_ext_attr(x) container_of(x, struct sysdev_ext_attribute, attr)
-
-ssize_t sysdev_store_ulong(struct sys_device *sysdev,
-			   struct sysdev_attribute *attr,
-			   const char *buf, size_t size)
-{
-	struct sysdev_ext_attribute *ea = to_ext_attr(attr);
-	char *end;
-	unsigned long new = simple_strtoul(buf, &end, 0);
-	if (end == buf)
-		return -EINVAL;
-	*(unsigned long *)(ea->var) = new;
-	/* Always return full write size even if we didn't consume all */
-	return size;
-}
-EXPORT_SYMBOL_GPL(sysdev_store_ulong);
-
-ssize_t sysdev_show_ulong(struct sys_device *sysdev,
-			  struct sysdev_attribute *attr,
-			  char *buf)
-{
-	struct sysdev_ext_attribute *ea = to_ext_attr(attr);
-	return snprintf(buf, PAGE_SIZE, "%lx\n", *(unsigned long *)(ea->var));
-}
-EXPORT_SYMBOL_GPL(sysdev_show_ulong);
-
-ssize_t sysdev_store_int(struct sys_device *sysdev,
-			   struct sysdev_attribute *attr,
-			   const char *buf, size_t size)
-{
-	struct sysdev_ext_attribute *ea = to_ext_attr(attr);
-	char *end;
-	long new = simple_strtol(buf, &end, 0);
-	if (end == buf || new > INT_MAX || new < INT_MIN)
-		return -EINVAL;
-	*(int *)(ea->var) = new;
-	/* Always return full write size even if we didn't consume all */
-	return size;
-}
-EXPORT_SYMBOL_GPL(sysdev_store_int);
-
-ssize_t sysdev_show_int(struct sys_device *sysdev,
-			  struct sysdev_attribute *attr,
-			  char *buf)
-{
-	struct sysdev_ext_attribute *ea = to_ext_attr(attr);
-	return snprintf(buf, PAGE_SIZE, "%d\n", *(int *)(ea->var));
-}
-EXPORT_SYMBOL_GPL(sysdev_show_int);
-
diff --git a/drivers/base/topology.c b/drivers/base/topology.c
index f6f37a0..ae989c5 100644
--- a/drivers/base/topology.c
+++ b/drivers/base/topology.c
@@ -23,7 +23,6 @@
  * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  *
  */
-#include <linux/sysdev.h>
 #include <linux/init.h>
 #include <linux/mm.h>
 #include <linux/cpu.h>
@@ -32,14 +31,14 @@
 #include <linux/topology.h>
 
 #define define_one_ro_named(_name, _func)				\
-static SYSDEV_ATTR(_name, 0444, _func, NULL)
+	static DEVICE_ATTR(_name, 0444, _func, NULL)
 
 #define define_one_ro(_name)				\
-static SYSDEV_ATTR(_name, 0444, show_##_name, NULL)
+	static DEVICE_ATTR(_name, 0444, show_##_name, NULL)
 
 #define define_id_show_func(name)				\
-static ssize_t show_##name(struct sys_device *dev,		\
-		struct sysdev_attribute *attr, char *buf)	\
+static ssize_t show_##name(struct device *dev,			\
+		struct device_attribute *attr, char *buf)	\
 {								\
 	unsigned int cpu = dev->id;				\
 	return sprintf(buf, "%d\n", topology_##name(cpu));	\
@@ -65,16 +64,16 @@ static ssize_t show_cpumap(int type, const struct cpumask *mask, char *buf)
 
 #ifdef arch_provides_topology_pointers
 #define define_siblings_show_map(name)					\
-static ssize_t show_##name(struct sys_device *dev,			\
-			   struct sysdev_attribute *attr, char *buf)	\
+static ssize_t show_##name(struct device *dev,				\
+			   struct device_attribute *attr, char *buf)	\
 {									\
 	unsigned int cpu = dev->id;					\
 	return show_cpumap(0, topology_##name(cpu), buf);		\
 }
 
 #define define_siblings_show_list(name)					\
-static ssize_t show_##name##_list(struct sys_device *dev,		\
-				  struct sysdev_attribute *attr,	\
+static ssize_t show_##name##_list(struct device *dev,			\
+				  struct device_attribute *attr,	\
 				  char *buf)				\
 {									\
 	unsigned int cpu = dev->id;					\
@@ -83,15 +82,15 @@ static ssize_t show_##name##_list(struct sys_device *dev,		\
 
 #else
 #define define_siblings_show_map(name)					\
-static ssize_t show_##name(struct sys_device *dev,			\
-			   struct sysdev_attribute *attr, char *buf)	\
+static ssize_t show_##name(struct device *dev,				\
+			   struct device_attribute *attr, char *buf)	\
 {									\
 	return show_cpumap(0, topology_##name(dev->id), buf);		\
 }
 
 #define define_siblings_show_list(name)					\
-static ssize_t show_##name##_list(struct sys_device *dev,		\
-				  struct sysdev_attribute *attr,	\
+static ssize_t show_##name##_list(struct device *dev,			\
+				  struct device_attribute *attr,	\
 				  char *buf)				\
 {									\
 	return show_cpumap(1, topology_##name(dev->id), buf);		\
@@ -124,16 +123,16 @@ define_one_ro_named(book_siblings_list, show_book_cpumask_list);
 #endif
 
 static struct attribute *default_attrs[] = {
-	&attr_physical_package_id.attr,
-	&attr_core_id.attr,
-	&attr_thread_siblings.attr,
-	&attr_thread_siblings_list.attr,
-	&attr_core_siblings.attr,
-	&attr_core_siblings_list.attr,
+	&dev_attr_physical_package_id.attr,
+	&dev_attr_core_id.attr,
+	&dev_attr_thread_siblings.attr,
+	&dev_attr_thread_siblings_list.attr,
+	&dev_attr_core_siblings.attr,
+	&dev_attr_core_siblings_list.attr,
 #ifdef CONFIG_SCHED_BOOK
-	&attr_book_id.attr,
-	&attr_book_siblings.attr,
-	&attr_book_siblings_list.attr,
+	&dev_attr_book_id.attr,
+	&dev_attr_book_siblings.attr,
+	&dev_attr_book_siblings_list.attr,
 #endif
 	NULL
 };
@@ -146,16 +145,16 @@ static struct attribute_group topology_attr_group = {
 /* Add/Remove cpu_topology interface for CPU device */
 static int __cpuinit topology_add_dev(unsigned int cpu)
 {
-	struct sys_device *sys_dev = get_cpu_sysdev(cpu);
+	struct device *dev = get_cpu_device(cpu);
 
-	return sysfs_create_group(&sys_dev->kobj, &topology_attr_group);
+	return sysfs_create_group(&dev->kobj, &topology_attr_group);
 }
 
 static void __cpuinit topology_remove_dev(unsigned int cpu)
 {
-	struct sys_device *sys_dev = get_cpu_sysdev(cpu);
+	struct device *dev = get_cpu_device(cpu);
 
-	sysfs_remove_group(&sys_dev->kobj, &topology_attr_group);
+	sysfs_remove_group(&dev->kobj, &topology_attr_group);
 }
 
 static int __cpuinit topology_cpu_callback(struct notifier_block *nfb,
diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 987a165..8c2df34 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -679,7 +679,7 @@ static struct kobj_type ktype_cpufreq = {
  */
 static int cpufreq_add_dev_policy(unsigned int cpu,
 				  struct cpufreq_policy *policy,
-				  struct sys_device *sys_dev)
+				  struct device *dev)
 {
 	int ret = 0;
 #ifdef CONFIG_SMP
@@ -728,7 +728,7 @@ static int cpufreq_add_dev_policy(unsigned int cpu,
 			spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
 
 			pr_debug("CPU already managed, adding link\n");
-			ret = sysfs_create_link(&sys_dev->kobj,
+			ret = sysfs_create_link(&dev->kobj,
 						&managed_policy->kobj,
 						"cpufreq");
 			if (ret)
@@ -761,7 +761,7 @@ static int cpufreq_add_dev_symlink(unsigned int cpu,
 
 	for_each_cpu(j, policy->cpus) {
 		struct cpufreq_policy *managed_policy;
-		struct sys_device *cpu_sys_dev;
+		struct device *cpu_dev;
 
 		if (j == cpu)
 			continue;
@@ -770,8 +770,8 @@ static int cpufreq_add_dev_symlink(unsigned int cpu,
 
 		pr_debug("CPU %u already managed, adding link\n", j);
 		managed_policy = cpufreq_cpu_get(cpu);
-		cpu_sys_dev = get_cpu_sysdev(j);
-		ret = sysfs_create_link(&cpu_sys_dev->kobj, &policy->kobj,
+		cpu_dev = get_cpu_device(j);
+		ret = sysfs_create_link(&cpu_dev->kobj, &policy->kobj,
 					"cpufreq");
 		if (ret) {
 			cpufreq_cpu_put(managed_policy);
@@ -783,7 +783,7 @@ static int cpufreq_add_dev_symlink(unsigned int cpu,
 
 static int cpufreq_add_dev_interface(unsigned int cpu,
 				     struct cpufreq_policy *policy,
-				     struct sys_device *sys_dev)
+				     struct device *dev)
 {
 	struct cpufreq_policy new_policy;
 	struct freq_attr **drv_attr;
@@ -793,7 +793,7 @@ static int cpufreq_add_dev_interface(unsigned int cpu,
 
 	/* prepare interface data */
 	ret = kobject_init_and_add(&policy->kobj, &ktype_cpufreq,
-				   &sys_dev->kobj, "cpufreq");
+				   &dev->kobj, "cpufreq");
 	if (ret)
 		return ret;
 
@@ -866,9 +866,9 @@ err_out_kobj_put:
  * with with cpu hotplugging and all hell will break loose. Tried to clean this
  * mess up, but more thorough testing is needed. - Mathieu
  */
-static int cpufreq_add_dev(struct sys_device *sys_dev)
+static int cpufreq_add_dev(struct device *dev, struct subsys_interface *sif)
 {
-	unsigned int cpu = sys_dev->id;
+	unsigned int cpu = dev->id;
 	int ret = 0, found = 0;
 	struct cpufreq_policy *policy;
 	unsigned long flags;
@@ -947,7 +947,7 @@ static int cpufreq_add_dev(struct sys_device *sys_dev)
 	blocking_notifier_call_chain(&cpufreq_policy_notifier_list,
 				     CPUFREQ_START, policy);
 
-	ret = cpufreq_add_dev_policy(cpu, policy, sys_dev);
+	ret = cpufreq_add_dev_policy(cpu, policy, dev);
 	if (ret) {
 		if (ret > 0)
 			/* This is a managed cpu, symlink created,
@@ -956,7 +956,7 @@ static int cpufreq_add_dev(struct sys_device *sys_dev)
 		goto err_unlock_policy;
 	}
 
-	ret = cpufreq_add_dev_interface(cpu, policy, sys_dev);
+	ret = cpufreq_add_dev_interface(cpu, policy, dev);
 	if (ret)
 		goto err_out_unregister;
 
@@ -999,15 +999,15 @@ module_out:
  * Caller should already have policy_rwsem in write mode for this CPU.
  * This routine frees the rwsem before returning.
  */
-static int __cpufreq_remove_dev(struct sys_device *sys_dev)
+static int __cpufreq_remove_dev(struct device *dev, struct subsys_interface *sif)
 {
-	unsigned int cpu = sys_dev->id;
+	unsigned int cpu = dev->id;
 	unsigned long flags;
 	struct cpufreq_policy *data;
 	struct kobject *kobj;
 	struct completion *cmp;
 #ifdef CONFIG_SMP
-	struct sys_device *cpu_sys_dev;
+	struct device *cpu_dev;
 	unsigned int j;
 #endif
 
@@ -1032,7 +1032,7 @@ static int __cpufreq_remove_dev(struct sys_device *sys_dev)
 		pr_debug("removing link\n");
 		cpumask_clear_cpu(cpu, data->cpus);
 		spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
-		kobj = &sys_dev->kobj;
+		kobj = &dev->kobj;
 		cpufreq_cpu_put(data);
 		unlock_policy_rwsem_write(cpu);
 		sysfs_remove_link(kobj, "cpufreq");
@@ -1071,8 +1071,8 @@ static int __cpufreq_remove_dev(struct sys_device *sys_dev)
 			strncpy(per_cpu(cpufreq_cpu_governor, j),
 				data->governor->name, CPUFREQ_NAME_LEN);
 #endif
-			cpu_sys_dev = get_cpu_sysdev(j);
-			kobj = &cpu_sys_dev->kobj;
+			cpu_dev = get_cpu_device(j);
+			kobj = &cpu_dev->kobj;
 			unlock_policy_rwsem_write(cpu);
 			sysfs_remove_link(kobj, "cpufreq");
 			lock_policy_rwsem_write(cpu);
@@ -1112,11 +1112,11 @@ static int __cpufreq_remove_dev(struct sys_device *sys_dev)
 	if (unlikely(cpumask_weight(data->cpus) > 1)) {
 		/* first sibling now owns the new sysfs dir */
 		cpumask_clear_cpu(cpu, data->cpus);
-		cpufreq_add_dev(get_cpu_sysdev(cpumask_first(data->cpus)));
+		cpufreq_add_dev(get_cpu_device(cpumask_first(data->cpus)), NULL);
 
 		/* finally remove our own symlink */
 		lock_policy_rwsem_write(cpu);
-		__cpufreq_remove_dev(sys_dev);
+		__cpufreq_remove_dev(dev, sif);
 	}
 #endif
 
@@ -1128,9 +1128,9 @@ static int __cpufreq_remove_dev(struct sys_device *sys_dev)
 }
 
 
-static int cpufreq_remove_dev(struct sys_device *sys_dev)
+static int cpufreq_remove_dev(struct device *dev, struct subsys_interface *sif)
 {
-	unsigned int cpu = sys_dev->id;
+	unsigned int cpu = dev->id;
 	int retval;
 
 	if (cpu_is_offline(cpu))
@@ -1139,7 +1139,7 @@ static int cpufreq_remove_dev(struct sys_device *sys_dev)
 	if (unlikely(lock_policy_rwsem_write(cpu)))
 		BUG();
 
-	retval = __cpufreq_remove_dev(sys_dev);
+	retval = __cpufreq_remove_dev(dev, sif);
 	return retval;
 }
 
@@ -1271,9 +1271,11 @@ out:
 }
 EXPORT_SYMBOL(cpufreq_get);
 
-static struct sysdev_driver cpufreq_sysdev_driver = {
-	.add		= cpufreq_add_dev,
-	.remove		= cpufreq_remove_dev,
+static struct subsys_interface cpufreq_interface = {
+	.name		= "cpufreq",
+	.subsys		= &cpu_subsys,
+	.add_dev	= cpufreq_add_dev,
+	.remove_dev	= cpufreq_remove_dev,
 };
 
 
@@ -1765,25 +1767,25 @@ static int __cpuinit cpufreq_cpu_callback(struct notifier_block *nfb,
 					unsigned long action, void *hcpu)
 {
 	unsigned int cpu = (unsigned long)hcpu;
-	struct sys_device *sys_dev;
+	struct device *dev;
 
-	sys_dev = get_cpu_sysdev(cpu);
-	if (sys_dev) {
+	dev = get_cpu_device(cpu);
+	if (dev) {
 		switch (action) {
 		case CPU_ONLINE:
 		case CPU_ONLINE_FROZEN:
-			cpufreq_add_dev(sys_dev);
+			cpufreq_add_dev(dev, NULL);
 			break;
 		case CPU_DOWN_PREPARE:
 		case CPU_DOWN_PREPARE_FROZEN:
 			if (unlikely(lock_policy_rwsem_write(cpu)))
 				BUG();
 
-			__cpufreq_remove_dev(sys_dev);
+			__cpufreq_remove_dev(dev, NULL);
 			break;
 		case CPU_DOWN_FAILED:
 		case CPU_DOWN_FAILED_FROZEN:
-			cpufreq_add_dev(sys_dev);
+			cpufreq_add_dev(dev, NULL);
 			break;
 		}
 	}
@@ -1830,8 +1832,7 @@ int cpufreq_register_driver(struct cpufreq_driver *driver_data)
 	cpufreq_driver = driver_data;
 	spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
 
-	ret = sysdev_driver_register(&cpu_sysdev_class,
-					&cpufreq_sysdev_driver);
+	ret = subsys_interface_register(&cpufreq_interface);
 	if (ret)
 		goto err_null_driver;
 
@@ -1850,7 +1851,7 @@ int cpufreq_register_driver(struct cpufreq_driver *driver_data)
 		if (ret) {
 			pr_debug("no CPU initialized for driver %s\n",
 							driver_data->name);
-			goto err_sysdev_unreg;
+			goto err_if_unreg;
 		}
 	}
 
@@ -1858,9 +1859,8 @@ int cpufreq_register_driver(struct cpufreq_driver *driver_data)
 	pr_debug("driver %s up and running\n", driver_data->name);
 
 	return 0;
-err_sysdev_unreg:
-	sysdev_driver_unregister(&cpu_sysdev_class,
-			&cpufreq_sysdev_driver);
+err_if_unreg:
+	subsys_interface_unregister(&cpufreq_interface);
 err_null_driver:
 	spin_lock_irqsave(&cpufreq_driver_lock, flags);
 	cpufreq_driver = NULL;
@@ -1887,7 +1887,7 @@ int cpufreq_unregister_driver(struct cpufreq_driver *driver)
 
 	pr_debug("unregistering driver %s\n", driver->name);
 
-	sysdev_driver_unregister(&cpu_sysdev_class, &cpufreq_sysdev_driver);
+	subsys_interface_unregister(&cpufreq_interface);
 	unregister_hotcpu_notifier(&cpufreq_cpu_notifier);
 
 	spin_lock_irqsave(&cpufreq_driver_lock, flags);
@@ -1907,8 +1907,7 @@ static int __init cpufreq_core_init(void)
 		init_rwsem(&per_cpu(cpu_policy_rwsem, cpu));
 	}
 
-	cpufreq_global_kobject = kobject_create_and_add("cpufreq",
-						&cpu_sysdev_class.kset.kobj);
+	cpufreq_global_kobject = kobject_create_and_add("cpufreq", &cpu_subsys.dev_root->kobj);
 	BUG_ON(!cpufreq_global_kobject);
 	register_syscore_ops(&cpufreq_syscore_ops);
 
diff --git a/drivers/cpufreq/cpufreq_stats.c b/drivers/cpufreq/cpufreq_stats.c
index c5072a9..390380a 100644
--- a/drivers/cpufreq/cpufreq_stats.c
+++ b/drivers/cpufreq/cpufreq_stats.c
@@ -11,7 +11,6 @@
 
 #include <linux/kernel.h>
 #include <linux/slab.h>
-#include <linux/sysdev.h>
 #include <linux/cpu.h>
 #include <linux/sysfs.h>
 #include <linux/cpufreq.h>
diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
index 06ce268..59f4261 100644
--- a/drivers/cpuidle/cpuidle.c
+++ b/drivers/cpuidle/cpuidle.c
@@ -291,10 +291,10 @@ EXPORT_SYMBOL_GPL(cpuidle_disable_device);
 static int __cpuidle_register_device(struct cpuidle_device *dev)
 {
 	int ret;
-	struct sys_device *sys_dev = get_cpu_sysdev((unsigned long)dev->cpu);
+	struct device *cpu_dev = get_cpu_device((unsigned long)dev->cpu);
 	struct cpuidle_driver *cpuidle_driver = cpuidle_get_driver();
 
-	if (!sys_dev)
+	if (!dev)
 		return -EINVAL;
 	if (!try_module_get(cpuidle_driver->owner))
 		return -EINVAL;
@@ -303,7 +303,7 @@ static int __cpuidle_register_device(struct cpuidle_device *dev)
 
 	per_cpu(cpuidle_devices, dev->cpu) = dev;
 	list_add(&dev->device_list, &cpuidle_detected_devices);
-	if ((ret = cpuidle_add_sysfs(sys_dev))) {
+	if ((ret = cpuidle_add_sysfs(cpu_dev))) {
 		module_put(cpuidle_driver->owner);
 		return ret;
 	}
@@ -344,7 +344,7 @@ EXPORT_SYMBOL_GPL(cpuidle_register_device);
  */
 void cpuidle_unregister_device(struct cpuidle_device *dev)
 {
-	struct sys_device *sys_dev = get_cpu_sysdev((unsigned long)dev->cpu);
+	struct device *cpu_dev = get_cpu_device((unsigned long)dev->cpu);
 	struct cpuidle_driver *cpuidle_driver = cpuidle_get_driver();
 
 	if (dev->registered == 0)
@@ -354,7 +354,7 @@ void cpuidle_unregister_device(struct cpuidle_device *dev)
 
 	cpuidle_disable_device(dev);
 
-	cpuidle_remove_sysfs(sys_dev);
+	cpuidle_remove_sysfs(cpu_dev);
 	list_del(&dev->device_list);
 	wait_for_completion(&dev->kobj_unregister);
 	per_cpu(cpuidle_devices, dev->cpu) = NULL;
@@ -411,7 +411,7 @@ static int __init cpuidle_init(void)
 	if (cpuidle_disabled())
 		return -ENODEV;
 
-	ret = cpuidle_add_class_sysfs(&cpu_sysdev_class);
+	ret = cpuidle_add_interface(cpu_subsys.dev_root);
 	if (ret)
 		return ret;
 
diff --git a/drivers/cpuidle/cpuidle.h b/drivers/cpuidle/cpuidle.h
index 38c3fd8..7db1866 100644
--- a/drivers/cpuidle/cpuidle.h
+++ b/drivers/cpuidle/cpuidle.h
@@ -5,7 +5,7 @@
 #ifndef __DRIVER_CPUIDLE_H
 #define __DRIVER_CPUIDLE_H
 
-#include <linux/sysdev.h>
+#include <linux/device.h>
 
 /* For internal use only */
 extern struct cpuidle_governor *cpuidle_curr_governor;
@@ -23,11 +23,11 @@ extern void cpuidle_uninstall_idle_handler(void);
 extern int cpuidle_switch_governor(struct cpuidle_governor *gov);
 
 /* sysfs */
-extern int cpuidle_add_class_sysfs(struct sysdev_class *cls);
-extern void cpuidle_remove_class_sysfs(struct sysdev_class *cls);
+extern int cpuidle_add_interface(struct device *dev);
+extern void cpuidle_remove_interface(struct device *dev);
 extern int cpuidle_add_state_sysfs(struct cpuidle_device *device);
 extern void cpuidle_remove_state_sysfs(struct cpuidle_device *device);
-extern int cpuidle_add_sysfs(struct sys_device *sysdev);
-extern void cpuidle_remove_sysfs(struct sys_device *sysdev);
+extern int cpuidle_add_sysfs(struct device *dev);
+extern void cpuidle_remove_sysfs(struct device *dev);
 
 #endif /* __DRIVER_CPUIDLE_H */
diff --git a/drivers/cpuidle/sysfs.c b/drivers/cpuidle/sysfs.c
index 1e756e1..3fe41fe 100644
--- a/drivers/cpuidle/sysfs.c
+++ b/drivers/cpuidle/sysfs.c
@@ -22,8 +22,8 @@ static int __init cpuidle_sysfs_setup(char *unused)
 }
 __setup("cpuidle_sysfs_switch", cpuidle_sysfs_setup);
 
-static ssize_t show_available_governors(struct sysdev_class *class,
-					struct sysdev_class_attribute *attr,
+static ssize_t show_available_governors(struct device *dev,
+					struct device_attribute *attr,
 					char *buf)
 {
 	ssize_t i = 0;
@@ -42,8 +42,8 @@ out:
 	return i;
 }
 
-static ssize_t show_current_driver(struct sysdev_class *class,
-				   struct sysdev_class_attribute *attr,
+static ssize_t show_current_driver(struct device *dev,
+				   struct device_attribute *attr,
 				   char *buf)
 {
 	ssize_t ret;
@@ -59,8 +59,8 @@ static ssize_t show_current_driver(struct sysdev_class *class,
 	return ret;
 }
 
-static ssize_t show_current_governor(struct sysdev_class *class,
-				     struct sysdev_class_attribute *attr,
+static ssize_t show_current_governor(struct device *dev,
+				     struct device_attribute *attr,
 				     char *buf)
 {
 	ssize_t ret;
@@ -75,8 +75,8 @@ static ssize_t show_current_governor(struct sysdev_class *class,
 	return ret;
 }
 
-static ssize_t store_current_governor(struct sysdev_class *class,
-				      struct sysdev_class_attribute *attr,
+static ssize_t store_current_governor(struct device *dev,
+				      struct device_attribute *attr,
 				      const char *buf, size_t count)
 {
 	char gov_name[CPUIDLE_NAME_LEN];
@@ -109,50 +109,48 @@ static ssize_t store_current_governor(struct sysdev_class *class,
 		return count;
 }
 
-static SYSDEV_CLASS_ATTR(current_driver, 0444, show_current_driver, NULL);
-static SYSDEV_CLASS_ATTR(current_governor_ro, 0444, show_current_governor,
-			 NULL);
+static DEVICE_ATTR(current_driver, 0444, show_current_driver, NULL);
+static DEVICE_ATTR(current_governor_ro, 0444, show_current_governor, NULL);
 
-static struct attribute *cpuclass_default_attrs[] = {
-	&attr_current_driver.attr,
-	&attr_current_governor_ro.attr,
+static struct attribute *cpuidle_default_attrs[] = {
+	&dev_attr_current_driver.attr,
+	&dev_attr_current_governor_ro.attr,
 	NULL
 };
 
-static SYSDEV_CLASS_ATTR(available_governors, 0444, show_available_governors,
-			 NULL);
-static SYSDEV_CLASS_ATTR(current_governor, 0644, show_current_governor,
-			 store_current_governor);
+static DEVICE_ATTR(available_governors, 0444, show_available_governors, NULL);
+static DEVICE_ATTR(current_governor, 0644, show_current_governor,
+		   store_current_governor);
 
-static struct attribute *cpuclass_switch_attrs[] = {
-	&attr_available_governors.attr,
-	&attr_current_driver.attr,
-	&attr_current_governor.attr,
+static struct attribute *cpuidle_switch_attrs[] = {
+	&dev_attr_available_governors.attr,
+	&dev_attr_current_driver.attr,
+	&dev_attr_current_governor.attr,
 	NULL
 };
 
-static struct attribute_group cpuclass_attr_group = {
-	.attrs = cpuclass_default_attrs,
+static struct attribute_group cpuidle_attr_group = {
+	.attrs = cpuidle_default_attrs,
 	.name = "cpuidle",
 };
 
 /**
- * cpuidle_add_class_sysfs - add CPU global sysfs attributes
+ * cpuidle_add_interface - add CPU global sysfs attributes
  */
-int cpuidle_add_class_sysfs(struct sysdev_class *cls)
+int cpuidle_add_interface(struct device *dev)
 {
 	if (sysfs_switch)
-		cpuclass_attr_group.attrs = cpuclass_switch_attrs;
+		cpuidle_attr_group.attrs = cpuidle_switch_attrs;
 
-	return sysfs_create_group(&cls->kset.kobj, &cpuclass_attr_group);
+	return sysfs_create_group(&dev->kobj, &cpuidle_attr_group);
 }
 
 /**
- * cpuidle_remove_class_sysfs - remove CPU global sysfs attributes
+ * cpuidle_remove_interface - remove CPU global sysfs attributes
  */
-void cpuidle_remove_class_sysfs(struct sysdev_class *cls)
+void cpuidle_remove_interface(struct device *dev)
 {
-	sysfs_remove_group(&cls->kset.kobj, &cpuclass_attr_group);
+	sysfs_remove_group(&dev->kobj, &cpuidle_attr_group);
 }
 
 struct cpuidle_attr {
@@ -365,16 +363,16 @@ void cpuidle_remove_state_sysfs(struct cpuidle_device *device)
 
 /**
  * cpuidle_add_sysfs - creates a sysfs instance for the target device
- * @sysdev: the target device
+ * @dev: the target device
  */
-int cpuidle_add_sysfs(struct sys_device *sysdev)
+int cpuidle_add_sysfs(struct device *cpu_dev)
 {
-	int cpu = sysdev->id;
+	int cpu = cpu_dev->id;
 	struct cpuidle_device *dev;
 	int error;
 
 	dev = per_cpu(cpuidle_devices, cpu);
-	error = kobject_init_and_add(&dev->kobj, &ktype_cpuidle, &sysdev->kobj,
+	error = kobject_init_and_add(&dev->kobj, &ktype_cpuidle, &cpu_dev->kobj,
 				     "cpuidle");
 	if (!error)
 		kobject_uevent(&dev->kobj, KOBJ_ADD);
@@ -383,11 +381,11 @@ int cpuidle_add_sysfs(struct sys_device *sysdev)
 
 /**
  * cpuidle_remove_sysfs - deletes a sysfs instance on the target device
- * @sysdev: the target device
+ * @dev: the target device
  */
-void cpuidle_remove_sysfs(struct sys_device *sysdev)
+void cpuidle_remove_sysfs(struct device *cpu_dev)
 {
-	int cpu = sysdev->id;
+	int cpu = cpu_dev->id;
 	struct cpuidle_device *dev;
 
 	dev = per_cpu(cpuidle_devices, cpu);
diff --git a/drivers/edac/edac_core.h b/drivers/edac/edac_core.h
index fe90cd4..e48ab31 100644
--- a/drivers/edac/edac_core.h
+++ b/drivers/edac/edac_core.h
@@ -32,7 +32,6 @@
 #include <linux/completion.h>
 #include <linux/kobject.h>
 #include <linux/platform_device.h>
-#include <linux/sysdev.h>
 #include <linux/workqueue.h>
 #include <linux/edac.h>
 
@@ -243,8 +242,8 @@ struct edac_device_ctl_info {
 	 */
 	struct edac_dev_sysfs_attribute *sysfs_attributes;
 
-	/* pointer to main 'edac' class in sysfs */
-	struct sysdev_class *edac_class;
+	/* pointer to main 'edac' subsys in sysfs */
+	struct bus_type *edac_subsys;
 
 	/* the internal state of this controller instance */
 	int op_state;
@@ -342,7 +341,7 @@ struct edac_pci_ctl_info {
 
 	int pci_idx;
 
-	struct sysdev_class *edac_class;	/* pointer to class */
+	struct bus_type *edac_subsys;	/* pointer to subsystem */
 
 	/* the internal state of this controller instance */
 	int op_state;
diff --git a/drivers/edac/edac_device.c b/drivers/edac/edac_device.c
index c3f6743..4b15459 100644
--- a/drivers/edac/edac_device.c
+++ b/drivers/edac/edac_device.c
@@ -23,7 +23,6 @@
 #include <linux/jiffies.h>
 #include <linux/spinlock.h>
 #include <linux/list.h>
-#include <linux/sysdev.h>
 #include <linux/ctype.h>
 #include <linux/workqueue.h>
 #include <asm/uaccess.h>
diff --git a/drivers/edac/edac_device_sysfs.c b/drivers/edac/edac_device_sysfs.c
index 86649df..b4ea185 100644
--- a/drivers/edac/edac_device_sysfs.c
+++ b/drivers/edac/edac_device_sysfs.c
@@ -1,5 +1,5 @@
 /*
- * file for managing the edac_device class of devices for EDAC
+ * file for managing the edac_device subsystem of devices for EDAC
  *
  * (C) 2007 SoftwareBitMaker 
  *
@@ -230,21 +230,21 @@ static struct kobj_type ktype_device_ctrl = {
  */
 int edac_device_register_sysfs_main_kobj(struct edac_device_ctl_info *edac_dev)
 {
-	struct sysdev_class *edac_class;
+	struct bus_type *edac_subsys;
 	int err;
 
 	debugf1("%s()\n", __func__);
 
 	/* get the /sys/devices/system/edac reference */
-	edac_class = edac_get_sysfs_class();
-	if (edac_class == NULL) {
-		debugf1("%s() no edac_class error\n", __func__);
+	edac_subsys = edac_get_sysfs_subsys();
+	if (edac_subsys == NULL) {
+		debugf1("%s() no edac_subsys error\n", __func__);
 		err = -ENODEV;
 		goto err_out;
 	}
 
-	/* Point to the 'edac_class' this instance 'reports' to */
-	edac_dev->edac_class = edac_class;
+	/* Point to the 'edac_subsys' this instance 'reports' to */
+	edac_dev->edac_subsys = edac_subsys;
 
 	/* Init the devices's kobject */
 	memset(&edac_dev->kobj, 0, sizeof(struct kobject));
@@ -261,7 +261,7 @@ int edac_device_register_sysfs_main_kobj(struct edac_device_ctl_info *edac_dev)
 
 	/* register */
 	err = kobject_init_and_add(&edac_dev->kobj, &ktype_device_ctrl,
-				   &edac_class->kset.kobj,
+				   &edac_subsys->dev_root->kobj,
 				   "%s", edac_dev->name);
 	if (err) {
 		debugf1("%s()Failed to register '.../edac/%s'\n",
@@ -284,7 +284,7 @@ err_kobj_reg:
 	module_put(edac_dev->owner);
 
 err_mod_get:
-	edac_put_sysfs_class();
+	edac_put_sysfs_subsys();
 
 err_out:
 	return err;
@@ -308,7 +308,7 @@ void edac_device_unregister_sysfs_main_kobj(struct edac_device_ctl_info *dev)
 	 *   b) 'kfree' the memory
 	 */
 	kobject_put(&dev->kobj);
-	edac_put_sysfs_class();
+	edac_put_sysfs_subsys();
 }
 
 /* edac_dev -> instance information */
diff --git a/drivers/edac/edac_mc.c b/drivers/edac/edac_mc.c
index d69144a..ca6c04d 100644
--- a/drivers/edac/edac_mc.c
+++ b/drivers/edac/edac_mc.c
@@ -25,7 +25,6 @@
 #include <linux/jiffies.h>
 #include <linux/spinlock.h>
 #include <linux/list.h>
-#include <linux/sysdev.h>
 #include <linux/ctype.h>
 #include <linux/edac.h>
 #include <asm/uaccess.h>
diff --git a/drivers/edac/edac_mc_sysfs.c b/drivers/edac/edac_mc_sysfs.c
index 29ffa35..d56e634 100644
--- a/drivers/edac/edac_mc_sysfs.c
+++ b/drivers/edac/edac_mc_sysfs.c
@@ -1021,19 +1021,19 @@ void edac_remove_sysfs_mci_device(struct mem_ctl_info *mci)
 int edac_sysfs_setup_mc_kset(void)
 {
 	int err = -EINVAL;
-	struct sysdev_class *edac_class;
+	struct bus_type *edac_subsys;
 
 	debugf1("%s()\n", __func__);
 
-	/* get the /sys/devices/system/edac class reference */
-	edac_class = edac_get_sysfs_class();
-	if (edac_class == NULL) {
-		debugf1("%s() no edac_class error=%d\n", __func__, err);
+	/* get the /sys/devices/system/edac subsys reference */
+	edac_subsys = edac_get_sysfs_subsys();
+	if (edac_subsys == NULL) {
+		debugf1("%s() no edac_subsys error=%d\n", __func__, err);
 		goto fail_out;
 	}
 
 	/* Init the MC's kobject */
-	mc_kset = kset_create_and_add("mc", NULL, &edac_class->kset.kobj);
+	mc_kset = kset_create_and_add("mc", NULL, &edac_subsys->dev_root->kobj);
 	if (!mc_kset) {
 		err = -ENOMEM;
 		debugf1("%s() Failed to register '.../edac/mc'\n", __func__);
@@ -1045,7 +1045,7 @@ int edac_sysfs_setup_mc_kset(void)
 	return 0;
 
 fail_kset:
-	edac_put_sysfs_class();
+	edac_put_sysfs_subsys();
 
 fail_out:
 	return err;
@@ -1059,6 +1059,6 @@ fail_out:
 void edac_sysfs_teardown_mc_kset(void)
 {
 	kset_unregister(mc_kset);
-	edac_put_sysfs_class();
+	edac_put_sysfs_subsys();
 }
 
diff --git a/drivers/edac/edac_module.h b/drivers/edac/edac_module.h
index 17aabb7..00f81b4 100644
--- a/drivers/edac/edac_module.h
+++ b/drivers/edac/edac_module.h
@@ -10,8 +10,6 @@
 #ifndef	__EDAC_MODULE_H__
 #define	__EDAC_MODULE_H__
 
-#include <linux/sysdev.h>
-
 #include "edac_core.h"
 
 /*
diff --git a/drivers/edac/edac_pci.c b/drivers/edac/edac_pci.c
index 2b378207..63af1c5 100644
--- a/drivers/edac/edac_pci.c
+++ b/drivers/edac/edac_pci.c
@@ -19,7 +19,6 @@
 #include <linux/slab.h>
 #include <linux/spinlock.h>
 #include <linux/list.h>
-#include <linux/sysdev.h>
 #include <linux/ctype.h>
 #include <linux/workqueue.h>
 #include <asm/uaccess.h>
diff --git a/drivers/edac/edac_pci_sysfs.c b/drivers/edac/edac_pci_sysfs.c
index 495198a..97f5064 100644
--- a/drivers/edac/edac_pci_sysfs.c
+++ b/drivers/edac/edac_pci_sysfs.c
@@ -338,12 +338,12 @@ static struct kobj_type ktype_edac_pci_main_kobj = {
  * edac_pci_main_kobj_setup()
  *
  *	setup the sysfs for EDAC PCI attributes
- *	assumes edac_class has already been initialized
+ *	assumes edac_subsys has already been initialized
  */
 static int edac_pci_main_kobj_setup(void)
 {
 	int err;
-	struct sysdev_class *edac_class;
+	struct bus_type *edac_subsys;
 
 	debugf0("%s()\n", __func__);
 
@@ -354,9 +354,9 @@ static int edac_pci_main_kobj_setup(void)
 	/* First time, so create the main kobject and its
 	 * controls and attributes
 	 */
-	edac_class = edac_get_sysfs_class();
-	if (edac_class == NULL) {
-		debugf1("%s() no edac_class\n", __func__);
+	edac_subsys = edac_get_sysfs_subsys();
+	if (edac_subsys == NULL) {
+		debugf1("%s() no edac_subsys\n", __func__);
 		err = -ENODEV;
 		goto decrement_count_fail;
 	}
@@ -381,7 +381,7 @@ static int edac_pci_main_kobj_setup(void)
 	/* Instanstiate the pci object */
 	err = kobject_init_and_add(edac_pci_top_main_kobj,
 				   &ktype_edac_pci_main_kobj,
-				   &edac_class->kset.kobj, "pci");
+				   &edac_subsys->dev_root->kobj, "pci");
 	if (err) {
 		debugf1("Failed to register '.../edac/pci'\n");
 		goto kobject_init_and_add_fail;
@@ -404,7 +404,7 @@ kzalloc_fail:
 	module_put(THIS_MODULE);
 
 mod_get_fail:
-	edac_put_sysfs_class();
+	edac_put_sysfs_subsys();
 
 decrement_count_fail:
 	/* if are on this error exit, nothing to tear down */
@@ -432,7 +432,7 @@ static void edac_pci_main_kobj_teardown(void)
 			__func__);
 		kobject_put(edac_pci_top_main_kobj);
 	}
-	edac_put_sysfs_class();
+	edac_put_sysfs_subsys();
 }
 
 /*
diff --git a/drivers/edac/edac_stub.c b/drivers/edac/edac_stub.c
index 86ad2ee..670c448 100644
--- a/drivers/edac/edac_stub.c
+++ b/drivers/edac/edac_stub.c
@@ -26,7 +26,7 @@ EXPORT_SYMBOL_GPL(edac_handlers);
 int edac_err_assert = 0;
 EXPORT_SYMBOL_GPL(edac_err_assert);
 
-static atomic_t edac_class_valid = ATOMIC_INIT(0);
+static atomic_t edac_subsys_valid = ATOMIC_INIT(0);
 
 /*
  * called to determine if there is an EDAC driver interested in
@@ -54,36 +54,37 @@ EXPORT_SYMBOL_GPL(edac_atomic_assert_error);
  * sysfs object: /sys/devices/system/edac
  *	need to export to other files
  */
-struct sysdev_class edac_class = {
+struct bus_type edac_subsys = {
 	.name = "edac",
+	.dev_name = "edac",
 };
-EXPORT_SYMBOL_GPL(edac_class);
+EXPORT_SYMBOL_GPL(edac_subsys);
 
 /* return pointer to the 'edac' node in sysfs */
-struct sysdev_class *edac_get_sysfs_class(void)
+struct bus_type *edac_get_sysfs_subsys(void)
 {
 	int err = 0;
 
-	if (atomic_read(&edac_class_valid))
+	if (atomic_read(&edac_subsys_valid))
 		goto out;
 
 	/* create the /sys/devices/system/edac directory */
-	err = sysdev_class_register(&edac_class);
+	err = subsys_system_register(&edac_subsys, NULL);
 	if (err) {
 		printk(KERN_ERR "Error registering toplevel EDAC sysfs dir\n");
 		return NULL;
 	}
 
 out:
-	atomic_inc(&edac_class_valid);
-	return &edac_class;
+	atomic_inc(&edac_subsys_valid);
+	return &edac_subsys;
 }
-EXPORT_SYMBOL_GPL(edac_get_sysfs_class);
+EXPORT_SYMBOL_GPL(edac_get_sysfs_subsys);
 
-void edac_put_sysfs_class(void)
+void edac_put_sysfs_subsys(void)
 {
 	/* last user unregisters it */
-	if (atomic_dec_and_test(&edac_class_valid))
-		sysdev_class_unregister(&edac_class);
+	if (atomic_dec_and_test(&edac_subsys_valid))
+		bus_unregister(&edac_subsys);
 }
-EXPORT_SYMBOL_GPL(edac_put_sysfs_class);
+EXPORT_SYMBOL_GPL(edac_put_sysfs_subsys);
diff --git a/drivers/edac/mce_amd_inj.c b/drivers/edac/mce_amd_inj.c
index 73c3e26..885e8ad 100644
--- a/drivers/edac/mce_amd_inj.c
+++ b/drivers/edac/mce_amd_inj.c
@@ -11,7 +11,6 @@
  */
 
 #include <linux/kobject.h>
-#include <linux/sysdev.h>
 #include <linux/edac.h>
 #include <linux/module.h>
 #include <asm/mce.h>
@@ -116,14 +115,14 @@ static struct edac_mce_attr *sysfs_attrs[] = { &mce_attr_status, &mce_attr_misc,
 
 static int __init edac_init_mce_inject(void)
 {
-	struct sysdev_class *edac_class = NULL;
+	struct bus_type *edac_subsys = NULL;
 	int i, err = 0;
 
-	edac_class = edac_get_sysfs_class();
-	if (!edac_class)
+	edac_subsys = edac_get_sysfs_subsys();
+	if (!edac_subsys)
 		return -EINVAL;
 
-	mce_kobj = kobject_create_and_add("mce", &edac_class->kset.kobj);
+	mce_kobj = kobject_create_and_add("mce", &edac_subsys->dev_root->kobj);
 	if (!mce_kobj) {
 		printk(KERN_ERR "Error creating a mce kset.\n");
 		err = -ENOMEM;
@@ -147,7 +146,7 @@ err_sysfs_create:
 	kobject_del(mce_kobj);
 
 err_mce_kobj:
-	edac_put_sysfs_class();
+	edac_put_sysfs_subsys();
 
 	return err;
 }
@@ -161,7 +160,7 @@ static void __exit edac_exit_mce_inject(void)
 
 	kobject_del(mce_kobj);
 
-	edac_put_sysfs_class();
+	edac_put_sysfs_subsys();
 }
 
 module_init(edac_init_mce_inject);
diff --git a/drivers/leds/led-class.c b/drivers/leds/led-class.c
index 6d5628b..0c8739c 100644
--- a/drivers/leds/led-class.c
+++ b/drivers/leds/led-class.c
@@ -15,7 +15,6 @@
 #include <linux/list.h>
 #include <linux/spinlock.h>
 #include <linux/device.h>
-#include <linux/sysdev.h>
 #include <linux/timer.h>
 #include <linux/err.h>
 #include <linux/ctype.h>
diff --git a/drivers/leds/led-triggers.c b/drivers/leds/led-triggers.c
index 6f1ff93..46b4c76 100644
--- a/drivers/leds/led-triggers.c
+++ b/drivers/leds/led-triggers.c
@@ -17,7 +17,6 @@
 #include <linux/list.h>
 #include <linux/spinlock.h>
 #include <linux/device.h>
-#include <linux/sysdev.h>
 #include <linux/timer.h>
 #include <linux/rwsem.h>
 #include <linux/leds.h>
diff --git a/drivers/net/bonding/bond_sysfs.c b/drivers/net/bonding/bond_sysfs.c
index 4ef7e2f..aef42f0 100644
--- a/drivers/net/bonding/bond_sysfs.c
+++ b/drivers/net/bonding/bond_sysfs.c
@@ -26,7 +26,6 @@
 #include <linux/module.h>
 #include <linux/device.h>
 #include <linux/sched.h>
-#include <linux/sysdev.h>
 #include <linux/fs.h>
 #include <linux/types.h>
 #include <linux/string.h>
diff --git a/drivers/platform/x86/ibm_rtl.c b/drivers/platform/x86/ibm_rtl.c
index 811d436..12ca930 100644
--- a/drivers/platform/x86/ibm_rtl.c
+++ b/drivers/platform/x86/ibm_rtl.c
@@ -28,7 +28,6 @@
 #include <linux/delay.h>
 #include <linux/module.h>
 #include <linux/io.h>
-#include <linux/sysdev.h>
 #include <linux/dmi.h>
 #include <linux/efi.h>
 #include <linux/mutex.h>
@@ -165,22 +164,22 @@ static int ibm_rtl_write(u8 value)
 	return ret;
 }
 
-static ssize_t rtl_show_version(struct sysdev_class * dev,
-                                struct sysdev_class_attribute *attr,
+static ssize_t rtl_show_version(struct device * dev,
+                                struct device_attribute *attr,
                                 char *buf)
 {
 	return sprintf(buf, "%d\n", (int)ioread8(&rtl_table->version));
 }
 
-static ssize_t rtl_show_state(struct sysdev_class *dev,
-                              struct sysdev_class_attribute *attr,
+static ssize_t rtl_show_state(struct device *dev,
+                              struct device_attribute *attr,
                               char *buf)
 {
 	return sprintf(buf, "%d\n", ioread8(&rtl_table->rt_status));
 }
 
-static ssize_t rtl_set_state(struct sysdev_class *dev,
-                             struct sysdev_class_attribute *attr,
+static ssize_t rtl_set_state(struct device *dev,
+                             struct device_attribute *attr,
                              const char *buf,
                              size_t count)
 {
@@ -205,27 +204,28 @@ static ssize_t rtl_set_state(struct sysdev_class *dev,
 	return ret;
 }
 
-static struct sysdev_class class_rtl = {
+static struct bus_type rtl_subsys = {
 	.name = "ibm_rtl",
+	.dev_name = "ibm_rtl",
 };
 
-static SYSDEV_CLASS_ATTR(version, S_IRUGO, rtl_show_version, NULL);
-static SYSDEV_CLASS_ATTR(state, 0600, rtl_show_state, rtl_set_state);
+static DEVICE_ATTR(version, S_IRUGO, rtl_show_version, NULL);
+static DEVICE_ATTR(state, 0600, rtl_show_state, rtl_set_state);
 
-static struct sysdev_class_attribute *rtl_attributes[] = {
-	&attr_version,
-	&attr_state,
+static struct device_attribute *rtl_attributes[] = {
+	&dev_attr_version,
+	&dev_attr_state,
 	NULL
 };
 
 
 static int rtl_setup_sysfs(void) {
 	int ret, i;
-	ret = sysdev_class_register(&class_rtl);
 
+	ret = subsys_system_register(&rtl_subsys, NULL);
 	if (!ret) {
 		for (i = 0; rtl_attributes[i]; i ++)
-			sysdev_class_create_file(&class_rtl, rtl_attributes[i]);
+			device_create_file(rtl_subsys.dev_root, rtl_attributes[i]);
 	}
 	return ret;
 }
@@ -233,8 +233,8 @@ static int rtl_setup_sysfs(void) {
 static void rtl_teardown_sysfs(void) {
 	int i;
 	for (i = 0; rtl_attributes[i]; i ++)
-		sysdev_class_remove_file(&class_rtl, rtl_attributes[i]);
-	sysdev_class_unregister(&class_rtl);
+		device_remove_file(rtl_subsys.dev_root, rtl_attributes[i]);
+	bus_unregister(&rtl_subsys);
 }
 
 
diff --git a/drivers/xen/xen-balloon.c b/drivers/xen/xen-balloon.c
index 9cc2259..3832e30 100644
--- a/drivers/xen/xen-balloon.c
+++ b/drivers/xen/xen-balloon.c
@@ -32,7 +32,6 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/sysdev.h>
 #include <linux/capability.h>
 
 #include <xen/xen.h>
@@ -46,9 +45,9 @@
 
 #define BALLOON_CLASS_NAME "xen_memory"
 
-static struct sys_device balloon_sysdev;
+static struct device balloon_dev;
 
-static int register_balloon(struct sys_device *sysdev);
+static int register_balloon(struct device *dev);
 
 /* React to a change in the target key */
 static void watch_target(struct xenbus_watch *watch,
@@ -98,9 +97,9 @@ static int __init balloon_init(void)
 
 	pr_info("xen-balloon: Initialising balloon driver.\n");
 
-	register_balloon(&balloon_sysdev);
+	register_balloon(&balloon_dev);
 
-	register_xen_selfballooning(&balloon_sysdev);
+	register_xen_selfballooning(&balloon_dev);
 
 	register_xenstore_notifier(&xenstore_notifier);
 
@@ -117,31 +116,31 @@ static void balloon_exit(void)
 module_exit(balloon_exit);
 
 #define BALLOON_SHOW(name, format, args...)				\
-	static ssize_t show_##name(struct sys_device *dev,		\
-				   struct sysdev_attribute *attr,	\
+	static ssize_t show_##name(struct device *dev,			\
+				   struct device_attribute *attr,	\
 				   char *buf)				\
 	{								\
 		return sprintf(buf, format, ##args);			\
 	}								\
-	static SYSDEV_ATTR(name, S_IRUGO, show_##name, NULL)
+	static DEVICE_ATTR(name, S_IRUGO, show_##name, NULL)
 
 BALLOON_SHOW(current_kb, "%lu\n", PAGES2KB(balloon_stats.current_pages));
 BALLOON_SHOW(low_kb, "%lu\n", PAGES2KB(balloon_stats.balloon_low));
 BALLOON_SHOW(high_kb, "%lu\n", PAGES2KB(balloon_stats.balloon_high));
 
-static SYSDEV_ULONG_ATTR(schedule_delay, 0444, balloon_stats.schedule_delay);
-static SYSDEV_ULONG_ATTR(max_schedule_delay, 0644, balloon_stats.max_schedule_delay);
-static SYSDEV_ULONG_ATTR(retry_count, 0444, balloon_stats.retry_count);
-static SYSDEV_ULONG_ATTR(max_retry_count, 0644, balloon_stats.max_retry_count);
+static DEVICE_ULONG_ATTR(schedule_delay, 0444, balloon_stats.schedule_delay);
+static DEVICE_ULONG_ATTR(max_schedule_delay, 0644, balloon_stats.max_schedule_delay);
+static DEVICE_ULONG_ATTR(retry_count, 0444, balloon_stats.retry_count);
+static DEVICE_ULONG_ATTR(max_retry_count, 0644, balloon_stats.max_retry_count);
 
-static ssize_t show_target_kb(struct sys_device *dev, struct sysdev_attribute *attr,
+static ssize_t show_target_kb(struct device *dev, struct device_attribute *attr,
 			      char *buf)
 {
 	return sprintf(buf, "%lu\n", PAGES2KB(balloon_stats.target_pages));
 }
 
-static ssize_t store_target_kb(struct sys_device *dev,
-			       struct sysdev_attribute *attr,
+static ssize_t store_target_kb(struct device *dev,
+			       struct device_attribute *attr,
 			       const char *buf,
 			       size_t count)
 {
@@ -158,11 +157,11 @@ static ssize_t store_target_kb(struct sys_device *dev,
 	return count;
 }
 
-static SYSDEV_ATTR(target_kb, S_IRUGO | S_IWUSR,
+static DEVICE_ATTR(target_kb, S_IRUGO | S_IWUSR,
 		   show_target_kb, store_target_kb);
 
 
-static ssize_t show_target(struct sys_device *dev, struct sysdev_attribute *attr,
+static ssize_t show_target(struct device *dev, struct device_attribute *attr,
 			      char *buf)
 {
 	return sprintf(buf, "%llu\n",
@@ -170,8 +169,8 @@ static ssize_t show_target(struct sys_device *dev, struct sysdev_attribute *attr
 		       << PAGE_SHIFT);
 }
 
-static ssize_t store_target(struct sys_device *dev,
-			    struct sysdev_attribute *attr,
+static ssize_t store_target(struct device *dev,
+			    struct device_attribute *attr,
 			    const char *buf,
 			    size_t count)
 {
@@ -188,23 +187,23 @@ static ssize_t store_target(struct sys_device *dev,
 	return count;
 }
 
-static SYSDEV_ATTR(target, S_IRUGO | S_IWUSR,
+static DEVICE_ATTR(target, S_IRUGO | S_IWUSR,
 		   show_target, store_target);
 
 
-static struct sysdev_attribute *balloon_attrs[] = {
-	&attr_target_kb,
-	&attr_target,
-	&attr_schedule_delay.attr,
-	&attr_max_schedule_delay.attr,
-	&attr_retry_count.attr,
-	&attr_max_retry_count.attr
+static struct device_attribute *balloon_attrs[] = {
+	&dev_attr_target_kb,
+	&dev_attr_target,
+	&dev_attr_schedule_delay.attr,
+	&dev_attr_max_schedule_delay.attr,
+	&dev_attr_retry_count.attr,
+	&dev_attr_max_retry_count.attr
 };
 
 static struct attribute *balloon_info_attrs[] = {
-	&attr_current_kb.attr,
-	&attr_low_kb.attr,
-	&attr_high_kb.attr,
+	&dev_attr_current_kb.attr,
+	&dev_attr_low_kb.attr,
+	&dev_attr_high_kb.attr,
 	NULL
 };
 
@@ -213,34 +212,35 @@ static struct attribute_group balloon_info_group = {
 	.attrs = balloon_info_attrs
 };
 
-static struct sysdev_class balloon_sysdev_class = {
-	.name = BALLOON_CLASS_NAME
+static struct bus_type balloon_subsys = {
+	.name = BALLOON_CLASS_NAME,
+	.dev_name = BALLOON_CLASS_NAME,
 };
 
-static int register_balloon(struct sys_device *sysdev)
+static int register_balloon(struct device *dev)
 {
 	int i, error;
 
-	error = sysdev_class_register(&balloon_sysdev_class);
+	error = bus_register(&balloon_subsys);
 	if (error)
 		return error;
 
-	sysdev->id = 0;
-	sysdev->cls = &balloon_sysdev_class;
+	dev->id = 0;
+	dev->bus = &balloon_subsys;
 
-	error = sysdev_register(sysdev);
+	error = device_register(dev);
 	if (error) {
-		sysdev_class_unregister(&balloon_sysdev_class);
+		bus_unregister(&balloon_subsys);
 		return error;
 	}
 
 	for (i = 0; i < ARRAY_SIZE(balloon_attrs); i++) {
-		error = sysdev_create_file(sysdev, balloon_attrs[i]);
+		error = device_create_file(dev, balloon_attrs[i]);
 		if (error)
 			goto fail;
 	}
 
-	error = sysfs_create_group(&sysdev->kobj, &balloon_info_group);
+	error = sysfs_create_group(&dev->kobj, &balloon_info_group);
 	if (error)
 		goto fail;
 
@@ -248,9 +248,9 @@ static int register_balloon(struct sys_device *sysdev)
 
  fail:
 	while (--i >= 0)
-		sysdev_remove_file(sysdev, balloon_attrs[i]);
-	sysdev_unregister(sysdev);
-	sysdev_class_unregister(&balloon_sysdev_class);
+		device_remove_file(dev, balloon_attrs[i]);
+	device_unregister(dev);
+	bus_unregister(&balloon_subsys);
 	return error;
 }
 
diff --git a/drivers/xen/xen-selfballoon.c b/drivers/xen/xen-selfballoon.c
index d93c708..b7b9e95 100644
--- a/drivers/xen/xen-selfballoon.c
+++ b/drivers/xen/xen-selfballoon.c
@@ -266,21 +266,20 @@ static void selfballoon_process(struct work_struct *work)
 
 #ifdef CONFIG_SYSFS
 
-#include <linux/sysdev.h>
 #include <linux/capability.h>
 
 #define SELFBALLOON_SHOW(name, format, args...)				\
-	static ssize_t show_##name(struct sys_device *dev,	\
-					   struct sysdev_attribute *attr, \
-					   char *buf) \
+	static ssize_t show_##name(struct device *dev,	\
+					  struct device_attribute *attr, \
+					  char *buf) \
 	{ \
 		return sprintf(buf, format, ##args); \
 	}
 
 SELFBALLOON_SHOW(selfballooning, "%d\n", xen_selfballooning_enabled);
 
-static ssize_t store_selfballooning(struct sys_device *dev,
-			    struct sysdev_attribute *attr,
+static ssize_t store_selfballooning(struct device *dev,
+			    struct device_attribute *attr,
 			    const char *buf,
 			    size_t count)
 {
@@ -303,13 +302,13 @@ static ssize_t store_selfballooning(struct sys_device *dev,
 	return count;
 }
 
-static SYSDEV_ATTR(selfballooning, S_IRUGO | S_IWUSR,
+static DEVICE_ATTR(selfballooning, S_IRUGO | S_IWUSR,
 		   show_selfballooning, store_selfballooning);
 
 SELFBALLOON_SHOW(selfballoon_interval, "%d\n", selfballoon_interval);
 
-static ssize_t store_selfballoon_interval(struct sys_device *dev,
-					  struct sysdev_attribute *attr,
+static ssize_t store_selfballoon_interval(struct device *dev,
+					  struct device_attribute *attr,
 					  const char *buf,
 					  size_t count)
 {
@@ -325,13 +324,13 @@ static ssize_t store_selfballoon_interval(struct sys_device *dev,
 	return count;
 }
 
-static SYSDEV_ATTR(selfballoon_interval, S_IRUGO | S_IWUSR,
+static DEVICE_ATTR(selfballoon_interval, S_IRUGO | S_IWUSR,
 		   show_selfballoon_interval, store_selfballoon_interval);
 
 SELFBALLOON_SHOW(selfballoon_downhys, "%d\n", selfballoon_downhysteresis);
 
-static ssize_t store_selfballoon_downhys(struct sys_device *dev,
-					 struct sysdev_attribute *attr,
+static ssize_t store_selfballoon_downhys(struct device *dev,
+					 struct device_attribute *attr,
 					 const char *buf,
 					 size_t count)
 {
@@ -347,14 +346,14 @@ static ssize_t store_selfballoon_downhys(struct sys_device *dev,
 	return count;
 }
 
-static SYSDEV_ATTR(selfballoon_downhysteresis, S_IRUGO | S_IWUSR,
+static DEVICE_ATTR(selfballoon_downhysteresis, S_IRUGO | S_IWUSR,
 		   show_selfballoon_downhys, store_selfballoon_downhys);
 
 
 SELFBALLOON_SHOW(selfballoon_uphys, "%d\n", selfballoon_uphysteresis);
 
-static ssize_t store_selfballoon_uphys(struct sys_device *dev,
-				       struct sysdev_attribute *attr,
+static ssize_t store_selfballoon_uphys(struct device *dev,
+				       struct device_attribute *attr,
 				       const char *buf,
 				       size_t count)
 {
@@ -370,14 +369,14 @@ static ssize_t store_selfballoon_uphys(struct sys_device *dev,
 	return count;
 }
 
-static SYSDEV_ATTR(selfballoon_uphysteresis, S_IRUGO | S_IWUSR,
+static DEVICE_ATTR(selfballoon_uphysteresis, S_IRUGO | S_IWUSR,
 		   show_selfballoon_uphys, store_selfballoon_uphys);
 
 SELFBALLOON_SHOW(selfballoon_min_usable_mb, "%d\n",
 				selfballoon_min_usable_mb);
 
-static ssize_t store_selfballoon_min_usable_mb(struct sys_device *dev,
-					       struct sysdev_attribute *attr,
+static ssize_t store_selfballoon_min_usable_mb(struct device *dev,
+					       struct device_attribute *attr,
 					       const char *buf,
 					       size_t count)
 {
@@ -393,7 +392,7 @@ static ssize_t store_selfballoon_min_usable_mb(struct sys_device *dev,
 	return count;
 }
 
-static SYSDEV_ATTR(selfballoon_min_usable_mb, S_IRUGO | S_IWUSR,
+static DEVICE_ATTR(selfballoon_min_usable_mb, S_IRUGO | S_IWUSR,
 		   show_selfballoon_min_usable_mb,
 		   store_selfballoon_min_usable_mb);
 
@@ -401,8 +400,8 @@ static SYSDEV_ATTR(selfballoon_min_usable_mb, S_IRUGO | S_IWUSR,
 #ifdef CONFIG_FRONTSWAP
 SELFBALLOON_SHOW(frontswap_selfshrinking, "%d\n", frontswap_selfshrinking);
 
-static ssize_t store_frontswap_selfshrinking(struct sys_device *dev,
-					     struct sysdev_attribute *attr,
+static ssize_t store_frontswap_selfshrinking(struct device *dev,
+					     struct device_attribute *attr,
 					     const char *buf,
 					     size_t count)
 {
@@ -424,13 +423,13 @@ static ssize_t store_frontswap_selfshrinking(struct sys_device *dev,
 	return count;
 }
 
-static SYSDEV_ATTR(frontswap_selfshrinking, S_IRUGO | S_IWUSR,
+static DEVICE_ATTR(frontswap_selfshrinking, S_IRUGO | S_IWUSR,
 		   show_frontswap_selfshrinking, store_frontswap_selfshrinking);
 
 SELFBALLOON_SHOW(frontswap_inertia, "%d\n", frontswap_inertia);
 
-static ssize_t store_frontswap_inertia(struct sys_device *dev,
-				       struct sysdev_attribute *attr,
+static ssize_t store_frontswap_inertia(struct device *dev,
+				       struct device_attribute *attr,
 				       const char *buf,
 				       size_t count)
 {
@@ -447,13 +446,13 @@ static ssize_t store_frontswap_inertia(struct sys_device *dev,
 	return count;
 }
 
-static SYSDEV_ATTR(frontswap_inertia, S_IRUGO | S_IWUSR,
+static DEVICE_ATTR(frontswap_inertia, S_IRUGO | S_IWUSR,
 		   show_frontswap_inertia, store_frontswap_inertia);
 
 SELFBALLOON_SHOW(frontswap_hysteresis, "%d\n", frontswap_hysteresis);
 
-static ssize_t store_frontswap_hysteresis(struct sys_device *dev,
-					  struct sysdev_attribute *attr,
+static ssize_t store_frontswap_hysteresis(struct device *dev,
+					  struct device_attribute *attr,
 					  const char *buf,
 					  size_t count)
 {
@@ -469,21 +468,21 @@ static ssize_t store_frontswap_hysteresis(struct sys_device *dev,
 	return count;
 }
 
-static SYSDEV_ATTR(frontswap_hysteresis, S_IRUGO | S_IWUSR,
+static DEVICE_ATTR(frontswap_hysteresis, S_IRUGO | S_IWUSR,
 		   show_frontswap_hysteresis, store_frontswap_hysteresis);
 
 #endif /* CONFIG_FRONTSWAP */
 
 static struct attribute *selfballoon_attrs[] = {
-	&attr_selfballooning.attr,
-	&attr_selfballoon_interval.attr,
-	&attr_selfballoon_downhysteresis.attr,
-	&attr_selfballoon_uphysteresis.attr,
-	&attr_selfballoon_min_usable_mb.attr,
+	&dev_attr_selfballooning.attr,
+	&dev_attr_selfballoon_interval.attr,
+	&dev_attr_selfballoon_downhysteresis.attr,
+	&dev_attr_selfballoon_uphysteresis.attr,
+	&dev_attr_selfballoon_min_usable_mb.attr,
 #ifdef CONFIG_FRONTSWAP
-	&attr_frontswap_selfshrinking.attr,
-	&attr_frontswap_hysteresis.attr,
-	&attr_frontswap_inertia.attr,
+	&dev_attr_frontswap_selfshrinking.attr,
+	&dev_attr_frontswap_hysteresis.attr,
+	&dev_attr_frontswap_inertia.attr,
 #endif
 	NULL
 };
@@ -494,12 +493,12 @@ static struct attribute_group selfballoon_group = {
 };
 #endif
 
-int register_xen_selfballooning(struct sys_device *sysdev)
+int register_xen_selfballooning(struct device *dev)
 {
 	int error = -1;
 
 #ifdef CONFIG_SYSFS
-	error = sysfs_create_group(&sysdev->kobj, &selfballoon_group);
+	error = sysfs_create_group(&dev->kobj, &selfballoon_group);
 #endif
 	return error;
 }
diff --git a/include/linux/cpu.h b/include/linux/cpu.h
index 6cb60fd..fc3da0d 100644
--- a/include/linux/cpu.h
+++ b/include/linux/cpu.h
@@ -14,7 +14,7 @@
 #ifndef _LINUX_CPU_H_
 #define _LINUX_CPU_H_
 
-#include <linux/sysdev.h>
+#include <linux/device.h>
 #include <linux/node.h>
 #include <linux/compiler.h>
 #include <linux/cpumask.h>
@@ -22,19 +22,19 @@
 struct cpu {
 	int node_id;		/* The node which contains the CPU */
 	int hotpluggable;	/* creates sysfs control file if hotpluggable */
-	struct sys_device sysdev;
+	struct device dev;
 };
 
 extern int register_cpu(struct cpu *cpu, int num);
-extern struct sys_device *get_cpu_sysdev(unsigned cpu);
+extern struct device *get_cpu_device(unsigned cpu);
 
-extern int cpu_add_sysdev_attr(struct sysdev_attribute *attr);
-extern void cpu_remove_sysdev_attr(struct sysdev_attribute *attr);
+extern int cpu_add_dev_attr(struct device_attribute *attr);
+extern void cpu_remove_dev_attr(struct device_attribute *attr);
 
-extern int cpu_add_sysdev_attr_group(struct attribute_group *attrs);
-extern void cpu_remove_sysdev_attr_group(struct attribute_group *attrs);
+extern int cpu_add_dev_attr_group(struct attribute_group *attrs);
+extern void cpu_remove_dev_attr_group(struct attribute_group *attrs);
 
-extern int sched_create_sysfs_power_savings_entries(struct sysdev_class *cls);
+extern int sched_create_sysfs_power_savings_entries(struct device *dev);
 
 #ifdef CONFIG_HOTPLUG_CPU
 extern void unregister_cpu(struct cpu *cpu);
@@ -160,7 +160,7 @@ static inline void cpu_maps_update_done(void)
 }
 
 #endif /* CONFIG_SMP */
-extern struct sysdev_class cpu_sysdev_class;
+extern struct bus_type cpu_subsys;
 
 #ifdef CONFIG_HOTPLUG_CPU
 /* Stop CPUs going up and down. */
diff --git a/include/linux/device.h b/include/linux/device.h
index 3136ede..d319a97 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -53,6 +53,8 @@ extern void bus_remove_file(struct bus_type *, struct bus_attribute *);
  * struct bus_type - The bus type of the device
  *
  * @name:	The name of the bus.
+ * @dev_name:	Used for subsystems to enumerate devices like ("foo%u", dev->id).
+ * @dev_root:	Default device to use as the parent.
  * @bus_attrs:	Default attributes of the bus.
  * @dev_attrs:	Default attributes of the devices on the bus.
  * @drv_attrs:	Default attributes of the device drivers on the bus.
@@ -86,6 +88,8 @@ extern void bus_remove_file(struct bus_type *, struct bus_attribute *);
  */
 struct bus_type {
 	const char		*name;
+	const char		*dev_name;
+	struct device		*dev_root;
 	struct bus_attribute	*bus_attrs;
 	struct device_attribute	*dev_attrs;
 	struct driver_attribute	*drv_attrs;
@@ -106,12 +110,30 @@ struct bus_type {
 	struct subsys_private *p;
 };
 
-extern int __must_check bus_register(struct bus_type *bus);
+/* This is a #define to keep the compiler from merging different
+ * instances of the __key variable */
+#define bus_register(subsys)			\
+({						\
+	static struct lock_class_key __key;	\
+	__bus_register(subsys, &__key);	\
+})
+extern int __must_check __bus_register(struct bus_type *bus,
+				       struct lock_class_key *key);
 extern void bus_unregister(struct bus_type *bus);
 
 extern int __must_check bus_rescan_devices(struct bus_type *bus);
 
 /* iterator helpers for buses */
+struct subsys_dev_iter {
+	struct klist_iter		ki;
+	const struct device_type	*type;
+};
+void subsys_dev_iter_init(struct subsys_dev_iter *iter,
+			 struct bus_type *subsys,
+			 struct device *start,
+			 const struct device_type *type);
+struct device *subsys_dev_iter_next(struct subsys_dev_iter *iter);
+void subsys_dev_iter_exit(struct subsys_dev_iter *iter);
 
 int bus_for_each_dev(struct bus_type *bus, struct device *start, void *data,
 		     int (*fn)(struct device *dev, void *data));
@@ -121,10 +143,8 @@ struct device *bus_find_device(struct bus_type *bus, struct device *start,
 struct device *bus_find_device_by_name(struct bus_type *bus,
 				       struct device *start,
 				       const char *name);
-
 int bus_for_each_drv(struct bus_type *bus, struct device_driver *start,
 		     void *data, int (*fn)(struct device_driver *, void *));
-
 void bus_sort_breadthfirst(struct bus_type *bus,
 			   int (*compare)(const struct device *a,
 					  const struct device *b));
@@ -256,6 +276,33 @@ struct device *driver_find_device(struct device_driver *drv,
 				  int (*match)(struct device *dev, void *data));
 
 /**
+ * struct subsys_interface - interfaces to device functions
+ * @name        name of the device function
+ * @subsystem   subsytem of the devices to attach to
+ * @node        the list of functions registered at the subsystem
+ * @add         device hookup to device function handler
+ * @remove      device hookup to device function handler
+ *
+ * Simple interfaces attached to a subsystem. Multiple interfaces can
+ * attach to a subsystem and its devices. Unlike drivers, they do not
+ * exclusively claim or control devices. Interfaces usually represent
+ * a specific functionality of a subsystem/class of devices.
+ */
+struct subsys_interface {
+	const char *name;
+	struct bus_type *subsys;
+	struct list_head node;
+	int (*add_dev)(struct device *dev, struct subsys_interface *sif);
+	int (*remove_dev)(struct device *dev, struct subsys_interface *sif);
+};
+
+int subsys_interface_register(struct subsys_interface *sif);
+void subsys_interface_unregister(struct subsys_interface *sif);
+
+int subsys_system_register(struct bus_type *subsys,
+		           const struct attribute_group **groups);
+
+/**
  * struct class - device classes
  * @name:	Name of the class.
  * @owner:	The module owner.
@@ -438,8 +485,28 @@ struct device_attribute {
 			 const char *buf, size_t count);
 };
 
+struct dev_ext_attribute {
+	struct device_attribute attr;
+	void *var;
+};
+
+ssize_t device_show_ulong(struct device *dev, struct device_attribute *attr,
+			  char *buf);
+ssize_t device_store_ulong(struct device *dev, struct device_attribute *attr,
+			   const char *buf, size_t count);
+ssize_t device_show_int(struct device *dev, struct device_attribute *attr,
+			char *buf);
+ssize_t device_store_int(struct device *dev, struct device_attribute *attr,
+			 const char *buf, size_t count);
+
 #define DEVICE_ATTR(_name, _mode, _show, _store) \
-struct device_attribute dev_attr_##_name = __ATTR(_name, _mode, _show, _store)
+	struct device_attribute dev_attr_##_name = __ATTR(_name, _mode, _show, _store)
+#define DEVICE_ULONG_ATTR(_name, _mode, _var) \
+	struct dev_ext_attribute dev_attr_##_name = \
+		{ __ATTR(_name, _mode, device_show_ulong, device_store_ulong), &(_var) }
+#define DEVICE_INT_ATTR(_name, _mode, _var) \
+	struct dev_ext_attribute dev_attr_##_name = \
+		{ __ATTR(_name, _mode, device_show_ulong, device_store_ulong), &(_var) }
 
 extern int __must_check device_create_file(struct device *device,
 					const struct device_attribute *entry);
@@ -600,6 +667,7 @@ struct device {
 	struct device_node	*of_node; /* associated device tree node */
 
 	dev_t			devt;	/* dev_t, creates the sysfs "dev" */
+	u32			id;	/* device instance */
 
 	spinlock_t		devres_lock;
 	struct list_head	devres_head;
diff --git a/include/linux/edac.h b/include/linux/edac.h
index 055b248..1cd3947 100644
--- a/include/linux/edac.h
+++ b/include/linux/edac.h
@@ -13,7 +13,7 @@
 #define _LINUX_EDAC_H_
 
 #include <linux/atomic.h>
-#include <linux/sysdev.h>
+#include <linux/device.h>
 
 #define EDAC_OPSTATE_INVAL	-1
 #define EDAC_OPSTATE_POLL	0
@@ -23,12 +23,12 @@
 extern int edac_op_state;
 extern int edac_err_assert;
 extern atomic_t edac_handlers;
-extern struct sysdev_class edac_class;
+extern struct bus_type edac_subsys;
 
 extern int edac_handler_set(void);
 extern void edac_atomic_assert_error(void);
-extern struct sysdev_class *edac_get_sysfs_class(void);
-extern void edac_put_sysfs_class(void);
+extern struct bus_type *edac_get_sysfs_subsys(void);
+extern void edac_put_sysfs_subsys(void);
 
 static inline void opstate_init(void)
 {
diff --git a/include/linux/memory.h b/include/linux/memory.h
index 935699b..1ac7f6e 100644
--- a/include/linux/memory.h
+++ b/include/linux/memory.h
@@ -15,7 +15,6 @@
 #ifndef _LINUX_MEMORY_H_
 #define _LINUX_MEMORY_H_
 
-#include <linux/sysdev.h>
 #include <linux/node.h>
 #include <linux/compiler.h>
 #include <linux/mutex.h>
@@ -38,7 +37,7 @@ struct memory_block {
 	int phys_device;		/* to which fru does this belong? */
 	void *hw;			/* optional pointer to fw/hw data */
 	int (*phys_callback)(struct memory_block *);
-	struct sys_device sysdev;
+	struct device dev;
 };
 
 int arch_get_memory_phys_device(unsigned long start_pfn);
diff --git a/include/linux/node.h b/include/linux/node.h
index 92370e2..65816958 100644
--- a/include/linux/node.h
+++ b/include/linux/node.h
@@ -14,12 +14,12 @@
 #ifndef _LINUX_NODE_H_
 #define _LINUX_NODE_H_
 
-#include <linux/sysdev.h>
+#include <linux/device.h>
 #include <linux/cpumask.h>
 #include <linux/workqueue.h>
 
 struct node {
-	struct sys_device	sysdev;
+	struct device	dev;
 
 #if defined(CONFIG_MEMORY_HOTPLUG_SPARSE) && defined(CONFIG_HUGETLBFS)
 	struct work_struct	node_work;
@@ -80,6 +80,6 @@ static inline void register_hugetlbfs_with_node(node_registration_func_t reg,
 }
 #endif
 
-#define to_node(sys_device) container_of(sys_device, struct node, sysdev)
+#define to_node(sys_device) container_of(sys_device, struct node, dev)
 
 #endif /* _LINUX_NODE_H_ */
diff --git a/include/linux/sysdev.h b/include/linux/sysdev.h
deleted file mode 100644
index 20f63d3..0000000
--- a/include/linux/sysdev.h
+++ /dev/null
@@ -1,164 +0,0 @@
-/**
- * System devices follow a slightly different driver model. 
- * They don't need to do dynammic driver binding, can't be probed, 
- * and don't reside on any type of peripheral bus. 
- * So, we represent and treat them a little differently.
- * 
- * We still have a notion of a driver for a system device, because we still
- * want to perform basic operations on these devices. 
- *
- * We also support auxiliary drivers binding to devices of a certain class.
- * 
- * This allows configurable drivers to register themselves for devices of
- * a certain type. And, it allows class definitions to reside in generic
- * code while arch-specific code can register specific drivers.
- *
- * Auxiliary drivers registered with a NULL cls are registered as drivers
- * for all system devices, and get notification calls for each device. 
- */
-
-
-#ifndef _SYSDEV_H_
-#define _SYSDEV_H_
-
-#include <linux/kobject.h>
-#include <linux/pm.h>
-
-
-struct sys_device;
-struct sysdev_class_attribute;
-
-struct sysdev_class {
-	const char *name;
-	struct list_head	drivers;
-	struct sysdev_class_attribute **attrs;
-	struct kset		kset;
-};
-
-struct sysdev_class_attribute {
-	struct attribute attr;
-	ssize_t (*show)(struct sysdev_class *, struct sysdev_class_attribute *,
-			char *);
-	ssize_t (*store)(struct sysdev_class *, struct sysdev_class_attribute *,
-			 const char *, size_t);
-};
-
-#define _SYSDEV_CLASS_ATTR(_name,_mode,_show,_store) 		\
-{					 			\
-	.attr = {.name = __stringify(_name), .mode = _mode },	\
-	.show	= _show,					\
-	.store	= _store,					\
-}
-
-#define SYSDEV_CLASS_ATTR(_name,_mode,_show,_store) 		\
-	struct sysdev_class_attribute attr_##_name = 		\
-		_SYSDEV_CLASS_ATTR(_name,_mode,_show,_store)
-
-
-extern int sysdev_class_register(struct sysdev_class *);
-extern void sysdev_class_unregister(struct sysdev_class *);
-
-extern int sysdev_class_create_file(struct sysdev_class *,
-	struct sysdev_class_attribute *);
-extern void sysdev_class_remove_file(struct sysdev_class *,
-	struct sysdev_class_attribute *);
-/**
- * Auxiliary system device drivers.
- */
-
-struct sysdev_driver {
-	struct list_head	entry;
-	int	(*add)(struct sys_device *);
-	int	(*remove)(struct sys_device *);
-};
-
-
-extern int sysdev_driver_register(struct sysdev_class *, struct sysdev_driver *);
-extern void sysdev_driver_unregister(struct sysdev_class *, struct sysdev_driver *);
-
-
-/**
- * sys_devices can be simplified a lot from regular devices, because they're
- * simply not as versatile. 
- */
-
-struct sys_device {
-	u32		id;
-	struct sysdev_class	* cls;
-	struct kobject		kobj;
-};
-
-extern int sysdev_register(struct sys_device *);
-extern void sysdev_unregister(struct sys_device *);
-
-
-struct sysdev_attribute { 
-	struct attribute	attr;
-	ssize_t (*show)(struct sys_device *, struct sysdev_attribute *, char *);
-	ssize_t (*store)(struct sys_device *, struct sysdev_attribute *,
-			 const char *, size_t);
-};
-
-
-#define _SYSDEV_ATTR(_name, _mode, _show, _store)		\
-{								\
-	.attr = { .name = __stringify(_name), .mode = _mode },	\
-	.show	= _show,					\
-	.store	= _store,					\
-}
-
-#define SYSDEV_ATTR(_name, _mode, _show, _store)		\
-	struct sysdev_attribute attr_##_name =			\
-		_SYSDEV_ATTR(_name, _mode, _show, _store);
-
-extern int sysdev_create_file(struct sys_device *, struct sysdev_attribute *);
-extern void sysdev_remove_file(struct sys_device *, struct sysdev_attribute *);
-
-/* Create/remove NULL terminated attribute list */
-static inline int
-sysdev_create_files(struct sys_device *d, struct sysdev_attribute **a)
-{
-	return sysfs_create_files(&d->kobj, (const struct attribute **)a);
-}
-
-static inline void
-sysdev_remove_files(struct sys_device *d, struct sysdev_attribute **a)
-{
-	return sysfs_remove_files(&d->kobj, (const struct attribute **)a);
-}
-
-struct sysdev_ext_attribute {
-	struct sysdev_attribute attr;
-	void *var;
-};
-
-/*
- * Support for simple variable sysdev attributes.
- * The pointer to the variable is stored in a sysdev_ext_attribute
- */
-
-/* Add more types as needed */
-
-extern ssize_t sysdev_show_ulong(struct sys_device *, struct sysdev_attribute *,
-				char *);
-extern ssize_t sysdev_store_ulong(struct sys_device *,
-			struct sysdev_attribute *, const char *, size_t);
-extern ssize_t sysdev_show_int(struct sys_device *, struct sysdev_attribute *,
-				char *);
-extern ssize_t sysdev_store_int(struct sys_device *,
-			struct sysdev_attribute *, const char *, size_t);
-
-#define _SYSDEV_ULONG_ATTR(_name, _mode, _var)				\
-	{ _SYSDEV_ATTR(_name, _mode, sysdev_show_ulong, sysdev_store_ulong), \
-	  &(_var) }
-#define SYSDEV_ULONG_ATTR(_name, _mode, _var)			\
-	struct sysdev_ext_attribute attr_##_name = 		\
-		_SYSDEV_ULONG_ATTR(_name, _mode, _var);
-#define _SYSDEV_INT_ATTR(_name, _mode, _var)				\
-	{ _SYSDEV_ATTR(_name, _mode, sysdev_show_int, sysdev_store_int), \
-	  &(_var) }
-#define SYSDEV_INT_ATTR(_name, _mode, _var)			\
-	struct sysdev_ext_attribute attr_##_name = 		\
-		_SYSDEV_INT_ATTR(_name, _mode, _var);
-
-#endif /* _SYSDEV_H_ */
diff --git a/include/xen/balloon.h b/include/xen/balloon.h
index d29c153..cc2e1a7 100644
--- a/include/xen/balloon.h
+++ b/include/xen/balloon.h
@@ -29,11 +29,11 @@ int alloc_xenballooned_pages(int nr_pages, struct page **pages,
 		bool highmem);
 void free_xenballooned_pages(int nr_pages, struct page **pages);
 
-struct sys_device;
+struct device;
 #ifdef CONFIG_XEN_SELFBALLOONING
-extern int register_xen_selfballooning(struct sys_device *sysdev);
+extern int register_xen_selfballooning(struct device *dev);
 #else
-static inline int register_xen_selfballooning(struct sys_device *sysdev)
+static inline int register_xen_selfballooning(struct device *dev)
 {
 	return -ENOSYS;
 }
diff --git a/kernel/rtmutex-tester.c b/kernel/rtmutex-tester.c
index 3d9f31c..98ec494 100644
--- a/kernel/rtmutex-tester.c
+++ b/kernel/rtmutex-tester.c
@@ -6,11 +6,11 @@
  *  Copyright (C) 2006, Timesys Corp., Thomas Gleixner <tglx@timesys.com>
  *
  */
+#include <linux/device.h>
 #include <linux/kthread.h>
 #include <linux/export.h>
 #include <linux/sched.h>
 #include <linux/spinlock.h>
-#include <linux/sysdev.h>
 #include <linux/timer.h>
 #include <linux/freezer.h>
 
@@ -27,7 +27,7 @@ struct test_thread_data {
 	int			opdata;
 	int			mutexes[MAX_RT_TEST_MUTEXES];
 	int			event;
-	struct sys_device	sysdev;
+	struct device		dev;
 };
 
 static struct test_thread_data thread_data[MAX_RT_TEST_THREADS];
@@ -271,7 +271,7 @@ static int test_func(void *data)
  *
  * opcode:data
  */
-static ssize_t sysfs_test_command(struct sys_device *dev, struct sysdev_attribute *attr,
+static ssize_t sysfs_test_command(struct device *dev, struct device_attribute *attr,
 				  const char *buf, size_t count)
 {
 	struct sched_param schedpar;
@@ -279,8 +279,8 @@ static ssize_t sysfs_test_command(struct sys_device *dev, struct sysdev_attribut
 	char cmdbuf[32];
 	int op, dat, tid, ret;
 
-	td = container_of(dev, struct test_thread_data, sysdev);
-	tid = td->sysdev.id;
+	td = container_of(dev, struct test_thread_data, dev);
+	tid = td->dev.id;
 
 	/* strings from sysfs write are not 0 terminated! */
 	if (count >= sizeof(cmdbuf))
@@ -334,7 +334,7 @@ static ssize_t sysfs_test_command(struct sys_device *dev, struct sysdev_attribut
  * @dev:	thread to query
  * @buf:	char buffer to be filled with thread status info
  */
-static ssize_t sysfs_test_status(struct sys_device *dev, struct sysdev_attribute *attr,
+static ssize_t sysfs_test_status(struct device *dev, struct device_attribute *attr,
 				 char *buf)
 {
 	struct test_thread_data *td;
@@ -342,8 +342,8 @@ static ssize_t sysfs_test_status(struct sys_device *dev, struct sysdev_attribute
 	char *curr = buf;
 	int i;
 
-	td = container_of(dev, struct test_thread_data, sysdev);
-	tsk = threads[td->sysdev.id];
+	td = container_of(dev, struct test_thread_data, dev);
+	tsk = threads[td->dev.id];
 
 	spin_lock(&rttest_lock);
 
@@ -360,28 +360,29 @@ static ssize_t sysfs_test_status(struct sys_device *dev, struct sysdev_attribute
 	spin_unlock(&rttest_lock);
 
 	curr += sprintf(curr, ", T: %p, R: %p\n", tsk,
-			mutexes[td->sysdev.id].owner);
+			mutexes[td->dev.id].owner);
 
 	return curr - buf;
 }
 
-static SYSDEV_ATTR(status, 0600, sysfs_test_status, NULL);
-static SYSDEV_ATTR(command, 0600, NULL, sysfs_test_command);
+static DEVICE_ATTR(status, 0600, sysfs_test_status, NULL);
+static DEVICE_ATTR(command, 0600, NULL, sysfs_test_command);
 
-static struct sysdev_class rttest_sysclass = {
+static struct bus_type rttest_subsys = {
 	.name = "rttest",
+	.dev_name = "rttest",
 };
 
 static int init_test_thread(int id)
 {
-	thread_data[id].sysdev.cls = &rttest_sysclass;
-	thread_data[id].sysdev.id = id;
+	thread_data[id].dev.bus = &rttest_subsys;
+	thread_data[id].dev.id = id;
 
 	threads[id] = kthread_run(test_func, &thread_data[id], "rt-test-%d", id);
 	if (IS_ERR(threads[id]))
 		return PTR_ERR(threads[id]);
 
-	return sysdev_register(&thread_data[id].sysdev);
+	return device_register(&thread_data[id].dev);
 }
 
 static int init_rttest(void)
@@ -393,7 +394,7 @@ static int init_rttest(void)
 	for (i = 0; i < MAX_RT_TEST_MUTEXES; i++)
 		rt_mutex_init(&mutexes[i]);
 
-	ret = sysdev_class_register(&rttest_sysclass);
+	ret = subsys_system_register(&rttest_subsys, NULL);
 	if (ret)
 		return ret;
 
@@ -401,10 +402,10 @@ static int init_rttest(void)
 		ret = init_test_thread(i);
 		if (ret)
 			break;
-		ret = sysdev_create_file(&thread_data[i].sysdev, &attr_status);
+		ret = device_create_file(&thread_data[i].dev, &dev_attr_status);
 		if (ret)
 			break;
-		ret = sysdev_create_file(&thread_data[i].sysdev, &attr_command);
+		ret = device_create_file(&thread_data[i].dev, &dev_attr_command);
 		if (ret)
 			break;
 	}
diff --git a/kernel/sched.c b/kernel/sched.c
index d6b149c..a7f381a 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -7940,54 +7940,52 @@ static ssize_t sched_power_savings_store(const char *buf, size_t count, int smt)
 }
 
 #ifdef CONFIG_SCHED_MC
-static ssize_t sched_mc_power_savings_show(struct sysdev_class *class,
-					   struct sysdev_class_attribute *attr,
-					   char *page)
+static ssize_t sched_mc_power_savings_show(struct device *dev,
+					   struct device_attribute *attr,
+					   char *buf)
 {
-	return sprintf(page, "%u\n", sched_mc_power_savings);
+	return sprintf(buf, "%u\n", sched_mc_power_savings);
 }
-static ssize_t sched_mc_power_savings_store(struct sysdev_class *class,
-					    struct sysdev_class_attribute *attr,
+static ssize_t sched_mc_power_savings_store(struct device *dev,
+					    struct device_attribute *attr,
 					    const char *buf, size_t count)
 {
 	return sched_power_savings_store(buf, count, 0);
 }
-static SYSDEV_CLASS_ATTR(sched_mc_power_savings, 0644,
-			 sched_mc_power_savings_show,
-			 sched_mc_power_savings_store);
+static DEVICE_ATTR(sched_mc_power_savings, 0644,
+		   sched_mc_power_savings_show,
+		   sched_mc_power_savings_store);
 #endif
 
 #ifdef CONFIG_SCHED_SMT
-static ssize_t sched_smt_power_savings_show(struct sysdev_class *dev,
-					    struct sysdev_class_attribute *attr,
-					    char *page)
+static ssize_t sched_smt_power_savings_show(struct device *dev,
+					    struct device_attribute *attr,
+					    char *buf)
 {
-	return sprintf(page, "%u\n", sched_smt_power_savings);
+	return sprintf(buf, "%u\n", sched_smt_power_savings);
 }
-static ssize_t sched_smt_power_savings_store(struct sysdev_class *dev,
-					     struct sysdev_class_attribute *attr,
+static ssize_t sched_smt_power_savings_store(struct device *dev,
+					    struct device_attribute *attr,
 					     const char *buf, size_t count)
 {
 	return sched_power_savings_store(buf, count, 1);
 }
-static SYSDEV_CLASS_ATTR(sched_smt_power_savings, 0644,
+static DEVICE_ATTR(sched_smt_power_savings, 0644,
 		   sched_smt_power_savings_show,
 		   sched_smt_power_savings_store);
 #endif
 
-int __init sched_create_sysfs_power_savings_entries(struct sysdev_class *cls)
+int __init sched_create_sysfs_power_savings_entries(struct device *dev)
 {
 	int err = 0;
 
 #ifdef CONFIG_SCHED_SMT
 	if (smt_capable())
-		err = sysfs_create_file(&cls->kset.kobj,
-					&attr_sched_smt_power_savings.attr);
+		err = device_create_file(dev, &dev_attr_sched_smt_power_savings);
 #endif
 #ifdef CONFIG_SCHED_MC
 	if (!err && mc_capable())
-		err = sysfs_create_file(&cls->kset.kobj,
-					&attr_sched_mc_power_savings.attr);
+		err = device_create_file(dev, &dev_attr_sched_mc_power_savings);
 #endif
 	return err;
 }
diff --git a/kernel/time/clockevents.c b/kernel/time/clockevents.c
index c4eb71c..cfe94a7 100644
--- a/kernel/time/clockevents.c
+++ b/kernel/time/clockevents.c
@@ -17,7 +17,6 @@
 #include <linux/module.h>
 #include <linux/notifier.h>
 #include <linux/smp.h>
-#include <linux/sysdev.h>
 
 #include "tick-internal.h"
 
diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index da2f760..23c47a3 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -23,8 +23,8 @@
  *   o Allow clocksource drivers to be unregistered
  */
 
+#include <linux/device.h>
 #include <linux/clocksource.h>
-#include <linux/sysdev.h>
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/sched.h> /* for spin_unlock_irq() using preempt_count() m68k */
@@ -792,8 +792,8 @@ EXPORT_SYMBOL(clocksource_unregister);
  * Provides sysfs interface for listing current clocksource.
  */
 static ssize_t
-sysfs_show_current_clocksources(struct sys_device *dev,
-				struct sysdev_attribute *attr, char *buf)
+sysfs_show_current_clocksources(struct device *dev,
+				struct device_attribute *attr, char *buf)
 {
 	ssize_t count = 0;
 
@@ -813,8 +813,8 @@ sysfs_show_current_clocksources(struct sys_device *dev,
  * Takes input from sysfs interface for manually overriding the default
  * clocksource selection.
  */
-static ssize_t sysfs_override_clocksource(struct sys_device *dev,
-					  struct sysdev_attribute *attr,
+static ssize_t sysfs_override_clocksource(struct device *dev,
+					  struct device_attribute *attr,
 					  const char *buf, size_t count)
 {
 	size_t ret = count;
@@ -847,8 +847,8 @@ static ssize_t sysfs_override_clocksource(struct sys_device *dev,
  * Provides sysfs interface for listing registered clocksources
  */
 static ssize_t
-sysfs_show_available_clocksources(struct sys_device *dev,
-				  struct sysdev_attribute *attr,
+sysfs_show_available_clocksources(struct device *dev,
+				  struct device_attribute *attr,
 				  char *buf)
 {
 	struct clocksource *src;
@@ -877,35 +877,36 @@ sysfs_show_available_clocksources(struct sys_device *dev,
 /*
  * Sysfs setup bits:
  */
-static SYSDEV_ATTR(current_clocksource, 0644, sysfs_show_current_clocksources,
+static DEVICE_ATTR(current_clocksource, 0644, sysfs_show_current_clocksources,
 		   sysfs_override_clocksource);
 
-static SYSDEV_ATTR(available_clocksource, 0444,
+static DEVICE_ATTR(available_clocksource, 0444,
 		   sysfs_show_available_clocksources, NULL);
 
-static struct sysdev_class clocksource_sysclass = {
+static struct bus_type clocksource_subsys = {
 	.name = "clocksource",
+	.dev_name = "clocksource",
 };
 
-static struct sys_device device_clocksource = {
+static struct device device_clocksource = {
 	.id	= 0,
-	.cls	= &clocksource_sysclass,
+	.bus	= &clocksource_subsys,
 };
 
 static int __init init_clocksource_sysfs(void)
 {
-	int error = sysdev_class_register(&clocksource_sysclass);
+	int error = subsys_system_register(&clocksource_subsys, NULL);
 
 	if (!error)
-		error = sysdev_register(&device_clocksource);
+		error = device_register(&device_clocksource);
 	if (!error)
-		error = sysdev_create_file(
+		error = device_create_file(
 				&device_clocksource,
-				&attr_current_clocksource);
+				&dev_attr_current_clocksource);
 	if (!error)
-		error = sysdev_create_file(
+		error = device_create_file(
 				&device_clocksource,
-				&attr_available_clocksource);
+				&dev_attr_available_clocksource);
 	return error;
 }
 
diff --git a/mm/compaction.c b/mm/compaction.c
index 899d956..1253d7a 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -721,23 +721,23 @@ int sysctl_extfrag_handler(struct ctl_table *table, int write,
 }
 
 #if defined(CONFIG_SYSFS) && defined(CONFIG_NUMA)
-ssize_t sysfs_compact_node(struct sys_device *dev,
-			struct sysdev_attribute *attr,
+ssize_t sysfs_compact_node(struct device *dev,
+			struct device_attribute *attr,
 			const char *buf, size_t count)
 {
 	compact_node(dev->id);
 
 	return count;
 }
-static SYSDEV_ATTR(compact, S_IWUSR, NULL, sysfs_compact_node);
+static DEVICE_ATTR(compact, S_IWUSR, NULL, sysfs_compact_node);
 
 int compaction_register_node(struct node *node)
 {
-	return sysdev_create_file(&node->sysdev, &attr_compact);
+	return device_create_file(&node->dev, &dev_attr_compact);
 }
 
 void compaction_unregister_node(struct node *node)
 {
-	return sysdev_remove_file(&node->sysdev, &attr_compact);
+	return device_remove_file(&node->dev, &dev_attr_compact);
 }
 #endif /* CONFIG_SYSFS && CONFIG_NUMA */
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index bb28a5f..60724a6 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1591,9 +1591,9 @@ static void __init hugetlb_sysfs_init(void)
 
 /*
  * node_hstate/s - associate per node hstate attributes, via their kobjects,
- * with node sysdevs in node_devices[] using a parallel array.  The array
- * index of a node sysdev or _hstate == node id.
- * This is here to avoid any static dependency of the node sysdev driver, in
+ * with node devices in node_devices[] using a parallel array.  The array
+ * index of a node device or _hstate == node id.
+ * This is here to avoid any static dependency of the node device driver, in
  * the base kernel, on the hugetlb module.
  */
 struct node_hstate {
@@ -1603,7 +1603,7 @@ struct node_hstate {
 struct node_hstate node_hstates[MAX_NUMNODES];
 
 /*
- * A subset of global hstate attributes for node sysdevs
+ * A subset of global hstate attributes for node devices
  */
 static struct attribute *per_node_hstate_attrs[] = {
 	&nr_hugepages_attr.attr,
@@ -1617,7 +1617,7 @@ static struct attribute_group per_node_hstate_attr_group = {
 };
 
 /*
- * kobj_to_node_hstate - lookup global hstate for node sysdev hstate attr kobj.
+ * kobj_to_node_hstate - lookup global hstate for node device hstate attr kobj.
  * Returns node id via non-NULL nidp.
  */
 static struct hstate *kobj_to_node_hstate(struct kobject *kobj, int *nidp)
@@ -1640,13 +1640,13 @@ static struct hstate *kobj_to_node_hstate(struct kobject *kobj, int *nidp)
 }
 
 /*
- * Unregister hstate attributes from a single node sysdev.
+ * Unregister hstate attributes from a single node device.
  * No-op if no hstate attributes attached.
  */
 void hugetlb_unregister_node(struct node *node)
 {
 	struct hstate *h;
-	struct node_hstate *nhs = &node_hstates[node->sysdev.id];
+	struct node_hstate *nhs = &node_hstates[node->dev.id];
 
 	if (!nhs->hugepages_kobj)
 		return;		/* no hstate attributes */
@@ -1662,7 +1662,7 @@ void hugetlb_unregister_node(struct node *node)
 }
 
 /*
- * hugetlb module exit:  unregister hstate attributes from node sysdevs
+ * hugetlb module exit:  unregister hstate attributes from node devices
  * that have them.
  */
 static void hugetlb_unregister_all_nodes(void)
@@ -1670,7 +1670,7 @@ static void hugetlb_unregister_all_nodes(void)
 	int nid;
 
 	/*
-	 * disable node sysdev registrations.
+	 * disable node device registrations.
 	 */
 	register_hugetlbfs_with_node(NULL, NULL);
 
@@ -1682,20 +1682,20 @@ static void hugetlb_unregister_all_nodes(void)
 }
 
 /*
- * Register hstate attributes for a single node sysdev.
+ * Register hstate attributes for a single node device.
  * No-op if attributes already registered.
  */
 void hugetlb_register_node(struct node *node)
 {
 	struct hstate *h;
-	struct node_hstate *nhs = &node_hstates[node->sysdev.id];
+	struct node_hstate *nhs = &node_hstates[node->dev.id];
 	int err;
 
 	if (nhs->hugepages_kobj)
 		return;		/* already allocated */
 
 	nhs->hugepages_kobj = kobject_create_and_add("hugepages",
-							&node->sysdev.kobj);
+							&node->dev.kobj);
 	if (!nhs->hugepages_kobj)
 		return;
 
@@ -1706,7 +1706,7 @@ void hugetlb_register_node(struct node *node)
 		if (err) {
 			printk(KERN_ERR "Hugetlb: Unable to add hstate %s"
 					" for node %d\n",
-						h->name, node->sysdev.id);
+						h->name, node->dev.id);
 			hugetlb_unregister_node(node);
 			break;
 		}
@@ -1715,8 +1715,8 @@ void hugetlb_register_node(struct node *node)
 
 /*
  * hugetlb init time:  register hstate attributes for all registered node
- * sysdevs of nodes that have memory.  All on-line nodes should have
- * registered their associated sysdev by this time.
+ * devices of nodes that have memory.  All on-line nodes should have
+ * registered their associated device by this time.
  */
 static void hugetlb_register_all_nodes(void)
 {
@@ -1724,12 +1724,12 @@ static void hugetlb_register_all_nodes(void)
 
 	for_each_node_state(nid, N_HIGH_MEMORY) {
 		struct node *node = &node_devices[nid];
-		if (node->sysdev.id == nid)
+		if (node->dev.id == nid)
 			hugetlb_register_node(node);
 	}
 
 	/*
-	 * Let the node sysdev driver know we're here so it can
+	 * Let the node device driver know we're here so it can
 	 * [un]register hstate attributes on node hotplug.
 	 */
 	register_hugetlbfs_with_node(hugetlb_register_node,
diff --git a/mm/vmscan.c b/mm/vmscan.c
index a1893c0..2b4189d 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3475,16 +3475,16 @@ int scan_unevictable_handler(struct ctl_table *table, int write,
  * a specified node's per zone unevictable lists for evictable pages.
  */
 
-static ssize_t read_scan_unevictable_node(struct sys_device *dev,
-					  struct sysdev_attribute *attr,
+static ssize_t read_scan_unevictable_node(struct device *dev,
+					  struct device_attribute *attr,
 					  char *buf)
 {
 	warn_scan_unevictable_pages();
 	return sprintf(buf, "0\n");	/* always zero; should fit... */
 }
 
-static ssize_t write_scan_unevictable_node(struct sys_device *dev,
-					   struct sysdev_attribute *attr,
+static ssize_t write_scan_unevictable_node(struct device *dev,
+					   struct device_attribute *attr,
 					const char *buf, size_t count)
 {
 	warn_scan_unevictable_pages();
@@ -3492,17 +3492,17 @@ static ssize_t write_scan_unevictable_node(struct sys_device *dev,
 }
 
 
-static SYSDEV_ATTR(scan_unevictable_pages, S_IRUGO | S_IWUSR,
+static DEVICE_ATTR(scan_unevictable_pages, S_IRUGO | S_IWUSR,
 			read_scan_unevictable_node,
 			write_scan_unevictable_node);
 
 int scan_unevictable_register_node(struct node *node)
 {
-	return sysdev_create_file(&node->sysdev, &attr_scan_unevictable_pages);
+	return device_create_file(&node->dev, &dev_attr_scan_unevictable_pages);
 }
 
 void scan_unevictable_unregister_node(struct node *node)
 {
-	sysdev_remove_file(&node->sysdev, &attr_scan_unevictable_pages);
+	device_remove_file(&node->dev, &dev_attr_scan_unevictable_pages);
 }
 #endif


