Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757566Ab2EUOHH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 10:07:07 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:45336 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757153Ab2EUOHC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 10:07:02 -0400
Message-ID: <1337609216.10262.11.camel@deadeye>
Subject: Re: Linux 3.2.18
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, torvalds@linux-foundation.org,
        stable@vger.kernel.org, lwn@lwn.net
Date: Mon, 21 May 2012 15:06:56 +0100
In-Reply-To: <1337608943.10262.10.camel@deadeye>
References: <1337608943.10262.10.camel@deadeye>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-NWOGwZ4pxhfxg73AllMQ"
X-Mailer: Evolution 3.2.2-1+b1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-NWOGwZ4pxhfxg73AllMQ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

diff --git a/Documentation/networking/ip-sysctl.txt b/Documentation/network=
ing/ip-sysctl.txt
index 589f2da..a4399f5 100644
--- a/Documentation/networking/ip-sysctl.txt
+++ b/Documentation/networking/ip-sysctl.txt
@@ -137,7 +137,7 @@ tcp_adv_win_scale - INTEGER
 	(if tcp_adv_win_scale > 0) or bytes-bytes/2^(-tcp_adv_win_scale),
 	if it is <=3D 0.
 	Possible values are [-31, 31], inclusive.
-	Default: 2
+	Default: 1
=20
 tcp_allowed_congestion_control - STRING
 	Show/set the congestion control choices available to non-privileged
@@ -397,7 +397,7 @@ tcp_rmem - vector of 3 INTEGERs: min, default, max
 	net.core.rmem_max.  Calling setsockopt() with SO_RCVBUF disables
 	automatic tuning of that socket's receive buffer size, in which
 	case this value is ignored.
-	Default: between 87380B and 4MB, depending on RAM size.
+	Default: between 87380B and 6MB, depending on RAM size.
=20
 tcp_sack - BOOLEAN
 	Enable select acknowledgments (SACKS).
diff --git a/Makefile b/Makefile
index 4c4efa3..add68f1 100644
--- a/Makefile
+++ b/Makefile
@@ -1,6 +1,6 @@
 VERSION =3D 3
 PATCHLEVEL =3D 2
-SUBLEVEL =3D 17
+SUBLEVEL =3D 18
 EXTRAVERSION =3D
 NAME =3D Saber-toothed Squirrel
=20
diff --git a/arch/arm/mach-omap2/include/mach/ctrl_module_pad_core_44xx.h b=
/arch/arm/mach-omap2/include/mach/ctrl_module_pad_core_44xx.h
index 1e2d332..c88420d 100644
--- a/arch/arm/mach-omap2/include/mach/ctrl_module_pad_core_44xx.h
+++ b/arch/arm/mach-omap2/include/mach/ctrl_module_pad_core_44xx.h
@@ -941,10 +941,10 @@
 #define OMAP4_DSI2_LANEENABLE_MASK				(0x7 << 29)
 #define OMAP4_DSI1_LANEENABLE_SHIFT				24
 #define OMAP4_DSI1_LANEENABLE_MASK				(0x1f << 24)
-#define OMAP4_DSI2_PIPD_SHIFT					19
-#define OMAP4_DSI2_PIPD_MASK					(0x1f << 19)
-#define OMAP4_DSI1_PIPD_SHIFT					14
-#define OMAP4_DSI1_PIPD_MASK					(0x1f << 14)
+#define OMAP4_DSI1_PIPD_SHIFT					19
+#define OMAP4_DSI1_PIPD_MASK					(0x1f << 19)
+#define OMAP4_DSI2_PIPD_SHIFT					14
+#define OMAP4_DSI2_PIPD_MASK					(0x1f << 14)
=20
 /* CONTROL_MCBSPLP */
 #define OMAP4_ALBCTRLRX_FSX_SHIFT				31
diff --git a/arch/arm/mach-orion5x/mpp.h b/arch/arm/mach-orion5x/mpp.h
index eac6897..db70e79 100644
--- a/arch/arm/mach-orion5x/mpp.h
+++ b/arch/arm/mach-orion5x/mpp.h
@@ -65,8 +65,8 @@
 #define MPP8_GIGE               MPP(8,  0x1, 0, 0, 1,   1,   1)
=20
 #define MPP9_UNUSED		MPP(9,  0x0, 0, 0, 1,   1,   1)
-#define MPP9_GPIO		MPP(9,  0x0, 0, 0, 1,   1,   1)
-#define MPP9_GIGE               MPP(9,  0x1, 1, 1, 1,   1,   1)
+#define MPP9_GPIO		MPP(9,  0x0, 1, 1, 1,   1,   1)
+#define MPP9_GIGE               MPP(9,  0x1, 0, 0, 1,   1,   1)
=20
 #define MPP10_UNUSED		MPP(10, 0x0, 0, 0, 1,   1,   1)
 #define MPP10_GPIO		MPP(10, 0x0, 1, 1, 1,   1,   1)
diff --git a/arch/arm/mm/fault.c b/arch/arm/mm/fault.c
index aa33949..4b0bc37 100644
--- a/arch/arm/mm/fault.c
+++ b/arch/arm/mm/fault.c
@@ -267,7 +267,9 @@ good_area:
 	return fault;
=20
 check_stack:
-	if (vma->vm_flags & VM_GROWSDOWN && !expand_stack(vma, addr))
+	/* Don't allow expansion below FIRST_USER_ADDRESS */
+	if (vma->vm_flags & VM_GROWSDOWN &&
+	    addr >=3D FIRST_USER_ADDRESS && !expand_stack(vma, addr))
 		goto good_area;
 out:
 	return fault;
diff --git a/arch/arm/vfp/vfpmodule.c b/arch/arm/vfp/vfpmodule.c
index 8f3ccdd..8ea07e4 100644
--- a/arch/arm/vfp/vfpmodule.c
+++ b/arch/arm/vfp/vfpmodule.c
@@ -11,6 +11,7 @@
 #include <linux/types.h>
 #include <linux/cpu.h>
 #include <linux/cpu_pm.h>
+#include <linux/hardirq.h>
 #include <linux/kernel.h>
 #include <linux/notifier.h>
 #include <linux/signal.h>
@@ -428,7 +429,10 @@ void VFP_bounce(u32 trigger, u32 fpexc, struct pt_regs=
 *regs)
