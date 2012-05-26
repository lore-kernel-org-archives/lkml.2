Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751634Ab2EZHkO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 03:40:14 -0400
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:3355 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750886Ab2EZHkL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 03:40:11 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [GIT PULL FOR v3.5] Move sta2x11_vip to staging
Date: Sat, 26 May 2012 09:39:58 +0200
User-Agent: KMail/1.13.7 (Linux/3.4.0-rc7-tschai; KDE/4.7.4; x86_64; ; )
Cc: Federico Vaga <federico.vaga@gmail.com>,
        "linux-kernel" <linux-kernel@vger.kernel.org>,
        Giancarlo Asnaghi <giancarlo.asnaghi@st.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201205260939.58100.hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mauro,

This patch moves the sta2x11_vip driver to the staging directory. In my opinion
this driver is not ready for prime-time.

As I mentioned a week ago, I never saw this driver when it was posted as that
was during a period were I was unavoidably absent from the list. The problem
with this driver is that it doesn't use any of the new frameworks (the control
framework and videobuf2 in particular), and this should be corrected first.

In addition it has a clear V4L2 API violation in that only one filehandle at
a time can open the video node. Developers really *must* run v4l2-compliance
before posting a new driver! Almost all of this would be caught by that tool
(except for using videobuf instead of vb2). Personally I think showing the
output of v4l2-compliance should be a requirement for getting a driver merged
under drivers/media/video.

I didn't get any reply from Federico when I posted my concerns last week, so
that makes me unhappy as well.

I hope the author will fix these issues, but in the meantime this will move
it to staging waiting for further developments.

Regards,

	Hans

The following changes since commit 5472d3f17845c4398c6a510b46855820920c2181:

  [media] mt9m032: Implement V4L2_CID_PIXEL_RATE control (2012-05-24 09:27:24 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git sta2x11

for you to fetch changes up to 66e2c2572a2b59df5d9f6043c5706a73ce624f89:

  sta2x11_vip: move to staging. (2012-05-26 09:27:15 +0200)

----------------------------------------------------------------
Hans Verkuil (1):
      sta2x11_vip: move to staging.

 drivers/media/video/Kconfig                                  |   13 -------------
 drivers/media/video/Makefile                                 |    1 -
 drivers/staging/media/Kconfig                                |    2 ++
 drivers/staging/media/Makefile                               |    1 +
 drivers/staging/media/sta2x11/Kconfig                        |   12 ++++++++++++
 drivers/staging/media/sta2x11/Makefile                       |    1 +
 drivers/{media/video => staging/media/sta2x11}/sta2x11_vip.c |    0
 drivers/{media/video => staging/media/sta2x11}/sta2x11_vip.h |    0
 8 files changed, 16 insertions(+), 14 deletions(-)
 create mode 100644 drivers/staging/media/sta2x11/Kconfig
 create mode 100644 drivers/staging/media/sta2x11/Makefile
 rename drivers/{media/video => staging/media/sta2x11}/sta2x11_vip.c (100%)
 rename drivers/{media/video => staging/media/sta2x11}/sta2x11_vip.h (100%)
