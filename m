Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758698Ab2CHV5h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 16:57:37 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:36083 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757815Ab2CHV5f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 16:57:35 -0500
Date: Fri, 9 Mar 2012 01:57:31 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Andy Lutomirski <luto@amacapital.net>, Kees Cook <keescook@chromium.org>
Cc: Oleg Nesterov <oleg@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Pavel Emelyanov <xemul@parallels.com>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Will Drewry <wad@chromium.org>
Subject: Re: [RFC] c/r: prctl: Add ability to set new mm_struct::exe_file v3
Message-ID: <20120308215731.GP21812@moon>
References: <20120308165112.GF21812@moon>
 <CAGXu5j+4RRGjzVxLSyz0CZCNMj4dPOxJp3pYGSN_sXFsiMhUaQ@mail.gmail.com>
 <20120308194008.GJ21812@moon>
 <CALCETrXpQOpAN64gfG-=iyXXy4Tid=9FyKVrT2grQxRgNPC-fg@mail.gmail.com>
 <20120308200729.GL21812@moon>
 <CALCETrXc9Etit+DUuxKtUwRKmqbwbE5vhDNYWgs0ijEesY8cUA@mail.gmail.com>
 <20120308202136.GM21812@moon>
 <CALCETrVe6VQgdEkZBv24ZaS-N8bFLr9umhgmBsHB6CMH699ykA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrVe6VQgdEkZBv24ZaS-N8bFLr9umhgmBsHB6CMH699ykA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 08, 2012 at 12:24:38PM -0800, Andy Lutomirski wrote:
> 
> nnp is no_new_privs, which is my patch and is almost, but not quite,
> very relevant to this discussion.  Hence my confusion ;)
> 
> FWIW, since I've touched this code recently, the cleanup you're
> suggesting sounds good.
> 

Andy, Kees, I guess the patch below might be a helper we need,
while I'm not sure on naming. hm?

	Cyrill
---
 include/linux/fs.h |    6 ++++++
 1 file changed, 6 insertions(+)

Index: linux-2.6.git/include/linux/fs.h
===================================================================
--- linux-2.6.git.orig/include/linux/fs.h
+++ linux-2.6.git/include/linux/fs.h
@@ -2669,5 +2669,11 @@ static inline void inode_has_no_xattr(st
 		inode->i_flags |= S_NOSEC;
 }
 
+static inline bool file_may_exec(struct file *f)
+{
+	return S_ISREG(f->f_path.dentry->d_inode->i_mode) &&
+		!(f->f_path.mnt->mnt_flags & MNT_NOEXEC);
+}
+
 #endif /* __KERNEL__ */
 #endif /* _LINUX_FS_H */
