Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755410Ab2HTNFZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 09:05:25 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52035 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755129Ab2HTNFT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 09:05:19 -0400
Message-ID: <1345467911.22400.140.camel@deadeye.wl.decadent.org.uk>
Subject: Re: Linux 3.2.28
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, torvalds@linux-foundation.org,
        Jiri Slaby <jslaby@suse.cz>, stable@vger.kernel.org, lwn@lwn.net
Date: Mon, 20 Aug 2012 14:05:11 +0100
In-Reply-To: <1345467862.22400.139.camel@deadeye.wl.decadent.org.uk>
References: <1345467862.22400.139.camel@deadeye.wl.decadent.org.uk>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-q0ilw9sE6MUanGhQw3MU"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-q0ilw9sE6MUanGhQw3MU
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

diff --git a/Makefile b/Makefile
index bdf851f..5368961 100644
--- a/Makefile
+++ b/Makefile
@@ -1,6 +1,6 @@
 VERSION =3D 3
 PATCHLEVEL =3D 2
-SUBLEVEL =3D 27
+SUBLEVEL =3D 28
 EXTRAVERSION =3D
 NAME =3D Saber-toothed Squirrel
=20
diff --git a/arch/arm/configs/mxs_defconfig b/arch/arm/configs/mxs_defconfi=
g
index 6ee781b..3ee3e84 100644
--- a/arch/arm/configs/mxs_defconfig
+++ b/arch/arm/configs/mxs_defconfig
@@ -32,7 +32,6 @@ CONFIG_NO_HZ=3Dy
 CONFIG_HIGH_RES_TIMERS=3Dy
 CONFIG_PREEMPT_VOLUNTARY=3Dy
 CONFIG_AEABI=3Dy
-CONFIG_DEFAULT_MMAP_MIN_ADDR=3D65536
 CONFIG_AUTO_ZRELADDR=3Dy
 CONFIG_FPE_NWFPE=3Dy
 CONFIG_NET=3Dy
diff --git a/arch/arm/mach-pxa/raumfeld.c b/arch/arm/mach-pxa/raumfeld.c
index f0c05f4..ae7786d 100644
--- a/arch/arm/mach-pxa/raumfeld.c
+++ b/arch/arm/mach-pxa/raumfeld.c
@@ -951,12 +951,12 @@ static struct i2c_board_info raumfeld_connector_i2c_b=
oard_info __initdata =3D {
=20
 static struct eeti_ts_platform_data eeti_ts_pdata =3D {
 	.irq_active_high =3D 1,
+	.irq_gpio =3D GPIO_TOUCH_IRQ,
 };
=20
 static struct i2c_board_info raumfeld_controller_i2c_board_info __initdata=
 =3D {
 	.type	=3D "eeti_ts",
 	.addr	=3D 0x0a,
-	.irq	=3D gpio_to_irq(GPIO_TOUCH_IRQ),
 	.platform_data =3D &eeti_ts_pdata,
 };
=20
diff --git a/arch/s390/kernel/compat_linux.c b/arch/s390/kernel/compat_linu=
x.c
index 84a9828..38c6645 100644
--- a/arch/s390/kernel/compat_linux.c
+++ b/arch/s390/kernel/compat_linux.c
@@ -615,7 +615,6 @@ asmlinkage unsigned long old32_mmap(struct mmap_arg_str=
uct_emu31 __user *arg)
 		return -EFAULT;
 	if (a.offset & ~PAGE_MASK)
 		return -EINVAL;
-	a.addr =3D (unsigned long) compat_ptr(a.addr);
 	return sys_mmap_pgoff(a.addr, a.len, a.prot, a.flags, a.fd,
 			      a.offset >> PAGE_SHIFT);
 }
@@ -626,7 +625,6 @@ asmlinkage long sys32_mmap2(struct mmap_arg_struct_emu3=
1 __user *arg)
=20
 	if (copy_from_user(&a, arg, sizeof(a)))
 		return -EFAULT;
-	a.addr =3D (unsigned long) compat_ptr(a.addr);
 	return sys_mmap_pgoff(a.addr, a.len, a.prot, a.flags, a.fd, a.offset);
 }
=20
diff --git a/arch/s390/kernel/compat_wrapper.S b/arch/s390/kernel/compat_wr=
apper.S
index 18c51df..25408d3 100644
--- a/arch/s390/kernel/compat_wrapper.S
+++ b/arch/s390/kernel/compat_wrapper.S
@@ -1636,7 +1636,7 @@ ENTRY(compat_sys_process_vm_readv_wrapper)
 	llgfr	%r6,%r6			# unsigned long
 	llgf	%r0,164(%r15)		# unsigned long
 	stg	%r0,160(%r15)
-	jg	sys_process_vm_readv
+	jg	compat_sys_process_vm_readv
=20
 ENTRY(compat_sys_process_vm_writev_wrapper)
 	lgfr	%r2,%r2			# compat_pid_t
@@ -1646,4 +1646,4 @@ ENTRY(compat_sys_process_vm_writev_wrapper)
 	llgfr	%r6,%r6			# unsigned long
 	llgf	%r0,164(%r15)		# unsigned long
 	stg	%r0,160(%r15)
-	jg	sys_process_vm_writev
+	jg	compat_sys_process_vm_writev
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 7315488..407789b 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -1956,6 +1956,7 @@ static __init void nested_vmx_setup_ctls_msrs(void)
 #endif
 		CPU_BASED_MOV_DR_EXITING | CPU_BASED_UNCOND_IO_EXITING |
 		CPU_BASED_USE_IO_BITMAPS | CPU_BASED_MONITOR_EXITING |
