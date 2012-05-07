Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757357Ab2EGQdx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 12:33:53 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:37790 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757267Ab2EGQdu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 12:33:50 -0400
Date: Mon, 7 May 2012 09:33:46 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net
Subject: Linux 3.0.31
Message-ID: <20120507163346.GA29178@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="k+w/mQv8wyuph6w0"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--k+w/mQv8wyuph6w0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.0.31 kernel.

All users of the 3.0 kernel series must upgrade.

---NOTE---
Note, No one actually tested the 3.0.31-rc1 patch I released, as it was
broken (I generated it incorrectly), so if there are any bugs in this
release, well...

I know the "this patch is in this release" emails are good for the
review process, but does anyone even care about the -rc patches anymore?
Are they just a waste of disk space and energy on my side in creating
them?
----------

The updated 3.0.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.g=
it linux-3.0.y
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git=
;a=3Dsummary

thanks,

greg k-h

------------

 Makefile                                      |    2=20
 arch/arm/include/asm/tls.h                    |    4=20
 arch/x86/kernel/apic/apic.c                   |   34 ++-
 arch/x86/xen/smp.c                            |   15 +
 arch/x86/xen/xen-asm.S                        |    2=20
 drivers/ata/libata-eh.c                       |    3=20
 drivers/dma/at_hdmac.c                        |    4=20
 drivers/firmware/efivars.c                    |  222 +++++++++++++++++++++=
+++--
 drivers/gpu/drm/i915/i915_gem_execbuffer.c    |    8=20
 drivers/gpu/drm/i915/intel_sdvo.c             |   34 ++-
 drivers/hwmon/coretemp.c                      |    6=20
 drivers/hwmon/fam15h_power.c                  |   42 ++++
 drivers/i2c/busses/i2c-pnx.c                  |    3=20
 drivers/mmc/host/sdhci-esdhc-imx.c            |    3=20
 drivers/net/wireless/ipw2x00/ipw2200.c        |   13 +
 drivers/net/wireless/rtlwifi/pci.c            |    1=20
 drivers/net/wireless/wl1251/main.c            |    1=20
 drivers/net/wireless/wl1251/sdio.c            |    2=20
 drivers/scsi/libsas/sas_expander.c            |   26 ++-
 drivers/staging/brcm80211/brcmsmac/wlc_bmac.c |    3=20
 drivers/staging/brcm80211/brcmsmac/wlc_bmac.h |    1=20
 drivers/staging/brcm80211/brcmsmac/wlc_main.c |    8=20
 drivers/usb/class/cdc-wdm.c                   |    7=20
 drivers/usb/core/hcd-pci.c                    |    9 +
 drivers/usb/gadget/f_mass_storage.c           |    2=20
 drivers/usb/gadget/file_storage.c             |    2=20
 drivers/usb/gadget/uvc.h                      |    2=20
 drivers/usb/gadget/uvc_v4l2.c                 |    2=20
 drivers/usb/host/ehci-hcd.c                   |    2=20
 drivers/usb/host/ehci-pci.c                   |    8=20
 drivers/usb/host/fsl-mph-dr-of.c              |    1=20
 fs/autofs4/autofs_i.h                         |   12 +
 fs/autofs4/dev-ioctl.c                        |    3=20
 fs/autofs4/inode.c                            |    4=20
 fs/autofs4/waitq.c                            |   20 --
 fs/hfsplus/catalog.c                          |    4=20
 fs/hfsplus/dir.c                              |   11 +
 fs/nfs/nfs4proc.c                             |   23 ++
 fs/nfs/super.c                                |    8=20
 fs/nfsd/nfs4proc.c                            |    7=20
 fs/nfsd/nfs4state.c                           |   23 +-
 fs/pipe.c                                     |   31 +++
 include/linux/efi.h                           |   13 +
 include/linux/kvm_host.h                      |    6=20
 include/linux/pipe_fs_i.h                     |    1=20
 include/linux/usb/hcd.h                       |    2=20
 kernel/sched.c                                |   53 +++---
 net/mac80211/tx.c                             |    3=20
 net/wireless/nl80211.c                        |   29 +--
 scripts/mod/file2alias.c                      |    4=20
 sound/soc/soc-dapm.c                          |    2=20
 virt/kvm/iommu.c                              |   12 -
 virt/kvm/kvm_main.c                           |    5=20
 53 files changed, 584 insertions(+), 164 deletions(-)

Al Viro (2):
      nfsd: fix b0rken error value for setattr on read-only mount
      nfsd: fix error values returned by nfsd4_lockt() when nfsd_open() fai=
ls

Alan Stern (3):
      EHCI: fix criterion for resuming the root hub
      USB: EHCI: fix crash during suspend on ASUS computers
      USB: gadget: storage gadgets send wrong error code for unknown comman=
ds

Alex Williamson (1):
      KVM: unmap pages from the iommu when slots are removed

Andre Przywara (1):
      hwmon: fam15h_power: fix bogus values with current BIOSes

Arend van Spriel (1):
      brcm80211: smac: resume transmit fifo upon receiving frames

Bryan O'Donoghue (1):
      x86, apic: APIC code touches invalid MSR on P5 class machines

