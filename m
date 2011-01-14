Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757564Ab1ANDla (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 22:41:30 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:36262 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751576Ab1ANDlY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 22:41:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=ZDRQspLyaYCfy5tcfZcI045WmU5i/edI5pcPH3QVbC/xkIjE5r/iJTIuEwkRD6RkI8
         VmsIdS2WaL4VU3F/g3D7O0gSKy5JnAsiKGpmIrK4wQHBCpeW2CzW0bfFhd4vdKZFfnsZ
         GOLUe+Bh6HX6xT7o59h112EaFJXZ2FlDRw+vY=
MIME-Version: 1.0
In-Reply-To: <AANLkTi=3UmR6=L-bKSJ2SbioPjaHodgzTj4my9dbNP1L@mail.gmail.com>
References: <AANLkTi=3UmR6=L-bKSJ2SbioPjaHodgzTj4my9dbNP1L@mail.gmail.com>
Date: Fri, 14 Jan 2011 14:41:23 +1100
Message-ID: <AANLkTimjRYref7+7LS7Su=THo6JFBRV0uEyaWwGqeAXT@mail.gmail.com>
Subject: Re: Please pull vfs-scale-working tree
From: Nick Piggin <npiggin@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 14, 2011 at 2:24 PM, Nick Piggin <npiggin@gmail.com> wrote:
> Git tree is here:
>
>  git://git.kernel.org/pub/scm/linux/kernel/git/npiggin/linux-npiggin.git
>
> Branch is:
>
>    vfs-scale-working
>
> Head:
> 657e94b673a805b427903c5628e95348235fad06
>
> Diffstat:
>  Documentation/filesystems/porting |    8 ++++----
>  Documentation/filesystems/vfs.txt |    4 ++--
>  fs/namei.c                        |   18 ++++++++++++++++++
>  fs/nfs/dir.c                      |    6 +++++-
>  include/linux/list_bl.h           |    5 +++--
>  include/linux/rculist_bl.h        |    3 ++-
>  6 files changed, 34 insertions(+), 10 deletions(-)
>
> Just bug fixes, importantly nfs chroot one that several people are hitting.
>
> d_set_d_op bugs *should* be a thing of the past after the dust settles
> from Al's work, so I'm leaving that area alone.
>
> Remaining known bug is an nfsd oops when exporting filesystems that
> supply a .d_revalidate(), which is not going to be a common configuration
> and I'd like to do a d_revalidate API change to fix it, so don't want to
> rush that through.

IOW, I think it would be OK to do an -rc1 with this known issue.
There were no reports of that bug triggering, it was just by review
from J. R. Okajima.

.d_revalidate filesystems tend to be network and cluster and such,
so it won't even affect a large proportion of nfsd servers.

It definitely *will* oops if somebody exports a .d_revalidate filesystem,
but it will be a clean NULL deref, at least.
