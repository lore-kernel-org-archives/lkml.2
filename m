Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964857Ab2CEOeJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 09:34:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7150 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932365Ab2CEOeG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 09:34:06 -0500
Date: Mon, 5 Mar 2012 15:26:55 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Kees Cook <keescook@chromium.org>, Tejun Heo <tj@kernel.org>
Subject: Re: [RFC] c/r: prctl: Add ability to set new mm_struct::exe_file
Message-ID: <20120305142655.GC9393@redhat.com>
References: <20120229192400.GA13194@redhat.com> <20120229200103.GJ11326@moon> <20120301180616.GA7652@redhat.com> <20120301191714.GF9930@moon> <20120301194120.GA11400@redhat.com> <20120302142630.GK8681@moon> <20120302152621.GA29744@redhat.com> <20120302161247.GO8681@moon> <20120303223333.GB26846@moon> <20120305142130.GA9393@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120305142130.GA9393@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/05, Oleg Nesterov wrote:
>
> On 03/04, Cyrill Gorcunov wrote:
> >
> > +	err = -EACCES;
> > +	if (!S_ISREG(dentry->d_inode->i_mode)	||
> > +	    exe_file->f_path.mnt->mnt_flags & MNT_NOEXEC)
> > +		goto exit;
> > +
> > +	if ((exe_file->f_flags & O_ACCMODE) != O_RDONLY)
> > +		goto exit;
> > +
> > +	err = inode_permission(dentry->d_inode, MAY_EXEC);
> > +	if (err)
> > +		goto exit;
>
> OK, I won't argue, probably this makes sense to make sure that
> admin can't get a heart attack looking at /proc/pid/exe.
>
> But the O_RDONLY check looks strange. We are not going to write
> to this file, we only set the name (and that is why I think it
> should be mm->exe_path). What is the point to check that the file
> was opened without FMODE_WRITE? Even if there were any security
> risk the apllication can open this file again with the different
> flags.

Seriously, I think we should cleanup this before c/r adds more
ugliness. I'll try to make the patch today.

And with all these checks I am no longer sure that fd is better
than filename ;)

Oleg.

