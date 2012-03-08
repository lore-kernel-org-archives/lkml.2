Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758505Ab2CHTkS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 14:40:18 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:57025 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753151Ab2CHTkO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 14:40:14 -0500
Date: Thu, 8 Mar 2012 23:40:08 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Kees Cook <keescook@chromium.org>
Cc: Oleg Nesterov <oleg@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Pavel Emelyanov <xemul@parallels.com>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>, Will Drewry <wad@chromium.org>
Subject: Re: [RFC] c/r: prctl: Add ability to set new mm_struct::exe_file v3
Message-ID: <20120308194008.GJ21812@moon>
References: <20120308165112.GF21812@moon>
 <CAGXu5j+4RRGjzVxLSyz0CZCNMj4dPOxJp3pYGSN_sXFsiMhUaQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGXu5j+4RRGjzVxLSyz0CZCNMj4dPOxJp3pYGSN_sXFsiMhUaQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 08, 2012 at 11:31:58AM -0800, Kees Cook wrote:
...
> > +       err = -EACCES;
> > +       if (!S_ISREG(dentry->d_inode->i_mode)   ||
> > +           exe_file->f_path.mnt->mnt_flags & MNT_NOEXEC)
> > +               goto exit;
> 
> I'm starting to notice that this pattern (testing ISREG and
> MNT_NOEXEC) is getting repeated a few times in the kernel, and at
> least the no-new-privs patch (not yet in -mm but hopefully soon given
> the seccomp_filter work) updates this pattern everywhere. Perhaps this
> should be extracted into a helper first, and then this patch can call
> that helper here? (And then nnp can just update the single helper.)
> 

I can do that if Andrew agree.

	Cyrill
