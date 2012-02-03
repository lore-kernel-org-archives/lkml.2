Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755558Ab2BCJlN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 04:41:13 -0500
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:3823 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752558Ab2BCJlG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 04:41:06 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: Re: [PATCH 0/6] Add poll_requested_events() function.
Date: Fri, 3 Feb 2012 10:40:10 +0100
User-Agent: KMail/1.13.7 (Linux/3.3.0-rc1-durdane; KDE/4.6.5; x86_64; ; )
Cc: Al Viro <viro@zeniv.linux.org.uk>, Jonathan Corbet <corbet@lwn.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Davide Libenzi <davidel@xmailserver.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Enke Chen <enkechen@cisco.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
References: <1328261325-8452-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1328261325-8452-1-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201202031040.10513.hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, February 03, 2012 10:28:39 Hans Verkuil wrote:
> Hi all,
> 
> This is the eighth version of this patch series and the last as far as
> I am concerned.
> 
> See this link for the previous version and the associated thread:
> 
> http://www.gossamer-threads.com/lists/linux/kernel/1486261
> 
> The changes compared to version 7 are:
> 
> - rebased to the linux-media staging/for_v3.4 branch.
> - renamed the poll_table fields to _qproc and _key as per Andrew's suggestion.
> - all poll changes are back in one patch (the first). With the renaming of
>   fields it made more sense to have it as one patch.
> - added the video4linux changes as well that depend on this new poll
>   behavior. This makes it ready to be merged in linux-media and linux-next.
> 
> Mauro, can you get this patch series in linux-next as soon as possible?
> 
> If anyone has any problems/comments/remarks regarding this patch series,
> then please speak up now and not one day before the 3.4 merge window opens...

I forgot to mention that this patch series is also available in git:

The following changes since commit 59b30294e14fa6a370fdd2bc2921cca1f977ef16:

  Merge branch 'v4l_for_linus' into staging/for_v3.4 (2012-01-23 18:11:30 -0200)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git pollv8

Hans Verkuil (6):
      poll: add poll_requested_events() and poll_does_not_wait() functions
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
 fs/select.c                             |   40 +++++++++++--------------
 include/linux/poll.h                    |   37 ++++++++++++++++++++----
 include/net/sock.h                      |    2 +-
 net/unix/af_unix.c                      |    2 +-
 9 files changed, 106 insertions(+), 59 deletions(-)
