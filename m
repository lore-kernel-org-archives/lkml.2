Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753878Ab2A0ShI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 13:37:08 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:52278 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752319Ab2A0ShG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 13:37:06 -0500
MIME-Version: 1.0
In-Reply-To: <20120127175939.928628374@openvz.org>
References: <20120127175342.273260614@openvz.org>
	<20120127175939.928628374@openvz.org>
Date: Fri, 27 Jan 2012 10:37:05 -0800
X-Google-Sender-Auth: ryPm9oHxu3qFimfim0WBmN-C6y8
Message-ID: <CAGXu5jJtBJGt-8iLrC5Jg9N0K2zeYxDtt8uZojY41osejV_aKg@mail.gmail.com>
Subject: Re: [RFC c/r 4/4] c/r: prctl: Extend PR_SET_MM to set up more
 mm_struct entries
From: Kees Cook <keescook@chromium.org>
To: Cyrill Gorcunov <gorcunov@openvz.org>
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
X-System-Of-Record: true
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 27, 2012 at 9:53 AM, Cyrill Gorcunov <gorcunov@openvz.org> wrote:
> +               if (opt == PR_SET_MM_START_STACK)
> +                       mm->start_stack = addr;
> +               else if (opt == PR_SET_MM_ARG_START)
> +                       mm->arg_start = addr;
> +               else if (opt == PR_SET_MM_ARG_END)
> +                       mm->arg_end = addr;
> +               else if (opt == PR_SET_MM_ENV_START)
> +                       mm->env_start = addr;
> +               else if (opt == PR_SET_MM_ENV_END)
> +                       mm->env_end = addr;
> +               break;

Why not a switch statement here? Not that it really matters. :)

> +
> +       case PR_SET_MM_AUXV:
> +               if (arg4 > sizeof(mm->saved_auxv))
> +                       goto out;
> +               up_read(&mm->mmap_sem);
> +
> +               error = -EFAULT;
> +               if (!copy_from_user(mm->saved_auxv, (const void __user *)addr, arg4))
> +                       error = 0;
> +
> +               return error;

Is the mmap_sem released here because of the copy_from_user()? Is it
still safe to write to saved_auxv?

-Kees

-- 
Kees Cook
ChromeOS Security
