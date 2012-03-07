Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759525Ab2CGRso (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 12:48:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:23242 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757826Ab2CGRsm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 12:48:42 -0500
Date: Wed, 7 Mar 2012 18:41:13 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        adobriyan@gmail.com, ebiederm@xmission.com, keescook@chromium.org,
        kosaki.motohiro@jp.fujitsu.com, matthltc@us.ibm.com, tj@kernel.org,
        xemul@parallels.com
Subject: Re: + mm-exec-rename-mm-exe_file-to-mm-exe_path.patch added to -mm
	tree
Message-ID: <20120307174113.GA25366@redhat.com>
References: <20120306231325.D4B26A0395@akpm.mtv.corp.google.com> <20120307162630.GG20558@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120307162630.GG20558@moon>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

s/mm-commits/lkml/

On 03/07, Cyrill Gorcunov wrote:
>
> On Tue, Mar 06, 2012 at 03:13:25PM -0800, akpm@linux-foundation.org wrote:
> > From: Oleg Nesterov <oleg@redhat.com>
> > Subject: mm/exec: rename mm->exe_file to mm->exe_path
> >
> > Rename mm->exe_file to mm->exe_path.  We only need this member to get the
> > path - an additional reference to bprm->file makes no sense.
> >
> > The patch doesn't rename added_exe_file_vma/removed_exe_file_vma and
> > mm->num_exe_file_vmas, and perhaps we can remove them later.
> >
> > Also remove the stale comment in include/linux/mm.h.
> >
> > Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> > Acked-by: Matt Helsley <matthltc@us.ibm.com>
> > Cc: Alexey Dobriyan <adobriyan@gmail.com>
> > Cc: Cyrill Gorcunov <gorcunov@openvz.org>
> > Cc: "Eric W. Biederman" <ebiederm@xmission.com>
> > Cc: Kees Cook <keescook@chromium.org>
> > Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> > Cc: Pavel Emelyanov <xemul@parallels.com>
> > Cc: Tejun Heo <tj@kernel.org
> > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>
> Hi Oleg, I fear this won't work.

Why?

> The reference to the plain
> path pointer is not enough.

Why? ;)

> Previously we always have a
> copy reference to 'struct file' in mm:exe_file.

And?

> But now we don't have it and as result I can easily trigger
> NULL dereference simply reading /proc/pid/exe link in
> a cycle in one process and kill the program in another.

Thanks!

But so far I disagree, I can't understand why struct path can't work.

Of course I can be wrong, but currently I think that either this patch
reveals another problem (unlikley), or (most likely) I did some stupid
mistake.

Can you send me the reproducer just in case?

> [ 1961.066410] Code: 41 5c 41 5d c9 c3 55 48 89 e5 41 54 53 48 83 ec 30
> 66 66 66 66 90 48 63 c2 89 55 cc 48 89 fb 48 8d 04 06 48 89 45 e8 48 8b
> 7f 08 <48> 8b 87 a8 00 00 00 48 85 c0 74 0d 48 8b 40 38 48 85 c0 74 04

No sure I understand this asm... Looks like path->dentry is NULL, strange.

I do not think I really need it, but just in case... could you send me
(privately) the result of "make fs/dcache.s" ?

I'll try to recheck the patch and think.

But if you can _explain_ why do you think that "struct path" can't work,
please explain ;)

Oleg.