+		CPU_BASED_RDPMC_EXITING |
 		CPU_BASED_ACTIVATE_SECONDARY_CONTROLS;
 	/*
 	 * We can allow some features even when not supported by the
diff --git a/drivers/gpu/drm/i915/i915_drv.h b/drivers/gpu/drm/i915/i915_dr=
v.h
index d62c731..c364358 100644
--- a/drivers/gpu/drm/i915/i915_drv.h
+++ b/drivers/gpu/drm/i915/i915_drv.h
@@ -1170,12 +1170,7 @@ i915_seqno_passed(uint32_t seq1, uint32_t seq2)
 	return (int32_t)(seq1 - seq2) >=3D 0;
 }
=20
-static inline u32
-i915_gem_next_request_seqno(struct intel_ring_buffer *ring)
-{
-	drm_i915_private_t *dev_priv =3D ring->dev->dev_private;
-	return ring->outstanding_lazy_request =3D dev_priv->next_seqno;
-}
+u32 i915_gem_next_request_seqno(struct intel_ring_buffer *ring);
=20
 int __must_check i915_gem_object_get_fence(struct drm_i915_gem_object *obj=
,
 					   struct intel_ring_buffer *pipelined);
diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_ge=
m.c
index 3e2edc6..548a400 100644
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -1647,6 +1647,28 @@ i915_gem_process_flushing_list(struct intel_ring_buf=
fer *ring,
 	}
 }
=20
+static u32
+i915_gem_get_seqno(struct drm_device *dev)
+{
+	drm_i915_private_t *dev_priv =3D dev->dev_private;
+	u32 seqno =3D dev_priv->next_seqno;
+
+	/* reserve 0 for non-seqno */
+	if (++dev_priv->next_seqno =3D=3D 0)
+		dev_priv->next_seqno =3D 1;
+
+	return seqno;
+}
+
+u32
+i915_gem_next_request_seqno(struct intel_ring_buffer *ring)
+{
+	if (ring->outstanding_lazy_request =3D=3D 0)
+		ring->outstanding_lazy_request =3D i915_gem_get_seqno(ring->dev);
+
+	return ring->outstanding_lazy_request;
+}
+
 int
 i915_add_request(struct intel_ring_buffer *ring,
 		 struct drm_file *file,
@@ -1658,6 +1680,7 @@ i915_add_request(struct intel_ring_buffer *ring,
 	int ret;
=20
 	BUG_ON(request =3D=3D NULL);
+	seqno =3D i915_gem_next_request_seqno(ring);
=20
 	ret =3D ring->add_request(ring, &seqno);
 	if (ret)
diff --git a/drivers/gpu/drm/i915/intel_ringbuffer.c b/drivers/gpu/drm/i915=
/intel_ringbuffer.c
index f6613dc..19085c0 100644
--- a/drivers/gpu/drm/i915/intel_ringbuffer.c
+++ b/drivers/gpu/drm/i915/intel_ringbuffer.c
@@ -52,20 +52,6 @@ static inline int ring_space(struct intel_ring_buffer *r=
ing)
 	return space;
 }
=20
-static u32 i915_gem_get_seqno(struct drm_device *dev)
-{
-	drm_i915_private_t *dev_priv =3D dev->dev_private;
-	u32 seqno;
-
-	seqno =3D dev_priv->next_seqno;
-
-	/* reserve 0 for non-seqno */
-	if (++dev_priv->next_seqno =3D=3D 0)
-		dev_priv->next_seqno =3D 1;
-
-	return seqno;
-}
-
 static int
 render_ring_flush(struct intel_ring_buffer *ring,
 		  u32	invalidate_domains,
@@ -277,8 +263,6 @@ static int init_ring_common(struct intel_ring_buffer *r=
ing)
 	I915_WRITE_HEAD(ring, 0);
 	ring->write_tail(ring, 0);
=20
-	/* Initialize the ring. */
-	I915_WRITE_START(ring, obj->gtt_offset);
 	head =3D I915_READ_HEAD(ring) & HEAD_ADDR;
=20
 	/* G45 ring initialization fails to reset head to zero */
@@ -304,14 +288,19 @@ static int init_ring_common(struct intel_ring_buffer =
*ring)
 		}
 	}
=20
+	/* Initialize the ring. This must happen _after_ we've cleared the ring
+	 * registers with the above sequence (the readback of the HEAD registers
+	 * also enforces ordering), otherwise the hw might lose the new ring
+	 * register values. */
+	I915_WRITE_START(ring, obj->gtt_offset);
 	I915_WRITE_CTL(ring,
 			((ring->size - PAGE_SIZE) & RING_NR_PAGES)
 			| RING_VALID);
=20
 	/* If the head is still not zero, the ring is dead */
