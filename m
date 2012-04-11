Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757030Ab2DKLJG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 07:09:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12890 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756429Ab2DKLJE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 07:09:04 -0400
Message-ID: <4F85664C.3020508@redhat.com>
Date: Wed, 11 Apr 2012 08:09:00 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL for v3.4-rc3] media fixes
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:
  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media v4l_for_linus

For some fixes for the media drivers:

- dvb core: there is a regression found when used with xine. For whatever unknown
  reason, xine (and xine-lib clients) wants that the frontend to tell what frequency
  he is using even before the PLL lock (or at least, it expects a non-zero frequency).
  On DVB, the frequency is only actually known after a frequency zig-zag seek, done by
  the DVB core. Anyway, the fix was trivial. That solves Fedora BZ#808871.

- ivtv: fix a regression when selecting the language channel;

- uvc: fix a race-related crash;

- it913x: fixes firmware loading;

- two few trivial patches (a dependency issue at a radio driver at sound Kconfig,
  and a warning fix on dvb).

Regards,
Mauro

-

Latest commit at the branch: 
ed0ee0ce0a3224dab5caa088a5f8b6df25924276 [media] uvcvideo: Fix race-related crash in uvc_video_clock_update()
The following changes since commit 7483d45f0aee3afc0646d185cabd4af9f6cab58c:

  Merge branch 'staging/for_v3.4' into v4l_for_linus (2012-03-23 08:06:43 -0300)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media v4l_for_linus

Chris Rankin (1):
      [media] dvb_frontend: regression fix: userspace ABI broken for xine

Hans Petter Selasky (1):
      [media] dvb_frontend: fix compiler warning

Hans Verkuil (2):
      [media] ivtv: Fix AUDIO_(BILINGUAL_)CHANNEL_SELECT regression
      [media] Drivers/media/radio: Fix build error

Laurent Pinchart (1):
      [media] uvcvideo: Fix race-related crash in uvc_video_clock_update()

Malcolm Priestley (1):
      [media] it913x: fix firmware loading errors

 drivers/media/dvb/dvb-core/dvb_frontend.c |   12 ++++++-
 drivers/media/dvb/dvb-usb/it913x.c        |   54 +++++++++++++++++++++-------
 drivers/media/video/ivtv/ivtv-ioctl.c     |    4 +-
 drivers/media/video/uvc/uvc_video.c       |   50 +++++++++++++++++---------
 sound/pci/Kconfig                         |    4 +-
 5 files changed, 87 insertions(+), 37 deletions(-)

