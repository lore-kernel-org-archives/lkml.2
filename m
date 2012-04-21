Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751462Ab2DUELi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2012 00:11:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40691 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750889Ab2DUELh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2012 00:11:37 -0400
Message-ID: <4F923374.4060902@redhat.com>
Date: Sat, 21 Apr 2012 01:11:32 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL for v3.4-rc4] media fixes
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:
  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media v4l_for_linus

for a some fixes for the media drivers:
	- Fixes a regression at DVB core when switching from DVB-S2 to DVB-S 
	  on Kaffeine (Fedora 16 Bugzilla #812895);
	- Fixes a mutex unlock at an error condition at drx-k;
	- Fix winbond-cir set mode;
	- mt9m032: Fix a compilation breakage with some random Kconfig;
	- mt9m032: fix two dead locks;
	- xc5000: don't require an special firmware (that won't be provided by
	  the vendor) just because the xtal frequency is different;
	- V4L DocBook: fix some typos at multi-plane formats description.

Thanks!
Mauro

-

Latest commit at the branch: 
e631f578048e2afd8bfede2e9dc86aa4592def3a [media] xc5000: support 32MHz & 31.875MHz xtal using the 41.024.5 firmware
The following changes since commit ed0ee0ce0a3224dab5caa088a5f8b6df25924276:

  [media] uvcvideo: Fix race-related crash in uvc_video_clock_update() (2012-04-09 10:15:28 -0300)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media v4l_for_linus

Alexey Khoroshilov (1):
      [media] drxk: Does not unlock mutex if sanity check failed in scu_command()

David Härdeman (1):
      [media] rc-core: set mode for winbond-cir

Guennadi Liakhovetski (2):
      [media] V4L: mt9m032: fix two dead-locks
      [media] V4L: mt9m032: fix compilation breakage

Mauro Carvalho Chehab (1):
      [media] dvb_frontend: Fix a regression when switching back to DVB-S

Michael Krufky (1):
      [media] xc5000: support 32MHz & 31.875MHz xtal using the 41.024.5 firmware

Sylwester Nawrocki (1):
      [media] V4L: DocBook: Fix typos in the multi-plane formats description

 Documentation/DocBook/media/v4l/pixfmt-nv12m.xml   |    2 +-
 Documentation/DocBook/media/v4l/pixfmt-yuv420m.xml |    2 +-
 drivers/media/common/tuners/xc5000.c               |   39 ++++++++++++++++++--
 drivers/media/common/tuners/xc5000.h               |    1 +
 drivers/media/dvb/dvb-core/dvb_frontend.c          |   25 ++++++++++++-
 drivers/media/dvb/frontends/drxk_hard.c            |    6 ++-
 drivers/media/rc/winbond-cir.c                     |    1 +
 drivers/media/video/Kconfig                        |    2 +-
 drivers/media/video/mt9m032.c                      |    5 ++-
 9 files changed, 71 insertions(+), 12 deletions(-)

