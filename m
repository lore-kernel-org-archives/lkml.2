Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758698Ab0JUPkP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 11:40:15 -0400
Received: from isilmar-3.linta.de ([188.40.101.200]:52000 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758659Ab0JUPkN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 11:40:13 -0400
Date: Thu, 21 Oct 2010 17:34:50 +0200
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: torvalds@osdl.org, akpm@osdl.org
Cc: linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [git pull] PCMCIA updates for 2.6.36
Message-ID: <20101021153450.GA12405@comet.dominikbrodowski.net>
Mail-Followup-To: torvalds@osdl.org, akpm@osdl.org,
	linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

several PCMCIA updates for 2.6.37 are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/brodo/pcmcia-2.6.git master

Please pull from that location. The diffstat and list of changes is below,
the individual diffs are sent (at least) to the linux-pcmcia list.

Thanks,
        Dominik


Dominik Brodowski (16):
      pcmcia: do not use win_req_t when calling pcmcia_request_window()
      pcmcia: split up modify_configuration() into two fixup functions
      pcmcia: move Vpp setup to struct pcmcia_device
      pcmcia: remove Pin, Copy configuration register access
      pcmcia: simplify Status, ExtStatus register access
      pcmcia: simplify IntType
      pcmcia: move config_{base,index,regs} to struct pcmcia_device
      pcmcia: convert pcmcia_request_configuration to pcmcia_enable_device
      pcmcia: Documentation update
      pcmcia: introduce autoconfiguration feature
      pcmcia: use autoconfiguration feature for ioports and iomem
      pcmcia: remove the "Finally, report what we've done" message
      pcmcia: move driver name to struct pcmcia_driver
      pcmcia: avoid messages on module (un)loading
      pcmcia: remove obsolete and wrong comments
      pcmcia: add a few debug statements

Maciej Żenczykowski (1):
      pcmcia: fix unused function compile warning

Rahul Ruikar (1):
      pcmcia: vrc4173_cardu: Fix error path for pci_release_regions and pci_disable_device

Tejun Heo (2):
      serial_cs: drop spurious flush_scheduled_work() call
      pcmcia: don't call flush_scheduled_work() spuriously

Vasiliy Kulikov (1):
      pcmcia: synclink_cs: fix information leak to userland

Wolfram Sang (1):
      pcmcia/yenta: guide users in case of problems with O2-bridges

 Documentation/pcmcia/driver-changes.txt          |   25 ++
 drivers/ata/pata_pcmcia.c                        |  104 ++----
 drivers/bluetooth/bluecard_cs.c                  |   12 +-
 drivers/bluetooth/bt3c_cs.c                      |   64 ++--
 drivers/bluetooth/btuart_cs.c                    |   62 ++--
 drivers/bluetooth/dtl1_cs.c                      |   27 +-
 drivers/char/pcmcia/cm4000_cs.c                  |   31 +--
 drivers/char/pcmcia/cm4040_cs.c                  |   40 +--
 drivers/char/pcmcia/ipwireless/main.c            |  117 +++----
 drivers/char/pcmcia/ipwireless/main.h            |    5 -
 drivers/char/pcmcia/ipwireless/tty.h             |    1 -
 drivers/char/pcmcia/synclink_cs.c                |   46 +--
 drivers/ide/ide-cs.c                             |  156 ++-------
 drivers/isdn/hardware/avm/avm_cs.c               |   83 +----
 drivers/isdn/hisax/avma1_cs.c                    |   97 +-----
 drivers/isdn/hisax/elsa_cs.c                     |  100 +-----
 drivers/isdn/hisax/sedlbauer_cs.c                |  168 +---------
 drivers/isdn/hisax/teles_cs.c                    |   98 +-----
 drivers/mmc/host/sdricoh_cs.c                    |    5 +-
 drivers/mtd/maps/pcmciamtd.c                     |  102 ++----
 drivers/net/pcmcia/3c574_cs.c                    |   35 +--
 drivers/net/pcmcia/3c589_cs.c                    |   47 +---
 drivers/net/pcmcia/axnet_cs.c                    |   87 +----
 drivers/net/pcmcia/com20020_cs.c                 |   43 +---
 drivers/net/pcmcia/fmvj18x_cs.c                  |   67 ++---
 drivers/net/pcmcia/ibmtr_cs.c                    |   89 ++----
 drivers/net/pcmcia/nmclan_cs.c                   |   42 +--
 drivers/net/pcmcia/pcnet_cs.c                    |  146 ++------
 drivers/net/pcmcia/smc91c92_cs.c                 |  114 ++-----
 drivers/net/pcmcia/xirc2ps_cs.c                  |  161 +++------
 drivers/net/wireless/airo_cs.c                   |  154 +--------
 drivers/net/wireless/atmel_cs.c                  |  135 +-------
 drivers/net/wireless/b43/pcmcia.c                |   24 +-
 drivers/net/wireless/hostap/hostap_cs.c          |  102 +-----
 drivers/net/wireless/libertas/if_cs.c            |   58 +---
 drivers/net/wireless/orinoco/orinoco_cs.c        |  137 +-------
 drivers/net/wireless/orinoco/spectrum_cs.c       |  134 +-------
 drivers/net/wireless/ray_cs.c                    |   91 ++----
 drivers/net/wireless/ray_cs.h                    |    2 -
 drivers/net/wireless/wl3501_cs.c                 |   47 +---
 drivers/parport/parport_cs.c                     |   76 +----
 drivers/pcmcia/au1000_generic.c                  |    3 -
 drivers/pcmcia/au1000_generic.h                  |    1 -
 drivers/pcmcia/au1000_pb1x00.c                   |    1 -
 drivers/pcmcia/cistpl.c                          |    1 -
 drivers/pcmcia/cs.c                              |    3 +-
 drivers/pcmcia/cs_internal.h                     |    9 -
 drivers/pcmcia/ds.c                              |   37 ++-
 drivers/pcmcia/i82092.c                          |    1 -
 drivers/pcmcia/i82365.c                          |    1 -
 drivers/pcmcia/m32r_cfc.c                        |    1 -
 drivers/pcmcia/m32r_pcc.c                        |    1 -
 drivers/pcmcia/m8xx_pcmcia.c                     |    1 -
 drivers/pcmcia/o2micro.h                         |    4 +-
 drivers/pcmcia/pcmcia_cis.c                      |  117 ++++++-
 drivers/pcmcia/pcmcia_resource.c                 |  409 +++++++++++++---------
 drivers/pcmcia/pd6729.c                          |    1 -
 drivers/pcmcia/rsrc_iodyn.c                      |    1 -
 drivers/pcmcia/rsrc_mgr.c                        |    1 -
 drivers/pcmcia/rsrc_nonstatic.c                  |    1 -
 drivers/pcmcia/sa1100_generic.c                  |    1 -
 drivers/pcmcia/soc_common.c                      |    4 -
 drivers/pcmcia/soc_common.h                      |    1 -
 drivers/pcmcia/socket_sysfs.c                    |    1 -
 drivers/pcmcia/tcic.c                            |    1 -
 drivers/pcmcia/vrc4173_cardu.c                   |   58 ++-
 drivers/pcmcia/xxs1500_ss.c                      |    1 -
 drivers/pcmcia/yenta_socket.c                    |    1 -
 drivers/scsi/pcmcia/aha152x_stub.c               |   48 +--
 drivers/scsi/pcmcia/fdomain_stub.c               |   24 +-
 drivers/scsi/pcmcia/nsp_cs.c                     |  182 ++--------
 drivers/scsi/pcmcia/qlogic_stub.c                |   24 +-
 drivers/scsi/pcmcia/sym53c500_cs.c               |   22 +-
 drivers/serial/serial_cs.c                       |  205 ++++-------
 drivers/ssb/main.c                               |    1 -
 drivers/ssb/pcmcia.c                             |    1 -
 drivers/ssb/scan.c                               |    1 -
 drivers/staging/comedi/drivers/cb_das16_cs.c     |   58 +---
 drivers/staging/comedi/drivers/das08_cs.c        |  129 +-------
 drivers/staging/comedi/drivers/ni_daq_700.c      |  130 +-------
 drivers/staging/comedi/drivers/ni_daq_dio24.c    |  130 +-------
 drivers/staging/comedi/drivers/ni_labpc_cs.c     |  144 +-------
 drivers/staging/comedi/drivers/ni_mio_cs.c       |   23 +-
 drivers/staging/comedi/drivers/quatech_daqp_cs.c |  124 +------
 drivers/staging/wlags49_h2/wl_cs.c               |   77 +----
 drivers/staging/wlags49_h2/wl_internal.h         |    1 -
 drivers/staging/wlags49_h2/wl_main.c             |   19 -
 drivers/telephony/ixj_pcmcia.c                   |   41 +--
 drivers/usb/host/sl811_cs.c                      |   68 +---
 include/pcmcia/cs.h                              |   95 -----
 include/pcmcia/ds.h                              |   85 +++--
 include/pcmcia/ss.h                              |    1 -
 sound/pcmcia/pdaudiocf/pdaudiocf.c               |   16 +-
 sound/pcmcia/pdaudiocf/pdaudiocf.h               |    1 -
 sound/pcmcia/vx/vxpocket.c                       |   15 +-
 sound/pcmcia/vx/vxpocket.h                       |    1 -
 96 files changed, 1327 insertions(+), 4135 deletions(-)
 delete mode 100644 include/pcmcia/cs.h
