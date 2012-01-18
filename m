Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758051Ab2ARSUh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 13:20:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38155 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758013Ab2ARSUR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 13:20:17 -0500
Message-ID: <4F170D5C.4070508@redhat.com>
Date: Wed, 18 Jan 2012 16:20:12 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL for v3.3-rc1] media - mostly fixes
X-Enigmail-Version: 1.3.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:
  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media v4l_for_linus

This series of 57 patches contains (mostly) fixes:

- Some V4L API fixes at the specs and a few non-compliance fixes
  at the drivers;
- DVB API spec, fix DTV_FREQUENCY unit and the ISDB-T parameters.
- pwc driver: Make it more compliant with the V4L2 spec and fix
	some issues on it;
- Make V4L control names more consistent;
- some board fixes to dib0700;
- xc4000 add support for signal strength measures;
- Several bug fixes due to the DVBv5 internal API changes;
- Several other bug fixes.

Thanks!
Mauro

-

Latest commit at the branch: 
36be126cb0ebe3000a65c1049f339a3e882a9a47 [media] as3645a: Fix compilation by including slab.h
The following changes since commit 126400033940afb658123517a2e80eb68259fbd7:

  [media] revert patch: HDIC HD29L2 DMB-TH USB2.0 reference design driver (2012-01-15 11:12:21 -0200)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media v4l_for_linus

Antti Palosaari (4):
      [media] anysee: do not attach same frontend twice
      [media] cxd2820r: do not switch to DVB-T when DVB-C fails
      [media] cxd2820r: wait demod lock for DVB-C too
      [media] cxd2820r: do not allow get_frontend() when demod is not initialized

Dan Carpenter (6):
      [media] cx23885: handle errors from videobuf_dvb_get_frontend()
      [media] mb86a20s: fix off by one checks
      [media] cx231xx: dereferencing NULL after allocation failure
      [media] saa7164: remove duplicate initialization
      [media] tlg2300: fix up check_firmware() return
      [media] ds3000: using logical && instead of bitwise &

Hans Verkuil (11):
      [media] v4l2 spec: clarify usage of V4L2_FBUF_FLAG_OVERLAY
      [media] zoran: do not set V4L2_FBUF_FLAG_OVERLAY
      [media] omap_vout: add missing OVERLAY_OUTPUT cap and set V4L2_FBUF_FLAG_OVERLAY
      [media] V4L2 Spec: fix extended control documentation
      [media] V4L2 Spec: improve the G/S_INPUT/OUTPUT documentation
      [media] v4l2-ioctl: make tuner 'type' check more strict for S_FREQUENCY
      [media] ivtv: remove exclusive radio open
      [media] cx18: remove exclusive open of radio device
      [media] ivtv: switch to the v4l core lock
      [media] ivtv: remove open_id/id from the filehandle code
      [media] v4l2-ctrls: make control names consistent

Hans de Goede (8):
      [media] pwc: Make fps runtime configurable through s_parm, drop fps module param
      [media] pwc: Make decoder data part of the main pwc struct
      [media] pwc: Fix pixfmt handling
      [media] pwc: Avoid sending mode info to the camera when it is not needed
      [media] pwc: Avoid unnecessarily rebuilding the decoder tables
      [media] pwc: Use one shared usb command buffer
      [media] pwc: Remove dev_hint module parameter
      [media] pwc: Simplify leds parameter parsing

Jesper Juhl (1):
      [media] tda18271c2dd: Remove pointless linux/version.h include

Jiri Slaby (4):
      [media] DVB: dib0700, move Nova-TD Stick to a separate set
      [media] DVB: dib0700, separate stk7070pd initialization
      [media] DVB: dib0700, add corrected Nova-TD frontend_attach
      [media] DVB: dib0700, add support for Nova-TD LEDs

Julia Lawall (2):
      [media] drivers/media/video/s5p-fimc/fimc-capture.c: adjust double test
      [media] drivers/media/video/s5p-mfc/s5p_mfc.c: adjust double test

Kamil Debski (2):
      [media] s5p-mfc: Fix volatile controls setup
      [media] s5p-g2d: fixed a bug in controls setting function

Laurent Pinchart (1):
      [media] as3645a: Fix compilation by including slab.h

Marek Szyprowski (1):
      [media] s5p-jpeg: adapt to recent videobuf2 changes

Mauro Carvalho Chehab (6):
      [media] dvb-core: fix a regression with MythTV
      [media] dvb-core: preserve the delivery system at cache clear
      [media] DocBook/dvbproperty.xml: Fix the units for DTV_FREQUENCY
      [media] DocBook/dvbproperty.xml: Fix ISDB-T delivery system parameters
      [media] DocBook/dvbproperty.xml: Remove DTV_MODULATION from ISDB-T
      [media] dvb_frontend: Don't call get_frontend() if idle

Miroslav Slugen (6):
      [media] cx23885-dvb: check if dvb_attach() succeded
      [media] cx23885: Don't duplicate xc4000 entry for radio
      [media] cx88: fix: don't duplicate xc4000 entry for radio
      [media] tuner: Fix numberspace conflict between xc4000 and pti 5nf05 tuners
      [media] xc4000: add support for signal strength measures
      [media] Add registers names to XC2028 tuner from datahseet and use them

