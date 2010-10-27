Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754226Ab0J0SGq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 14:06:46 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:52535 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753622Ab0J0SGn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 14:06:43 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX1+gzGtJhDigeBVGgHhEKA/W+N/2xBrHoazt/Da54F
	o719oqt3ksR2kk
Message-ID: <4CC86A2E.5050704@gmx.de>
Date: Wed, 27 Oct 2010 20:06:38 +0200
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
User-Agent: Mozilla-Thunderbird 2.0.0.24 (X11/20100328)
MIME-Version: 1.0
To: torvalds@linux-foundation.org
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] viafb updates
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull these viafb updates for 2.6.37 from:

   git://github.com/schandinat/linux-2.6.git viafb-next

The biggest part is a redesign of the output device handling which allows now 
limited runtime reconfiguration of the output device setup. Furthermore initial 
support for suspend and resume was added as well as support for the new VX900 
IGP. Some patches also include minor bugfixes and cleanups.


Thanks,

Florian Tobias Schandinat


Deepak Saxena (1):
       Minimal support for viafb suspend/resume

Florian Tobias Schandinat (28):
       viafb: reset correct PLL
       viafb: remove lcdtbl.h
       viafb: remove stub
       viafb: unify output path configuration
       viafb: enable second display channel at central place
       viafb: rework output device routing
       viafb: propagate __init and __devinit
       viafb: reduce viafb_set_iga_path usage
       viafb: add new output device management
       viafb: use new device routing
       viafb: merge the remaining output path with enable functions
       viafb: add interface for output device configuration
       viafb: limit LCD code impact
       viafb: introduce per output device power management
       viafb: vt1636 cleanup
       viafb: fix i2c_transfer error handling
       viafb: enable I2C for CRT
       viafb: reduce I2C timeout and delay
       viafb: add function to change sync polarity per device
       viafb: set sync polarity for all output devices
       viafb: add a mapping of supported output devices
       viafb: rename output devices
       viafb: add documentation for proc interface
       viafb: use proper register for colour when doing fill ops
       viafb: restore display on resume
       viafb: make suspend and resume work (on all machines?)
       viafb: fix hardware acceleration for suspend & resume
       viafb: add initial VX900 support

  Documentation/fb/viafb.txt   |   48 +++
  drivers/video/via/Makefile   |    2 +-
  drivers/video/via/accel.c    |   53 +++--
  drivers/video/via/accel.h    |    3 +-
  drivers/video/via/chip.h     |    3 +
  drivers/video/via/dvi.c      |  189 ++++++++-----
  drivers/video/via/dvi.h      |    4 +-
  drivers/video/via/global.h   |    1 -
  drivers/video/via/hw.c       |  648 ++++++++++++++++++++++++------------------
  drivers/video/via/hw.h       |   53 +++-
  drivers/video/via/ioctl.c    |    2 +
  drivers/video/via/lcd.c      |   90 +++----
  drivers/video/via/lcd.h      |    6 +-
  drivers/video/via/lcdtbl.h   |  591 --------------------------------------
  drivers/video/via/tbl1636.c  |   71 -----
  drivers/video/via/tbl1636.h  |   34 ---
  drivers/video/via/via-core.c |   16 +-
  drivers/video/via/via_i2c.c  |   31 ++-
  drivers/video/via/viafbdev.c |  294 +++++++++++++++++---
  drivers/video/via/viafbdev.h |    7 +
  drivers/video/via/vt1636.c   |  121 +++------
  21 files changed, 1022 insertions(+), 1245 deletions(-)
  delete mode 100644 drivers/video/via/lcdtbl.h
  delete mode 100644 drivers/video/via/tbl1636.c
  delete mode 100644 drivers/video/via/tbl1636.h
