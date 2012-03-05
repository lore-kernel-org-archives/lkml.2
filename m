Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756937Ab2CERGE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 12:06:04 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:62411 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754462Ab2CERGB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 12:06:01 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of gorcunov@gmail.com designates 10.205.117.15 as permitted sender) smtp.mail=gorcunov@gmail.com; dkim=pass header.i=gorcunov@gmail.com
Date: Mon, 5 Mar 2012 21:05:56 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Matt Helsley <matthltc@us.ibm.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Kees Cook <keescook@chromium.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Pavel Emelyanov <xemul@parallels.com>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/1] turn mm->exe_file into mm->exe_path
Message-ID: <20120305170556.GC12341@moon>
References: <20120305152826.GA12419@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120305152826.GA12419@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 05, 2012 at 04:28:26PM +0100, Oleg Nesterov wrote:
> I think the patch is simple and self-explanatory, it simply
> does s/mm->exe_file/mm->exe_path/.
> 
> Why do we need mm->exe_file? IIUC, there are 2 reasons:
> 
> 	1. we do not want O(n) proc/pid/exe looking for the 1st
> 	   VM_EXECUTABLE vma.
> 
> 	2. we do not want to rely on vma->vm_file->f_path,
> 	   bprm->file->f_op->mmap can change ->vm_file.
> 
> Unless there was another subtle reason, "struct path *exe_path"
> can equally work but it looks more clear.
> 
> And can't we also remove added_exe_file_vma/removed_exe_file_vma?
> Why do we need mm->num_exe_file_vmas? Afaics it is only needed to
> "free" mm->exe_file if the application unmaps all these vmas. Say,
> to allow to unmount fs.
>
> Can't we simply add PR_CLEAR_MM_EXE_PATH instead? Of course it is
> not enough if ->vm_file still has a reference. But c/r people want
> PR_SET_MM_EXE_FILE anyway, see http://marc.info/?t=133052865500016
> So perhaps we can add PR_SET_MM_EXE_PATH which accepts NULL as well
> and kill this counter?
>

So, if I understand you correctly, if there is exe_path, I would
simply put() it and get() and assign new one. Looks cool for me.

Not sure where we may use PR_SET_MM_EXE_PATH with NULL to kill
num_exe_file_vmas from user space though (or to kill this exe_path
in case if num_exe_file_vmas is removed from code).

	Cyrill
