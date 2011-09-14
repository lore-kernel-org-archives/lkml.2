Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932873Ab1INQA2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 12:00:28 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:33740 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753431Ab1INQA0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 12:00:26 -0400
Date: Wed, 14 Sep 2011 20:00:19 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: Pavel Machek <pavel@ucw.cz>, Andrew Morton <akpm00@gmail.com>,
        linux-kernel@vger.kernel.org, containers@lists.osdl.org,
        linux-fsdevel@vger.kernel.org, Kirill Shutemov <kirill@shutemov.name>,
        Pavel Emelyanov <xemul@parallels.com>,
        James Bottomley <jbottomley@parallels.com>,
        Nathan Lynch <ntl@pobox.com>, Zan Lynx <zlynx@acm.org>,
        Daniel Lezcano <dlezcano@fr.ibm.com>, Tejun Heo <tj@kernel.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 2/2] fs, proc: Introduce the /proc/<pid>/map_files/
 directory v12
Message-ID: <20110914160018.GW25367@sun>
References: <20110913211359.674453213@openvz.org>
 <20110913212447.918816776@openvz.org>
 <20110913235222.043927b3.akpm@linux-foundation.org>
 <20110914105607.GP25367@sun>
 <20110914111437.GA22516@atrey.karlin.mff.cuni.cz>
 <20110914113912.GQ25367@sun>
 <20110914134405.GV25367@sun>
 <20110914144841.GA7906@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110914144841.GA7906@albatros>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 14, 2011 at 06:48:41PM +0400, Vasiliy Kulikov wrote:
...
> 
> Actually now I see the difference between having something mapped and
> having an _fd_ of this something.
> 
> Relevant code:
> 
> +static struct dentry *
> +proc_map_files_instantiate(struct inode *dir, struct dentry *dentry,
> +              struct task_struct *task, const void *ptr)
> +{
> ...
> +   inode->i_mode = S_IFLNK;
> +
> +   if (file->f_mode & FMODE_READ)
> +       inode->i_mode |= S_IRUSR | S_IXUSR;
> +   if (file->f_mode & FMODE_WRITE)
> +       inode->i_mode |= S_IWUSR | S_IXUSR;
> 
> 
> If you have a write mmap area, but no fd, you may not trunc a file; with
> map_files/ you may get an fd and ftrunc it.
> 

This stands for anonymous memory, and if you have enough rights to
access the task this ftruncate is the last problem (since having ptrace
access to the task I _aready_ can trash various stuff inside, i dont need
even bother to look into map_files/ or whatever). So I don't see how
ftruncate migh harm you here?

	Cyrill
