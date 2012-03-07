Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932716Ab2CGUOg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 15:14:36 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:55518 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757043Ab2CGUOf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 15:14:35 -0500
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
In-Reply-To: <20120307125217.GC20558@moon>
References: <20120307125217.GC20558@moon>
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Date: Thu, 8 Mar 2012 09:14:13 +1300
Message-ID: <CAKgNAkjhoG_3tm0NFzTZTQCHf22S2nScE_7+chCWWpNaFmTk0g@mail.gmail.com>
Subject: Re: [PATCH] prctl: Use CAP_SYS_RESOUCE for PR_SET_MM option
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Pavel Emelyanov <xemul@parallels.com>,
        Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 8, 2012 at 1:52 AM, Cyrill Gorcunov <gorcunov@openvz.org> wrote:
> CAP_SYS_ADMIN is already overloaded left and right,
> so to have more finegrained access control use
> CAP_SYS_RESOUCE here.
>
> The CAP_SYS_RESOUCE is chosen because this prctl
> option allows a current process to adjust some
> fields of memory map descriptor which rather
> represent what the process owns: pointers to
> code, data, stack segments, command line,
> auxilary vector data and etc.

Acked-by: Michael Kerrisk <mtk.manpages@gmail.com>



> Suggested-by: Michael Kerrisk <mtk.manpages@gmail.com>
> CC: Andrew Morton <akpm@linux-foundation.org>
> CC: Pavel Emelyanov <xemul@parallels.com>
> CC: Tejun Heo <tj@kernel.org>
> CC: Oleg Nesterov <oleg@redhat.com>
> CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> CC: Kees Cook <keescook@chromium.org>
> Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
> ---
>  kernel/sys.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> Index: linux-2.6.git/kernel/sys.c
> ===================================================================
> --- linux-2.6.git.orig/kernel/sys.c
> +++ linux-2.6.git/kernel/sys.c
> @@ -1712,7 +1712,7 @@ static int prctl_set_mm(int opt, unsigne
>        if (arg5 || (arg4 && opt != PR_SET_MM_AUXV))
>                return -EINVAL;
>
> -       if (!capable(CAP_SYS_ADMIN))
> +       if (!capable(CAP_SYS_RESOURCE))
>                return -EPERM;
>
>        if (addr >= TASK_SIZE)



-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface"; http://man7.org/tlpi/