Patrick Boettcher (2):
      [media] DVB-CORE: remove superfluous DTV_CMDs
      [media] : add MODULE_FIRMWARE to dib0700

Sachin Kamat (3):
      [media] s5p-fimc: Fix incorrect control ID assignment
      [media] s5p-mfc: Remove linux/version.h include from s5p_mfc.c
      [media] s5p-fimc: Remove linux/version.h include from fimc-mdevice.c

 Documentation/DocBook/media/dvb/dvbproperty.xml    |   12 +-
 .../DocBook/media/v4l/vidioc-g-ext-ctrls.xml       |   18 +-
 Documentation/DocBook/media/v4l/vidioc-g-fbuf.xml  |   23 ++-
 .../DocBook/media/v4l/vidioc-g-frequency.xml       |    7 +-
 Documentation/DocBook/media/v4l/vidioc-g-input.xml |    4 +-
 .../DocBook/media/v4l/vidioc-g-output.xml          |    5 +-
 Documentation/feature-removal-schedule.txt         |   11 -
 Documentation/video4linux/v4l2-controls.txt        |   21 --
 drivers/media/common/tuners/tuner-xc2028.c         |   27 ++-
 drivers/media/common/tuners/xc4000.c               |   86 +++++++
 drivers/media/dvb/dvb-core/dvb_frontend.c          |   41 ++--
 drivers/media/dvb/dvb-usb/anysee.c                 |   20 +-
 drivers/media/dvb/dvb-usb/dib0700.h                |    2 +
 drivers/media/dvb/dvb-usb/dib0700_core.c           |    1 +
 drivers/media/dvb/dvb-usb/dib0700_devices.c        |  150 +++++++++++-
 drivers/media/dvb/frontends/cxd2820r_core.c        |   10 +-
 drivers/media/dvb/frontends/ds3000.c               |    2 +-
 drivers/media/dvb/frontends/mb86a20s.c             |    8 +-
 drivers/media/dvb/frontends/tda18271c2dd.c         |    1 -
 drivers/media/video/as3645a.c                      |    1 +
 drivers/media/video/cx18/cx18-fileops.c            |   41 ++---
 drivers/media/video/cx231xx/cx231xx-cards.c        |    2 +-
 drivers/media/video/cx23885/cx23885-cards.c        |    4 +-
 drivers/media/video/cx23885/cx23885-dvb.c          |    5 +
 drivers/media/video/cx23885/cx23885-video.c        |    7 +-
 drivers/media/video/cx88/cx88-cards.c              |   24 +-
 drivers/media/video/ivtv/ivtv-driver.c             |    3 -
 drivers/media/video/ivtv/ivtv-driver.h             |    3 +-
 drivers/media/video/ivtv/ivtv-fileops.c            |  118 ++++------
 drivers/media/video/ivtv/ivtv-ioctl.c              |   22 +--
 drivers/media/video/ivtv/ivtv-irq.c                |    4 +-
 drivers/media/video/ivtv/ivtv-streams.c            |    2 +-
 drivers/media/video/ivtv/ivtv-yuv.c                |   22 ++-
 drivers/media/video/omap/omap_vout.c               |    7 +-
 drivers/media/video/pwc/pwc-ctrl.c                 |  239 +++++++++-----------
 drivers/media/video/pwc/pwc-dec1.c                 |   16 +-
 drivers/media/video/pwc/pwc-dec1.h                 |    6 +-
 drivers/media/video/pwc/pwc-dec23.c                |   41 ++--
 drivers/media/video/pwc/pwc-dec23.h                |    9 +-
 drivers/media/video/pwc/pwc-if.c                   |  175 ++-------------
 drivers/media/video/pwc/pwc-misc.c                 |    1 -
 drivers/media/video/pwc/pwc-v4l.c                  |   90 ++++++--
 drivers/media/video/pwc/pwc.h                      |   14 +-
 drivers/media/video/s5p-fimc/fimc-capture.c        |    7 +-
 drivers/media/video/s5p-fimc/fimc-core.c           |    6 +-
 drivers/media/video/s5p-fimc/fimc-mdevice.c        |    1 -
 drivers/media/video/s5p-g2d/g2d.c                  |    1 +
 drivers/media/video/s5p-jpeg/jpeg-core.c           |    7 +-
 drivers/media/video/s5p-mfc/s5p_mfc.c              |    3 +-
 drivers/media/video/s5p-mfc/s5p_mfc_dec.c          |    2 +-
 drivers/media/video/saa7164/saa7164-cards.c        |    4 -
 drivers/media/video/tlg2300/pd-main.c              |    4 +-
 drivers/media/video/v4l2-ctrls.c                   |   54 +++---
 drivers/media/video/v4l2-ioctl.c                   |    8 +-
 drivers/media/video/zoran/zoran_driver.c           |    1 -
 include/media/tuner.h                              |    3 +-
 56 files changed, 727 insertions(+), 679 deletions(-)

