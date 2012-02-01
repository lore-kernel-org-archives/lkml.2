Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755109Ab2BAVHl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 16:07:41 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:33309 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752926Ab2BAVHg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 16:07:36 -0500
X-Sasl-enc: W6q45SC9SoOsAKKp/ga3sAnbbpxYJ/8G7r8kLeOffZf4 1328130454
Date: Wed, 1 Feb 2012 13:02:36 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: [00/65] 3.0.19-stable review
Message-ID: <20120201210236.GA25966@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.0.19 release.
There are @num@ patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let us know.  If anyone is a maintainer of the proper subsystem, and
wants to add a Signed-off-by: line to the patch, please respond with it.

Responses should be made by Friday, February 3, 2012, 20:00:00 UTC
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.0.19-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h


 Makefile                                |    4 +-
 arch/arm/mach-ux500/Kconfig             |    1 +
 arch/arm/mm/proc-v7.S                   |    6 --
 arch/x86/include/asm/uv/uv_hub.h        |    4 +-
 arch/x86/kernel/microcode_amd.c         |   24 ++++++-
 arch/x86/net/bpf_jit_comp.c             |   36 ++++++----
 crypto/sha512_generic.c                 |   62 ++++++++++--------
 drivers/gpu/drm/drm_auth.c              |    6 ++-
 drivers/gpu/drm/drm_fops.c              |    5 ++
 drivers/gpu/drm/i915/intel_sdvo.c       |    8 +--
 drivers/gpu/drm/radeon/radeon_irq_kms.c |    6 ++
 drivers/gpu/drm/vmwgfx/vmwgfx_kms.c     |    2 +-
 drivers/hwmon/f71805f.c                 |   10 ++--
 drivers/hwmon/sht15.c                   |    3 +-
 drivers/hwmon/w83627ehf.c               |    6 ++
 drivers/net/bonding/bond_alb.c          |   27 +++-----
 drivers/tty/serial/amba-pl011.c         |   14 ++++
 drivers/tty/serial/jsm/jsm_driver.c     |    1 +
 drivers/tty/tty_port.c                  |   12 ++--
 drivers/usb/class/cdc-wdm.c             |   59 +++++++++++------
 drivers/usb/host/ehci-fsl.c             |    2 +-
 drivers/usb/host/xhci-ring.c            |    6 +-
 drivers/usb/misc/usbsevseg.c            |    2 +-
 drivers/usb/serial/cp210x.c             |  107 +++++++++++++++++++++---------
 drivers/usb/serial/ftdi_sio.c           |   14 +++-
 drivers/usb/serial/ftdi_sio_ids.h       |   19 ++++++
 drivers/usb/serial/io_ti.c              |   10 +--
 drivers/usb/serial/option.c             |    5 ++
 drivers/usb/serial/qcaux.c              |    7 ++-
 fs/ecryptfs/crypto.c                    |   49 ++------------
 fs/ecryptfs/inode.c                     |   48 ++++++++++----
 fs/ecryptfs/miscdev.c                   |   56 +++++++++++-----
 fs/ecryptfs/read_write.c                |   19 ++++--
 fs/xfs/linux-2.6/xfs_discard.c          |    4 +-
 fs/xfs/xfs_vnodeops.c                   |    3 +-
 include/drm/drmP.h                      |    1 +
 include/net/netns/generic.h             |    1 +
 kernel/printk.c                         |    6 +-
 kernel/trace/ftrace.c                   |   76 ++++++++++++++--------
 net/caif/caif_dev.c                     |   11 +--
 net/caif/cfcnfg.c                       |    1 -
 net/core/net_namespace.c                |   31 +++++----
 net/ipv4/ah4.c                          |    2 -
 net/ipv4/tcp_ipv4.c                     |    2 +-
 net/ipv4/tcp_output.c                   |    6 +-
 net/ipv6/ah6.c                          |    2 -
 net/ipv6/tcp_ipv6.c                     |    2 +-
 net/l2tp/l2tp_ip.c                      |    5 --
 net/rds/af_rds.c                        |   20 ++----
 sound/pci/hda/patch_realtek.c           |   11 +++
 sound/pci/hda/patch_sigmatel.c          |    8 ++-
 51 files changed, 508 insertions(+), 324 deletions(-)
