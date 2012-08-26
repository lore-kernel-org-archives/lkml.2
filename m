Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757133Ab2HZCwh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2012 22:52:37 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:47400 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756576Ab2HZCwe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2012 22:52:34 -0400
Date: Sat, 25 Aug 2012 19:52:30 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.5.3
Message-ID: <20120826025230.GA7498@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vtzGhvizbBRQ85DL"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--vtzGhvizbBRQ85DL
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.5.3 kernel.

All users of the 3.5 kernel series must upgrade.

The updated 3.5.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.g=
it linux-3.5.y
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git=
;a=3Dsummary

thanks,

greg k-h

------------

 Makefile                                    |    2=20
 arch/s390/kernel/compat_linux.c             |    2=20
 arch/s390/kernel/compat_wrapper.S           |    4=20
 arch/x86/kvm/emulate.c                      |    4=20
 arch/x86/kvm/i8259.c                        |   17 +
 arch/x86/kvm/vmx.c                          |   90 +++++++-
 arch/x86/kvm/x86.c                          |    4=20
 arch/x86/xen/p2m.c                          |    5=20
 drivers/base/core.c                         |    9=20
 drivers/dma/imx-dma.c                       |   36 ++-
 drivers/gpu/drm/i915/i915_sysfs.c           |   12 +
 drivers/gpu/drm/i915/intel_display.c        |   11 -
 drivers/gpu/drm/i915/intel_dp.c             |   18 -
 drivers/gpu/drm/i915/intel_ringbuffer.c     |    7=20
 drivers/gpu/drm/mgag200/mgag200_mode.c      |   12 -
 drivers/gpu/drm/nouveau/nvc0_pm.c           |    2=20
 drivers/gpu/drm/nouveau/nvd0_display.c      |    2=20
 drivers/gpu/drm/radeon/atombios_crtc.c      |   14 +
 drivers/gpu/drm/radeon/evergreen.c          |   71 +------
 drivers/gpu/drm/radeon/evergreen_cs.c       |    6=20
 drivers/gpu/drm/radeon/evergreend.h         |    2=20
 drivers/gpu/drm/radeon/ni.c                 |   14 +
 drivers/gpu/drm/radeon/r600_cs.c            |    6=20
 drivers/gpu/drm/radeon/radeon_asic.h        |    8=20
 drivers/gpu/drm/radeon/radeon_drv.c         |    3=20
 drivers/gpu/drm/radeon/radeon_legacy_crtc.c |    4=20
 drivers/gpu/drm/radeon/radeon_mode.h        |    1=20
 drivers/gpu/drm/radeon/rv515.c              |   13 -
 drivers/gpu/drm/radeon/si.c                 |   14 +
 drivers/infiniband/ulp/srp/ib_srp.c         |   87 ++++++--
 drivers/net/wireless/rt2x00/rt2800usb.c     |    1=20
 drivers/staging/comedi/drivers.c            |    2=20
 drivers/tty/serial/pmac_zilog.c             |   12 -
 drivers/usb/gadget/u_ether.c                |    6=20
 drivers/usb/host/pci-quirks.c               |    7=20
 drivers/usb/host/pci-quirks.h               |    1=20
 drivers/usb/host/xhci-pci.c                 |   10=20
 drivers/usb/host/xhci-ring.c                |   36 ++-
 drivers/usb/host/xhci.c                     |    8=20
 drivers/usb/host/xhci.h                     |    1=20
 drivers/usb/serial/ftdi_sio.c               |    1=20
 drivers/usb/serial/ftdi_sio_ids.h           |    7=20
 drivers/usb/serial/mos7840.c                |    9=20
 drivers/usb/serial/option.c                 |  281 +++++++++++------------=
-----
 fs/ext4/balloc.c                            |   62 +++---
 fs/ext4/bitmap.c                            |    1=20
 fs/ext4/extents.c                           |    1=20
 fs/ext4/super.c                             |    6=20
 fs/fuse/file.c                              |    2=20
 fs/jbd2/journal.c                           |    3=20
 include/drm/drm_pciids.h                    |    3=20
 include/linux/jbd2.h                        |    1=20
 include/linux/usb.h                         |   21 ++
 security/yama/yama_lsm.c                    |   10=20
 54 files changed, 561 insertions(+), 411 deletions(-)

Alex Deucher (4):
      drm/radeon: properly handle crtc powergating
      drm/radeon: add some new SI pci ids
      drm/radeon: fix bank tiling parameters on cayman
      drm/radeon: fix bank tiling parameters on evergreen

Avi Kivity (2):
      KVM: VMX: Fix ds/es corruption on i386 with preemption
      KVM: x86 emulator: fix byte-sized MOVZX/MOVSX

Bart Van Assche (1):
      IB/srp: Fix a race condition

Bj=C3=B8rn Mork (1):
      USB: option: add ZTE K5006-Z

Bruce Rogers (1):
      KVM: x86: apply kvmclock offset to guest wall clock time

Christian K=C3=B6nig (1):
      drm/radeon: fix bank tiling parameters on SI

Christoph Bumiller (1):
      drm/nvd0/disp: mask off high 16 bit of negative cursor x-coordinate

