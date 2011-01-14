Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757562Ab1ANDYi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 22:24:38 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:50285 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757048Ab1ANDYc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 22:24:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=aZ9R6cQpeT8VmUr0jzkGoBj0nKRvd5ovk7ALLX5RI8mxz7k3esSXgbjKUzPIFqmEwY
         qoMvehx1tptTveZ/vFHuRJazR6QixuWM3H+iphVXPGZEbB36kFhX/sDI74FVW84tOpWS
         R2bKjBKocyPdv1kgDJ9nlOz5w6taZnAYk3BPg=
MIME-Version: 1.0
Date: Fri, 14 Jan 2011 14:24:30 +1100
Message-ID: <AANLkTi=3UmR6=L-bKSJ2SbioPjaHodgzTj4my9dbNP1L@mail.gmail.com>
Subject: Please pull vfs-scale-working tree
From: Nick Piggin <npiggin@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Git tree is here:

  git://git.kernel.org/pub/scm/linux/kernel/git/npiggin/linux-npiggin.git

Branch is:

    vfs-scale-working

Head:
657e94b673a805b427903c5628e95348235fad06

Diffstat:
 Documentation/filesystems/porting |    8 ++++----
 Documentation/filesystems/vfs.txt |    4 ++--
 fs/namei.c                        |   18 ++++++++++++++++++
 fs/nfs/dir.c                      |    6 +++++-
 include/linux/list_bl.h           |    5 +++--
 include/linux/rculist_bl.h        |    3 ++-
 6 files changed, 34 insertions(+), 10 deletions(-)

Just bug fixes, importantly nfs chroot one that several people are hitting.

d_set_d_op bugs *should* be a thing of the past after the dust settles
from Al's work, so I'm leaving that area alone.

Remaining known bug is an nfsd oops when exporting filesystems that
supply a .d_revalidate(), which is not going to be a common configuration
and I'd like to do a d_revalidate API change to fix it, so don't want to
rush that through.

Thanks,
Nick
