Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757264Ab2CFQfc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 11:35:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10176 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755538Ab2CFQfb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 11:35:31 -0500
Date: Tue, 6 Mar 2012 17:28:14 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Matt Helsley <matthltc@us.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Kees Cook <keescook@chromium.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Pavel Emelyanov <xemul@parallels.com>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/1] turn mm->exe_file into mm->exe_path
Message-ID: <20120306162814.GA12836@redhat.com>
References: <20120305152826.GA12419@redhat.com> <20120305211436.GM7666@count0.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120305211436.GM7666@count0.beaverton.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/05, Matt Helsley wrote:
>
> On Mon, Mar 05, 2012 at 04:28:26PM +0100, Oleg Nesterov wrote:
> >
> > Unless there was another subtle reason, "struct path *exe_path"
> > can equally work but it looks more clear.
>
> PATCH 1/1 looks fine. I think Alexey Dobriyan was working on a similar
> patch years ago.

Good, can I take the above as your Acked-by/Reviewed-by ?


> > And can't we also remove added_exe_file_vma/removed_exe_file_vma?
> > Why do we need mm->num_exe_file_vmas? Afaics it is only needed to
> > "free" mm->exe_file if the application unmaps all these vmas. Say,
> > to allow to unmount fs.
>
> Yup. I know it's not pretty to have to track the exe file refs this way
> but I couldn't see any other way to keep a reference to the file (or
> path) and avoid pinning the mounted filesystem the exectuable is on.
>
> > Can't we simply add PR_CLEAR_MM_EXE_PATH instead? Of course it is
> > not enough if ->vm_file still has a reference. But c/r people want
>
> Relying solely on this prctl would break existing programs.

so we can't :/ I expected this answer.

> I believe Al
> Viro's example was a program that copies its text to a new executable
> area, unmaps the original, performs a pivot_root(), and finally umounts
> the old root. Removing the counter would cause the mount to be pinned
> for these programs and the umount would fail.

Yes, sure, the application should do PR_SET_MM_EXE_PATH(NULL) after unmap.
I am wondering if there is any apllication which actually does this.

But OK, it is hardly possible to argue with "break existing program".

Thanks,

Oleg.

