Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754541Ab1ACLrm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 06:47:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:14168 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753892Ab1ACLrl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 06:47:41 -0500
Message-ID: <4D21B752.8070000@redhat.com>
Date: Mon, 03 Jan 2011 09:47:30 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL for v2.6.37-rc8] V4L/DVB regression fixes
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

There are two regressions affecting audio at ivtv driver. One of them is at the
initial volume setting, and the other one at wm8775, and it is due to a new board
addition on another driver that uses it. Both patches are trivial: one checks
the volume range and the other just reverts the patch that broke wm8775+ivtv.

Could you please merge them before releasing 2.6.37?

Thanks!
Mauro

The following changes since commit 387c31c7e5c9805b0aef8833d1731a5fe7bdea14:

  Linux 2.6.37-rc8 (2010-12-28 17:05:48 -0800)

are available in the git repository at:
  ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git v4l_for_linus

Andy Walls (1):
      [media] cx25840: Prevent device probe failure due to volume control ERANGE error

Mauro Carvalho Chehab (1):
      [media] wm8775: Revert changeset fcb9757333 to avoid a regression

 drivers/media/video/cx25840/cx25840-core.c |   19 +++++-
 drivers/media/video/cx88/cx88-alsa.c       |   99 +++-----------------------
 drivers/media/video/cx88/cx88-cards.c      |    7 ++
 drivers/media/video/cx88/cx88-video.c      |   27 +-------
 drivers/media/video/cx88/cx88.h            |    6 +-
 drivers/media/video/wm8775.c               |  104 ++++++++++-----------------
 include/media/wm8775.h                     |    3 -
 7 files changed, 78 insertions(+), 187 deletions(-)

