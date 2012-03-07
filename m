Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758785Ab2CGRDa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 12:03:30 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:36835 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755524Ab2CGRD2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 12:03:28 -0500
MIME-Version: 1.0
In-Reply-To: <20120307125217.GC20558@moon>
References: <20120307125217.GC20558@moon>
Date: Wed, 7 Mar 2012 09:03:27 -0800
X-Google-Sender-Auth: sWapcG1cTC347jj9U_hPw-Fy39o
Message-ID: <CAGXu5jL2QWWdnA-T3RQDWCaOuCcW8dvBXfGFBb6Oe9C1zT3oJw@mail.gmail.com>
Subject: Re: [PATCH] prctl: Use CAP_SYS_RESOUCE for PR_SET_MM option
From: Kees Cook <keescook@chromium.org>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Pavel Emelyanov <xemul@parallels.com>, Tejun Heo <tj@kernel.org>,
        Oleg Nesterov <oleg@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 7, 2012 at 4:52 AM, Cyrill Gorcunov <gorcunov@openvz.org> wrote:
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
>
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

Yeah, getting away from CAP_SYS_ADMIN is a good idea.

Acked-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
ChromeOS Security
