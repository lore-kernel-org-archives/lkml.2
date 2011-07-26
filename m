Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753783Ab1GZPxy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 11:53:54 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34760 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753509Ab1GZPxr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 11:53:47 -0400
MIME-Version: 1.0
In-Reply-To: <20110726085804.GA1639@x4.trippels.de>
References: <20110725185649.GA22133@ZenIV.linux.org.uk> <20110726033535.GA11939@x4.trippels.de>
 <CA+55aFzaKHpVdLKac6rFN+YsAugz1aR3fv-reThJiD4HWDND8w@mail.gmail.com>
 <20110726082146.GB11939@x4.trippels.de> <CADxeRwnYxgxZPT3DN=SraZOvL_juWzV+MoY9+0vqZr29y6U6cA@mail.gmail.com>
 <20110726085804.GA1639@x4.trippels.de>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 26 Jul 2011 08:52:50 -0700
Message-ID: <CA+55aFz0S3mO9ETFZpsEcbotWV+NMzaFhpZcN09LNAdk+eavjg@mail.gmail.com>
Subject: Re: [git pull] vfs pile 1.5
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: Steven Liu <lingjiujianke@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 26, 2011 at 1:58 AM, Markus Trippelsdorf
<markus@trippelsdorf.de> wrote:
>
> #ifdefs are ugly. The following fixes the issue for me:

Actually, I think the proper fix is just the following
(whitespace-damaged).  It's better to just set ".get_acl" to NULL, and
it's what we used to do back when it was called "check_acl" (see
commit 4e34e719e45).

Christoph?

                  Linus

---
 fs/xfs/xfs_acl.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/xfs/xfs_acl.h b/fs/xfs/xfs_acl.h
index 2c656ef49473..b97a6edcab9d 100644
--- a/fs/xfs/xfs_acl.h
+++ b/fs/xfs/xfs_acl.h
@@ -51,7 +51,7 @@ extern int posix_acl_default_exists(struct inode *inode);
 extern const struct xattr_handler xfs_xattr_acl_access_handler;
 extern const struct xattr_handler xfs_xattr_acl_default_handler;
 #else
-# define xfs_get_acl(inode, type)                      NULL
+# define xfs_get_acl                                   NULL
 # define xfs_inherit_acl(inode, default_acl)           0
 # define xfs_acl_chmod(inode)                          0
 # define posix_acl_access_exists(inode)                        0
