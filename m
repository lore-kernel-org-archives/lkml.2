Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755938Ab1GQLT7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jul 2011 07:19:59 -0400
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:2025 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755751Ab1GQLT6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jul 2011 07:19:58 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [GIT PATCHES FOR 3.1] v4l-dvb: add and use poll_requested_events() function
Date: Sun, 17 Jul 2011 13:19:48 +0200
User-Agent: KMail/1.13.5 (Linux/3.0.0-rc7-tschai; KDE/4.6.2; x86_64; ; )
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk,
        Jonathan Corbet <corbet@lwn.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201107171319.48483.hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mauro,

This patch series adds the poll_requested_events() function and uses it in
the V4L2 core and the ivtv driver.

The poll patch is unchanged from the RFCv3 patch posted a week ago and the
other patches are unchanged from the RFCv1 patch series posted last Wednesday
on the linux-media list.

Tested with vivi and ivtv.

Regards,

	Hans

The following changes since commit bec969c908bb22931fd5ab8ecdf99de8702a6a31:

  [media] v4l: s5p-tv: add TV Mixer driver for Samsung S5P platform (2011-07-14 13:09:48 -0300)

are available in the git repository at:
  ssh://linuxtv.org/git/hverkuil/media_tree.git poll

Hans Verkuil (6):
      poll: add poll_requested_events() function
      ivtv: only start streaming in poll() if polling for input.
      videobuf2: only start streaming in poll() if so requested by the poll mask.
      videobuf: only start streaming in poll() if so requested by the poll mask.
      videobuf2-core: also test for pending events.
      vivi: let vb2_poll handle events.

 drivers/media/video/ivtv/ivtv-fileops.c |    6 ++-
 drivers/media/video/videobuf-core.c     |    3 +-
 drivers/media/video/videobuf2-core.c    |   48 +++++++++++++++++++++---------
 drivers/media/video/vivi.c              |    9 +-----
 fs/eventpoll.c                          |   19 +++++++++--
 fs/select.c                             |   38 +++++++++++-------------
 include/linux/poll.h                    |    7 ++++-
 7 files changed, 78 insertions(+), 52 deletions(-)
