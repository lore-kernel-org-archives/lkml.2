Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760429Ab0HEWHy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 18:07:54 -0400
Received: from isilmar-3.linta.de ([188.40.101.200]:45909 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933687Ab0HEWHr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 18:07:47 -0400
Date: Fri, 6 Aug 2010 00:05:11 +0200
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: torvalds@osdl.org, akpm@osdl.org
Cc: linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [git pull] PCMCIA updates for 2.6.36
Message-ID: <20100805220511.GA7040@comet.dominikbrodowski.net>
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

several PCMCIA updates for 2.6.36 are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/brodo/pcmcia-2.6.git master

Please pull from that location. The diffstat and list of changes is below,
the individual diffs are sent (at least) to the linux-pcmcia list.

This patch series also includes the removal of the PCMCIA ioctl code.
The Kconfig option was already removed in the past kernel series; I have not
received any further feedback -- besides the notable opposition by
Russell King, last repeated during the 2.6.35 merge window -- on why
this long obsoleted ioctl should still be made available by the kernel.

In other news, this patch set contains a large cleanup of how PCMCIA
drivers set up and utilize ioport resources -- the less often used
iomem resources will follow in the next release cycle, though they
are already properly set up, exported in sysfs, and registered with
the core on properly behaving socket drivers. 

Thanks,
        Dominik

Dominik Brodowski (18):
      pcmcia: remove obsolete ioctl
      pcmcia: simplify event callback
      pcmcia: split up central event handler
      pcmcia: remove obsolete CS_EVENT_ definitions
      pcmcia: remove unused flag, simplify headers
      pcmcia: remove cs_types.h
      pcmcia: use pcmica_{read,write}_config_byte
      pcmcia: clean up cs.h
      pcmcia: use struct resource for PCMCIA devices
      pcmcia: do not use io_req_t after call to pcmcia_request_io()
      pcmcia: do not use io_req_t when calling pcmcia_request_io()
      pcmcia: move local definitions out of include/pcmcia/cs.h
      pcmcia: remove memreq_t
      pcmcia: use struct resource for PCMCIA devices, part 2
      pcmcia: export resource information to sysfs
      pcmcia: insert PCMCIA device resources into resource tree
      pcmcia: do not request windows if you don't need to
      pcmcia: avoid buffer overflow in pcmcia_setup_isa_irq

 Documentation/feature-removal-schedule.txt       |   23 -
 Documentation/pcmcia/driver-changes.txt          |   12 +
 drivers/ata/pata_pcmcia.c                        |   38 +-
 drivers/bluetooth/bluecard_cs.c                  |   32 +-
 drivers/bluetooth/bt3c_cs.c                      |   27 +-
 drivers/bluetooth/btuart_cs.c                    |   31 +-
 drivers/bluetooth/dtl1_cs.c                      |   35 +-
 drivers/char/pcmcia/cm4000_cs.c                  |   30 +-
 drivers/char/pcmcia/cm4040_cs.c                  |   37 +-
 drivers/char/pcmcia/ipwireless/main.c            |   47 +-
 drivers/char/pcmcia/ipwireless/main.h            |    1 -
 drivers/char/pcmcia/ipwireless/tty.h             |    1 -
 drivers/char/pcmcia/synclink_cs.c                |   29 +-
 drivers/ide/ide-cs.c                             |   39 +-
 drivers/isdn/hardware/avm/avm_cs.c               |   25 +-
 drivers/isdn/hisax/avma1_cs.c                    |   29 +-
 drivers/isdn/hisax/elsa_cs.c                     |   32 +-
 drivers/isdn/hisax/sedlbauer_cs.c                |   83 +--
 drivers/isdn/hisax/teles_cs.c                    |   30 +-
 drivers/mmc/host/sdricoh_cs.c                    |    1 -
 drivers/mtd/maps/pcmciamtd.c                     |   15 +-
 drivers/net/pcmcia/3c574_cs.c                    |   14 +-
 drivers/net/pcmcia/3c589_cs.c                    |   14 +-
 drivers/net/pcmcia/axnet_cs.c                    |   48 +-
 drivers/net/pcmcia/com20020_cs.c                 |   22 +-
 drivers/net/pcmcia/fmvj18x_cs.c                  |   48 +-
 drivers/net/pcmcia/ibmtr_cs.c                    |   29 +-
 drivers/net/pcmcia/nmclan_cs.c                   |   32 +-
 drivers/net/pcmcia/pcnet_cs.c                    |   63 +-
 drivers/net/pcmcia/smc91c92_cs.c                 |   71 +-
 drivers/net/pcmcia/xirc2ps_cs.c                  |   60 +-
 drivers/net/wireless/airo_cs.c                   |   74 +--
 drivers/net/wireless/atmel_cs.c                  |   25 +-
 drivers/net/wireless/b43/pcmcia.c                |   13 +-
 drivers/net/wireless/hostap/hostap_cs.c          |  136 +--
 drivers/net/wireless/libertas/if_cs.c            |   16 +-
 drivers/net/wireless/orinoco/orinoco_cs.c        |   30 +-
 drivers/net/wireless/orinoco/spectrum_cs.c       |   62 +-
 drivers/net/wireless/ray_cs.c                    |   27 +-
 drivers/net/wireless/wl3501_cs.c                 |   24 +-
 drivers/parport/parport_cs.c                     |   23 +-
 drivers/pcmcia/Makefile                          |    1 -
 drivers/pcmcia/au1000_generic.h                  |    1 -
 drivers/pcmcia/au1000_pb1x00.c                   |    2 -
 drivers/pcmcia/cistpl.c                          |   11 +-
 drivers/pcmcia/cs.c                              |   79 +--
 drivers/pcmcia/cs_internal.h                     |   62 +-
 drivers/pcmcia/db1xxx_ss.c                       |    1 -
 drivers/pcmcia/ds.c                              |  184 ++--
 drivers/pcmcia/i82092.c                          |    1 -
 drivers/pcmcia/i82365.c                          |    1 -
 drivers/pcmcia/m32r_cfc.c                        |    1 -
 drivers/pcmcia/m32r_pcc.c                        |    1 -
 drivers/pcmcia/m8xx_pcmcia.c                     |    1 -
 drivers/pcmcia/pcmcia_cis.c                      |    1 -
 drivers/pcmcia/pcmcia_ioctl.c                    | 1077 ----------------------
 drivers/pcmcia/pcmcia_resource.c                 |  331 ++++---
 drivers/pcmcia/pd6729.c                          |    1 -
 drivers/pcmcia/pxa2xx_base.c                     |    1 -
 drivers/pcmcia/rsrc_iodyn.c                      |    8 +-
 drivers/pcmcia/rsrc_mgr.c                        |    6 +-
 drivers/pcmcia/rsrc_nonstatic.c                  |   15 +-
 drivers/pcmcia/sa1100_generic.c                  |    1 -
 drivers/pcmcia/soc_common.h                      |    1 -
 drivers/pcmcia/socket_sysfs.c                    |    1 -
 drivers/pcmcia/tcic.c                            |    1 -
 drivers/pcmcia/xxs1500_ss.c                      |    1 -
 drivers/pcmcia/yenta_socket.c                    |    1 -
 drivers/scsi/pcmcia/aha152x_stub.c               |   17 +-
 drivers/scsi/pcmcia/fdomain_stub.c               |   15 +-
 drivers/scsi/pcmcia/nsp_cs.c                     |   61 +-
 drivers/scsi/pcmcia/qlogic_stub.c                |   33 +-
 drivers/scsi/pcmcia/sym53c500_cs.c               |   31 +-
 drivers/serial/serial_cs.c                       |   68 +-
 drivers/ssb/main.c                               |    1 -
 drivers/ssb/pcmcia.c                             |   15 +-
 drivers/ssb/scan.c                               |    1 -
 drivers/staging/comedi/drivers/cb_das16_cs.c     |   37 +-
 drivers/staging/comedi/drivers/das08_cs.c        |   36 +-
 drivers/staging/comedi/drivers/ni_daq_700.c      |   62 +-
 drivers/staging/comedi/drivers/ni_daq_dio24.c    |   63 +-
 drivers/staging/comedi/drivers/ni_labpc_cs.c     |   63 +-
 drivers/staging/comedi/drivers/ni_mio_cs.c       |   16 +-
 drivers/staging/comedi/drivers/quatech_daqp_cs.c |   37 +-
 drivers/staging/wlags49_h2/wl_cs.c               |   11 +-
 drivers/staging/wlags49_h2/wl_internal.h         |    1 -
 drivers/telephony/ixj_pcmcia.c                   |   20 +-
 drivers/usb/host/sl811_cs.c                      |   24 +-
 include/pcmcia/cistpl.h                          |    2 +
 include/pcmcia/cs.h                              |  157 +---
 include/pcmcia/cs_types.h                        |   40 -
 include/pcmcia/ds.h                              |  251 +-----
 include/pcmcia/ss.h                              |   25 +-
 sound/pcmcia/pdaudiocf/pdaudiocf.c               |    9 +-
 sound/pcmcia/pdaudiocf/pdaudiocf.h               |    1 -
 sound/pcmcia/vx/vxpocket.c                       |    9 +-
 sound/pcmcia/vx/vxpocket.h                       |    1 -
 97 files changed, 1189 insertions(+), 3138 deletions(-)
 delete mode 100644 drivers/pcmcia/pcmcia_ioctl.c
 delete mode 100644 include/pcmcia/cs_types.h