Dan Williams (1):
      SCSI: libsas: fix false positive 'device attached' conditions

Daniel Vetter (1):
      drm/i915: handle input/output sdvo timings separately in mode_set

David Miller (1):
      Fix modpost failures in fedora 17

David Vrabel (1):
      xen: correctly check for pending events when restoring irq flags

Eric B=E9nard (1):
      mmc: unbreak sdhci-esdhc-imx on i.MX25

Felix Fietkau (1):
      mac80211: fix AP mode EAP tx for VLAN stations

Grazvydas Ignotas (2):
      wl1251: fix crash on remove due to premature kfree
      wl1251: fix crash on remove due to leftover work item

Greg Kroah-Hartman (3):
      Revert "usb: Fix build error due to dma_mask is not at pdev_archdata =
at ARM"
      hfsplus: Fix potential buffer overflows
      Linux 3.0.31

Guenter Roeck (2):
      hwmon: (fam15h_power) Fix pci_device_id array
      hwmon: (coretemp) Increase CPU core limit

Jan Kara (1):
      nfs: Enclose hostname in brackets when needed in nfs_do_root_mount

Johannes Berg (1):
      nl80211: ensure interface is up in various APIs

Kirill A. Shutemov (1):
      hwmon: (coretemp) fix oops on cpu unplug

Konrad Rzeszutek Wilk (1):
      xen/smp: Fix crash when booting with ACPI hotplug CPUs.

Larry Finger (1):
      rtlwifi: Fix oops on unload

Laurent Pinchart (1):
      usb gadget: uvc: uvc_request_data::length field must be signed

Lin Ming (1):
      libata: skip old error history when counting probe trials

Linus Torvalds (3):
      Revert "autofs: work around unhappy compat problem on x86-64"
      pipes: add a "packetized pipe" mode for writing
      autofs: make the autofsv5 packet file descriptor use a packetized pipe

Mark Brown (1):
      ASoC: dapm: Ensure power gets managed for line widgets

Matthew Garrett (3):
      efi: Add new variable attributes
      efi: Validate UEFI boot variables
      efivars: Improve variable validation

Mike Waychison (1):
      efivars: String functions

Nicolas Ferre (1):
      dmaengine: at_hdmac: remove clear-on-read in atc_dostart()

Oliver Neukum (1):
      USB: cdc-wdm: fix race leading leading to memory corruption

Peter Zijlstra (1):
      sched: Fix nohz load accounting -- again!

Roland Stigge (1):
      i2c: pnx: Disable clk in suspend

Stanislav Yakovlev (1):
      ipw2200: Fix race condition in the command completion acknowledge

Thomas Jackson (1):
      SCSI: libsas: fix sas_find_bcast_phy() in the presence of 'vacant' ph=
ys

Tony Luck (1):
      efivars: fix warnings when CONFIG_PSTORE=3Dn

Trond Myklebust (2):
      NFSv4: Ensure that the LOCK code sets exception->inode
      NFSv4: Ensure that we check lock exclusive/shared type against open m=
odes

Will Deacon (1):
      ARM: 7403/1: tls: remove covert channel via TPIDRURW

Xi Wang (2):
      drm/i915: fix integer overflow in i915_gem_execbuffer2()
      drm/i915: fix integer overflow in i915_gem_do_execbuffer()


--k+w/mQv8wyuph6w0
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIcBAEBAgAGBQJPp/lqAAoJEDjbvchgkmk+IzwP/jrpfywZ3esKrh98OozVfT4f
w2E8tLuGiiyVn2+Y3z6PqgXX8P/0SPslL4fbhorGZX2uFeNH+YC7KXuQhAXj6p/b
/FLLJ9JOF5VPJEBvJPW7ciIzNu2SrEQEV6Bkp8h0RJP/ZcBiKuomkgbNtAKbH2j0
btrgsLlOp7Ie68ZMn4uoHvhipEBWKdC6ARZnNFO1yqFoaRVb1MiMU7gNJztrdr26
ILQ6ykq6jAO/kii/5HYLigsSaePKnHJsFo+kgnUfKl6j0ZTo3r/DmxBhUOqCaBH6
BPeJRkiTw/6oF1oA93CEVWilYuP9yXJb2Xtb/Cc5DrixpEq2uRQgxktg3u6Tns9/
RYa5/fWc9tz/9BNuSQQAmiSwLdUofqR7drA4u4rtv4dK6w+QILajL++R6S9zL9TL
speHmFRxwY0+NnVnhrDKychH9kyLIqqk86NQk6ClNSw/9zlzF84qxPAhz+9USki6
bep0NL5tqhiqQEjUW0DE1WOv/Om4iIfYl2/KexnVwRRuy5z27/4e32v2hQ2n7x2v
bfHxweq1ZxdVYgESMrkufeYQ4fcmOx0wfwr6ZReTesUtPOp9hX6ajX9G0GA4ptbC
n4Acd+6cfnRT9J7c0nylK6nvdmpNKfrwXT6ET767awfQLx9JLpNpa68Hc89xPM00
sXUeR2bbYIMZBVXXnX5l
=DHIi
-----END PGP SIGNATURE-----

--k+w/mQv8wyuph6w0--
