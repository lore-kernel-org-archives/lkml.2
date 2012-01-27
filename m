Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754172Ab2A0Sn6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 13:43:58 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:38019 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753178Ab2A0Sn5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 13:43:57 -0500
Date: Fri, 27 Jan 2012 22:43:51 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Kees Cook <keescook@chromium.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Pavel Emelyanov <xemul@openvz.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>, Tejun Heo <tj@kernel.org>,
        Andrew Vagin <avagin@openvz.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [RFC c/r 4/4] c/r: prctl: Extend PR_SET_MM to set up more
 mm_struct entries
Message-ID: <20120127184351.GI11086@moon>
References: <20120127175342.273260614@openvz.org>
 <20120127175939.928628374@openvz.org>
 <CAGXu5jJtBJGt-8iLrC5Jg9N0K2zeYxDtt8uZojY41osejV_aKg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGXu5jJtBJGt-8iLrC5Jg9N0K2zeYxDtt8uZojY41osejV_aKg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 27, 2012 at 10:37:05AM -0800, Kees Cook wrote:
> On Fri, Jan 27, 2012 at 9:53 AM, Cyrill Gorcunov <gorcunov@openvz.org> wrote:
> > +               if (opt == PR_SET_MM_START_STACK)
> > +                       mm->start_stack = addr;
> > +               else if (opt == PR_SET_MM_ARG_START)
> > +                       mm->arg_start = addr;
> > +               else if (opt == PR_SET_MM_ARG_END)
> > +                       mm->arg_end = addr;
> > +               else if (opt == PR_SET_MM_ENV_START)
> > +                       mm->env_start = addr;
> > +               else if (opt == PR_SET_MM_ENV_END)
> > +                       mm->env_end = addr;
> > +               break;
> 
> Why not a switch statement here? Not that it really matters. :)
> 

Just to look different from toplevel switch, which is better from my POV.

> > +
> > +       case PR_SET_MM_AUXV:
> > +               if (arg4 > sizeof(mm->saved_auxv))
> > +                       goto out;
> > +               up_read(&mm->mmap_sem);
> > +
> > +               error = -EFAULT;
> > +               if (!copy_from_user(mm->saved_auxv, (const void __user *)addr, arg4))
> > +                       error = 0;
> > +
> > +               return error;
> 
> Is the mmap_sem released here because of the copy_from_user()? Is it
> still safe to write to saved_auxv?
> 

At moment I believe yes (if only I'm not missing something), we poke this
vector at elf loading procedure, so it's up to user to sync access to "own"
saved_auxv and write sane values inside.

	Cyrill
