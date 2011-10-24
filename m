Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932116Ab1JXL5Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 07:57:24 -0400
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:1694 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755725Ab1JXL5W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 07:57:22 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: [GIT PATCHES FOR 3.2] add poll_requested_events() function
Date: Mon, 24 Oct 2011 13:57:06 +0200
User-Agent: KMail/1.13.7 (Linux/3.0-6.slh.5-aptosid-686; KDE/4.6.5; i686; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Jonathan Corbet <corbet@lwn.net>, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201110241357.06816.hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since there have been no more comment on RFCv4 of this patch series
(http://comments.gmane.org/gmane.linux.kernel/1196926), I'm posting this
pull request for v3.2.

I never received any acks or comments from Al Viro (or anyone else from
linux-fsdevel for that matter), so I'm following Andrew's suggestion and I just
go ahead with this.

This series should be pulled in via the media git repository since the media
drivers are the primary users of the new poll_requested_events() function.

Regards,

	Hans

The following changes since commit a63366b935456dd0984f237642f6d4001dcf8017:

  [media] mxl111sf: update demod_ops.info.name to "MaxLinear MxL111SF DVB-T demodulator" (2011-10-24 
03:20:09 +0200)

are available in the git repository at:
  ssh://linuxtv.org/git/hverkuil/media_tree.git pollv3

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
 fs/eventpoll.c                          |   18 +++++++++--
 fs/select.c                             |   38 +++++++++++-------------
 include/linux/poll.h                    |   13 ++++++++-
 7 files changed, 84 insertions(+), 51 deletions(-)