=20
 static void vfp_enable(void *unused)
 {
-	u32 access =3D get_copro_access();
+	u32 access;
+
+	BUG_ON(preemptible());
+	access =3D get_copro_access();
=20
 	/*
 	 * Enable full access to VFP (cp10 and cp11)
@@ -556,7 +560,7 @@ static int __init vfp_init(void)
 	unsigned int cpu_arch =3D cpu_architecture();
=20
 	if (cpu_arch >=3D CPU_ARCH_ARMv6)
-		vfp_enable(NULL);
+		on_each_cpu(vfp_enable, NULL, 1);
=20
 	/*
 	 * First check that there is a VFP that we can use.
@@ -577,8 +581,6 @@ static int __init vfp_init(void)
 	} else {
 		hotcpu_notifier(vfp_hotplug, 0);
=20
-		smp_call_function(vfp_enable, NULL, 1);
-
 		VFP_arch =3D (vfpsid & FPSID_ARCH_MASK) >> FPSID_ARCH_BIT;  /* Extract t=
he architecture version */
 		printk("implementor %02x architecture %d part %02x variant %x rev %x\n",
 			(vfpsid & FPSID_IMPLEMENTER_MASK) >> FPSID_IMPLEMENTER_BIT,
diff --git a/arch/ia64/include/asm/unistd.h b/arch/ia64/include/asm/unistd.=
h
index 7617248..7a3bd25 100644
--- a/arch/ia64/include/asm/unistd.h
+++ b/arch/ia64/include/asm/unistd.h
@@ -323,11 +323,12 @@
 #define __NR_sendmmsg			1331
 #define __NR_process_vm_readv		1332
 #define __NR_process_vm_writev		1333
+#define __NR_accept4			1334
=20
 #ifdef __KERNEL__
=20
=20
-#define NR_syscalls			310 /* length of syscall table */
+#define NR_syscalls			311 /* length of syscall table */
=20
 /*
  * The following defines stop scripts/checksyscalls.sh from complaining ab=
out
diff --git a/arch/ia64/kernel/entry.S b/arch/ia64/kernel/entry.S
index 5b31d46..1ccbe12 100644
--- a/arch/ia64/kernel/entry.S
+++ b/arch/ia64/kernel/entry.S
@@ -1779,6 +1779,7 @@ sys_call_table:
 	data8 sys_sendmmsg
 	data8 sys_process_vm_readv
 	data8 sys_process_vm_writev
+	data8 sys_accept4
=20
 	.org sys_call_table + 8*NR_syscalls	// guard against failures to increase=
 NR_syscalls
 #endif /* __IA64_ASM_PARAVIRTUALIZED_NATIVE */
diff --git a/arch/sparc/kernel/central.c b/arch/sparc/kernel/central.c
index 38d48a5..9708851 100644
--- a/arch/sparc/kernel/central.c
+++ b/arch/sparc/kernel/central.c
@@ -269,4 +269,4 @@ static int __init sunfire_init(void)
 	return 0;
 }
=20
-subsys_initcall(sunfire_init);
+fs_initcall(sunfire_init);
diff --git a/arch/sparc/mm/ultra.S b/arch/sparc/mm/ultra.S
index b57a594..874162a 100644
--- a/arch/sparc/mm/ultra.S
+++ b/arch/sparc/mm/ultra.S
@@ -495,11 +495,11 @@ xcall_fetch_glob_regs:
 	stx		%o7, [%g1 + GR_SNAP_O7]
 	stx		%i7, [%g1 + GR_SNAP_I7]
 	/* Don't try this at home kids... */
-	rdpr		%cwp, %g2
-	sub		%g2, 1, %g7
+	rdpr		%cwp, %g3
+	sub		%g3, 1, %g7
 	wrpr		%g7, %cwp
 	mov		%i7, %g7
-	wrpr		%g2, %cwp
+	wrpr		%g3, %cwp
 	stx		%g7, [%g1 + GR_SNAP_RPC]
 	sethi		%hi(trap_block), %g7
 	or		%g7, %lo(trap_block), %g7
diff --git a/arch/tile/kernel/compat_signal.c b/arch/tile/kernel/compat_sig=
nal.c
index a7869ad..41459d8 100644
--- a/arch/tile/kernel/compat_signal.c
+++ b/arch/tile/kernel/compat_signal.c
@@ -406,19 +406,17 @@ int compat_setup_rt_frame(int sig, struct k_sigaction=
 *ka, siginfo_t *info,
 	 * Set up registers for signal handler.
 	 * Registers that we don't modify keep the value they had from
 	 * user-space at the time we took the signal.
+	 * We always pass siginfo and mcontext, regardless of SA_SIGINFO,
+	 * since some things rely on this (e.g. glibc's debug/segfault.c).
 	 */
 	regs->pc =3D ptr_to_compat_reg(ka->sa.sa_handler);
 	regs->ex1 =3D PL_ICS_EX1(USER_PL, 1); /* set crit sec in handler */
 	regs->sp =3D ptr_to_compat_reg(frame);
 	regs->lr =3D restorer;
 	regs->regs[0] =3D (unsigned long) usig;
-
-	if (ka->sa.sa_flags & SA_SIGINFO) {
-		/* Need extra arguments, so mark to restore caller-saves. */
-		regs->regs[1] =3D ptr_to_compat_reg(&frame->info);
-		regs->regs[2] =3D ptr_to_compat_reg(&frame->uc);
-		regs->flags |=3D PT_FLAGS_CALLER_SAVES;
-	}
+	regs->regs[1] =3D ptr_to_compat_reg(&frame->info);
+	regs->regs[2] =3D ptr_to_compat_reg(&frame->uc);
+	regs->flags |=3D PT_FLAGS_CALLER_SAVES;
=20
 	/*
 	 * Notify any tracer that was single-stepping it.
diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 6d16b4b..7e3002b 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -173,6 +173,7 @@ config CRYPTO_DEV_MV_CESA
 	select CRYPTO_ALGAPI
 	select CRYPTO_AES
 	select CRYPTO_BLKCIPHER2
+	select CRYPTO_HASH
 	help
 	  This driver allows you to utilize the Cryptographic Engines and
 	  Security Accelerator (CESA) which can be found on the Marvell Orion
diff --git a/drivers/gpio/gpio-ml-ioh.c b/drivers/gpio/gpio-ml-ioh.c
index 461958f..271fd49 100644
--- a/drivers/gpio/gpio-ml-ioh.c
+++ b/drivers/gpio/gpio-ml-ioh.c
@@ -448,6 +448,7 @@ static int __devinit ioh_gpio_probe(struct pci_dev *pde=
v,
 		chip->reg =3D chip->base;
 		chip->ch =3D i;
 		mutex_init(&chip->lock);
+		spin_lock_init(&chip->spinlock);
 		ioh_gpio_setup(chip, num_ports[i]);
 		ret =3D gpiochip_add(&chip->gpio);
 		if (ret) {
diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 801d92d..a417f94 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -698,8 +698,8 @@ static int parse_hw_handler(struct dm_arg_set *as, stru=
ct multipath *m)
 		return 0;
=20
 	m->hw_handler_name =3D kstrdup(dm_shift_arg(as), GFP_KERNEL);
-	request_module("scsi_dh_%s", m->hw_handler_name);
-	if (scsi_dh_handler_exist(m->hw_handler_name) =3D=3D 0) {
+	if (!try_then_request_module(scsi_dh_handler_exist(m->hw_handler_name),
+				     "scsi_dh_%s", m->hw_handler_name)) {
 		ti->error =3D "unknown hardware handler type";
 		ret =3D -EINVAL;
 		goto fail;
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 065ab4f..adcd850 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -392,6 +392,8 @@ void mddev_suspend(struct mddev *mddev)
 	synchronize_rcu();
 	wait_event(mddev->sb_wait, atomic_read(&mddev->active_io) =3D=3D 0);
 	mddev->pers->quiesce(mddev, 1);
+
+	del_timer_sync(&mddev->safemode_timer);
 }
 EXPORT_SYMBOL_GPL(mddev_suspend);
=20
diff --git a/drivers/media/rc/ene_ir.c b/drivers/media/rc/ene_ir.c
index cf10ecf..ed77c6d 100644
--- a/drivers/media/rc/ene_ir.c
+++ b/drivers/media/rc/ene_ir.c
@@ -1018,22 +1018,6 @@ static int ene_probe(struct pnp_dev *pnp_dev, const =
struct pnp_device_id *id)
=20
 	spin_lock_init(&dev->hw_lock);
=20
-	/* claim the resources */
-	error =3D -EBUSY;
-	dev->hw_io =3D pnp_port_start(pnp_dev, 0);
-	if (!request_region(dev->hw_io, ENE_IO_SIZE, ENE_DRIVER_NAME)) {
-		dev->hw_io =3D -1;
-		dev->irq =3D -1;
-		goto error;
-	}
-
-	dev->irq =3D pnp_irq(pnp_dev, 0);
-	if (request_irq(dev->irq, ene_isr,
-			IRQF_SHARED, ENE_DRIVER_NAME, (void *)dev)) {
-		dev->irq =3D -1;
-		goto error;
-	}
-
 	pnp_set_drvdata(pnp_dev, dev);
 	dev->pnp_dev =3D pnp_dev;
=20
@@ -1086,6 +1070,22 @@ static int ene_probe(struct pnp_dev *pnp_dev, const =
struct pnp_device_id *id)
 	device_set_wakeup_capable(&pnp_dev->dev, true);
 	device_set_wakeup_enable(&pnp_dev->dev, true);
=20
+	/* claim the resources */
+	error =3D -EBUSY;
+	dev->hw_io =3D pnp_port_start(pnp_dev, 0);
+	if (!request_region(dev->hw_io, ENE_IO_SIZE, ENE_DRIVER_NAME)) {
+		dev->hw_io =3D -1;
+		dev->irq =3D -1;
+		goto error;
+	}
+
+	dev->irq =3D pnp_irq(pnp_dev, 0);
+	if (request_irq(dev->irq, ene_isr,
+			IRQF_SHARED, ENE_DRIVER_NAME, (void *)dev)) {
+		dev->irq =3D -1;
+		goto error;
+	}
+
 	error =3D rc_register_device(rdev);
 	if (error < 0)
 		goto error;
diff --git a/drivers/media/rc/fintek-cir.c b/drivers/media/rc/fintek-cir.c
index 7f7079b..4218f73 100644
--- a/drivers/media/rc/fintek-cir.c
+++ b/drivers/media/rc/fintek-cir.c
@@ -504,16 +504,6 @@ static int fintek_probe(struct pnp_dev *pdev, const st=
ruct pnp_device_id *dev_id
=20
 	spin_lock_init(&fintek->fintek_lock);
=20
-	ret =3D -EBUSY;
-	/* now claim resources */
-	if (!request_region(fintek->cir_addr,
-			    fintek->cir_port_len, FINTEK_DRIVER_NAME))
-		goto failure;
-
-	if (request_irq(fintek->cir_irq, fintek_cir_isr, IRQF_SHARED,
-			FINTEK_DRIVER_NAME, (void *)fintek))
-		goto failure;
-
 	pnp_set_drvdata(pdev, fintek);
 	fintek->pdev =3D pdev;
=20
@@ -548,6 +538,16 @@ static int fintek_probe(struct pnp_dev *pdev, const st=
ruct pnp_device_id *dev_id
 	/* rx resolution is hardwired to 50us atm, 1, 25, 100 also possible */
 	rdev->rx_resolution =3D US_TO_NS(CIR_SAMPLE_PERIOD);
=20
+	ret =3D -EBUSY;
+	/* now claim resources */
+	if (!request_region(fintek->cir_addr,
+			    fintek->cir_port_len, FINTEK_DRIVER_NAME))
+		goto failure;
+
+	if (request_irq(fintek->cir_irq, fintek_cir_isr, IRQF_SHARED,
+			FINTEK_DRIVER_NAME, (void *)fintek))
+		goto failure;
+
 	ret =3D rc_register_device(rdev);
 	if (ret)
 		goto failure;
diff --git a/drivers/media/rc/ite-cir.c b/drivers/media/rc/ite-cir.c
index 682009d..0e49c99 100644
--- a/drivers/media/rc/ite-cir.c
+++ b/drivers/media/rc/ite-cir.c
@@ -1515,16 +1515,6 @@ static int ite_probe(struct pnp_dev *pdev, const str=
uct pnp_device_id
 	/* initialize raw event */
 	init_ir_raw_event(&itdev->rawir);
=20
-	ret =3D -EBUSY;
-	/* now claim resources */
-	if (!request_region(itdev->cir_addr,
-				dev_desc->io_region_size, ITE_DRIVER_NAME))
-		goto failure;
-
-	if (request_irq(itdev->cir_irq, ite_cir_isr, IRQF_SHARED,
-			ITE_DRIVER_NAME, (void *)itdev))
-		goto failure;
-
 	/* set driver data into the pnp device */
 	pnp_set_drvdata(pdev, itdev);
 	itdev->pdev =3D pdev;
@@ -1600,6 +1590,16 @@ static int ite_probe(struct pnp_dev *pdev, const str=
uct pnp_device_id
 	rdev->driver_name =3D ITE_DRIVER_NAME;
 	rdev->map_name =3D RC_MAP_RC6_MCE;
=20
+	ret =3D -EBUSY;
+	/* now claim resources */
+	if (!request_region(itdev->cir_addr,
+				dev_desc->io_region_size, ITE_DRIVER_NAME))
+		goto failure;
+
+	if (request_irq(itdev->cir_irq, ite_cir_isr, IRQF_SHARED,
+			ITE_DRIVER_NAME, (void *)itdev))
+		goto failure;
+
 	ret =3D rc_register_device(rdev);
 	if (ret)
 		goto failure;
diff --git a/drivers/media/rc/nuvoton-cir.c b/drivers/media/rc/nuvoton-cir.=
c
index 144f3f5..8b2c071 100644
--- a/drivers/media/rc/nuvoton-cir.c
+++ b/drivers/media/rc/nuvoton-cir.c
@@ -1021,24 +1021,6 @@ static int nvt_probe(struct pnp_dev *pdev, const str=
uct pnp_device_id *dev_id)
 	spin_lock_init(&nvt->nvt_lock);
 	spin_lock_init(&nvt->tx.lock);
=20
-	ret =3D -EBUSY;
-	/* now claim resources */
-	if (!request_region(nvt->cir_addr,
-			    CIR_IOREG_LENGTH, NVT_DRIVER_NAME))
-		goto failure;
-
-	if (request_irq(nvt->cir_irq, nvt_cir_isr, IRQF_SHARED,
-			NVT_DRIVER_NAME, (void *)nvt))
-		goto failure;
-
-	if (!request_region(nvt->cir_wake_addr,
-			    CIR_IOREG_LENGTH, NVT_DRIVER_NAME))
-		goto failure;
-
-	if (request_irq(nvt->cir_wake_irq, nvt_cir_wake_isr, IRQF_SHARED,
-			NVT_DRIVER_NAME, (void *)nvt))
-		goto failure;
-
 	pnp_set_drvdata(pdev, nvt);
 	nvt->pdev =3D pdev;
=20
@@ -1085,6 +1067,24 @@ static int nvt_probe(struct pnp_dev *pdev, const str=
uct pnp_device_id *dev_id)
 	rdev->tx_resolution =3D XYZ;
 #endif
=20
+	ret =3D -EBUSY;
+	/* now claim resources */
+	if (!request_region(nvt->cir_addr,
+			    CIR_IOREG_LENGTH, NVT_DRIVER_NAME))
+		goto failure;
+
+	if (request_irq(nvt->cir_irq, nvt_cir_isr, IRQF_SHARED,
+			NVT_DRIVER_NAME, (void *)nvt))
+		goto failure;
+
+	if (!request_region(nvt->cir_wake_addr,
+			    CIR_IOREG_LENGTH, NVT_DRIVER_NAME))
+		goto failure;
+
+	if (request_irq(nvt->cir_wake_irq, nvt_cir_wake_isr, IRQF_SHARED,
+			NVT_DRIVER_NAME, (void *)nvt))
+		goto failure;
+
 	ret =3D rc_register_device(rdev);
 	if (ret)
 		goto failure;
diff --git a/drivers/media/rc/winbond-cir.c b/drivers/media/rc/winbond-cir.=
c
index a7e7d6f..4591770 100644
--- a/drivers/media/rc/winbond-cir.c
+++ b/drivers/media/rc/winbond-cir.c
@@ -991,39 +991,10 @@ wbcir_probe(struct pnp_dev *device, const struct pnp_=
device_id *dev_id)
 		"(w: 0x%lX, e: 0x%lX, s: 0x%lX, i: %u)\n",
 		data->wbase, data->ebase, data->sbase, data->irq);
=20
-	if (!request_region(data->wbase, WAKEUP_IOMEM_LEN, DRVNAME)) {
-		dev_err(dev, "Region 0x%lx-0x%lx already in use!\n",
-			data->wbase, data->wbase + WAKEUP_IOMEM_LEN - 1);
-		err =3D -EBUSY;
-		goto exit_free_data;
-	}
-
-	if (!request_region(data->ebase, EHFUNC_IOMEM_LEN, DRVNAME)) {
-		dev_err(dev, "Region 0x%lx-0x%lx already in use!\n",
-			data->ebase, data->ebase + EHFUNC_IOMEM_LEN - 1);
-		err =3D -EBUSY;
-		goto exit_release_wbase;
-	}
-
-	if (!request_region(data->sbase, SP_IOMEM_LEN, DRVNAME)) {
-		dev_err(dev, "Region 0x%lx-0x%lx already in use!\n",
-			data->sbase, data->sbase + SP_IOMEM_LEN - 1);
-		err =3D -EBUSY;
-		goto exit_release_ebase;
-	}
-
-	err =3D request_irq(data->irq, wbcir_irq_handler,
-			  IRQF_DISABLED, DRVNAME, device);
-	if (err) {
-		dev_err(dev, "Failed to claim IRQ %u\n", data->irq);
-		err =3D -EBUSY;
-		goto exit_release_sbase;
-	}
-
 	led_trigger_register_simple("cir-tx", &data->txtrigger);
 	if (!data->txtrigger) {
 		err =3D -ENOMEM;
-		goto exit_free_irq;
+		goto exit_free_data;
 	}
=20
 	led_trigger_register_simple("cir-rx", &data->rxtrigger);
@@ -1062,9 +1033,38 @@ wbcir_probe(struct pnp_dev *device, const struct pnp=
_device_id *dev_id)
 	data->dev->priv =3D data;
 	data->dev->dev.parent =3D &device->dev;
=20
+	if (!request_region(data->wbase, WAKEUP_IOMEM_LEN, DRVNAME)) {
+		dev_err(dev, "Region 0x%lx-0x%lx already in use!\n",
+			data->wbase, data->wbase + WAKEUP_IOMEM_LEN - 1);
+		err =3D -EBUSY;
+		goto exit_free_rc;
+	}
+
+	if (!request_region(data->ebase, EHFUNC_IOMEM_LEN, DRVNAME)) {
+		dev_err(dev, "Region 0x%lx-0x%lx already in use!\n",
+			data->ebase, data->ebase + EHFUNC_IOMEM_LEN - 1);
+		err =3D -EBUSY;
+		goto exit_release_wbase;
+	}
+
+	if (!request_region(data->sbase, SP_IOMEM_LEN, DRVNAME)) {
+		dev_err(dev, "Region 0x%lx-0x%lx already in use!\n",
+			data->sbase, data->sbase + SP_IOMEM_LEN - 1);
+		err =3D -EBUSY;
+		goto exit_release_ebase;
+	}
+
+	err =3D request_irq(data->irq, wbcir_irq_handler,
+			  IRQF_DISABLED, DRVNAME, device);
+	if (err) {
+		dev_err(dev, "Failed to claim IRQ %u\n", data->irq);
+		err =3D -EBUSY;
+		goto exit_release_sbase;
+	}
+
 	err =3D rc_register_device(data->dev);
 	if (err)
-		goto exit_free_rc;
+		goto exit_free_irq;
=20
 	device_init_wakeup(&device->dev, 1);
=20
@@ -1072,14 +1072,6 @@ wbcir_probe(struct pnp_dev *device, const struct pnp=
_device_id *dev_id)
=20
 	return 0;
=20
-exit_free_rc:
-	rc_free_device(data->dev);
-exit_unregister_led:
-	led_classdev_unregister(&data->led);
-exit_unregister_rxtrigger:
-	led_trigger_unregister_simple(data->rxtrigger);
-exit_unregister_txtrigger:
-	led_trigger_unregister_simple(data->txtrigger);
 exit_free_irq:
 	free_irq(data->irq, device);
 exit_release_sbase:
@@ -1088,6 +1080,14 @@ exit_release_ebase:
 	release_region(data->ebase, EHFUNC_IOMEM_LEN);
 exit_release_wbase:
 	release_region(data->wbase, WAKEUP_IOMEM_LEN);
+exit_free_rc:
+	rc_free_device(data->dev);
+exit_unregister_led:
+	led_classdev_unregister(&data->led);
+exit_unregister_rxtrigger:
+	led_trigger_unregister_simple(data->rxtrigger);
+exit_unregister_txtrigger:
+	led_trigger_unregister_simple(data->txtrigger);
 exit_free_data:
 	kfree(data);
 	pnp_set_drvdata(device, NULL);
diff --git a/drivers/media/video/marvell-ccic/mmp-driver.c b/drivers/media/=
video/marvell-ccic/mmp-driver.c
index fb0b124..a6b7657 100644
--- a/drivers/media/video/marvell-ccic/mmp-driver.c
+++ b/drivers/media/video/marvell-ccic/mmp-driver.c
@@ -175,7 +175,6 @@ static int mmpcam_probe(struct platform_device *pdev)
 	INIT_LIST_HEAD(&cam->devlist);
=20
 	mcam =3D &cam->mcam;
-	mcam->platform =3D MHP_Armada610;
 	mcam->plat_power_up =3D mmpcam_power_up;
 	mcam->plat_power_down =3D mmpcam_power_down;
 	mcam->dev =3D &pdev->dev;
diff --git a/drivers/media/video/s5p-fimc/fimc-capture.c b/drivers/media/vi=
deo/s5p-fimc/fimc-capture.c
index 2cc3b91..327a81f 100644
--- a/drivers/media/video/s5p-fimc/fimc-capture.c
+++ b/drivers/media/video/s5p-fimc/fimc-capture.c
@@ -1304,7 +1304,7 @@ static int fimc_subdev_set_crop(struct v4l2_subdev *s=
d,
 	fimc_capture_try_crop(ctx, r, crop->pad);
=20
 	if (crop->which =3D=3D V4L2_SUBDEV_FORMAT_TRY) {
-		mutex_lock(&fimc->lock);
+		mutex_unlock(&fimc->lock);
 		*v4l2_subdev_get_try_crop(fh, crop->pad) =3D *r;
 		return 0;
 	}
diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/bro=
adcom/tg3.c
index 3d55883..2dcac28 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -879,8 +879,13 @@ static inline unsigned int tg3_has_work(struct tg3_nap=
i *tnapi)
 		if (sblk->status & SD_STATUS_LINK_CHG)
 			work_exists =3D 1;
 	}
-	/* check for RX/TX work to do */
-	if (sblk->idx[0].tx_consumer !=3D tnapi->tx_cons ||
+
+	/* check for TX work to do */
+	if (sblk->idx[0].tx_consumer !=3D tnapi->tx_cons)
+		work_exists =3D 1;
+
+	/* check for RX work to do */
+	if (tnapi->rx_rcb_prod_idx &&
 	    *(tnapi->rx_rcb_prod_idx) !=3D tnapi->rx_rcb_ptr)
 		work_exists =3D 1;
=20
@@ -5895,6 +5900,9 @@ static int tg3_poll_work(struct tg3_napi *tnapi, int =
work_done, int budget)
 			return work_done;
 	}
=20
+	if (!tnapi->rx_rcb_prod_idx)
+		return work_done;
+
 	/* run RX thread, within the bounds set by NAPI.
 	 * All RX "locking" is done by ensuring outside
 	 * code synchronizes with tg3->napi.poll()
@@ -7448,6 +7456,12 @@ static int tg3_alloc_consistent(struct tg3 *tp)
 		 */
 		switch (i) {
 		default:
+			if (tg3_flag(tp, ENABLE_RSS)) {
+				tnapi->rx_rcb_prod_idx =3D NULL;
+				break;
+			}
+			/* Fall through */
+		case 1:
 			tnapi->rx_rcb_prod_idx =3D &sblk->idx[0].rx_producer;
 			break;
 		case 2:
diff --git a/drivers/net/ethernet/intel/e1000/e1000_main.c b/drivers/net/et=
hernet/intel/e1000/e1000_main.c
index cf480b5..de00805 100644
--- a/drivers/net/ethernet/intel/e1000/e1000_main.c
+++ b/drivers/net/ethernet/intel/e1000/e1000_main.c
@@ -494,7 +494,11 @@ out:
 static void e1000_down_and_stop(struct e1000_adapter *adapter)
 {
 	set_bit(__E1000_DOWN, &adapter->flags);
-	cancel_work_sync(&adapter->reset_task);
+
+	/* Only kill reset task if adapter is not resetting */
+	if (!test_bit(__E1000_RESETTING, &adapter->flags))
+		cancel_work_sync(&adapter->reset_task);
+
 	cancel_delayed_work_sync(&adapter->watchdog_task);
 	cancel_delayed_work_sync(&adapter->phy_info_task);
 	cancel_delayed_work_sync(&adapter->fifo_stall_task);
diff --git a/drivers/net/ethernet/marvell/sky2.c b/drivers/net/ethernet/mar=
vell/sky2.c
index 7eb8a00..65c51ff 100644
--- a/drivers/net/ethernet/marvell/sky2.c
+++ b/drivers/net/ethernet/marvell/sky2.c
@@ -2475,8 +2475,13 @@ static struct sk_buff *receive_copy(struct sky2_port=
 *sky2,
 		skb_copy_from_linear_data(re->skb, skb->data, length);
 		skb->ip_summed =3D re->skb->ip_summed;
 		skb->csum =3D re->skb->csum;
+		skb->rxhash =3D re->skb->rxhash;
+		skb->vlan_tci =3D re->skb->vlan_tci;
+
 		pci_dma_sync_single_for_device(sky2->hw->pdev, re->data_addr,
 					       length, PCI_DMA_FROMDEVICE);
+		re->skb->vlan_tci =3D 0;
+		re->skb->rxhash =3D 0;
 		re->skb->ip_summed =3D CHECKSUM_NONE;
 		skb_put(skb, length);
 	}
@@ -2561,9 +2566,6 @@ static struct sk_buff *sky2_receive(struct net_device=
 *dev,
 	struct sk_buff *skb =3D NULL;
 	u16 count =3D (status & GMR_FS_LEN) >> 16;
=20
-	if (status & GMR_FS_VLAN)
-		count -=3D VLAN_HLEN;	/* Account for vlan tag */
-
 	netif_printk(sky2, rx_status, KERN_DEBUG, dev,
 		     "rx slot %u status 0x%x len %d\n",
 		     sky2->rx_next, status, length);
@@ -2571,6 +2573,9 @@ static struct sk_buff *sky2_receive(struct net_device=
 *dev,
 	sky2->rx_next =3D (sky2->rx_next + 1) % sky2->rx_pending;
 	prefetch(sky2->rx_ring + sky2->rx_next);
=20
+	if (vlan_tx_tag_present(re->skb))
+		count -=3D VLAN_HLEN;	/* Account for vlan tag */
+
 	/* This chip has hardware problems that generates bogus status.
 	 * So do only marginal checking and expect higher level protocols
 	 * to handle crap frames.
@@ -2628,11 +2633,8 @@ static inline void sky2_tx_done(struct net_device *d=
ev, u16 last)
 }
=20
 static inline void sky2_skb_rx(const struct sky2_port *sky2,
-			       u32 status, struct sk_buff *skb)
+			       struct sk_buff *skb)
 {
-	if (status & GMR_FS_VLAN)
-		__vlan_hwaccel_put_tag(skb, be16_to_cpu(sky2->rx_tag));
-
 	if (skb->ip_summed =3D=3D CHECKSUM_NONE)
 		netif_receive_skb(skb);
 	else
@@ -2686,6 +2688,14 @@ static void sky2_rx_checksum(struct sky2_port *sky2,=
 u32 status)
 	}
 }
=20
+static void sky2_rx_tag(struct sky2_port *sky2, u16 length)
+{
+	struct sk_buff *skb;
+
+	skb =3D sky2->rx_ring[sky2->rx_next].skb;
+	__vlan_hwaccel_put_tag(skb, be16_to_cpu(length));
+}
+
 static void sky2_rx_hash(struct sky2_port *sky2, u32 status)
 {
 	struct sk_buff *skb;
@@ -2744,8 +2754,7 @@ static int sky2_status_intr(struct sky2_hw *hw, int t=
o_do, u16 idx)
 			}
=20
 			skb->protocol =3D eth_type_trans(skb, dev);
-
-			sky2_skb_rx(sky2, status, skb);
+			sky2_skb_rx(sky2, skb);
=20
 			/* Stop after net poll weight */
 			if (++work_done >=3D to_do)
@@ -2753,11 +2762,11 @@ static int sky2_status_intr(struct sky2_hw *hw, int=
 to_do, u16 idx)
 			break;
=20
 		case OP_RXVLAN:
-			sky2->rx_tag =3D length;
+			sky2_rx_tag(sky2, length);
 			break;
=20
 		case OP_RXCHKSVLAN:
-			sky2->rx_tag =3D length;
+			sky2_rx_tag(sky2, length);
 			/* fall through */
 		case OP_RXCHKS:
 			if (likely(dev->features & NETIF_F_RXCSUM))
diff --git a/drivers/net/ethernet/marvell/sky2.h b/drivers/net/ethernet/mar=
vell/sky2.h
index ff6f58b..3c896ce 100644
--- a/drivers/net/ethernet/marvell/sky2.h
+++ b/drivers/net/ethernet/marvell/sky2.h
@@ -2241,7 +2241,6 @@ struct sky2_port {
 	u16		     rx_pending;
 	u16		     rx_data_size;
 	u16		     rx_nfrags;
-	u16		     rx_tag;
=20
 	struct {
 		unsigned long last;
diff --git a/drivers/net/ethernet/stmicro/stmmac/mmc_core.c b/drivers/net/e=
thernet/stmicro/stmmac/mmc_core.c
index 41e6b33..c07cfe9 100644
--- a/drivers/net/ethernet/stmicro/stmmac/mmc_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/mmc_core.c
@@ -22,6 +22,7 @@
   Author: Giuseppe Cavallaro <peppe.cavallaro@st.com>
 **************************************************************************=
*****/
=20
+#include <linux/kernel.h>
 #include <linux/io.h>
 #include "mmc.h"
=20
diff --git a/drivers/net/ethernet/sun/sungem.c b/drivers/net/ethernet/sun/s=
ungem.c
index ceab215..c508d6a 100644
--- a/drivers/net/ethernet/sun/sungem.c
+++ b/drivers/net/ethernet/sun/sungem.c
@@ -2340,7 +2340,7 @@ static int gem_suspend(struct pci_dev *pdev, pm_messa=
ge_t state)
 	netif_device_detach(dev);
=20
 	/* Switch off chip, remember WOL setting */
-	gp->asleep_wol =3D gp->wake_on_lan;
+	gp->asleep_wol =3D !!gp->wake_on_lan;
 	gem_do_stop(dev, gp->asleep_wol);
=20
 	/* Unlock the network stack */
diff --git a/drivers/net/phy/icplus.c b/drivers/net/phy/icplus.c
index c81f136..b142300 100644
--- a/drivers/net/phy/icplus.c
+++ b/drivers/net/phy/icplus.c
@@ -150,7 +150,8 @@ static int ip101a_config_init(struct phy_device *phydev=
)
 	/* Enable Auto Power Saving mode */
 	c =3D phy_read(phydev, IP10XX_SPEC_CTRL_STATUS);
 	c |=3D IP101A_APS_ON;
-	return c;
+
+	return phy_write(phydev, IP10XX_SPEC_CTRL_STATUS, c);
 }
=20
 static int ip175c_read_status(struct phy_device *phydev)
diff --git a/drivers/net/usb/asix.c b/drivers/net/usb/asix.c
index fda4be2..a9abee8 100644
--- a/drivers/net/usb/asix.c
+++ b/drivers/net/usb/asix.c
@@ -403,7 +403,7 @@ static struct sk_buff *asix_tx_fixup(struct usbnet *dev=
, struct sk_buff *skb,
 	u32 packet_len;
 	u32 padbytes =3D 0xffff0000;
=20
-	padlen =3D ((skb->len + 4) % 512) ? 0 : 4;
+	padlen =3D ((skb->len + 4) & (dev->maxpacket - 1)) ? 0 : 4;
=20
 	if ((!skb_cloned(skb)) &&
 	    ((headroom + tailroom) >=3D (4 + padlen))) {
@@ -425,7 +425,7 @@ static struct sk_buff *asix_tx_fixup(struct usbnet *dev=
, struct sk_buff *skb,
 	cpu_to_le32s(&packet_len);
 	skb_copy_to_linear_data(skb, &packet_len, sizeof(packet_len));
=20
-	if ((skb->len % 512) =3D=3D 0) {
+	if (padlen) {
 		cpu_to_le32s(&padbytes);
 		memcpy(skb_tail_pointer(skb), &padbytes, sizeof(padbytes));
 		skb_put(skb, sizeof(padbytes));
diff --git a/drivers/net/usb/cdc_ether.c b/drivers/net/usb/cdc_ether.c
index 4fd4144..2ba40cf 100644
--- a/drivers/net/usb/cdc_ether.c
+++ b/drivers/net/usb/cdc_ether.c
@@ -83,6 +83,7 @@ int usbnet_generic_cdc_bind(struct usbnet *dev, struct us=
b_interface *intf)
 	struct cdc_state		*info =3D (void *) &dev->data;
 	int				status;
 	int				rndis;
+	bool				android_rndis_quirk =3D false;
 	struct usb_driver		*driver =3D driver_of(intf);
 	struct usb_cdc_mdlm_desc	*desc =3D NULL;
 	struct usb_cdc_mdlm_detail_desc *detail =3D NULL;
@@ -195,6 +196,11 @@ int usbnet_generic_cdc_bind(struct usbnet *dev, struct=
 usb_interface *intf)
 					info->control,
 					info->u->bSlaveInterface0,
 					info->data);
+				/* fall back to hard-wiring for RNDIS */
+				if (rndis) {
+					android_rndis_quirk =3D true;
+					goto next_desc;
+				}
 				goto bad_desc;
 			}
 			if (info->control !=3D intf) {
@@ -271,11 +277,15 @@ next_desc:
 	/* Microsoft ActiveSync based and some regular RNDIS devices lack the
 	 * CDC descriptors, so we'll hard-wire the interfaces and not check
 	 * for descriptors.
+	 *
+	 * Some Android RNDIS devices have a CDC Union descriptor pointing
+	 * to non-existing interfaces.  Ignore that and attempt the same
+	 * hard-wired 0 and 1 interfaces.
 	 */
-	if (rndis && !info->u) {
+	if (rndis && (!info->u || android_rndis_quirk)) {
 		info->control =3D usb_ifnum_to_if(dev->udev, 0);
 		info->data =3D usb_ifnum_to_if(dev->udev, 1);
-		if (!info->control || !info->data) {
+		if (!info->control || !info->data || info->control !=3D intf) {
 			dev_dbg(&intf->dev,
 				"rndis: master #0/%p slave #1/%p\n",
 				info->control,
@@ -472,6 +482,7 @@ static const struct driver_info wwan_info =3D {
 /*------------------------------------------------------------------------=
-*/
=20
 #define HUAWEI_VENDOR_ID	0x12D1
+#define NOVATEL_VENDOR_ID	0x1410
=20
 static const struct usb_device_id	products [] =3D {
 /*
@@ -589,6 +600,21 @@ static const struct usb_device_id	products [] =3D {
  * because of bugs/quirks in a given product (like Zaurus, above).
  */
 {
+	/* Novatel USB551L */
+	/* This match must come *before* the generic CDC-ETHER match so that
+	 * we get FLAG_WWAN set on the device, since it's descriptors are
+	 * generic CDC-ETHER.
+	 */
+	.match_flags    =3D   USB_DEVICE_ID_MATCH_VENDOR
+		 | USB_DEVICE_ID_MATCH_PRODUCT
+		 | USB_DEVICE_ID_MATCH_INT_INFO,
+	.idVendor               =3D NOVATEL_VENDOR_ID,
+	.idProduct		=3D 0xB001,
+	.bInterfaceClass	=3D USB_CLASS_COMM,
+	.bInterfaceSubClass	=3D USB_CDC_SUBCLASS_ETHERNET,
+	.bInterfaceProtocol	=3D USB_CDC_PROTO_NONE,
+	.driver_info =3D (unsigned long)&wwan_info,
+}, {
 	USB_INTERFACE_INFO(USB_CLASS_COMM, USB_CDC_SUBCLASS_ETHERNET,
 			USB_CDC_PROTO_NONE),
 	.driver_info =3D (unsigned long) &cdc_info,
diff --git a/drivers/net/usb/usbnet.c b/drivers/net/usb/usbnet.c
index 750e330..b873b5d 100644
--- a/drivers/net/usb/usbnet.c
+++ b/drivers/net/usb/usbnet.c
@@ -281,17 +281,32 @@ int usbnet_change_mtu (struct net_device *net, int ne=
w_mtu)
 }
 EXPORT_SYMBOL_GPL(usbnet_change_mtu);
=20
+/* The caller must hold list->lock */
+static void __usbnet_queue_skb(struct sk_buff_head *list,
+			struct sk_buff *newsk, enum skb_state state)
+{
+	struct skb_data *entry =3D (struct skb_data *) newsk->cb;
+
+	__skb_queue_tail(list, newsk);
+	entry->state =3D state;
+}
+
 /*------------------------------------------------------------------------=
-*/
=20
 /* some LK 2.4 HCDs oopsed if we freed or resubmitted urbs from
  * completion callbacks.  2.5 should have fixed those bugs...
  */
=20
-static void defer_bh(struct usbnet *dev, struct sk_buff *skb, struct sk_bu=
ff_head *list)
+static enum skb_state defer_bh(struct usbnet *dev, struct sk_buff *skb,
+		struct sk_buff_head *list, enum skb_state state)
 {
 	unsigned long		flags;
+	enum skb_state 		old_state;
+	struct skb_data *entry =3D (struct skb_data *) skb->cb;
=20
 	spin_lock_irqsave(&list->lock, flags);
+	old_state =3D entry->state;
+	entry->state =3D state;
 	__skb_unlink(skb, list);
 	spin_unlock(&list->lock);
 	spin_lock(&dev->done.lock);
@@ -299,6 +314,7 @@ static void defer_bh(struct usbnet *dev, struct sk_buff=
 *skb, struct sk_buff_hea
 	if (dev->done.qlen =3D=3D 1)
 		tasklet_schedule(&dev->bh);
 	spin_unlock_irqrestore(&dev->done.lock, flags);
+	return old_state;
 }
=20
 /* some work can't be done in tasklets, so we use keventd
@@ -339,7 +355,6 @@ static int rx_submit (struct usbnet *dev, struct urb *u=
rb, gfp_t flags)
 	entry =3D (struct skb_data *) skb->cb;
 	entry->urb =3D urb;
 	entry->dev =3D dev;
-	entry->state =3D rx_start;
 	entry->length =3D 0;
=20
 	usb_fill_bulk_urb (urb, dev->udev, dev->in,
@@ -371,7 +386,7 @@ static int rx_submit (struct usbnet *dev, struct urb *u=
rb, gfp_t flags)
 			tasklet_schedule (&dev->bh);
 			break;
 		case 0:
-			__skb_queue_tail (&dev->rxq, skb);
+			__usbnet_queue_skb(&dev->rxq, skb, rx_start);
 		}
 	} else {
 		netif_dbg(dev, ifdown, dev->net, "rx: stopped\n");
@@ -422,16 +437,17 @@ static void rx_complete (struct urb *urb)
 	struct skb_data		*entry =3D (struct skb_data *) skb->cb;
 	struct usbnet		*dev =3D entry->dev;
 	int			urb_status =3D urb->status;
+	enum skb_state		state;
=20
 	skb_put (skb, urb->actual_length);
-	entry->state =3D rx_done;
+	state =3D rx_done;
 	entry->urb =3D NULL;
=20
 	switch (urb_status) {
 	/* success */
 	case 0:
 		if (skb->len < dev->net->hard_header_len) {
-			entry->state =3D rx_cleanup;
+			state =3D rx_cleanup;
 			dev->net->stats.rx_errors++;
 			dev->net->stats.rx_length_errors++;
 			netif_dbg(dev, rx_err, dev->net,
@@ -470,7 +486,7 @@ static void rx_complete (struct urb *urb)
 				  "rx throttle %d\n", urb_status);
 		}
 block:
-		entry->state =3D rx_cleanup;
+		state =3D rx_cleanup;
 		entry->urb =3D urb;
 		urb =3D NULL;
 		break;
@@ -481,17 +497,18 @@ block:
 		// FALLTHROUGH
=20
 	default:
-		entry->state =3D rx_cleanup;
+		state =3D rx_cleanup;
 		dev->net->stats.rx_errors++;
 		netif_dbg(dev, rx_err, dev->net, "rx status %d\n", urb_status);
 		break;
 	}
=20
-	defer_bh(dev, skb, &dev->rxq);
+	state =3D defer_bh(dev, skb, &dev->rxq, state);
=20
 	if (urb) {
 		if (netif_running (dev->net) &&
-		    !test_bit (EVENT_RX_HALT, &dev->flags)) {
+		    !test_bit (EVENT_RX_HALT, &dev->flags) &&
+		    state !=3D unlink_start) {
 			rx_submit (dev, urb, GFP_ATOMIC);
 			return;
 		}
@@ -577,16 +594,23 @@ EXPORT_SYMBOL_GPL(usbnet_purge_paused_rxq);
 static int unlink_urbs (struct usbnet *dev, struct sk_buff_head *q)
 {
 	unsigned long		flags;
-	struct sk_buff		*skb, *skbnext;
+	struct sk_buff		*skb;
 	int			count =3D 0;
=20
 	spin_lock_irqsave (&q->lock, flags);
-	skb_queue_walk_safe(q, skb, skbnext) {
+	while (!skb_queue_empty(q)) {
 		struct skb_data		*entry;
 		struct urb		*urb;
 		int			retval;
=20
-		entry =3D (struct skb_data *) skb->cb;
+		skb_queue_walk(q, skb) {
+			entry =3D (struct skb_data *) skb->cb;
+			if (entry->state !=3D unlink_start)
+				goto found;
+		}
+		break;
+found:
+		entry->state =3D unlink_start;
 		urb =3D entry->urb;
=20
 		/*
@@ -1037,8 +1061,7 @@ static void tx_complete (struct urb *urb)
 	}
=20
 	usb_autopm_put_interface_async(dev->intf);
-	entry->state =3D tx_done;
-	defer_bh(dev, skb, &dev->txq);
+	(void) defer_bh(dev, skb, &dev->txq, tx_done);
 }
=20
 /*------------------------------------------------------------------------=
-*/
@@ -1094,7 +1117,6 @@ netdev_tx_t usbnet_start_xmit (struct sk_buff *skb,
 	entry =3D (struct skb_data *) skb->cb;
 	entry->urb =3D urb;
 	entry->dev =3D dev;
-	entry->state =3D tx_start;
 	entry->length =3D length;
=20
 	usb_fill_bulk_urb (urb, dev->udev, dev->out,
@@ -1153,7 +1175,7 @@ netdev_tx_t usbnet_start_xmit (struct sk_buff *skb,
 		break;
 	case 0:
 		net->trans_start =3D jiffies;
-		__skb_queue_tail (&dev->txq, skb);
+		__usbnet_queue_skb(&dev->txq, skb, tx_start);
 		if (dev->txq.qlen >=3D TX_QLEN (dev))
 			netif_stop_queue (net);
 	}
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/ampdu.c b/drivers/net/=
wireless/brcm80211/brcmsmac/ampdu.c
index 7f27dbd..0515862 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/ampdu.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/ampdu.c
@@ -1053,17 +1053,13 @@ brcms_c_ampdu_dotxstatus_complete(struct ampdu_info=
 *ampdu, struct scb *scb,
 		}
 		/* either retransmit or send bar if ack not recd */
 		if (!ack_recd) {
-			struct ieee80211_tx_rate *txrate =3D
-			    tx_info->status.rates;
-			if (retry && (txrate[0].count < (int)retry_limit)) {
+			if (retry && (ini->txretry[index] < (int)retry_limit)) {
 				ini->txretry[index]++;
 				ini->tx_in_transit--;
 				/*
 				 * Use high prededence for retransmit to
 				 * give some punch
 				 */
-				/* brcms_c_txq_enq(wlc, scb, p,
-				 * BRCMS_PRIO_TO_PREC(tid)); */
 				brcms_c_txq_enq(wlc, scb, p,
 						BRCMS_PRIO_TO_HI_PREC(tid));
 			} else {
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/w=
ireless/brcm80211/brcmsmac/main.c
index f98becc..833cbef 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
@@ -7879,7 +7879,7 @@ brcms_c_recvctl(struct brcms_c_info *wlc, struct d11r=
xhdr *rxh,
 	if (wlc->hw->suspended_fifos) {
 		hdr =3D (struct ieee80211_hdr *)p->data;
 		if (ieee80211_is_beacon(hdr->frame_control))
-			brcms_b_mute(wlc->hw, false);
+			brcms_b_mute(wlc->hw, false, 0);
 	}
=20
 	memcpy(IEEE80211_SKB_RXCB(p), &rx_status, sizeof(rx_status));
diff --git a/drivers/regulator/max8997.c b/drivers/regulator/max8997.c
index 6176129..8cba82d 100644
--- a/drivers/regulator/max8997.c
+++ b/drivers/regulator/max8997.c
@@ -689,7 +689,7 @@ static int max8997_set_voltage_buck(struct regulator_de=
v *rdev,
 		}
=20
 		new_val++;
-	} while (desc->min + desc->step + new_val <=3D desc->max);
+	} while (desc->min + desc->step * new_val <=3D desc->max);
=20
 	new_idx =3D tmp_idx;
 	new_val =3D tmp_val;
diff --git a/drivers/spi/spi-topcliff-pch.c b/drivers/spi/spi-topcliff-pch.=
c
index 54b9d2e..1590dbd 100644
--- a/drivers/spi/spi-topcliff-pch.c
+++ b/drivers/spi/spi-topcliff-pch.c
@@ -196,6 +196,7 @@ struct pch_spi_data {
 	struct pch_spi_dma_ctrl dma;
 	int use_dma;
 	u8 irq_reg_sts;
+	int save_total_len;
 };
=20
 /**
@@ -823,11 +824,13 @@ static void pch_spi_copy_rx_data_for_dma(struct pch_s=
pi_data *data, int bpw)
 		rx_dma_buf =3D data->dma.rx_buf_virt;
 		for (j =3D 0; j < data->bpw_len; j++)
 			*rx_buf++ =3D *rx_dma_buf++ & 0xFF;
+		data->cur_trans->rx_buf =3D rx_buf;
 	} else {
 		rx_sbuf =3D data->cur_trans->rx_buf;
 		rx_dma_sbuf =3D data->dma.rx_buf_virt;
 		for (j =3D 0; j < data->bpw_len; j++)
 			*rx_sbuf++ =3D *rx_dma_sbuf++;
+		data->cur_trans->rx_buf =3D rx_sbuf;
 	}
 }
=20
@@ -853,6 +856,9 @@ static int pch_spi_start_transfer(struct pch_spi_data *=
data)
 	rtn =3D wait_event_interruptible_timeout(data->wait,
 					       data->transfer_complete,
 					       msecs_to_jiffies(2 * HZ));
+	if (!rtn)
+		dev_err(&data->master->dev,
+			"%s wait-event timeout\n", __func__);
=20
 	dma_sync_sg_for_cpu(&data->master->dev, dma->sg_rx_p, dma->nent,
 			    DMA_FROM_DEVICE);
@@ -924,7 +930,8 @@ static void pch_spi_request_dma(struct pch_spi_data *da=
ta, int bpw)
 	dma_cap_set(DMA_SLAVE, mask);
=20
 	/* Get DMA's dev information */
-	dma_dev =3D pci_get_bus_and_slot(2, PCI_DEVFN(12, 0));
+	dma_dev =3D pci_get_bus_and_slot(data->board_dat->pdev->bus->number,
+				       PCI_DEVFN(12, 0));
=20
 	/* Set Tx DMA */
 	param =3D &dma->param_tx;
@@ -988,6 +995,7 @@ static void pch_spi_handle_dma(struct pch_spi_data *dat=
a, int *bpw)
 	int i;
 	int size;
 	int rem;
+	int head;
 	unsigned long flags;
 	struct pch_spi_dma_ctrl *dma;
=20
@@ -1016,6 +1024,11 @@ static void pch_spi_handle_dma(struct pch_spi_data *=
data, int *bpw)
 	}
 	data->bpw_len =3D data->cur_trans->len / (*bpw / 8);
=20
+	if (data->bpw_len > PCH_BUF_SIZE) {
+		data->bpw_len =3D PCH_BUF_SIZE;
+		data->cur_trans->len -=3D PCH_BUF_SIZE;
+	}
+
 	/* copy Tx Data */
 	if (data->cur_trans->tx_buf !=3D NULL) {
 		if (*bpw =3D=3D 8) {
@@ -1030,10 +1043,17 @@ static void pch_spi_handle_dma(struct pch_spi_data =
*data, int *bpw)
 				*tx_dma_sbuf++ =3D *tx_sbuf++;
 		}
 	}
+
+	/* Calculate Rx parameter for DMA transmitting */
 	if (data->bpw_len > PCH_DMA_TRANS_SIZE) {
-		num =3D data->bpw_len / PCH_DMA_TRANS_SIZE + 1;
+		if (data->bpw_len % PCH_DMA_TRANS_SIZE) {
+			num =3D data->bpw_len / PCH_DMA_TRANS_SIZE + 1;
+			rem =3D data->bpw_len % PCH_DMA_TRANS_SIZE;
+		} else {
+			num =3D data->bpw_len / PCH_DMA_TRANS_SIZE;
+			rem =3D PCH_DMA_TRANS_SIZE;
+		}
 		size =3D PCH_DMA_TRANS_SIZE;
-		rem =3D data->bpw_len % PCH_DMA_TRANS_SIZE;
 	} else {
 		num =3D 1;
 		size =3D data->bpw_len;
@@ -1093,15 +1113,23 @@ static void pch_spi_handle_dma(struct pch_spi_data =
*data, int *bpw)
 	dma->nent =3D num;
 	dma->desc_rx =3D desc_rx;
=20
-	/* TX */
-	if (data->bpw_len > PCH_DMA_TRANS_SIZE) {
-		num =3D data->bpw_len / PCH_DMA_TRANS_SIZE;
+	/* Calculate Tx parameter for DMA transmitting */
+	if (data->bpw_len > PCH_MAX_FIFO_DEPTH) {
+		head =3D PCH_MAX_FIFO_DEPTH - PCH_DMA_TRANS_SIZE;
+		if (data->bpw_len % PCH_DMA_TRANS_SIZE > 4) {
+			num =3D data->bpw_len / PCH_DMA_TRANS_SIZE + 1;
+			rem =3D data->bpw_len % PCH_DMA_TRANS_SIZE - head;
+		} else {
+			num =3D data->bpw_len / PCH_DMA_TRANS_SIZE;
+			rem =3D data->bpw_len % PCH_DMA_TRANS_SIZE +
+			      PCH_DMA_TRANS_SIZE - head;
+		}
 		size =3D PCH_DMA_TRANS_SIZE;
-		rem =3D 16;
 	} else {
 		num =3D 1;
 		size =3D data->bpw_len;
 		rem =3D data->bpw_len;
+		head =3D 0;
 	}
=20
 	dma->sg_tx_p =3D kzalloc(sizeof(struct scatterlist)*num, GFP_ATOMIC);
@@ -1111,11 +1139,17 @@ static void pch_spi_handle_dma(struct pch_spi_data =
*data, int *bpw)
 	for (i =3D 0; i < num; i++, sg++) {
 		if (i =3D=3D 0) {
 			sg->offset =3D 0;
+			sg_set_page(sg, virt_to_page(dma->tx_buf_virt), size + head,
+				    sg->offset);
+			sg_dma_len(sg) =3D size + head;
+		} else if (i =3D=3D (num - 1)) {
+			sg->offset =3D head + size * i;
+			sg->offset =3D sg->offset * (*bpw / 8);
 			sg_set_page(sg, virt_to_page(dma->tx_buf_virt), rem,
 				    sg->offset);
 			sg_dma_len(sg) =3D rem;
 		} else {
-			sg->offset =3D rem + size * (i - 1);
+			sg->offset =3D head + size * i;
 			sg->offset =3D sg->offset * (*bpw / 8);
 			sg_set_page(sg, virt_to_page(dma->tx_buf_virt), size,
 				    sg->offset);
@@ -1203,6 +1237,7 @@ static void pch_spi_process_messages(struct work_stru=
ct *pwork)
 				    data->current_msg->spi->bits_per_word);
 	pch_spi_writereg(data->master, PCH_SSNXCR, SSN_NO_CONTROL);
 	do {
+		int cnt;
 		/* If we are already processing a message get the next
 		transfer structure from the message otherwise retrieve
 		the 1st transfer request from the message. */
@@ -1222,11 +1257,28 @@ static void pch_spi_process_messages(struct work_st=
ruct *pwork)
 		}
 		spin_unlock(&data->lock);
=20
+		if (!data->cur_trans->len)
+			goto out;
+		cnt =3D (data->cur_trans->len - 1) / PCH_BUF_SIZE + 1;
+		data->save_total_len =3D data->cur_trans->len;
 		if (data->use_dma) {
-			pch_spi_handle_dma(data, &bpw);
-			if (!pch_spi_start_transfer(data))
-				goto out;
-			pch_spi_copy_rx_data_for_dma(data, bpw);
+			int i;
+			char *save_rx_buf =3D data->cur_trans->rx_buf;
+			for (i =3D 0; i < cnt; i ++) {
+				pch_spi_handle_dma(data, &bpw);
+				if (!pch_spi_start_transfer(data)) {
+					data->transfer_complete =3D true;
+					data->current_msg->status =3D -EIO;
+					data->current_msg->complete
+						   (data->current_msg->context);
+					data->bcurrent_msg_processing =3D false;
+					data->current_msg =3D NULL;
+					data->cur_trans =3D NULL;
+					goto out;
+				}
+				pch_spi_copy_rx_data_for_dma(data, bpw);
+			}
+			data->cur_trans->rx_buf =3D save_rx_buf;
 		} else {
 			pch_spi_set_tx(data, &bpw);
 			pch_spi_set_ir(data);
@@ -1237,6 +1289,7 @@ static void pch_spi_process_messages(struct work_stru=
ct *pwork)
 			data->pkt_tx_buff =3D NULL;
 		}
 		/* increment message count */
+		data->cur_trans->len =3D data->save_total_len;
 		data->current_msg->actual_length +=3D data->cur_trans->len;
=20
 		dev_dbg(&data->master->dev,
@@ -1389,6 +1442,7 @@ static int __devinit pch_spi_pd_probe(struct platform=
_device *plat_dev)
 	master->num_chipselect =3D PCH_MAX_CS;
 	master->setup =3D pch_spi_setup;
 	master->transfer =3D pch_spi_transfer;
+	master->mode_bits =3D SPI_CPOL | SPI_CPHA | SPI_LSB_FIRST;
=20
 	data->board_dat =3D board_dat;
 	data->plat_dev =3D plat_dev;
diff --git a/drivers/target/target_core_file.c b/drivers/target/target_core=
_file.c
index b4864fb..cad8b92 100644
--- a/drivers/target/target_core_file.c
+++ b/drivers/target/target_core_file.c
@@ -170,6 +170,7 @@ static struct se_device *fd_create_virtdevice(
 	inode =3D file->f_mapping->host;
 	if (S_ISBLK(inode->i_mode)) {
 		struct request_queue *q;
+		unsigned long long dev_size;
 		/*
 		 * Setup the local scope queue_limits from struct request_queue->limits
 		 * to pass into transport_add_device_to_core_hba() as struct se_dev_limi=
ts.
@@ -184,13 +185,12 @@ static struct se_device *fd_create_virtdevice(
 		 * one (1) logical sector from underlying struct block_device
 		 */
 		fd_dev->fd_block_size =3D bdev_logical_block_size(inode->i_bdev);
-		fd_dev->fd_dev_size =3D (i_size_read(file->f_mapping->host) -
+		dev_size =3D (i_size_read(file->f_mapping->host) -
 				       fd_dev->fd_block_size);
=20
 		pr_debug("FILEIO: Using size: %llu bytes from struct"
 			" block_device blocks: %llu logical_block_size: %d\n",
-			fd_dev->fd_dev_size,
-			div_u64(fd_dev->fd_dev_size, fd_dev->fd_block_size),
+			dev_size, div_u64(dev_size, fd_dev->fd_block_size),
 			fd_dev->fd_block_size);
 	} else {
 		if (!(fd_dev->fbd_flags & FBDF_HAS_SIZE)) {
@@ -606,10 +606,20 @@ static u32 fd_get_device_type(struct se_device *dev)
 static sector_t fd_get_blocks(struct se_device *dev)
 {
 	struct fd_dev *fd_dev =3D dev->dev_ptr;
-	unsigned long long blocks_long =3D div_u64(fd_dev->fd_dev_size,
-			dev->se_sub_dev->se_dev_attrib.block_size);
+	struct file *f =3D fd_dev->fd_file;
+	struct inode *i =3D f->f_mapping->host;
+	unsigned long long dev_size;
+	/*
+	 * When using a file that references an underlying struct block_device,
+	 * ensure dev_size is always based on the current inode size in order
+	 * to handle underlying block_device resize operations.
+	 */
+	if (S_ISBLK(i->i_mode))
+		dev_size =3D (i_size_read(i) - fd_dev->fd_block_size);
+	else
+		dev_size =3D fd_dev->fd_dev_size;
=20
-	return blocks_long;
+	return div_u64(dev_size, dev->se_sub_dev->se_dev_attrib.block_size);
 }
=20
 static struct se_subsystem_api fileio_template =3D {
diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_p=
r.c
index 6cf6ff4..b75bc92 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -223,6 +223,9 @@ int target_scsi2_reservation_release(struct se_task *ta=
sk)
 	if (dev->dev_reserved_node_acl !=3D sess->se_node_acl)
 		goto out_unlock;
=20
+	if (dev->dev_res_bin_isid !=3D sess->sess_bin_isid)
+		goto out_unlock;
+
 	dev->dev_reserved_node_acl =3D NULL;
 	dev->dev_flags &=3D ~DF_SPC2_RESERVATIONS;
 	if (dev->dev_flags & DF_SPC2_RESERVATIONS_WITH_ISID) {
diff --git a/drivers/target/target_core_tpg.c b/drivers/target/target_core_=
tpg.c
index 8ddd133..d91fe44 100644
--- a/drivers/target/target_core_tpg.c
+++ b/drivers/target/target_core_tpg.c
@@ -63,7 +63,6 @@ static void core_clear_initiator_node_from_tpg(
 	int i;
 	struct se_dev_entry *deve;
 	struct se_lun *lun;
-	struct se_lun_acl *acl, *acl_tmp;
=20
 	spin_lock_irq(&nacl->device_list_lock);
 	for (i =3D 0; i < TRANSPORT_MAX_LUNS_PER_TPG; i++) {
@@ -84,28 +83,7 @@ static void core_clear_initiator_node_from_tpg(
 		core_update_device_list_for_node(lun, NULL, deve->mapped_lun,
 			TRANSPORT_LUNFLAGS_NO_ACCESS, nacl, tpg, 0);
=20
-		spin_lock(&lun->lun_acl_lock);
-		list_for_each_entry_safe(acl, acl_tmp,
-					&lun->lun_acl_list, lacl_list) {
-			if (!strcmp(acl->initiatorname, nacl->initiatorname) &&
-			    (acl->mapped_lun =3D=3D deve->mapped_lun))
-				break;
-		}
-
-		if (!acl) {
-			pr_err("Unable to locate struct se_lun_acl for %s,"
-				" mapped_lun: %u\n", nacl->initiatorname,
-				deve->mapped_lun);
-			spin_unlock(&lun->lun_acl_lock);
-			spin_lock_irq(&nacl->device_list_lock);
-			continue;
-		}
-
-		list_del(&acl->lacl_list);
-		spin_unlock(&lun->lun_acl_lock);
-
 		spin_lock_irq(&nacl->device_list_lock);
-		kfree(acl);
 	}
 	spin_unlock_irq(&nacl->device_list_lock);
 }
diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index 93a00d8..4410ae7 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -487,18 +487,19 @@ ext4_xattr_release_block(handle_t *handle, struct ino=
de *inode,
 		ext4_free_blocks(handle, inode, bh, 0, 1,
 				 EXT4_FREE_BLOCKS_METADATA |
 				 EXT4_FREE_BLOCKS_FORGET);
+		unlock_buffer(bh);
 	} else {
 		le32_add_cpu(&BHDR(bh)->h_refcount, -1);
+		if (ce)
+			mb_cache_entry_release(ce);
+		unlock_buffer(bh);
 		error =3D ext4_handle_dirty_metadata(handle, inode, bh);
 		if (IS_SYNC(inode))
 			ext4_handle_sync(handle);
 		dquot_free_block(inode, 1);
 		ea_bdebug(bh, "refcount now=3D%d; releasing",
 			  le32_to_cpu(BHDR(bh)->h_refcount));
-		if (ce)
-			mb_cache_entry_release(ce);
 	}
-	unlock_buffer(bh);
 out:
 	ext4_std_error(inode->i_sb, error);
 	return;
diff --git a/fs/jffs2/gc.c b/fs/jffs2/gc.c
index 31dce61..4bbd521 100644
--- a/fs/jffs2/gc.c
+++ b/fs/jffs2/gc.c
@@ -225,8 +225,8 @@ int jffs2_garbage_collect_pass(struct jffs2_sb_info *c)
 			return 0;
=20
 		D1(printk(KERN_DEBUG "No progress from erasing blocks; doing GC anyway\n=
"));
-		spin_lock(&c->erase_completion_lock);
 		mutex_lock(&c->alloc_sem);
+		spin_lock(&c->erase_completion_lock);
 	}
=20
 	/* First, work out which block we're garbage-collecting */
diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index 51f6a40..bab7c58 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -1802,6 +1802,7 @@ static int _nfs4_do_open(struct inode *dir, struct de=
ntry *dentry, fmode_t fmode
 			nfs_setattr_update_inode(state->inode, sattr);
 		nfs_post_op_update_inode(state->inode, opendata->o_res.f_attr);
 	}
+	nfs_revalidate_inode(server, state->inode);
 	nfs4_opendata_put(opendata);
 	nfs4_put_state_owner(sp);
 	*res =3D state;
diff --git a/include/linux/mtd/map.h b/include/linux/mtd/map.h
index a9e6ba4..daad4e6 100644
--- a/include/linux/mtd/map.h
+++ b/include/linux/mtd/map.h
@@ -26,7 +26,7 @@
 #include <linux/list.h>
 #include <linux/string.h>
 #include <linux/bug.h>
-
+#include <linux/kernel.h>
=20
 #include <asm/unaligned.h>
 #include <asm/system.h>
diff --git a/include/linux/usb/usbnet.h b/include/linux/usb/usbnet.h
index 605b0aa..76f4396 100644
--- a/include/linux/usb/usbnet.h
+++ b/include/linux/usb/usbnet.h
@@ -191,7 +191,8 @@ extern void usbnet_cdc_status(struct usbnet *, struct u=
rb *);
 enum skb_state {
 	illegal =3D 0,
 	tx_start, tx_done,
-	rx_start, rx_done, rx_cleanup
+	rx_start, rx_done, rx_cleanup,
+	unlink_start
 };
=20
 struct skb_data {	/* skb->cb is one of these */
diff --git a/kernel/fork.c b/kernel/fork.c
index 0acf42c0..26f1ab0 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -47,6 +47,7 @@
 #include <linux/audit.h>
 #include <linux/memcontrol.h>
 #include <linux/ftrace.h>
+#include <linux/proc_fs.h>
 #include <linux/profile.h>
 #include <linux/rmap.h>
 #include <linux/ksm.h>
@@ -1387,6 +1388,8 @@ bad_fork_cleanup_io:
 	if (p->io_context)
 		exit_io_context(p);
 bad_fork_cleanup_namespaces:
+	if (unlikely(clone_flags & CLONE_NEWPID))
+		pid_ns_release_proc(p->nsproxy->pid_ns);
 	exit_task_namespaces(p);
 bad_fork_cleanup_mm:
 	if (p->mm)
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index bd936ed..7120c2e 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2405,7 +2405,6 @@ retry_avoidcopy:
 		if (outside_reserve) {
 			BUG_ON(huge_pte_none(pte));
 			if (unmap_ref_private(mm, vma, old_page, address)) {
-				BUG_ON(page_count(old_page) !=3D 1);
 				BUG_ON(huge_pte_none(pte));
 				spin_lock(&mm->page_table_lock);
 				goto retry_avoidcopy;
diff --git a/mm/nobootmem.c b/mm/nobootmem.c
index 7fa41b4..07c08c4 100644
--- a/mm/nobootmem.c
+++ b/mm/nobootmem.c
@@ -83,8 +83,7 @@ void __init free_bootmem_late(unsigned long addr, unsigne=
d long size)
=20
 static void __init __free_pages_memory(unsigned long start, unsigned long =
end)
 {
-	int i;
-	unsigned long start_aligned, end_aligned;
+	unsigned long i, start_aligned, end_aligned;
 	int order =3D ilog2(BITS_PER_LONG);
=20
 	start_aligned =3D (start + (BITS_PER_LONG - 1)) & ~(BITS_PER_LONG - 1);
diff --git a/mm/percpu.c b/mm/percpu.c
index 716eb4a..5c29750 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -1642,6 +1642,16 @@ int __init pcpu_embed_first_chunk(size_t reserved_si=
ze, size_t dyn_size,
 		areas[group] =3D ptr;
=20
 		base =3D min(ptr, base);
+	}
+
+	/*
+	 * Copy data and free unused parts.  This should happen after all
+	 * allocations are complete; otherwise, we may end up with
+	 * overlapping groups.
+	 */
+	for (group =3D 0; group < ai->nr_groups; group++) {
+		struct pcpu_group_info *gi =3D &ai->groups[group];
+		void *ptr =3D areas[group];
=20
 		for (i =3D 0; i < gi->nr_units; i++, ptr +=3D ai->unit_size) {
 			if (gi->cpu_map[i] =3D=3D NR_CPUS) {
diff --git a/net/core/dev.c b/net/core/dev.c
index cd5050e..61a7baa 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -1421,14 +1421,34 @@ EXPORT_SYMBOL(register_netdevice_notifier);
  *	register_netdevice_notifier(). The notifier is unlinked into the
  *	kernel structures and may then be reused. A negative errno code
  *	is returned on a failure.
+ *
+ * 	After unregistering unregister and down device events are synthesized
+ *	for all devices on the device list to the removed notifier to remove
+ *	the need for special case cleanup code.
  */
=20
 int unregister_netdevice_notifier(struct notifier_block *nb)
 {
+	struct net_device *dev;
+	struct net *net;
 	int err;
=20
 	rtnl_lock();
 	err =3D raw_notifier_chain_unregister(&netdev_chain, nb);
+	if (err)
+		goto unlock;
+
+	for_each_net(net) {
+		for_each_netdev(net, dev) {
+			if (dev->flags & IFF_UP) {
+				nb->notifier_call(nb, NETDEV_GOING_DOWN, dev);
+				nb->notifier_call(nb, NETDEV_DOWN, dev);
+			}
+			nb->notifier_call(nb, NETDEV_UNREGISTER, dev);
+			nb->notifier_call(nb, NETDEV_UNREGISTER_BATCH, dev);
+		}
+	}
+unlock:
 	rtnl_unlock();
 	return err;
 }
diff --git a/net/core/pktgen.c b/net/core/pktgen.c
index 0001c24..df878de 100644
--- a/net/core/pktgen.c
+++ b/net/core/pktgen.c
@@ -1932,7 +1932,7 @@ static int pktgen_device_event(struct notifier_block =
*unused,
 {
 	struct net_device *dev =3D ptr;
=20
-	if (!net_eq(dev_net(dev), &init_net))
+	if (!net_eq(dev_net(dev), &init_net) || pktgen_exiting)
 		return NOTIFY_DONE;
=20
 	/* It is OK that we do not hold the group lock right now,
@@ -3758,12 +3758,18 @@ static void __exit pg_cleanup(void)
 {
 	struct pktgen_thread *t;
 	struct list_head *q, *n;
+	LIST_HEAD(list);
=20
 	/* Stop all interfaces & threads */
 	pktgen_exiting =3D true;
=20
-	list_for_each_safe(q, n, &pktgen_threads) {
+	mutex_lock(&pktgen_thread_lock);
+	list_splice_init(&pktgen_threads, &list);
+	mutex_unlock(&pktgen_thread_lock);
+
+	list_for_each_safe(q, n, &list) {
 		t =3D list_entry(q, struct pktgen_thread, th_list);
+		list_del(&t->th_list);
 		kthread_stop(t->tsk);
 		kfree(t);
 	}
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 7904db4..11ba922 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -851,8 +851,7 @@ new_segment:
 wait_for_sndbuf:
 		set_bit(SOCK_NOSPACE, &sk->sk_socket->flags);
 wait_for_memory:
-		if (copied)
-			tcp_push(sk, flags & ~MSG_MORE, mss_now, TCP_NAGLE_PUSH);
+		tcp_push(sk, flags & ~MSG_MORE, mss_now, TCP_NAGLE_PUSH);
=20
 		if ((err =3D sk_stream_wait_memory(sk, &timeo)) !=3D 0)
 			goto do_error;
@@ -3216,7 +3215,7 @@ void __init tcp_init(void)
 {
 	struct sk_buff *skb =3D NULL;
 	unsigned long limit;
-	int i, max_share, cnt;
+	int i, max_rshare, max_wshare, cnt;
 	unsigned long jiffy =3D jiffies;
=20
 	BUILD_BUG_ON(sizeof(struct tcp_skb_cb) > sizeof(skb->cb));
@@ -3280,15 +3279,16 @@ void __init tcp_init(void)
=20
 	/* Set per-socket limits to no more than 1/128 the pressure threshold */
 	limit =3D ((unsigned long)sysctl_tcp_mem[1]) << (PAGE_SHIFT - 7);
-	max_share =3D min(4UL*1024*1024, limit);
+	max_wshare =3D min(4UL*1024*1024, limit);
+	max_rshare =3D min(6UL*1024*1024, limit);
=20
 	sysctl_tcp_wmem[0] =3D SK_MEM_QUANTUM;
 	sysctl_tcp_wmem[1] =3D 16*1024;
-	sysctl_tcp_wmem[2] =3D max(64*1024, max_share);
+	sysctl_tcp_wmem[2] =3D max(64*1024, max_wshare);
=20
 	sysctl_tcp_rmem[0] =3D SK_MEM_QUANTUM;
 	sysctl_tcp_rmem[1] =3D 87380;
-	sysctl_tcp_rmem[2] =3D max(87380, max_share);
+	sysctl_tcp_rmem[2] =3D max(87380, max_rshare);
=20
 	printk(KERN_INFO "TCP: Hash tables configured "
 	       "(established %u bind %u)\n",
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index daedc07..9726927 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -83,7 +83,7 @@ int sysctl_tcp_ecn __read_mostly =3D 2;
 EXPORT_SYMBOL(sysctl_tcp_ecn);
 int sysctl_tcp_dsack __read_mostly =3D 1;
 int sysctl_tcp_app_win __read_mostly =3D 31;
-int sysctl_tcp_adv_win_scale __read_mostly =3D 2;
+int sysctl_tcp_adv_win_scale __read_mostly =3D 1;
 EXPORT_SYMBOL(sysctl_tcp_adv_win_scale);
=20
 int sysctl_tcp_stdurg __read_mostly;
@@ -2868,11 +2868,14 @@ static inline void tcp_complete_cwr(struct sock *sk=
)
=20
 	/* Do not moderate cwnd if it's already undone in cwr or recovery. */
 	if (tp->undo_marker) {
-		if (inet_csk(sk)->icsk_ca_state =3D=3D TCP_CA_CWR)
+		if (inet_csk(sk)->icsk_ca_state =3D=3D TCP_CA_CWR) {
 			tp->snd_cwnd =3D min(tp->snd_cwnd, tp->snd_ssthresh);
-		else /* PRR */
+			tp->snd_cwnd_stamp =3D tcp_time_stamp;
+		} else if (tp->snd_ssthresh < TCP_INFINITE_SSTHRESH) {
+			/* PRR algorithm. */
 			tp->snd_cwnd =3D tp->snd_ssthresh;
-		tp->snd_cwnd_stamp =3D tcp_time_stamp;
+			tp->snd_cwnd_stamp =3D tcp_time_stamp;
+		}
 	}
 	tcp_ca_event(sk, CA_EVENT_COMPLETE_CWR);
 }
diff --git a/net/l2tp/l2tp_ip.c b/net/l2tp/l2tp_ip.c
index 55670ec..2a2a3e7 100644
--- a/net/l2tp/l2tp_ip.c
+++ b/net/l2tp/l2tp_ip.c
@@ -441,8 +441,9 @@ static int l2tp_ip_sendmsg(struct kiocb *iocb, struct s=
ock *sk, struct msghdr *m
=20
 		daddr =3D lip->l2tp_addr.s_addr;
 	} else {
+		rc =3D -EDESTADDRREQ;
 		if (sk->sk_state !=3D TCP_ESTABLISHED)
-			return -EDESTADDRREQ;
+			goto out;
=20
 		daddr =3D inet->inet_daddr;
 		connected =3D 1;
diff --git a/net/sched/sch_netem.c b/net/sched/sch_netem.c
index 7801b15..a489d8b 100644
--- a/net/sched/sch_netem.c
+++ b/net/sched/sch_netem.c
@@ -351,10 +351,8 @@ static int netem_enqueue(struct sk_buff *skb, struct Q=
disc *sch)
 	if (q->corrupt && q->corrupt >=3D get_crandom(&q->corrupt_cor)) {
 		if (!(skb =3D skb_unshare(skb, GFP_ATOMIC)) ||
 		    (skb->ip_summed =3D=3D CHECKSUM_PARTIAL &&
-		     skb_checksum_help(skb))) {
-			sch->qstats.drops++;
-			return NET_XMIT_DROP;
-		}
+		     skb_checksum_help(skb)))
+			return qdisc_drop(skb, sch);
=20
 		skb->data[net_random() % skb_headlen(skb)] ^=3D 1<<(net_random() % 8);
 	}
diff --git a/sound/pci/echoaudio/echoaudio_dsp.c b/sound/pci/echoaudio/echo=
audio_dsp.c
index 64417a7..d8c670c 100644
--- a/sound/pci/echoaudio/echoaudio_dsp.c
+++ b/sound/pci/echoaudio/echoaudio_dsp.c
@@ -475,7 +475,7 @@ static int load_firmware(struct echoaudio *chip)
 	const struct firmware *fw;
 	int box_type, err;
=20
-	if (snd_BUG_ON(!chip->dsp_code_to_load || !chip->comm_page))
+	if (snd_BUG_ON(!chip->comm_page))
 		return -EPERM;
=20
 	/* See if the ASIC is present and working - only if the DSP is already lo=
aded */
diff --git a/sound/pci/hda/hda_intel.c b/sound/pci/hda/hda_intel.c
index 192e6c0..53345bc 100644
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -769,11 +769,13 @@ static unsigned int azx_rirb_get_response(struct hda_=
bus *bus,
 {
 	struct azx *chip =3D bus->private_data;
 	unsigned long timeout;
+	unsigned long loopcounter;
 	int do_poll =3D 0;
=20
  again:
 	timeout =3D jiffies + msecs_to_jiffies(1000);
-	for (;;) {
+
+	for (loopcounter =3D 0;; loopcounter++) {
 		if (chip->polling_mode || do_poll) {
 			spin_lock_irq(&chip->reg_lock);
 			azx_update_rirb(chip);
@@ -789,7 +791,7 @@ static unsigned int azx_rirb_get_response(struct hda_bu=
s *bus,
 		}
 		if (time_after(jiffies, timeout))
 			break;
-		if (bus->needs_damn_long_delay)
+		if (bus->needs_damn_long_delay || loopcounter > 3000)
 			msleep(2); /* temporary workaround */
 		else {
 			udelay(10);
diff --git a/sound/pci/hda/patch_sigmatel.c b/sound/pci/hda/patch_sigmatel.=
c
index ed67698..7b7a516 100644
--- a/sound/pci/hda/patch_sigmatel.c
+++ b/sound/pci/hda/patch_sigmatel.c
@@ -4484,9 +4484,9 @@ static int stac92xx_init(struct hda_codec *codec)
 		def_conf =3D get_defcfg_connect(def_conf);
 		/* skip any ports that don't have jacks since presence
  		 * detection is useless */
-		if (def_conf !=3D AC_JACK_PORT_COMPLEX) {
-			if (def_conf !=3D AC_JACK_PORT_NONE)
-				stac_toggle_power_map(codec, nid, 1);
+		if (def_conf !=3D AC_JACK_PORT_NONE &&
+		    !is_jack_detectable(codec, nid)) {
+			stac_toggle_power_map(codec, nid, 1);
 			continue;
 		}
 		if (enable_pin_detect(codec, nid, STAC_PWR_EVENT)) {
diff --git a/sound/soc/codecs/wm8994.c b/sound/soc/codecs/wm8994.c
index 7806301..3e7aa22 100644
--- a/sound/soc/codecs/wm8994.c
+++ b/sound/soc/codecs/wm8994.c
@@ -1027,7 +1027,7 @@ static int aif2clk_ev(struct snd_soc_dapm_widget *w,
 		snd_soc_update_bits(codec, WM8994_POWER_MANAGEMENT_5,
 				    WM8994_AIF2DACL_ENA |
 				    WM8994_AIF2DACR_ENA, 0);
-		snd_soc_update_bits(codec, WM8994_POWER_MANAGEMENT_5,
+		snd_soc_update_bits(codec, WM8994_POWER_MANAGEMENT_4,
 				    WM8994_AIF2ADCL_ENA |
 				    WM8994_AIF2ADCR_ENA, 0);
=20


--=20
Ben Hutchings
You can't have everything.  Where would you put it?

--=-NWOGwZ4pxhfxg73AllMQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAT7pMAOe/yOyVhhEJAQpyHg/9HidSNlBmQEuhGHLXVh03ag4W/tF4aqBK
hwMUuvjzfxeMjRa90ki2NzqVEvIMtjBvvSJ5v+qVAHiC8RinixFOUk1iyAr/ucQ9
6AiUaYzZCeBwFKZaoanM0Rxv28Qvbv1DL/D7nxUdSov0rwUK0zJLjLrCpKOXCNr2
w2z1we7Q8md0HvVmXdozWWOILcA1/sHN5wNFoV5mlwDdF8zhXech6O7I8qUbLp/F
NESJPQFHpjVgZNhkOkTwolp8HWpmcMbuBn+I8s8viVvwpz1ukT5ZtvyJYxI/STOX
UU+5iWo8kkN/iSDT8LqOBH91mftkdj4taijVWFxuj71FrFg6nbj4syVGZme7AQbP
aiw4nQNJYTvK0LAsWTr+9eSCpSEFQC31XJOFJui/isI3h1jjz7nrHkhy4Lr2ifdS
cTj6pQGO/CEM5i0CfW7FNGpeyViB+TeO8a8AD4pHZJoS6t7FALGYHSnLFp1pEmAJ
yl6tF2iQba8oktAPvzhHdipbfOWVlXGRfAl5M2zp83gZki6lFKfC6/DfX8VA4GA/
YSnABvCL8aZxHC9NF3/MuOOF2lghaJ0J1MZRNlISi0WSyNVUUiiErppm7/WWE2PY
w31NxJpuHdT2itFDfNv1KOZDTcOM6fh0zWeXUtPa/SHo5rTMAxGZaPMGqQPCtk1Z
6a1SjWe3Zjk=
=Zas+
-----END PGP SIGNATURE-----

--=-NWOGwZ4pxhfxg73AllMQ--
