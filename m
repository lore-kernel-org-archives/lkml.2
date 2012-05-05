Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756078Ab2EETji (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 15:39:38 -0400
Received: from mail-pz0-f45.google.com ([209.85.210.45]:44499 "EHLO
	mail-pz0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755320Ab2EETjf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 15:39:35 -0400
Date: Sat, 5 May 2012 12:39:29 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Paul Kimoto <kimoto@lightlink.com>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: Re: [ 00/75] 3.3.5-stable review
Message-ID: <20120505193929.GA21715@kroah.com>
References: <20120504204258.GA12552@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wac7ysb48OaltWcw"
Content-Disposition: inline
In-Reply-To: <20120504204258.GA12552@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wac7ysb48OaltWcw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Paul Kimoto pointed out that I messed up generating the 3.3.5-rc1 patch,
so here is the 3.3.5-rc2 patch, with the proper header files added.
 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.3.5-rc2.gz
The diffstat can be found below.

thanks,

greg k-h

 Makefile                                    |    4 +-
 arch/arm/Kconfig                            |    9 +
 arch/arm/include/asm/tls.h                  |    4 +
 arch/arm/kernel/irq.c                       |    6 +-
 arch/arm/mm/abort-ev6.S                     |   17 +-
 arch/mips/ath79/dev-wmac.c                  |    2 +-
 arch/powerpc/platforms/85xx/common.c        |    6 +
 arch/powerpc/platforms/85xx/mpc85xx_mds.c   |   11 +-
 arch/powerpc/platforms/85xx/p1022_ds.c      |   13 +-
 arch/x86/boot/Makefile                      |    3 +-
 arch/x86/boot/compressed/Makefile           |    1 +
 arch/x86/boot/compressed/eboot.c            |    8 +-
 arch/x86/boot/compressed/head_32.S          |   14 +-
 arch/x86/boot/compressed/head_64.S          |   22 ++-
 arch/x86/boot/compressed/mkpiggy.c          |   11 +-
 arch/x86/boot/tools/build.c                 |   42 ++--
 arch/x86/include/asm/x86_init.h             |    1 -
 arch/x86/kernel/apic/apic.c                 |   34 ++--
 arch/x86/kernel/apic/apic_numachip.c        |    7 +-
 arch/x86/kernel/cpu/amd.c                   |    7 +-
 arch/x86/kernel/cpu/common.c                |    9 -
 arch/x86/kernel/i387.c                      |    1 +
 arch/x86/kernel/microcode_amd.c             |   12 +-
 arch/x86/kernel/microcode_core.c            |   10 +-
 arch/x86/kernel/x86_init.c                  |    1 -
 arch/x86/xen/smp.c                          |   15 ++
 arch/x86/xen/xen-asm.S                      |    2 +-
 drivers/ata/libata-eh.c                     |    3 +-
 drivers/crypto/talitos.c                    |   20 +-
 drivers/dma/at_hdmac.c                      |    4 -
 drivers/firmware/efivars.c                  |  196 +++++++++++++++++++
 drivers/gpu/drm/i915/i915_gem_execbuffer.c  |    8 +-
 drivers/gpu/drm/i915/i915_reg.h             |    1 +
 drivers/gpu/drm/i915/intel_ringbuffer.c     |    8 +
 drivers/gpu/drm/i915/intel_sdvo.c           |   34 ++--
 drivers/gpu/drm/nouveau/nouveau_acpi.c      |    2 +-
 drivers/gpu/drm/radeon/atombios_crtc.c      |    4 +-
 drivers/hwmon/coretemp.c                    |    6 +-
 drivers/hwmon/fam15h_power.c                |   42 ++++
 drivers/i2c/busses/i2c-pnx.c                |    3 +-
 drivers/input/mouse/synaptics.c             |    3 +-
 drivers/md/raid5.c                          |    4 +-
 drivers/net/wireless/b43/main.c             |   10 +-
 drivers/net/wireless/ipw2x00/ipw2200.c      |   13 +-
 drivers/net/wireless/iwlwifi/iwl-1000.c     |    8 +-
 drivers/net/wireless/iwlwifi/iwl-2000.c     |   16 +-
 drivers/net/wireless/iwlwifi/iwl-5000.c     |   11 +-
 drivers/net/wireless/iwlwifi/iwl-6000.c     |   10 +-
 drivers/net/wireless/iwlwifi/iwl-agn.c      |    3 -
 drivers/net/wireless/iwlwifi/iwl-fh.h       |   24 ++-
 drivers/net/wireless/iwlwifi/iwl-mac80211.c |   10 +-
 drivers/net/wireless/iwlwifi/iwl-prph.h     |   27 ++-
 drivers/net/wireless/rtlwifi/pci.c          |    1 +
 drivers/net/wireless/wl1251/main.c          |    1 +
 drivers/net/wireless/wl1251/sdio.c          |    2 +-
 drivers/platform/x86/dell-laptop.c          |    1 +
 drivers/scsi/libsas/sas_expander.c          |   26 ++-
 drivers/usb/class/cdc-wdm.c                 |    7 +-
 drivers/usb/core/hcd-pci.c                  |    9 +
 drivers/usb/gadget/dummy_hcd.c              |    1 -
 drivers/usb/gadget/f_mass_storage.c         |    2 +-
 drivers/usb/gadget/file_storage.c           |    2 +-
 drivers/usb/gadget/uvc.h                    |    2 +-
 drivers/usb/gadget/uvc_v4l2.c               |    2 +-
 drivers/usb/host/ehci-pci.c                 |    8 +
 drivers/usb/host/ehci-tegra.c               |    1 -
 fs/autofs4/autofs_i.h                       |   12 +-
 fs/autofs4/dev-ioctl.c                      |    3 +-
 fs/autofs4/inode.c                          |    4 +-
 fs/autofs4/waitq.c                          |   20 +-
 fs/exec.c                                   |    3 +
 fs/hfsplus/catalog.c                        |    4 +
 fs/hfsplus/dir.c                            |   11 ++
 fs/nfs/nfs4proc.c                           |   23 ++-
 fs/nfs/read.c                               |    2 +-
 fs/nfs/super.c                              |    8 +-
 fs/nfs/write.c                              |    2 +-
 fs/pipe.c                                   |   31 ++-
 include/linux/efi.h                         |   13 +-
 include/linux/pipe_fs_i.h                   |    1 +
 include/linux/usb/hcd.h                     |    2 +
 kernel/exit.c                               |   19 --
 kernel/power/swap.c                         |   28 ++-
 kernel/sched/core.c                         |   75 ++++----
 kernel/signal.c                             |    9 +
 kernel/trace/trace_output.c                 |    5 +
 net/mac80211/tx.c                           |    3 +-
 net/wireless/nl80211.c                      |   29 +--
 sound/pci/hda/patch_realtek.c               |    1 +
 sound/soc/codecs/wm8994.c                   |  276 +++++++++++++++++++++------
 sound/soc/soc-dapm.c                        |    2 +
 tools/include/tools/be_byteshift.h          |   70 +++++++
 tools/include/tools/le_byteshift.h          |   70 +++++++
 93 files changed, 1177 insertions(+), 356 deletions(-)

--wac7ysb48OaltWcw
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIcBAEBAgAGBQJPpYHxAAoJEDjbvchgkmk+Y5oQAK2/ZET9caBj9PGYn655vIiz
v5V/Ad4T+vI+T8WcKnpNKGzKJGE0ShI3pOtavCqdNAvwy5FrHobmn6zO5BHwvUzU
COb5rtoEljKPT/q3Y4TqXXGVyelAlWzdSZtXy160SCdlPQhcjQkRyxg52OLi9qaA
xNmYT3YRENfDGwz2r6nPO+Hrgcopu2vM1flAlsseAXl8h9+MaqsHiUzPolIBeamS
xfbUZbwh17rV3GOS7dOP4ImR7RJAERif9xL7X1FqcENpPi4E9DD97ydtTAQPrKQE
RHXdMyiu6GqRTZHAXOAVzAG2OQw10o4end45Lv5orbl58unegvQNHnpS8L7Xvavz
DN6oTbYvw5H1TZh/wntf+5ESloZoJgVvq3tLgpJ/+K2P0Jg1ArIUH6der2+696HQ
eVhLTRnlV4pn7wzuojcY4YaZiEBJQ+CxRVaKu/St2E+FhuXWntdwzAvFpI+fy+uC
XTcBWaSHMAcRa/hDtkV7AAKgXBGLiFncmivCpmX7BroTOnkJDej++zIGRKQg2RYT
MZ5P7Wpva1+g+/kl00LAuGAylq0GeHMjRh1l5OdRskojCG0j9ALZXDPBmnoIM6dY
MAryHPGVfusuzSzYOvetY+ViLuZO72L6iMjhF7rC3v+wbDYyHuHGYfY5n0rvhXLK
JXxOSt9kvTU0IJ7VcT+y
=HTnH
-----END PGP SIGNATURE-----

--wac7ysb48OaltWcw--
