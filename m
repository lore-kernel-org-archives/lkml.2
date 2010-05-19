Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753494Ab0ESGqG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 02:46:06 -0400
Received: from isilmar-3.linta.de ([188.40.101.200]:37524 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751289Ab0ESGqC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 02:46:02 -0400
Date: Wed, 19 May 2010 08:41:49 +0200
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: torvalds@osdl.org, akpm@osdl.org
Cc: linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [git pull] PCMCIA updates for 2.6.35
Message-ID: <20100519064149.GA5755@comet.dominikbrodowski.net>
Mail-Followup-To: torvalds@osdl.org, akpm@osdl.org,
	linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

several PCMCIA updates for 2.6.35 are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/brodo/pcmcia-2.6.git master

Please pull from that location. The diffstat and list of changes is below,
the individual diffs are sent (at least) to the linux-pcmcia list.

This patch series also includes the removal of the PCMCIA ioctl Kconfig
option for ARM (acd200bf, see also commit a3f916f2 which went in last time).
So far, only Russell King has spoken out against this; a few days ago he
repeated his opposition.[1] Attempts to resolve this issue still haven't
been successful[2]. If it turns out that a PCMCIA ioctl indeed is still
needed (or we need a cut-down PCMCIA ioctl, and have sufficient information
on what is needed), the Kconfig option may need to be re-enabled before
2.6.35 is released.

In any case, I'll only push patches removing actual PCMCIA ioctl code during
the next merge window.

[1] http://readlist.com/lists/vger.kernel.org/linux-kernel/159/798284.html
[2] http://readlist.com/lists/vger.kernel.org/linux-kernel/159/798290.html


Thanks,
        Dominik


Dominik Brodowski (21):
      pcmcia: remove unused IRQ modification feature
      pcmcia: setup IRQ to be used by PCMCIA drivers at card insert
      pcmcia: replace struct irq with uint pcmcia_irq in struct pcmcia_socket
      pcmcia: pass FORCED_PULSE parameter in pcmcia_request_configuration()
      pcmcia: re-work pcmcia_request_irq()
      pcmcia: clean up cs.h
      pcmcia: dev_node removal (write-only drivers)
      pcmcia: dev_node removal (drivers with updated printk call)
      pcmcia: dev_node removal (drivers with unregister_netdev check)
      pcmcia: dev_node removal (remaining drivers)
      pcmcia: dev_node removal (core)
      pcmcia: move high level CIS access code to separate file
      pcmcia: move all pcmcia_resource_ops providers into one module
      pcmcia: clarify alloc_io_space, move it to resource handlers
      pcmcia: do not autoadd root PCI bus resources
      pcmcia: remove unused mem_op.h
      pcmcia: remove pcmcia_add_device_lock
      pcmcia: call pcmcia_{read,write}_cis_mem with ops_mutex held
      pcmcia: remove suspend-related comment from yenta_socket.c
      pata_pcmcia: get rid of extra indirection
      pcmcia: disable PCMCIA ioctl also for ARM

Javier Martinez Canillas (7):
      drivers/staging/comedi: dev_node removal (cb_das16_cs)
      drivers/staging/comedi: dev_node removal (das08_cs)
      drivers/staging/comedi: dev_node removal (ni_daq_700)
      drivers/staging/comedi: dev_node removal (ni_daq_dio24)
      drivers/staging/comedi: dev_node removal (ni_labpc_cs)
      drivers/staging/comedi: dev_node removal (ni_mio_cs)
      drivers/staging/comedi: dev_node removal (quatech_daqp_cs)

Tejun Heo (1):
      pcmcia: update gfp/slab.h includes

 Documentation/pcmcia/driver-changes.txt          |   13 +
 drivers/ata/pata_pcmcia.c                        |   47 +--
 drivers/bluetooth/bluecard_cs.c                  |   11 +-
 drivers/bluetooth/bt3c_cs.c                      |   11 +-
 drivers/bluetooth/btuart_cs.c                    |   11 +-
 drivers/bluetooth/dtl1_cs.c                      |   11 +-
 drivers/char/pcmcia/cm4000_cs.c                  |    9 +-
 drivers/char/pcmcia/cm4040_cs.c                  |    5 -
 drivers/char/pcmcia/ipwireless/main.c            |   19 +-
 drivers/char/pcmcia/ipwireless/main.h            |    1 -
 drivers/char/pcmcia/ipwireless/tty.c             |   19 +-
 drivers/char/pcmcia/ipwireless/tty.h             |    3 +-
 drivers/char/pcmcia/synclink_cs.c                |   22 +-
 drivers/ide/ide-cs.c                             |   20 +-
 drivers/isdn/hardware/avm/avm_cs.c               |   76 +---
 drivers/isdn/hisax/avma1_cs.c                    |   63 +--
 drivers/isdn/hisax/elsa_cs.c                     |   40 +--
 drivers/isdn/hisax/sedlbauer_cs.c                |   60 +--
 drivers/isdn/hisax/teles_cs.c                    |   50 +--
 drivers/mtd/maps/pcmciamtd.c                     |    3 -
 drivers/net/pcmcia/3c574_cs.c                    |   15 +-
 drivers/net/pcmcia/3c589_cs.c                    |   16 +-
 drivers/net/pcmcia/axnet_cs.c                    |   21 +-
 drivers/net/pcmcia/com20020_cs.c                 |   29 +-
 drivers/net/pcmcia/fmvj18x_cs.c                  |   18 +-
 drivers/net/pcmcia/ibmtr_cs.c                    |   16 +-
 drivers/net/pcmcia/nmclan_cs.c                   |   14 +-
 drivers/net/pcmcia/pcnet_cs.c                    |   16 +-
 drivers/net/pcmcia/smc91c92_cs.c                 |   17 +-
 drivers/net/pcmcia/xirc2ps_cs.c                  |   36 +--
 drivers/net/wireless/airo_cs.c                   |   72 +---
 drivers/net/wireless/atmel_cs.c                  |   70 +---
 drivers/net/wireless/b43/pcmcia.c                |    5 +-
 drivers/net/wireless/hostap/hostap_cs.c          |   38 +-
 drivers/net/wireless/libertas/if_cs.c            |   21 +-
 drivers/net/wireless/orinoco/orinoco_cs.c        |   27 +-
 drivers/net/wireless/orinoco/spectrum_cs.c       |   27 +-
 drivers/net/wireless/ray_cs.c                    |   15 +-
 drivers/net/wireless/ray_cs.h                    |    1 -
 drivers/net/wireless/wl3501.h                    |    1 -
 drivers/net/wireless/wl3501_cs.c                 |   23 +-
 drivers/parport/parport_cs.c                     |   13 +-
 drivers/pcmcia/Kconfig                           |   22 +-
 drivers/pcmcia/Makefile                          |    9 +-
 drivers/pcmcia/bfin_cf_pcmcia.c                  |    2 +-
 drivers/pcmcia/cardbus.c                         |    1 -
 drivers/pcmcia/cistpl.c                          |  121 +----
 drivers/pcmcia/cs.c                              |    1 -
 drivers/pcmcia/cs_internal.h                     |   22 +-
 drivers/pcmcia/ds.c                              |   34 +-
 drivers/pcmcia/omap_cf.c                         |    2 +-
 drivers/pcmcia/pcmcia_cis.c                      |  356 ++++++++++++
 drivers/pcmcia/pcmcia_ioctl.c                    |   23 +-
 drivers/pcmcia/pcmcia_resource.c                 |  634 ++++++----------------
 drivers/pcmcia/rsrc_iodyn.c                      |  172 ++++++
 drivers/pcmcia/rsrc_mgr.c                        |  112 +----
 drivers/pcmcia/rsrc_nonstatic.c                  |  164 +++++--
 drivers/pcmcia/yenta_socket.c                    |    7 -
 drivers/scsi/pcmcia/aha152x_stub.c               |    9 +-
 drivers/scsi/pcmcia/fdomain_stub.c               |    9 +-
 drivers/scsi/pcmcia/nsp_cs.c                     |   23 +-
 drivers/scsi/pcmcia/nsp_cs.h                     |    1 -
 drivers/scsi/pcmcia/qlogic_stub.c                |   13 +-
 drivers/scsi/pcmcia/sym53c500_cs.c               |    9 +-
 drivers/serial/serial_cs.c                       |   36 +-
 drivers/ssb/main.c                               |    2 +-
 drivers/staging/comedi/drivers/cb_das16_cs.c     |   45 +--
 drivers/staging/comedi/drivers/das08_cs.c        |   35 +-
 drivers/staging/comedi/drivers/ni_daq_700.c      |   42 +--
 drivers/staging/comedi/drivers/ni_daq_dio24.c    |   42 +--
 drivers/staging/comedi/drivers/ni_labpc_cs.c     |   42 +--
 drivers/staging/comedi/drivers/ni_mio_cs.c       |   19 +-
 drivers/staging/comedi/drivers/quatech_daqp_cs.c |   45 +--
 drivers/staging/netwave/netwave_cs.c             |    9 +-
 drivers/staging/wavelan/wavelan_cs.c             |   15 +-
 drivers/staging/wlags49_h2/wl_cs.c               |    9 +-
 drivers/telephony/ixj_pcmcia.c                   |    3 -
 drivers/usb/host/sl811_cs.c                      |   28 +-
 include/pcmcia/cs.h                              |   19 +-
 include/pcmcia/ds.h                              |   29 +-
 include/pcmcia/mem_op.h                          |  116 ----
 include/pcmcia/ss.h                              |    7 +-
 sound/pcmcia/pdaudiocf/pdaudiocf.c               |   12 +-
 sound/pcmcia/pdaudiocf/pdaudiocf.h               |    1 -
 sound/pcmcia/vx/vxpocket.c                       |   10 +-
 sound/pcmcia/vx/vxpocket.h                       |    1 -
 86 files changed, 1179 insertions(+), 2139 deletions(-)
 create mode 100644 drivers/pcmcia/pcmcia_cis.c
 create mode 100644 drivers/pcmcia/rsrc_iodyn.c
 delete mode 100644 include/pcmcia/mem_op.h
