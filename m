Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932884Ab2JESjk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 14:39:40 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:54015 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932699Ab2JESji (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 14:39:38 -0400
Date: Fri, 5 Oct 2012 14:39:33 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Anatol Pomozov <anatol.pomozov@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk,
        linux-kernel@vger.kernel.org, Louis Huemiller <lhuemill@google.com>
Subject: Re: [PATCH] fs: Preserve error code in get_empty_filp()
Message-ID: <20121005183933.GA12693@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Anatol Pomozov <anatol.pomozov@gmail.com>,
	linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk,
	linux-kernel@vger.kernel.org, Louis Huemiller <lhuemill@google.com>
References: <1347505915-27984-1-git-send-email-anatol.pomozov@gmail.com>
 <CAOMFOmWEifGsiq3t93FL6xjPDy1Y0OTJ+h+mek0Q=cn_sb+j2w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOMFOmWEifGsiq3t93FL6xjPDy1Y0OTJ+h+mek0Q=cn_sb+j2w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 05, 2012 at 11:16:12AM -0700, Anatol Pomozov wrote:
> Hi, AlViro
> 
> Is any reason why this change is ignored? For me it looks like a
> straightforward bugfix.
> 
> A little bit of context for this change. We at Google work on a test
> framework that shows how kernel behaves under memory pressure. In the
> codepath that I am fixing the syscalls return ENFILE error, but in
> fact the correct error would be ENOMEM. get_empty_filp() should
> preserve the original error and not to replace all errors with ENFILE.

Anatol,

I suggest that you rebase this patch against the latest kernel and
then resend it; I just tried editing out the angle brackets, and the
patch completely failed to apply; every single patch hunk was rejected
by patch(1).  This may be because when you forwarded the patch as a
reply, the whitespace got corrupted --- but that's why I never
recommend resending a patch as part of a reply.  Instead, send a new
patch as a new thread, freshly regenerated against whatever is most
likely to be useful to the maintainer (aviro in this case) and then
put a ping as a comment or in the subject line.

Cheers,

						- Ted

% patch -b -p1 < /tmp/patch 
patching file arch/ia64/kernel/perfmon.c
Hunk #1 FAILED at 2221.
1 out of 1 hunk FAILED -- saving rejects to file arch/ia64/kernel/perfmon.c.rej
patching file fs/anon_inodes.c
Hunk #1 FAILED at 160.
1 out of 1 hunk FAILED -- saving rejects to file fs/anon_inodes.c.rej
patching file fs/file_table.c
Hunk #2 FAILED at 108.
Hunk #3 FAILED at 117.
Hunk #4 FAILED at 149.
Hunk #5 FAILED at 173.
4 out of 5 hunks FAILED -- saving rejects to file fs/file_table.c.rej
patching file fs/hugetlbfs/inode.c
Hunk #1 FAILED at 984.
1 out of 1 hunk FAILED -- saving rejects to file fs/hugetlbfs/inode.c.rej
patching file fs/namei.c
Hunk #1 FAILED at 2885.
1 out of 1 hunk FAILED -- saving rejects to file fs/namei.c.rej
patching file fs/open.c
Hunk #1 FAILED at 781.
1 out of 1 hunk FAILED -- saving rejects to file fs/open.c.rej
patching file fs/pipe.c
Hunk #1 FAILED at 1035.
1 out of 1 hunk FAILED -- saving rejects to file fs/pipe.c.rej
patching file ipc/shm.c
Hunk #1 FAILED at 1039.
1 out of 1 hunk FAILED -- saving rejects to file ipc/shm.c.rej
patching file mm/shmem.c
Hunk #1 FAILED at 2948.
1 out of 1 hunk FAILED -- saving rejects to file mm/shmem.c.rej
patching file net/socket.c
Hunk #1 FAILED at 369.
1 out of 1 hunk FAILED -- saving rejects to file net/socket.c.rej