-	if ((I915_READ_CTL(ring) & RING_VALID) =3D=3D 0 ||
-	    I915_READ_START(ring) !=3D obj->gtt_offset ||
-	    (I915_READ_HEAD(ring) & HEAD_ADDR) !=3D 0) {
+	if (wait_for((I915_READ_CTL(ring) & RING_VALID) !=3D 0 &&
+		     I915_READ_START(ring) =3D=3D obj->gtt_offset &&
+		     (I915_READ_HEAD(ring) & HEAD_ADDR) =3D=3D 0, 50)) {
 		DRM_ERROR("%s initialization failed "
 				"ctl %08x head %08x tail %08x start %08x\n",
 				ring->name,
@@ -488,7 +477,7 @@ gen6_add_request(struct intel_ring_buffer *ring,
 	mbox1_reg =3D ring->signal_mbox[0];
 	mbox2_reg =3D ring->signal_mbox[1];
=20
-	*seqno =3D i915_gem_get_seqno(ring->dev);
+	*seqno =3D i915_gem_next_request_seqno(ring);
=20
 	update_mboxes(ring, *seqno, mbox1_reg);
 	update_mboxes(ring, *seqno, mbox2_reg);
@@ -586,8 +575,7 @@ static int
 pc_render_add_request(struct intel_ring_buffer *ring,
 		      u32 *result)
 {
-	struct drm_device *dev =3D ring->dev;
-	u32 seqno =3D i915_gem_get_seqno(dev);
+	u32 seqno =3D i915_gem_next_request_seqno(ring);
 	struct pipe_control *pc =3D ring->private;
 	u32 scratch_addr =3D pc->gtt_offset + 128;
 	int ret;
@@ -638,8 +626,7 @@ static int
 render_ring_add_request(struct intel_ring_buffer *ring,
 			u32 *result)
 {
-	struct drm_device *dev =3D ring->dev;
-	u32 seqno =3D i915_gem_get_seqno(dev);
+	u32 seqno =3D i915_gem_next_request_seqno(ring);
 	int ret;
=20
 	ret =3D intel_ring_begin(ring, 4);
@@ -813,7 +800,7 @@ ring_add_request(struct intel_ring_buffer *ring,
 	if (ret)
 		return ret;
=20
-	seqno =3D i915_gem_get_seqno(ring->dev);
+	seqno =3D i915_gem_next_request_seqno(ring);
=20
 	intel_ring_emit(ring, MI_STORE_DWORD_INDEX);
 	intel_ring_emit(ring, I915_GEM_HWS_INDEX << MI_STORE_DWORD_INDEX_SHIFT);
diff --git a/drivers/gpu/drm/radeon/evergreen.c b/drivers/gpu/drm/radeon/ev=
ergreen.c
index 931f4df..fc0633c 100644
--- a/drivers/gpu/drm/radeon/evergreen.c
+++ b/drivers/gpu/drm/radeon/evergreen.c
@@ -1065,24 +1065,8 @@ void evergreen_agp_enable(struct radeon_device *rdev=
)
=20
 void evergreen_mc_stop(struct radeon_device *rdev, struct evergreen_mc_sav=
e *save)
 {
-	save->vga_control[0] =3D RREG32(D1VGA_CONTROL);
-	save->vga_control[1] =3D RREG32(D2VGA_CONTROL);
 	save->vga_render_control =3D RREG32(VGA_RENDER_CONTROL);
 	save->vga_hdp_control =3D RREG32(VGA_HDP_CONTROL);
-	save->crtc_control[0] =3D RREG32(EVERGREEN_CRTC_CONTROL + EVERGREEN_CRTC0=
_REGISTER_OFFSET);
-	save->crtc_control[1] =3D RREG32(EVERGREEN_CRTC_CONTROL + EVERGREEN_CRTC1=
_REGISTER_OFFSET);
-	if (rdev->num_crtc >=3D 4) {
-		save->vga_control[2] =3D RREG32(EVERGREEN_D3VGA_CONTROL);
-		save->vga_control[3] =3D RREG32(EVERGREEN_D4VGA_CONTROL);
-		save->crtc_control[2] =3D RREG32(EVERGREEN_CRTC_CONTROL + EVERGREEN_CRTC=
2_REGISTER_OFFSET);
-		save->crtc_control[3] =3D RREG32(EVERGREEN_CRTC_CONTROL + EVERGREEN_CRTC=
3_REGISTER_OFFSET);
-	}
-	if (rdev->num_crtc >=3D 6) {
-		save->vga_control[4] =3D RREG32(EVERGREEN_D5VGA_CONTROL);
-		save->vga_control[5] =3D RREG32(EVERGREEN_D6VGA_CONTROL);
-		save->crtc_control[4] =3D RREG32(EVERGREEN_CRTC_CONTROL + EVERGREEN_CRTC=
4_REGISTER_OFFSET);
-		save->crtc_control[5] =3D RREG32(EVERGREEN_CRTC_CONTROL + EVERGREEN_CRTC=
5_REGISTER_OFFSET);
-	}
=20
 	/* Stop all video */
 	WREG32(VGA_RENDER_CONTROL, 0);
@@ -1193,47 +1177,6 @@ void evergreen_mc_resume(struct radeon_device *rdev,=
 struct evergreen_mc_save *s
 	/* Unlock host access */
 	WREG32(VGA_HDP_CONTROL, save->vga_hdp_control);
 	mdelay(1);
-	/* Restore video state */
-	WREG32(D1VGA_CONTROL, save->vga_control[0]);
-	WREG32(D2VGA_CONTROL, save->vga_control[1]);
-	if (rdev->num_crtc >=3D 4) {
-		WREG32(EVERGREEN_D3VGA_CONTROL, save->vga_control[2]);
-		WREG32(EVERGREEN_D4VGA_CONTROL, save->vga_control[3]);
-	}
-	if (rdev->num_crtc >=3D 6) {
-		WREG32(EVERGREEN_D5VGA_CONTROL, save->vga_control[4]);
-		WREG32(EVERGREEN_D6VGA_CONTROL, save->vga_control[5]);
-	}
-	WREG32(EVERGREEN_CRTC_UPDATE_LOCK + EVERGREEN_CRTC0_REGISTER_OFFSET, 1);
-	WREG32(EVERGREEN_CRTC_UPDATE_LOCK + EVERGREEN_CRTC1_REGISTER_OFFSET, 1);
-	if (rdev->num_crtc >=3D 4) {
-		WREG32(EVERGREEN_CRTC_UPDATE_LOCK + EVERGREEN_CRTC2_REGISTER_OFFSET, 1);
-		WREG32(EVERGREEN_CRTC_UPDATE_LOCK + EVERGREEN_CRTC3_REGISTER_OFFSET, 1);
-	}
-	if (rdev->num_crtc >=3D 6) {
-		WREG32(EVERGREEN_CRTC_UPDATE_LOCK + EVERGREEN_CRTC4_REGISTER_OFFSET, 1);
-		WREG32(EVERGREEN_CRTC_UPDATE_LOCK + EVERGREEN_CRTC5_REGISTER_OFFSET, 1);
-	}
-	WREG32(EVERGREEN_CRTC_CONTROL + EVERGREEN_CRTC0_REGISTER_OFFSET, save->cr=
tc_control[0]);
-	WREG32(EVERGREEN_CRTC_CONTROL + EVERGREEN_CRTC1_REGISTER_OFFSET, save->cr=
tc_control[1]);
-	if (rdev->num_crtc >=3D 4) {
-		WREG32(EVERGREEN_CRTC_CONTROL + EVERGREEN_CRTC2_REGISTER_OFFSET, save->c=
rtc_control[2]);
-		WREG32(EVERGREEN_CRTC_CONTROL + EVERGREEN_CRTC3_REGISTER_OFFSET, save->c=
rtc_control[3]);
-	}
-	if (rdev->num_crtc >=3D 6) {
-		WREG32(EVERGREEN_CRTC_CONTROL + EVERGREEN_CRTC4_REGISTER_OFFSET, save->c=
rtc_control[4]);
-		WREG32(EVERGREEN_CRTC_CONTROL + EVERGREEN_CRTC5_REGISTER_OFFSET, save->c=
rtc_control[5]);
-	}
-	WREG32(EVERGREEN_CRTC_UPDATE_LOCK + EVERGREEN_CRTC0_REGISTER_OFFSET, 0);
-	WREG32(EVERGREEN_CRTC_UPDATE_LOCK + EVERGREEN_CRTC1_REGISTER_OFFSET, 0);
-	if (rdev->num_crtc >=3D 4) {
-		WREG32(EVERGREEN_CRTC_UPDATE_LOCK + EVERGREEN_CRTC2_REGISTER_OFFSET, 0);
-		WREG32(EVERGREEN_CRTC_UPDATE_LOCK + EVERGREEN_CRTC3_REGISTER_OFFSET, 0);
-	}
-	if (rdev->num_crtc >=3D 6) {
-		WREG32(EVERGREEN_CRTC_UPDATE_LOCK + EVERGREEN_CRTC4_REGISTER_OFFSET, 0);
-		WREG32(EVERGREEN_CRTC_UPDATE_LOCK + EVERGREEN_CRTC5_REGISTER_OFFSET, 0);
-	}
 	WREG32(VGA_RENDER_CONTROL, save->vga_render_control);
 }
=20
@@ -2080,10 +2023,18 @@ static void evergreen_gpu_init(struct radeon_device=
 *rdev)
 	if (rdev->flags & RADEON_IS_IGP)
 		rdev->config.evergreen.tile_config |=3D 1 << 4;
 	else {
-		if ((mc_arb_ramcfg & NOOFBANK_MASK) >> NOOFBANK_SHIFT)
-			rdev->config.evergreen.tile_config |=3D 1 << 4;
-		else
+		switch ((mc_arb_ramcfg & NOOFBANK_MASK) >> NOOFBANK_SHIFT) {
+		case 0: /* four banks */
 			rdev->config.evergreen.tile_config |=3D 0 << 4;
+			break;
+		case 1: /* eight banks */
+			rdev->config.evergreen.tile_config |=3D 1 << 4;
+			break;
+		case 2: /* sixteen banks */
+		default:
+			rdev->config.evergreen.tile_config |=3D 2 << 4;
+			break;
+		}
 	}
 	rdev->config.evergreen.tile_config |=3D
 		((mc_arb_ramcfg & BURSTLENGTH_MASK) >> BURSTLENGTH_SHIFT) << 8;
diff --git a/drivers/gpu/drm/radeon/ni.c b/drivers/gpu/drm/radeon/ni.c
index 9e50814..636255b 100644
--- a/drivers/gpu/drm/radeon/ni.c
+++ b/drivers/gpu/drm/radeon/ni.c
@@ -804,10 +804,18 @@ static void cayman_gpu_init(struct radeon_device *rde=
v)
 		rdev->config.cayman.tile_config |=3D (3 << 0);
 		break;
 	}
-	if ((mc_arb_ramcfg & NOOFBANK_MASK) >> NOOFBANK_SHIFT)
-		rdev->config.cayman.tile_config |=3D 1 << 4;
-	else
+	switch ((mc_arb_ramcfg & NOOFBANK_MASK) >> NOOFBANK_SHIFT) {
+	case 0: /* four banks */
 		rdev->config.cayman.tile_config |=3D 0 << 4;
+		break;
+	case 1: /* eight banks */
+		rdev->config.cayman.tile_config |=3D 1 << 4;
+		break;
+	case 2: /* sixteen banks */
+	default:
+		rdev->config.cayman.tile_config |=3D 2 << 4;
+		break;
+	}
 	rdev->config.cayman.tile_config |=3D
 		((gb_addr_config & PIPE_INTERLEAVE_SIZE_MASK) >> PIPE_INTERLEAVE_SIZE_SH=
IFT) << 8;
 	rdev->config.cayman.tile_config |=3D
diff --git a/drivers/gpu/drm/radeon/radeon_asic.h b/drivers/gpu/drm/radeon/=
radeon_asic.h
index 5991484..5ce9402 100644
--- a/drivers/gpu/drm/radeon/radeon_asic.h
+++ b/drivers/gpu/drm/radeon/radeon_asic.h
@@ -253,13 +253,10 @@ void rs690_line_buffer_adjust(struct radeon_device *r=
dev,
  * rv515
  */
 struct rv515_mc_save {
-	u32 d1vga_control;
-	u32 d2vga_control;
 	u32 vga_render_control;
 	u32 vga_hdp_control;
-	u32 d1crtc_control;
-	u32 d2crtc_control;
 };
+
 int rv515_init(struct radeon_device *rdev);
 void rv515_fini(struct radeon_device *rdev);
 uint32_t rv515_mc_rreg(struct radeon_device *rdev, uint32_t reg);
@@ -387,11 +384,10 @@ void r700_cp_fini(struct radeon_device *rdev);
  * evergreen
  */
 struct evergreen_mc_save {
-	u32 vga_control[6];
 	u32 vga_render_control;
 	u32 vga_hdp_control;
-	u32 crtc_control[6];
 };
+
 void evergreen_pcie_gart_tlb_flush(struct radeon_device *rdev);
 int evergreen_init(struct radeon_device *rdev);
 void evergreen_fini(struct radeon_device *rdev);
diff --git a/drivers/gpu/drm/radeon/rv515.c b/drivers/gpu/drm/radeon/rv515.=
c
index 6613ee9..d5f45b4 100644
--- a/drivers/gpu/drm/radeon/rv515.c
+++ b/drivers/gpu/drm/radeon/rv515.c
@@ -281,12 +281,8 @@ int rv515_debugfs_ga_info_init(struct radeon_device *r=
dev)
=20
 void rv515_mc_stop(struct radeon_device *rdev, struct rv515_mc_save *save)
 {
-	save->d1vga_control =3D RREG32(R_000330_D1VGA_CONTROL);
-	save->d2vga_control =3D RREG32(R_000338_D2VGA_CONTROL);
 	save->vga_render_control =3D RREG32(R_000300_VGA_RENDER_CONTROL);
 	save->vga_hdp_control =3D RREG32(R_000328_VGA_HDP_CONTROL);
-	save->d1crtc_control =3D RREG32(R_006080_D1CRTC_CONTROL);
-	save->d2crtc_control =3D RREG32(R_006880_D2CRTC_CONTROL);
=20
 	/* Stop all video */
 	WREG32(R_0068E8_D2CRTC_UPDATE_LOCK, 0);
@@ -311,15 +307,6 @@ void rv515_mc_resume(struct radeon_device *rdev, struc=
t rv515_mc_save *save)
 	/* Unlock host access */
 	WREG32(R_000328_VGA_HDP_CONTROL, save->vga_hdp_control);
 	mdelay(1);
-	/* Restore video state */
-	WREG32(R_000330_D1VGA_CONTROL, save->d1vga_control);
-	WREG32(R_000338_D2VGA_CONTROL, save->d2vga_control);
-	WREG32(R_0060E8_D1CRTC_UPDATE_LOCK, 1);
-	WREG32(R_0068E8_D2CRTC_UPDATE_LOCK, 1);
-	WREG32(R_006080_D1CRTC_CONTROL, save->d1crtc_control);
-	WREG32(R_006880_D2CRTC_CONTROL, save->d2crtc_control);
-	WREG32(R_0060E8_D1CRTC_UPDATE_LOCK, 0);
-	WREG32(R_0068E8_D2CRTC_UPDATE_LOCK, 0);
 	WREG32(R_000300_VGA_RENDER_CONTROL, save->vga_render_control);
 }
=20
diff --git a/drivers/input/touchscreen/eeti_ts.c b/drivers/input/touchscree=
n/eeti_ts.c
index 7f8f538..4f938bb 100644
--- a/drivers/input/touchscreen/eeti_ts.c
+++ b/drivers/input/touchscreen/eeti_ts.c
@@ -48,7 +48,7 @@ struct eeti_ts_priv {
 	struct input_dev *input;
 	struct work_struct work;
 	struct mutex mutex;
-	int irq, irq_active_high;
+	int irq_gpio, irq, irq_active_high;
 };
=20
 #define EETI_TS_BITDEPTH	(11)
@@ -62,7 +62,7 @@ struct eeti_ts_priv {
=20
 static inline int eeti_ts_irq_active(struct eeti_ts_priv *priv)
 {
-	return gpio_get_value(irq_to_gpio(priv->irq)) =3D=3D priv->irq_active_hig=
h;
+	return gpio_get_value(priv->irq_gpio) =3D=3D priv->irq_active_high;
 }
=20
 static void eeti_ts_read(struct work_struct *work)
@@ -157,7 +157,7 @@ static void eeti_ts_close(struct input_dev *dev)
 static int __devinit eeti_ts_probe(struct i2c_client *client,
 				   const struct i2c_device_id *idp)
 {
-	struct eeti_ts_platform_data *pdata;
+	struct eeti_ts_platform_data *pdata =3D client->dev.platform_data;
 	struct eeti_ts_priv *priv;
 	struct input_dev *input;
 	unsigned int irq_flags;
@@ -199,9 +199,12 @@ static int __devinit eeti_ts_probe(struct i2c_client *=
client,
=20
 	priv->client =3D client;
 	priv->input =3D input;
-	priv->irq =3D client->irq;
+	priv->irq_gpio =3D pdata->irq_gpio;
+	priv->irq =3D gpio_to_irq(pdata->irq_gpio);
=20
-	pdata =3D client->dev.platform_data;
+	err =3D gpio_request_one(pdata->irq_gpio, GPIOF_IN, client->name);
+	if (err < 0)
+		goto err1;
=20
 	if (pdata)
 		priv->irq_active_high =3D pdata->irq_active_high;
@@ -215,13 +218,13 @@ static int __devinit eeti_ts_probe(struct i2c_client =
*client,
=20
 	err =3D input_register_device(input);
 	if (err)
-		goto err1;
+		goto err2;
=20
 	err =3D request_irq(priv->irq, eeti_ts_isr, irq_flags,
 			  client->name, priv);
 	if (err) {
 		dev_err(&client->dev, "Unable to request touchscreen IRQ.\n");
-		goto err2;
+		goto err3;
 	}
=20
 	/*
@@ -233,9 +236,11 @@ static int __devinit eeti_ts_probe(struct i2c_client *=
client,
 	device_init_wakeup(&client->dev, 0);
 	return 0;
=20
-err2:
+err3:
 	input_unregister_device(input);
 	input =3D NULL; /* so we dont try to free it below */
+err2:
+	gpio_free(pdata->irq_gpio);
 err1:
 	input_free_device(input);
 	kfree(priv);
diff --git a/drivers/mfd/ezx-pcap.c b/drivers/mfd/ezx-pcap.c
index 43a76c4..db662e2 100644
--- a/drivers/mfd/ezx-pcap.c
+++ b/drivers/mfd/ezx-pcap.c
@@ -202,7 +202,7 @@ static void pcap_isr_work(struct work_struct *work)
 		}
 		local_irq_enable();
 		ezx_pcap_write(pcap, PCAP_REG_MSR, pcap->msr);
-	} while (gpio_get_value(irq_to_gpio(pcap->spi->irq)));
+	} while (gpio_get_value(pdata->gpio));
 }
=20
 static void pcap_irq_handler(unsigned int irq, struct irq_desc *desc)
diff --git a/drivers/net/caif/caif_serial.c b/drivers/net/caif/caif_serial.=
c
index 23406e6..ae286a9 100644
--- a/drivers/net/caif/caif_serial.c
+++ b/drivers/net/caif/caif_serial.c
@@ -325,6 +325,9 @@ static int ldisc_open(struct tty_struct *tty)
=20
 	sprintf(name, "cf%s", tty->name);
 	dev =3D alloc_netdev(sizeof(*ser), name, caifdev_setup);
+	if (!dev)
+		return -ENOMEM;
+
 	ser =3D netdev_priv(dev);
 	ser->tty =3D tty_kref_get(tty);
 	ser->dev =3D dev;
diff --git a/drivers/net/ethernet/broadcom/bnx2.c b/drivers/net/ethernet/br=
oadcom/bnx2.c
index 965c723..721adfd 100644
--- a/drivers/net/ethernet/broadcom/bnx2.c
+++ b/drivers/net/ethernet/broadcom/bnx2.c
@@ -5378,7 +5378,7 @@ bnx2_free_tx_skbs(struct bnx2 *bp)
 			int k, last;
=20
 			if (skb =3D=3D NULL) {
-				j++;
+				j =3D NEXT_TX_BD(j);
 				continue;
 			}
=20
@@ -5390,8 +5390,8 @@ bnx2_free_tx_skbs(struct bnx2 *bp)
 			tx_buf->skb =3D NULL;
=20
 			last =3D tx_buf->nr_frags;
-			j++;
-			for (k =3D 0; k < last; k++, j++) {
+			j =3D NEXT_TX_BD(j);
+			for (k =3D 0; k < last; k++, j =3D NEXT_TX_BD(j)) {
 				tx_buf =3D &txr->tx_buf_ring[TX_RING_IDX(j)];
 				dma_unmap_page(&bp->pdev->dev,
 					dma_unmap_addr(tx_buf, mapping),
diff --git a/drivers/net/ethernet/intel/e1000/e1000_main.c b/drivers/net/et=
hernet/intel/e1000/e1000_main.c
index de00805..0549261 100644
--- a/drivers/net/ethernet/intel/e1000/e1000_main.c
+++ b/drivers/net/ethernet/intel/e1000/e1000_main.c
@@ -4743,12 +4743,14 @@ static int __e1000_shutdown(struct pci_dev *pdev, b=
ool *enable_wake)
 		e1000_setup_rctl(adapter);
 		e1000_set_rx_mode(netdev);
=20
+		rctl =3D er32(RCTL);
+
 		/* turn on all-multi mode if wake on multicast is enabled */
-		if (wufc & E1000_WUFC_MC) {
-			rctl =3D er32(RCTL);
+		if (wufc & E1000_WUFC_MC)
 			rctl |=3D E1000_RCTL_MPE;
-			ew32(RCTL, rctl);
-		}
+
+		/* enable receives in the hardware */
+		ew32(RCTL, rctl | E1000_RCTL_EN);
=20
 		if (hw->mac_type >=3D e1000_82540) {
 			ctrl =3D er32(CTRL);
diff --git a/drivers/net/ethernet/intel/e1000e/82571.c b/drivers/net/ethern=
et/intel/e1000e/82571.c
index 3072d35..4f4d52a 100644
--- a/drivers/net/ethernet/intel/e1000e/82571.c
+++ b/drivers/net/ethernet/intel/e1000e/82571.c
@@ -1600,10 +1600,8 @@ static s32 e1000_check_for_serdes_link_82571(struct =
e1000_hw *hw)
 			 * auto-negotiation in the TXCW register and disable
 			 * forced link in the Device Control register in an
 			 * attempt to auto-negotiate with our link partner.
-			 * If the partner code word is null, stop forcing
-			 * and restart auto negotiation.
 			 */
-			if ((rxcw & E1000_RXCW_C) || !(rxcw & E1000_RXCW_CW))  {
+			if (rxcw & E1000_RXCW_C) {
 				/* Enable autoneg, and unforce link up */
 				ew32(TXCW, mac->txcw);
 				ew32(CTRL, (ctrl & ~E1000_CTRL_SLU));
diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 7bea9c6..a12c9bf 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -1243,10 +1243,12 @@ static long __tun_chr_ioctl(struct file *file, unsi=
gned int cmd,
 	int vnet_hdr_sz;
 	int ret;
=20
-	if (cmd =3D=3D TUNSETIFF || _IOC_TYPE(cmd) =3D=3D 0x89)
+	if (cmd =3D=3D TUNSETIFF || _IOC_TYPE(cmd) =3D=3D 0x89) {
 		if (copy_from_user(&ifr, argp, ifreq_len))
 			return -EFAULT;
-
+	} else {
+		memset(&ifr, 0, sizeof(ifr));
+	}
 	if (cmd =3D=3D TUNGETFEATURES) {
 		/* Currently this just means: "what IFF flags are valid?".
 		 * This is needed because we never checked for invalid flags on
diff --git a/drivers/net/usb/kaweth.c b/drivers/net/usb/kaweth.c
index 582ca2d..c4c6a73 100644
--- a/drivers/net/usb/kaweth.c
+++ b/drivers/net/usb/kaweth.c
@@ -1308,7 +1308,7 @@ static int kaweth_internal_control_msg(struct usb_dev=
ice *usb_dev,
         int retv;
         int length =3D 0; /* shut up GCC */
=20
-        urb =3D usb_alloc_urb(0, GFP_NOIO);
+	urb =3D usb_alloc_urb(0, GFP_ATOMIC);
         if (!urb)
                 return -ENOMEM;
=20
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath=
/ath9k/hw.c
index 7f97164..2b8e957 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -674,6 +674,7 @@ int ath9k_hw_init(struct ath_hw *ah)
 	case AR9300_DEVID_AR9340:
 	case AR9300_DEVID_AR9580:
 	case AR9300_DEVID_AR9462:
+	case AR9485_DEVID_AR1111:
 		break;
 	default:
 		if (common->bus_ops->ath_bus_type =3D=3D ATH_USB)
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath=
/ath9k/hw.h
index 1bd8edf..a5c4ba8 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -48,6 +48,7 @@
 #define AR9300_DEVID_AR9580	0x0033
 #define AR9300_DEVID_AR9462	0x0034
 #define AR9300_DEVID_AR9330	0x0035
+#define AR9485_DEVID_AR1111	0x0037
=20
 #define AR5416_AR9100_DEVID	0x000b
=20
diff --git a/drivers/net/wireless/ath/ath9k/pci.c b/drivers/net/wireless/at=
h/ath9k/pci.c
index 2dcdf63..1883d39 100644
--- a/drivers/net/wireless/ath/ath9k/pci.c
+++ b/drivers/net/wireless/ath/ath9k/pci.c
@@ -35,6 +35,7 @@ static DEFINE_PCI_DEVICE_TABLE(ath_pci_id_table) =3D {
 	{ PCI_VDEVICE(ATHEROS, 0x0032) }, /* PCI-E  AR9485 */
 	{ PCI_VDEVICE(ATHEROS, 0x0033) }, /* PCI-E  AR9580 */
 	{ PCI_VDEVICE(ATHEROS, 0x0034) }, /* PCI-E  AR9462 */
+	{ PCI_VDEVICE(ATHEROS, 0x0037) }, /* PCI-E  AR1111/AR9485 */
 	{ 0 }
 };
=20
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c b/drivers/net/wirele=
ss/iwlwifi/iwl-agn-rs.c
index 9ba2c1b..3395025 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
@@ -708,11 +708,14 @@ static int rs_toggle_antenna(u32 valid_ant, u32 *rate=
_n_flags,
  */
 static bool rs_use_green(struct ieee80211_sta *sta)
 {
-	struct iwl_station_priv *sta_priv =3D (void *)sta->drv_priv;
-	struct iwl_rxon_context *ctx =3D sta_priv->ctx;
-
-	return (sta->ht_cap.cap & IEEE80211_HT_CAP_GRN_FLD) &&
-		!(ctx->ht.non_gf_sta_present);
+	/*
+	 * There's a bug somewhere in this code that causes the
+	 * scaling to get stuck because GF+SGI can't be combined
+	 * in SISO rates. Until we find that bug, disable GF, it
+	 * has only limited benefit and we still interoperate with
+	 * GF APs since we can always receive GF transmissions.
+	 */
+	return false;
 }
=20
 /**
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/r=
t2x00/rt61pci.c
index bf55b4a..d69f88c 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -2243,8 +2243,7 @@ static void rt61pci_txdone(struct rt2x00_dev *rt2x00d=
ev)
=20
 static void rt61pci_wakeup(struct rt2x00_dev *rt2x00dev)
 {
-	struct ieee80211_conf conf =3D { .flags =3D 0 };
-	struct rt2x00lib_conf libconf =3D { .conf =3D &conf };
+	struct rt2x00lib_conf libconf =3D { .conf =3D &rt2x00dev->hw->conf };
=20
 	rt61pci_config(rt2x00dev, &libconf, IEEE80211_CONF_CHANGE_PS);
 }
diff --git a/drivers/net/wireless/rtlwifi/usb.c b/drivers/net/wireless/rtlw=
ifi/usb.c
index db34db6..a49e848 100644
--- a/drivers/net/wireless/rtlwifi/usb.c
+++ b/drivers/net/wireless/rtlwifi/usb.c
@@ -120,15 +120,19 @@ static u32 _usb_read_sync(struct rtl_priv *rtlpriv, u=
32 addr, u16 len)
 	u8 request;
 	u16 wvalue;
 	u16 index;
-	__le32 *data =3D &rtlpriv->usb_data[rtlpriv->usb_data_index];
+	__le32 *data;
+	unsigned long flags;
=20
+	spin_lock_irqsave(&rtlpriv->locks.usb_lock, flags);
+	if (++rtlpriv->usb_data_index >=3D RTL_USB_MAX_RX_COUNT)
+		rtlpriv->usb_data_index =3D 0;
+	data =3D &rtlpriv->usb_data[rtlpriv->usb_data_index];
+	spin_unlock_irqrestore(&rtlpriv->locks.usb_lock, flags);
 	request =3D REALTEK_USB_VENQT_CMD_REQ;
 	index =3D REALTEK_USB_VENQT_CMD_IDX; /* n/a */
=20
 	wvalue =3D (u16)addr;
 	_usbctrl_vendorreq_sync_read(udev, request, wvalue, index, data, len);
-	if (++rtlpriv->usb_data_index >=3D RTL_USB_MAX_RX_COUNT)
-		rtlpriv->usb_data_index =3D 0;
 	return le32_to_cpu(*data);
 }
=20
@@ -909,6 +913,10 @@ int __devinit rtl_usb_probe(struct usb_interface *intf=
,
 				    GFP_KERNEL);
 	if (!rtlpriv->usb_data)
 		return -ENOMEM;
+
+	/* this spin lock must be initialized early */
+	spin_lock_init(&rtlpriv->locks.usb_lock);
+
 	rtlpriv->usb_data_index =3D 0;
 	SET_IEEE80211_DEV(hw, &intf->dev);
 	udev =3D interface_to_usbdev(intf);
diff --git a/drivers/net/wireless/rtlwifi/wifi.h b/drivers/net/wireless/rtl=
wifi/wifi.h
index b1e9deb..deb87e9 100644
--- a/drivers/net/wireless/rtlwifi/wifi.h
+++ b/drivers/net/wireless/rtlwifi/wifi.h
@@ -1550,6 +1550,7 @@ struct rtl_locks {
 	spinlock_t rf_lock;
 	spinlock_t lps_lock;
 	spinlock_t waitq_lock;
+	spinlock_t usb_lock;
=20
 	/*Dual mac*/
 	spinlock_t cck_and_rw_pagea_lock;
diff --git a/fs/hfsplus/wrapper.c b/fs/hfsplus/wrapper.c
index 7daf4b8..90effcc 100644
--- a/fs/hfsplus/wrapper.c
+++ b/fs/hfsplus/wrapper.c
@@ -56,7 +56,7 @@ int hfsplus_submit_bio(struct super_block *sb, sector_t s=
ector,
 	DECLARE_COMPLETION_ONSTACK(wait);
 	struct bio *bio;
 	int ret =3D 0;
-	unsigned int io_size;
+	u64 io_size;
 	loff_t start;
 	int offset;
=20
diff --git a/include/linux/input/eeti_ts.h b/include/linux/input/eeti_ts.h
index f875b31..16625d7 100644
--- a/include/linux/input/eeti_ts.h
+++ b/include/linux/input/eeti_ts.h
@@ -2,6 +2,7 @@
 #define LINUX_INPUT_EETI_TS_H
=20
 struct eeti_ts_platform_data {
+	int irq_gpio;
 	unsigned int irq_active_high;
 };
=20
diff --git a/include/linux/mfd/ezx-pcap.h b/include/linux/mfd/ezx-pcap.h
index 40c37216..32a1b5c 100644
--- a/include/linux/mfd/ezx-pcap.h
+++ b/include/linux/mfd/ezx-pcap.h
@@ -16,6 +16,7 @@ struct pcap_subdev {
 struct pcap_platform_data {
 	unsigned int irq_base;
 	unsigned int config;
+	int gpio;
 	void (*init) (void *);	/* board specific init */
 	int num_subdevs;
 	struct pcap_subdev *subdevs;
diff --git a/net/caif/caif_dev.c b/net/caif/caif_dev.c
index 68223e4..4e9115d 100644
--- a/net/caif/caif_dev.c
+++ b/net/caif/caif_dev.c
@@ -428,9 +428,9 @@ static int __init caif_device_init(void)
=20
 static void __exit caif_device_exit(void)
 {
-	unregister_pernet_subsys(&caif_net_ops);
 	unregister_netdevice_notifier(&caif_device_notifier);
 	dev_remove_pack(&caif_packet_type);
+	unregister_pernet_subsys(&caif_net_ops);
 }
=20
 module_init(caif_device_init);
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 05842ab..0cf604b 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -670,6 +670,12 @@ static void set_operstate(struct net_device *dev, unsi=
gned char transition)
 	}
 }
=20
+static unsigned int rtnl_dev_get_flags(const struct net_device *dev)
+{
+	return (dev->flags & ~(IFF_PROMISC | IFF_ALLMULTI)) |
+	       (dev->gflags & (IFF_PROMISC | IFF_ALLMULTI));
+}
+
 static unsigned int rtnl_dev_combine_flags(const struct net_device *dev,
 					   const struct ifinfomsg *ifm)
 {
@@ -678,7 +684,7 @@ static unsigned int rtnl_dev_combine_flags(const struct=
 net_device *dev,
 	/* bugwards compatibility: ifi_change =3D=3D 0 is treated as ~0 */
 	if (ifm->ifi_change)
 		flags =3D (flags & ifm->ifi_change) |
-			(dev->flags & ~ifm->ifi_change);
+			(rtnl_dev_get_flags(dev) & ~ifm->ifi_change);
=20
 	return flags;
 }
diff --git a/net/ipv4/cipso_ipv4.c b/net/ipv4/cipso_ipv4.c
index 86f3b88..afaa735 100644
--- a/net/ipv4/cipso_ipv4.c
+++ b/net/ipv4/cipso_ipv4.c
@@ -1725,8 +1725,10 @@ int cipso_v4_validate(const struct sk_buff *skb, uns=
igned char **option)
 		case CIPSO_V4_TAG_LOCAL:
 			/* This is a non-standard tag that we only allow for
 			 * local connections, so if the incoming interface is
-			 * not the loopback device drop the packet. */
-			if (!(skb->dev->flags & IFF_LOOPBACK)) {
+			 * not the loopback device drop the packet. Further,
+			 * there is no legitimate reason for setting this from
+			 * userspace so reject it if skb is NULL. */
+			if (skb =3D=3D NULL || !(skb->dev->flags & IFF_LOOPBACK)) {
 				err_offset =3D opt_iter;
 				goto validate_return_locked;
 			}
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 11ba922..ad466a7 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -2391,7 +2391,10 @@ static int do_tcp_setsockopt(struct sock *sk, int le=
vel,
 		/* Cap the max timeout in ms TCP will retry/retrans
 		 * before giving up and aborting (ETIMEDOUT) a connection.
 		 */
-		icsk->icsk_user_timeout =3D msecs_to_jiffies(val);
+		if (val < 0)
+			err =3D -EINVAL;
+		else
+			icsk->icsk_user_timeout =3D msecs_to_jiffies(val);
 		break;
 	default:
 		err =3D -ENOPROTOOPT;
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 32e6ca2..a08a621 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -5415,7 +5415,9 @@ int tcp_rcv_established(struct sock *sk, struct sk_bu=
ff *skb,
 			if (tp->copied_seq =3D=3D tp->rcv_nxt &&
 			    len - tcp_header_len <=3D tp->ucopy.len) {
 #ifdef CONFIG_NET_DMA
-				if (tcp_dma_try_early_copy(sk, skb, tcp_header_len)) {
+				if (tp->ucopy.task =3D=3D current &&
+				    sock_owned_by_user(sk) &&
+				    tcp_dma_try_early_copy(sk, skb, tcp_header_len)) {
 					copied_early =3D 1;
 					eaten =3D 1;
 				}
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index a7078fd..f85de8e 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -543,6 +543,7 @@ void ieee80211_stop_mesh(struct ieee80211_sub_if_data *=
sdata)
=20
 	del_timer_sync(&sdata->u.mesh.housekeeping_timer);
 	del_timer_sync(&sdata->u.mesh.mesh_path_root_timer);
+	del_timer_sync(&sdata->u.mesh.mesh_path_timer);
 	/*
 	 * If the timer fired while we waited for it, it will have
 	 * requeued the work. Now the work will be running again
diff --git a/net/sched/sch_sfb.c b/net/sched/sch_sfb.c
index 17859ea..351a69b 100644
--- a/net/sched/sch_sfb.c
+++ b/net/sched/sch_sfb.c
@@ -559,6 +559,8 @@ static int sfb_dump(struct Qdisc *sch, struct sk_buff *=
skb)
=20
 	sch->qstats.backlog =3D q->qdisc->qstats.backlog;
 	opts =3D nla_nest_start(skb, TCA_OPTIONS);
+	if (opts =3D=3D NULL)
+		goto nla_put_failure;
 	NLA_PUT(skb, TCA_SFB_PARMS, sizeof(opt), &opt);
 	return nla_nest_end(skb, opts);
=20
diff --git a/net/sctp/input.c b/net/sctp/input.c
index b7692aa..0fc18c7 100644
--- a/net/sctp/input.c
+++ b/net/sctp/input.c
@@ -736,15 +736,12 @@ static void __sctp_unhash_endpoint(struct sctp_endpoi=
nt *ep)
=20
 	epb =3D &ep->base;
=20
-	if (hlist_unhashed(&epb->node))
-		return;
-
 	epb->hashent =3D sctp_ep_hashfn(epb->bind_addr.port);
=20
 	head =3D &sctp_ep_hashtable[epb->hashent];
=20
 	sctp_write_lock(&head->lock);
-	__hlist_del(&epb->node);
+	hlist_del_init(&epb->node);
 	sctp_write_unlock(&head->lock);
 }
=20
@@ -825,7 +822,7 @@ static void __sctp_unhash_established(struct sctp_assoc=
iation *asoc)
 	head =3D &sctp_assoc_hashtable[epb->hashent];
=20
 	sctp_write_lock(&head->lock);
-	__hlist_del(&epb->node);
+	hlist_del_init(&epb->node);
 	sctp_write_unlock(&head->lock);
 }
=20
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 0075554..8e49d76 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -1231,8 +1231,14 @@ out_free:
 	SCTP_DEBUG_PRINTK("About to exit __sctp_connect() free asoc: %p"
 			  " kaddrs: %p err: %d\n",
 			  asoc, kaddrs, err);
-	if (asoc)
+	if (asoc) {
+		/* sctp_primitive_ASSOCIATE may have added this association
+		 * To the hash table, try to unhash it, just in case, its a noop
+		 * if it wasn't hashed so we're safe
+		 */
+		sctp_unhash_established(asoc);
 		sctp_association_free(asoc);
+	}
 	return err;
 }
=20
@@ -1942,8 +1948,10 @@ SCTP_STATIC int sctp_sendmsg(struct kiocb *iocb, str=
uct sock *sk,
 	goto out_unlock;
=20
 out_free:
-	if (new_asoc)
+	if (new_asoc) {
+		sctp_unhash_established(asoc);
 		sctp_association_free(asoc);
+	}
 out_unlock:
 	sctp_release_sock(sk);
=20
diff --git a/net/wanrouter/wanmain.c b/net/wanrouter/wanmain.c
index 788a12c..2ab7850 100644
--- a/net/wanrouter/wanmain.c
+++ b/net/wanrouter/wanmain.c
@@ -602,36 +602,31 @@ static int wanrouter_device_new_if(struct wan_device =
*wandev,
 		 * successfully, add it to the interface list.
 		 */
=20
-		if (dev->name =3D=3D NULL) {
-			err =3D -EINVAL;
-		} else {
+#ifdef WANDEBUG
+		printk(KERN_INFO "%s: registering interface %s...\n",
+		       wanrouter_modname, dev->name);
+#endif
=20
-			#ifdef WANDEBUG
-			printk(KERN_INFO "%s: registering interface %s...\n",
-				wanrouter_modname, dev->name);
-			#endif
-
-			err =3D register_netdev(dev);
-			if (!err) {
-				struct net_device *slave =3D NULL;
-				unsigned long smp_flags=3D0;
-
-				lock_adapter_irq(&wandev->lock, &smp_flags);
-
-				if (wandev->dev =3D=3D NULL) {
-					wandev->dev =3D dev;
-				} else {
-					for (slave=3Dwandev->dev;
-					     DEV_TO_SLAVE(slave);
-					     slave =3D DEV_TO_SLAVE(slave))
-						DEV_TO_SLAVE(slave) =3D dev;
-				}
-				++wandev->ndev;
-
-				unlock_adapter_irq(&wandev->lock, &smp_flags);
-				err =3D 0;	/* done !!! */
-				goto out;
+		err =3D register_netdev(dev);
+		if (!err) {
+			struct net_device *slave =3D NULL;
+			unsigned long smp_flags=3D0;
+
+			lock_adapter_irq(&wandev->lock, &smp_flags);
+
+			if (wandev->dev =3D=3D NULL) {
+				wandev->dev =3D dev;
+			} else {
+				for (slave=3Dwandev->dev;
+				     DEV_TO_SLAVE(slave);
+				     slave =3D DEV_TO_SLAVE(slave))
+					DEV_TO_SLAVE(slave) =3D dev;
 			}
+			++wandev->ndev;
+
+			unlock_adapter_irq(&wandev->lock, &smp_flags);
+			err =3D 0;	/* done !!! */
+			goto out;
 		}
 		if (wandev->del_if)
 			wandev->del_if(wandev, dev);
diff --git a/net/wireless/core.c b/net/wireless/core.c
index 220f3bd..8f5042d 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -971,6 +971,11 @@ static int cfg80211_netdev_notifier_call(struct notifi=
er_block * nb,
 		 */
 		synchronize_rcu();
 		INIT_LIST_HEAD(&wdev->list);
+		/*
+		 * Ensure that all events have been processed and
+		 * freed.
+		 */
+		cfg80211_process_wdev_events(wdev);
 		break;
 	case NETDEV_PRE_UP:
 		if (!(wdev->wiphy->interface_modes & BIT(wdev->iftype)))
diff --git a/net/wireless/core.h b/net/wireless/core.h
index b9ec306..02c3be3 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -426,6 +426,7 @@ int cfg80211_change_iface(struct cfg80211_registered_de=
vice *rdev,
 			  struct net_device *dev, enum nl80211_iftype ntype,
 			  u32 *flags, struct vif_params *params);
 void cfg80211_process_rdev_events(struct cfg80211_registered_device *rdev)=
;
+void cfg80211_process_wdev_events(struct wireless_dev *wdev);
=20
 int cfg80211_can_change_interface(struct cfg80211_registered_device *rdev,
 				  struct wireless_dev *wdev,
diff --git a/net/wireless/util.c b/net/wireless/util.c
index b5e4c1c..22fb802 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -725,7 +725,7 @@ void cfg80211_upload_connect_keys(struct wireless_dev *=
wdev)
 	wdev->connect_keys =3D NULL;
 }
=20
-static void cfg80211_process_wdev_events(struct wireless_dev *wdev)
+void cfg80211_process_wdev_events(struct wireless_dev *wdev)
 {
 	struct cfg80211_event *ev;
 	unsigned long flags;
diff --git a/sound/pci/hda/patch_conexant.c b/sound/pci/hda/patch_conexant.=
c
index 51a1afc..402f330 100644
--- a/sound/pci/hda/patch_conexant.c
+++ b/sound/pci/hda/patch_conexant.c
@@ -3059,7 +3059,6 @@ static const struct snd_pci_quirk cxt5066_cfg_tbl[] =
=3D {
 	SND_PCI_QUIRK(0x1028, 0x02d8, "Dell Vostro", CXT5066_DELL_VOSTRO),
 	SND_PCI_QUIRK(0x1028, 0x02f5, "Dell Vostro 320", CXT5066_IDEAPAD),
 	SND_PCI_QUIRK(0x1028, 0x0401, "Dell Vostro 1014", CXT5066_DELL_VOSTRO),
-	SND_PCI_QUIRK(0x1028, 0x0402, "Dell Vostro", CXT5066_DELL_VOSTRO),
 	SND_PCI_QUIRK(0x1028, 0x0408, "Dell Inspiron One 19T", CXT5066_IDEAPAD),
 	SND_PCI_QUIRK(0x1028, 0x050f, "Dell Inspiron", CXT5066_IDEAPAD),
 	SND_PCI_QUIRK(0x1028, 0x0510, "Dell Vostro", CXT5066_IDEAPAD),
diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 2e2eb93..32c8169 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -4981,6 +4981,8 @@ static const struct alc_fixup alc269_fixups[] =3D {
 	[ALC269_FIXUP_PCM_44K] =3D {
 		.type =3D ALC_FIXUP_FUNC,
 		.v.func =3D alc269_fixup_pcm_44k,
+		.chained =3D true,
+		.chain_id =3D ALC269_FIXUP_QUANTA_MUTE
 	},
 	[ALC269_FIXUP_STEREO_DMIC] =3D {
 		.type =3D ALC_FIXUP_FUNC,
@@ -5077,9 +5079,10 @@ static const struct snd_pci_quirk alc269_fixup_tbl[]=
 =3D {
 	SND_PCI_QUIRK(0x17aa, 0x21ca, "Thinkpad L412", ALC269_FIXUP_SKU_IGNORE),
 	SND_PCI_QUIRK(0x17aa, 0x21e9, "Thinkpad Edge 15", ALC269_FIXUP_SKU_IGNORE=
),
 	SND_PCI_QUIRK(0x17aa, 0x21f6, "Thinkpad T530", ALC269_FIXUP_LENOVO_DOCK),
+	SND_PCI_QUIRK(0x17aa, 0x21fa, "Thinkpad X230", ALC269_FIXUP_LENOVO_DOCK),
+	SND_PCI_QUIRK(0x17aa, 0x21fb, "Thinkpad T430s", ALC269_FIXUP_LENOVO_DOCK)=
,
 	SND_PCI_QUIRK(0x17aa, 0x2203, "Thinkpad X230 Tablet", ALC269_FIXUP_LENOVO=
_DOCK),
-	SND_PCI_QUIRK(0x17aa, 0x3bf8, "Quanta FL1", ALC269_FIXUP_QUANTA_MUTE),
-	SND_PCI_QUIRK(0x17aa, 0x3bf8, "Lenovo Ideapd", ALC269_FIXUP_PCM_44K),
+	SND_PCI_QUIRK(0x17aa, 0x3bf8, "Quanta FL1", ALC269_FIXUP_PCM_44K),
 	SND_PCI_QUIRK(0x17aa, 0x9e54, "LENOVO NB", ALC269_FIXUP_LENOVO_EAPD),
=20
 #if 1



--=-q0ilw9sE6MUanGhQw3MU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUDI2B+e/yOyVhhEJAQopThAAzJKKXJW8ztF+aeAX35H6tywEN2gYyZZh
y+LWOmu4aKa0FY1qbSkBE3GdzeCNCiAXnXU/VBU829d68ZuZrbJEW0TnSbEa34IK
chhGFCfypwHHc1w7h5Qh4CH+JdAwq8w34GYNEFLp0tvJaBxLLDoxV2plB7POW1rT
ZStC2xeqOPXJg3zRvQp8FYyXGRLa5Z8wM7nVrhqGP0giNXzpijoJdtjkiSW5Qbto
uaqMVbjiSmXD0qPc6bLKOUPPIR1AjFNWH+lbFrxcr9jyX/lO49nXc+2akCsPGA/7
M+FlPDrTBKvFh/Twnw+Z1kw+BF+kEMWV7NyjAml4WZmLVGdAACyv0VDaFPkHsvOA
NbK4CKg7nhyR/8ic7PlTriWindswZ0C9Yrc/ygIozJz7/yNzF6foEB3s/LvWXsEC
c19HcBXhul6JGIXDjm7+UAdGxAV4ns+ZJ8oALVRlv21KE0/W0DiVHpCIQm0f18D2
BXb3CviyymiLuxrrxI4ujApKX4EdMy+zjYZjGAWmS1x7xRB9mNtllFzKheBRwYyH
helFvdBH8r6g748h5AmzgQsJ34TzO00vJ9FGd03ie/bFMrggbLbOnw25n5eXagCs
75FUjrmC89XHoBh6uYU9pmgaBMq56A6ojXelNvIZIYW4NORX+9VYgJfkdopGYgBp
hwPlaOj22nw=
=fTem
-----END PGP SIGNATURE-----

--=-q0ilw9sE6MUanGhQw3MU--
