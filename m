Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753698Ab1GFOze (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 10:55:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14371 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753375Ab1GFOzd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 10:55:33 -0400
Message-ID: <4E14775D.9010503@redhat.com>
Date: Wed, 06 Jul 2011 11:55:25 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110624 Thunderbird/5.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL for v3.1-rc7] media fixes
X-Enigmail-Version: 1.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:
  ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git v4l_for_linus

For a series of bug fixes:
	- mx1-camera were using an uninitialized variable;
	- pwc issues at USB disconnect;
	- several mceusb and lirc fixes;
	- some OOPSes fixes at uvc driver;
	- some videobuf2 fixes;
	- some omap1 camera fixes;
	- m5mols/s5p-fimc fixes (this is a driver added at 3.0 merge window);

Thanks!
Mauro

The following changes since commit d364ee4fdb33a329b16cdf9342e9770b4d4ddc83:

  [media] soc_camera: preserve const attribute (2011-06-01 15:03:56 -0300)

are available in the git repository at:
  ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git v4l_for_linus

Andre Bartke (1):
      [media] V4L: mx1-camera: fix uninitialized variable

Hans de Goede (1):
      [media] pwc: better usb disconnect handling

HeungJun, Kim (4):
      [media] m5mols: Fix capture image size register definition
      [media] m5mols: add m5mols_read_u8/u16/u32() according to I2C byte width
      [media] m5mols: remove union in the m5mols_get_version(), and VERSION_SIZE
      [media] m5mols: Use proper email address format

Jarod Wilson (20):
      [media] mceusb: add and use mce_dbg printk macro
      [media] mceusb: support I-O Data GV-MC7/RCKIT
      [media] mceusb: mce_sync_in is brain-dead
      [media] [staging] lirc_imon: fix unused-but-set warnings
      [media] [staging] lirc_sir: fix unused-but-set warnings
      [media] lirc_dev: store cdev in irctl, up maxdevs
      [media] fintek-cir: make suspend with active IR more reliable
      [media] nuvoton-cir: in_use isn't actually in use, remove it
      [media] mceusb: plug memory leak on data transmit
      [media] imon: support for 0x46 0xffdc imon vfd
      [media] imon: fix initial panel key repeat suppression
      [media] ite-cir: 8709 needs to use pnp resource 2
      [media] keymaps: fix table for pinnacle pctv hd devices
      [media] lirc_zilog: fix spinning rx thread
      [media] [staging] lirc_serial: allocate irq at init time
      [media] rc: fix ghost keypresses with certain hw
      [media] saa7134: fix raw IR timeout value
      [media] imon: auto-config ffdc 7e device
      [media] imon: allow either proto on unknown 0xffdc
      [media] rc: call input_sync after scancode reports

Laurent Pinchart (2):
      [media] v4l: Don't access media entity after is has been destroyed
      [media] uvcvideo: Ignore entities for terminals with no supported format

Marek Szyprowski (5):
      [media] MAINTAINERS: Add videobuf2 maintainers
      [media] media: vb2: add __GFP_NOWARN to dma-sg allocator
      [media] Revert "[media] v4l2: vb2: one more fix for REQBUFS()"
      [media] media: vb2: reset queued_count value during queue reinitialization
      [media] media: vb2: fix allocation failure check

Ohad Ben-Cohen (1):
      [media] media: omap3isp: fix a potential NULL deref

Sjoerd Simons (2):
      [media] uvcvideo: Remove buffers from the queues when freeing
      [media] uvcvideo: Disable the queue when failing to start

Sylwester Nawrocki (7):
      [media] s5p-fimc: Fix possible memory leak during capture devnode registration
      [media] s5p-fimc: Fix V4L2_PIX_FMT_RGB565X description
      [media] s5p-fimc: Fix data structures documentation and cleanup debug trace
      [media] s5p-fimc: Fix wrong buffer size in queue_setup
      [media] s5p-fimc: Remove empty buf_init operation
      [media] s5p-fimc: Use pix_mp for the color format lookup
      [media] s5p-fimc: Update copyright notices

Vaibhav Hiremath (2):
      [media] OMAP_VOUT: Change hardcoded device node number to -1
      [media] omap_vout: Added check in reqbuf & mmap for buf_size allocation

Vladimir Pantelic (1):
      [media] OMAP_VOUTLIB: Fix wrong resizer calculation

 MAINTAINERS                                    |    9 ++
 drivers/media/rc/fintek-cir.c                  |    5 +
 drivers/media/rc/imon.c                        |   19 +++-
 drivers/media/rc/ir-raw.c                      |    4 +-
 drivers/media/rc/ite-cir.c                     |   12 ++-
 drivers/media/rc/ite-cir.h                     |    3 +
 drivers/media/rc/keymaps/rc-pinnacle-pctv-hd.c |   58 ++++-----
 drivers/media/rc/lirc_dev.c                    |   37 ++++--
 drivers/media/rc/mceusb.c                      |   80 ++++++-------
 drivers/media/rc/nuvoton-cir.c                 |    2 -
 drivers/media/rc/nuvoton-cir.h                 |    1 -
 drivers/media/rc/rc-main.c                     |   48 ++++----
 drivers/media/video/m5mols/m5mols.h            |   57 +++++-----
 drivers/media/video/m5mols/m5mols_capture.c    |   22 ++--
 drivers/media/video/m5mols/m5mols_controls.c   |    6 +-
 drivers/media/video/m5mols/m5mols_core.c       |  144 ++++++++++++++--------
 drivers/media/video/m5mols/m5mols_reg.h        |   21 +++-
 drivers/media/video/mx1_camera.c               |   10 +-
 drivers/media/video/omap/omap_vout.c           |   18 +++-
 drivers/media/video/omap/omap_voutlib.c        |    6 +-
 drivers/media/video/omap3isp/isp.c             |    2 +-
 drivers/media/video/pwc/pwc-ctrl.c             |    2 +-
 drivers/media/video/pwc/pwc-if.c               |  152 ++++++++----------------
 drivers/media/video/pwc/pwc.h                  |    4 +-
 drivers/media/video/s5p-fimc/fimc-capture.c    |   21 +---
 drivers/media/video/s5p-fimc/fimc-core.c       |   28 ++---
 drivers/media/video/s5p-fimc/fimc-core.h       |   29 ++---
 drivers/media/video/saa7134/saa7134-input.c    |    2 +-
 drivers/media/video/uvc/uvc_entity.c           |   34 ++++--
 drivers/media/video/uvc/uvc_queue.c            |    2 +
 drivers/media/video/uvc/uvc_video.c            |    4 +-
 drivers/media/video/v4l2-dev.c                 |   39 +-----
 drivers/media/video/videobuf2-core.c           |   14 +--
 drivers/media/video/videobuf2-dma-sg.c         |    2 +-
 drivers/staging/lirc/lirc_imon.c               |   10 +--
 drivers/staging/lirc/lirc_serial.c             |   44 ++++----
 drivers/staging/lirc/lirc_sir.c                |   11 +--
 drivers/staging/lirc/lirc_zilog.c              |    4 +-
 include/media/lirc_dev.h                       |    2 +-
 include/media/m5mols.h                         |    4 +-
 40 files changed, 479 insertions(+), 493 deletions(-)

