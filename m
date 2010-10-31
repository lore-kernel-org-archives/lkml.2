Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755733Ab0JaN6T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Oct 2010 09:58:19 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:58997 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752004Ab0JaN6Q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Oct 2010 09:58:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=QQ73qFTCHIeQYBx95Wxy2L1yOtoX+Yns922qznaXj7MUcqbwkj++GLk+pOJAtCwbR4
         n9dVdEqrT6lnhKAMUiCzGo1uaQqTzrIUSbhHgw5EMOcf5O9Ig1L6F4t/YTanBXKeTMwP
         UQVgOzW8yq6LA0iH23wmrt75hmAGhM3CVnfCI=
MIME-Version: 1.0
In-Reply-To: <1288464215.3017.34.camel@localhost.localdomain>
References: <1288464215.3017.34.camel@localhost.localdomain>
Date: Sun, 31 Oct 2010 16:58:13 +0300
Message-ID: <AANLkTikNq985RtHN3-9w1QLiNyxc7qha69NCDum76E6h@mail.gmail.com>
Subject: Re: [GIT PULL] notification tree
From: Alexey Zaytsev <alexey.zaytsev@gmail.com>
To: Eric Paris <eparis@redhat.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Eric.

Now that the interface seems to be more or less set, could you please
document the new syscalls?
The last design document I could find is from 2009, and there seem to
be some updates.

On Sat, Oct 30, 2010 at 22:43, Eric Paris <eparis@redhat.com> wrote:
> The notification tree has patches to address a number of fanotify
> complaints from last cycle.  The most important being the (ABI
> compatible) addition of 'classes' which will allow things like
> hierarchical storage managers to receive events before scanners or
> indexers.  It also includes default limits on the amount of memory an
> fanotify listener can consume and other minor changes.  An updated
> example program which makes use of most all of the fanotify feature set
> can be found at
>
> http://git.infradead.org/users/eparis/fanotify-example.git
>
> ---
>
> The following changes since commit 2d10d8737ccdba752d60106abbc6ed4f37404923:
>
>  Merge branches 'x86-fixes-for-linus' and 'x86-uv-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip (2010-10-29 18:58:00 -0700)
>
> are available in the git repository at:
>
>  git://git.infradead.org/users/eparis/notify.git for-linus
>
> Andrew Morton (1):
>      fs/notify/fanotify/fanotify_user.c: fix warnings
>
> Eric Paris (17):
>      fanotify: allow fanotify to be built
>      fsnotify: implement ordering between notifiers
>      fanotify: implement fanotify listener ordering
>      fanotify: use __aligned_u64 in fanotify userspace metadata
>      fsnotify: correctly handle return codes from listeners
>      fsnotify: call fsnotify_parent in perm events
>      fanotify: allow userspace to flush all marks
>      fanotify: ignore fanotify ignore marks if open writers
>      fsnotify: implement a default maximum queue depth
>      fanotify: allow userspace to override max queue depth
>      fanotify: limit the number of marks in a single fanotify group
>      fanotify: allow userspace to override max marks
>      fanotify: limit number of listeners per user
>      fanotify: do not send events for irregular files
>      fsnotify: rename FS_IN_ISDIR to FS_ISDIR
>      fanotify: ignore events on directories unless specifically requested
>      fanotify: do not recalculate the mask if the ignored mask changed
>
> Lino Sanfilippo (2):
>      make fanotify_read() restartable across signals
>      Ensure FMODE_NONOTIFY is not set by userspace
>
> Richard Kennedy (1):
>      fsnotify: remove alignment padding from fsnotify_mark on 64 bit builds
>
> Stefan Hajnoczi (1):
>      fanotify: Fix FAN_CLOSE comments
>
>  fs/notify/Kconfig                  |    2 +-
>  fs/notify/fanotify/fanotify.c      |   27 ++++++++--
>  fs/notify/fanotify/fanotify_user.c |   98 +++++++++++++++++++++++++++++++++---
>  fs/notify/fsnotify.c               |   35 ++++++++-----
>  fs/notify/inode_mark.c             |    9 +++-
>  fs/notify/inotify/inotify_user.c   |    2 +-
>  fs/notify/vfsmount_mark.c          |    6 ++-
>  include/linux/Kbuild               |    1 +
>  include/linux/fanotify.h           |   36 ++++++++++---
>  include/linux/fsnotify.h           |   38 ++++++++------
>  include/linux/fsnotify_backend.h   |   26 +++++++--
>  include/linux/sched.h              |    3 +
>  12 files changed, 219 insertions(+), 64 deletions(-)
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
