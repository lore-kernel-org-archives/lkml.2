Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758762Ab2CHWDP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 17:03:15 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:45942 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758719Ab2CHWDN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 17:03:13 -0500
MIME-Version: 1.0
In-Reply-To: <20120308215731.GP21812@moon>
References: <20120308165112.GF21812@moon>
	<CAGXu5j+4RRGjzVxLSyz0CZCNMj4dPOxJp3pYGSN_sXFsiMhUaQ@mail.gmail.com>
	<20120308194008.GJ21812@moon>
	<CALCETrXpQOpAN64gfG-=iyXXy4Tid=9FyKVrT2grQxRgNPC-fg@mail.gmail.com>
	<20120308200729.GL21812@moon>
	<CALCETrXc9Etit+DUuxKtUwRKmqbwbE5vhDNYWgs0ijEesY8cUA@mail.gmail.com>
	<20120308202136.GM21812@moon>
	<CALCETrVe6VQgdEkZBv24ZaS-N8bFLr9umhgmBsHB6CMH699ykA@mail.gmail.com>
	<20120308215731.GP21812@moon>
Date: Thu, 8 Mar 2012 14:03:13 -0800
X-Google-Sender-Auth: 56_f8UZw1KTVINLY5m-uAKhOewM
Message-ID: <CAGXu5j+fDwk_17bLtx9KdeoCs+hxgksMvxzutJjgB76tP+NV4g@mail.gmail.com>
Subject: Re: [RFC] c/r: prctl: Add ability to set new mm_struct::exe_file v3
From: Kees Cook <keescook@chromium.org>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Andy Lutomirski <luto@amacapital.net>, Oleg Nesterov <oleg@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Pavel Emelyanov <xemul@parallels.com>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Will Drewry <wad@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 8, 2012 at 1:57 PM, Cyrill Gorcunov <gorcunov@openvz.org> wrote:
> On Thu, Mar 08, 2012 at 12:24:38PM -0800, Andy Lutomirski wrote:
>>
>> nnp is no_new_privs, which is my patch and is almost, but not quite,
>> very relevant to this discussion.  Hence my confusion ;)
>>
>> FWIW, since I've touched this code recently, the cleanup you're
>> suggesting sounds good.
>>
>
> Andy, Kees, I guess the patch below might be a helper we need,
> while I'm not sure on naming. hm?
>
>        Cyrill
> ---
>  include/linux/fs.h |    6 ++++++
>  1 file changed, 6 insertions(+)
>
> Index: linux-2.6.git/include/linux/fs.h
> ===================================================================
> --- linux-2.6.git.orig/include/linux/fs.h
> +++ linux-2.6.git/include/linux/fs.h
> @@ -2669,5 +2669,11 @@ static inline void inode_has_no_xattr(st
>                inode->i_flags |= S_NOSEC;
>  }
>
> +static inline bool file_may_exec(struct file *f)
> +{
> +       return S_ISREG(f->f_path.dentry->d_inode->i_mode) &&
> +               !(f->f_path.mnt->mnt_flags & MNT_NOEXEC);
> +}
> +
>  #endif /* __KERNEL__ */
>  #endif /* _LINUX_FS_H */

How about "file_is_exec" instead, since it doesn't (and likely
shouldn't) include the inode_permission(..., EXEC)? I'd like other
people's thoughts on this since maybe it's not needed and I instead
have accidentally derailed this patch with useless bike shedding.

-Kees

-- 
Kees Cook
ChromeOS Security
