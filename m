Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933023Ab0LTS1t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 13:27:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:25046 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933009Ab0LTS1r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 13:27:47 -0500
Message-ID: <4D0FA00E.6010701@redhat.com>
Date: Mon, 20 Dec 2010 16:27:26 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL for 2.6.37-rc7] V4L/DVB fixes
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:
  ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git v4l_for_linus

For a series of fixes at v4l2 drivers. They fix an OOPS at bttv due to BKL
patches, a series of regressions that happened at gspca sonixj driver, 
affecting most of the sonix Jpeg cams and a duplicated symbol, noticed by
enabling allyesconfig + staging/cx23821.

Thanks!
Mauro

---


The following changes since commit cf7d7e5a1980d1116ee152d25dac382b112b9c17:

  Linux 2.6.37-rc5 (2010-12-06 20:09:04 -0800)

are available in the git repository at:
  ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git v4l_for_linus

Brandon Philips (1):
      [media] bttv: remove unneeded locking comments

Jean-Francois Moine (6):
      [media] gspca - sonixj: Move bridge init to sd start
      [media] gspca - sonixj: Fix a bad probe exchange
      [media] gspca - sonixj: Add a flag in the driver_info table
      [media] gspca - sonixj: Set the flag for some devices
      [media] gspca - sonixj: Add the bit definitions of the bridge reg 0x01 and 0x17
      [media] gspca - sonixj: Better handling of the bridge registers 0x01 and 0x17

Mauro Carvalho Chehab (2):
      [media] Don't export format_by_forcc on two different drivers
      [media] bttv: fix mutex use before init (BZ#24602)

 drivers/media/common/saa7146_hlp.c      |    8 +-
 drivers/media/common/saa7146_video.c    |   16 +-
 drivers/media/video/bt8xx/bttv-driver.c |  117 +---------
 drivers/media/video/gspca/sonixj.c      |  416 ++++++++++++++-----------------
 drivers/staging/cx25821/cx25821-video.c |    8 +-
 drivers/staging/cx25821/cx25821-video.h |    2 +-
 include/media/saa7146.h                 |    2 +-
 7 files changed, 205 insertions(+), 364 deletions(-)

