Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946296Ab2JDV1F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 17:27:05 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42952 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946260Ab2JDV07 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 17:26:59 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
Subject: =?UTF-8?q?=5B=2000/33=5D=203=2E0=2E45-stable=20review?=
Date: Thu,  4 Oct 2012 14:26:22 -0700
Message-Id: <20121004210558.383865383@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.2.421.g261b511
User-Agent: quilt/0.60-2.1.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.0.45 release.
There are 33 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat Oct  6 21:02:56 UTC 2012.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.0.45-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Bart Van Assche <bvanassche@acm.org>
    SCSI: scsi_dh_alua: Enable STPG for unavailable ports

Dan Williams <djbw@fb.com>
    SCSI: scsi_remove_target: fix softlockup regression on hot remove

Yinghai Lu <yinghai@kernel.org>
    PCI: honor child buses add_size in hot plug configuration

Avi Kivity <avi@redhat.com>
    x86/alternatives: Fix p6 nops on non-modular kernels

Dan Williams <dan.j.williams@intel.com>
    isci: fix isci_pci_probe() generates warning on efi failure path

Bart Van Assche <bvanassche@acm.org>
    IB/srp: Avoid having aborted requests hang

Bart Van Assche <bvanassche@acm.org>
    IB/srp: Fix use-after-free in srp_reset_req()

Patrick McHardy <kaber@trash.net>
    IPoIB: Fix use-after-free of multicast object

Wei Yongjun <yongjun_wei@trendmicro.com.cn>
    can: mscan-mpc5xxx: fix return value check in mpc512x_can_get_clock()

Stephen M. Cameron <scameron@beardog.cce.hp.com>
    SCSI: hpsa: Use LUN reset instead of target reset

Benjamin Herrenschmidt <benh@kernel.crashing.org>
    SCSI: ibmvscsi: Fix host config length field overflow

Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
    UBI: fix autoresize handling in R/O mode

Russ Gorby <russ.gorby@intel.com>
    n_gsm: memory leak in uplink error path

Michael Spang <spang@chromium.org>
    Increase XHCI suspend timeout to 16ms

Denys Vlasenko <vda.linux@googlemail.com>
    coredump: prevent double-free on an error path in core dumper

Russ Gorby <russ.gorby@intel.com>
    n_gsm: added interlocking for gsm_data_lock for certain code paths

Sarah Sharp <sarah.a.sharp@linux.intel.com>
    xhci: Intel Panther Point BEI quirk.

Khalid Aziz <khalid.aziz@hp.com>
    firmware: Add missing attributes to EFI variable attribute print out from sysfs

Larry Finger <Larry.Finger@lwfinger.net>
    b43legacy: Fix crash on unload when firmware not available

Flavio Leitner <fbl@redhat.com>
    serial: set correct baud_base for EXSYS EX-41092 Dual 16950

Linus Walleij <linus.walleij@linaro.org>
    serial: pl011: handle corruption at high clock speeds

Jiri Slaby <jslaby@suse.cz>
    TTY: ttyprintk, don't touch behind tty->write_buf

Stanislav Kozina <skozina@redhat.com>
    Remove BUG_ON from n_tty_read()

Ian Abbott <abbotti@mev.co.uk>
    staging: comedi: fix memory leak for saved channel list

Ian Abbott <abbotti@mev.co.uk>
    staging: comedi: don't dereference user memory for INSN_INTTRIG

Ian Abbott <abbotti@mev.co.uk>
    staging: comedi: jr3_pci: fix iomem dereference

Ian Abbott <abbotti@mev.co.uk>
    staging: comedi: s626: don't dereference insn->data

Ben Hutchings <ben@decadent.org.uk>
    staging: speakup_soft: Fix reading of init string

Bjørn Mork <bjorn@mork.no>
    USB: qcaux: add Pantech vendor class match

Antonio Ospite <ospite@studenti.unina.it>
    USB: ftdi_sio: add TIAO USB Multi-Protocol Adapter (TUMPA) support

Bjørn Mork <bjorn@mork.no>
    USB: option: blacklist QMI interface on ZTE MF683

Mike Snitzer <snitzer@redhat.com>
    dm: handle requests beyond end of device instead of using BUG_ON

Miklos Szeredi <miklos@szeredi.hu>
    vfs: dcache: fix deadlock in tree traversal


-------------

Diffstat:

 Makefile                                       |  4 +-
 arch/x86/kernel/alternative.c                  |  2 +-
 drivers/char/ttyprintk.c                       |  2 +-
 drivers/firmware/efivars.c                     | 17 ++++++--
 drivers/infiniband/ulp/ipoib/ipoib_main.c      |  2 +-
 drivers/infiniband/ulp/ipoib/ipoib_multicast.c | 19 ++++-----
 drivers/infiniband/ulp/srp/ib_srp.c            |  3 +-
 drivers/md/dm.c                                | 56 +++++++++++++++++---------
 drivers/mtd/ubi/build.c                        |  5 +++
 drivers/net/can/mscan/mpc5xxx_can.c            |  4 +-
 drivers/net/wireless/b43legacy/main.c          |  2 +
 drivers/pci/setup-bus.c                        | 26 ++++++++++++
 drivers/scsi/device_handler/scsi_dh_alua.c     |  3 +-
 drivers/scsi/hpsa.c                            |  2 +-
 drivers/scsi/ibmvscsi/ibmvscsi.c               |  3 ++
 drivers/scsi/isci/init.c                       |  1 -
 drivers/scsi/isci/probe_roms.c                 |  1 -
 drivers/scsi/scsi_sysfs.c                      | 30 +++++++-------
 drivers/staging/comedi/comedi_fops.c           |  5 ++-
 drivers/staging/comedi/drivers/jr3_pci.c       |  2 +-
 drivers/staging/comedi/drivers/s626.c          |  2 +-
 drivers/staging/speakup/speakup_soft.c         | 13 ++----
 drivers/tty/n_gsm.c                            | 15 +++++--
 drivers/tty/n_tty.c                            |  3 +-
 drivers/tty/serial/8250_pci.c                  |  9 ++++-
 drivers/tty/serial/amba-pl011.c                | 15 ++++++-
 drivers/usb/host/xhci-pci.c                    |  1 +
 drivers/usb/host/xhci-ring.c                   |  4 +-
 drivers/usb/host/xhci.c                        |  2 +-
 drivers/usb/host/xhci.h                        |  1 +
 drivers/usb/serial/ftdi_sio.c                  |  2 +
 drivers/usb/serial/ftdi_sio_ids.h              |  5 +++
 drivers/usb/serial/option.c                    |  3 +-
 drivers/usb/serial/qcaux.c                     | 10 ++---
 fs/binfmt_elf.c                                | 19 ++-------
 fs/dcache.c                                    |  6 +++
 include/linux/pci_ids.h                        |  1 -
 37 files changed, 194 insertions(+), 106 deletions(-)