Daniel Vetter (3):
      drm/i915: correctly order the ring init sequence
      drm/i915: ignore eDP bpc settings from vbt
      drm/i915: reorder edp disabling to fix ivb MacBook Air

Dave Airlie (1):
      drm/mgag200: fix G200ER pll picking algorithm

Fabio Estevam (1):
      dma: imx-dma: Fix kernel crash due to missing clock conversion

Gleb Natapov (1):
      KVM: PIC: call ack notifiers for irqs that are dropped form irr

Greg Kroah-Hartman (1):
      Linux 3.5.3

Gustavo Padovan (1):
      USB: add USB_VENDOR_AND_INTERFACE_INFO() macro

Heiko Carstens (2):
      s390/compat: fix compat wrappers for process_vm system calls
      s390/compat: fix mmap compat system calls

Hunt Xu (1):
      drm/i915: make rc6 in sysfs functions conditional

Ian Abbott (1):
      staging: comedi: Fix reversed test in comedi_device_attach()

Jason Wessel (1):
      pmac_zilog,kdb: Fix console poll hook to return instead of loop

Jeongdo Son (1):
      rt2x00: Add support for BUFFALO WLI-UC-GNM2 to rt2800usb.

Jerome Glisse (1):
      drm/radeon: do not reenable crtc after moving vram start address

Jesse Barnes (1):
      drm/i915: prefer wide & slow to fast & narrow in DP configs

Jim Cromie (1):
      drivers-core: make structured logging play nice with dynamic-debug

Kees Cook (1):
      Yama: access task_struct->comm directly

Konrad Rzeszutek Wilk (1):
      xen/p2m: Reserve 8MB of _brk space for P2M leafs when populating back.

Maarten Lankhorst (1):
      nouveau: fixup scanout enable in nvc0_pm

Marek Ol=C5=A1=C3=A1k (1):
      drm/radeon/kms: allow "invalid" DB formats as a means to disable DB

Mark Ferrell (1):
      usb: serial: mos7840: Fixup mos7840_chars_in_buffer()

Michael Grzeschik (1):
      usb: gadget: u_ether: fix kworker 100% CPU issue with still used inte=
rfaces in eth_stop

Orit Wasserman (1):
      KVM: VMX: Fix KVM_SET_SREGS with big real mode segments

Ozan =C3=87a=C4=9Flayan (1):
      USB: ftdi_sio: Add VID/PID for Kondo Serial USB

Sarah Sharp (4):
      xhci: Add Etron XHCI_TRUST_TX_LENGTH quirk.
      xhci: Increase reset timeout for Renesas 720201 host.
      xhci: Switch PPT ports to EHCI on shutdown.
      xhci: Fix bug after deq ptr set to link TRB.

Theodore Ts'o (5):
      ext4: make sure the journal sb is written in ext4_clear_journal_err()
      ext4: avoid kmemcheck complaint from reading uninitialized memory
      ext4: don't call ext4_error while block group is locked
      ext4: fix long mount times on very big file systems
      ext4: fix kernel BUG on large-scale rm -rf commands

Zach Brown (1):
      fuse: verify all ioctl retry iov elements

fangxiaozhi (1):
      USB: support the new interfaces of Huawei Data Card devices in option=
 driver


--vtzGhvizbBRQ85DL
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIcBAEBAgAGBQJQOY9tAAoJEDjbvchgkmk+GAEQAJfA9EM602f574nLD3Re3wUJ
cvUr71j4EWx9xmplQ8e6D7dwp3SS+HPo1lv207eFHS4RDTludH/izeAAujq4ybJ4
D+4eBFELkUI8Qm+zd71q7BSH/OHfDJ3bDkwARUaPewRv1SxJs2Xzubgo3AcFVoV/
8dwQ5UzNcNFUm3b5Cf+cSaPCrXyi6Da31TwHWmybDEDGRaxHQHheAQYG6eUoU0VQ
rKDifFSrueyIXFHte0T8eZSlxTcOv8ZeCojaNllbtDCaZrFZHjdo9YgrByVIqJly
L058n+QuD/zauKuzdh7xLjQashT7j1+OA+amx9Mh4hgFjumqfWKCsdHo0N6Me+jK
CSbOuoEEy+VfdbMoZe9CAnzCdnt32/SinsAPN6FevE9T5tsSNTKhC4KddltxbYYU
VAPAkfoN7RWtqsThpT0y2QawHMCyBdN5ylvSoNkke7mXAThBgxXqFEvl+w+ciIlb
LNnvNW6B+cmnqTeTg6kKxuEZ0DVb5vNGRwITw63dII7tApk3I01MMIUG3nTD6+CD
vBhyUR+6b/BiUKjlkmxhirqEMWyNNmiXvog8MsKqyPc6hqrAVU9JVfptm9ECNkeF
DDy26xs/sfnbn3+HNSHnUpGodd2mGBFOMvnDUd6pXyP/YKmlcWL2pl9lqDBFyExl
xeEJfC9RFNIZpjrVVGit
=9FDp
-----END PGP SIGNATURE-----

--vtzGhvizbBRQ85DL--
