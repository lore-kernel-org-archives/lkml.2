Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754142Ab2DACKN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2012 22:10:13 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:35193 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753535Ab2DACKL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2012 22:10:11 -0400
MIME-Version: 1.0
In-Reply-To: <20120330234317.GC411@lenovo-rd230-04.lab.bos.redhat.com>
References: <20120330234317.GC411@lenovo-rd230-04.lab.bos.redhat.com>
Date: Sat, 31 Mar 2012 19:10:10 -0700
X-Google-Sender-Auth: z6nHg3NuyJehRX9Ia8wWbyuXiz8
Message-ID: <CAGXu5jJhwy9=dmY_6WZWWxJ2MG2Vb2nwsh5zoQ3ocbvrt7HH0w@mail.gmail.com>
Subject: Re: [PATCH] sysctl: fix restrict write access to dmesg_restrict
From: Kees Cook <keescook@chromium.org>
To: Phillip Lougher <plougher@redhat.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Richard Weinberger <richard@nod.at>,
        Dan Rosenberg <drosenberg@vsecurity.com>,
        "Serge E. Hallyn" <serge@hallyn.com>, Eugene Teo <eteo@redhat.com>,
        Eric Paris <eparis@redhat.com>, James Morris <jmorris@namei.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Actually, proc_dmesg_restrict is just a CAP_SYSADMIN-checking wrapper
around proc_dointvec_minmax. Probably both dmesg_restrict and
kptr_restrict should use it.

On Fri, Mar 30, 2012 at 4:43 PM, Phillip Lougher <plougher@redhat.com> wrote:
> Commit bfdc0b4 adds code to restrict access to dmesg_restrict,
> however, it incorrectly alters kptr_restrict rather than
> dmesg_restrict.
>
> The original patch from Richard Weinberger
> (https://lkml.org/lkml/2011/3/14/362) alters dmesg_restrict as
> expected, and so the patch seems to have been misapplied.
>
> Signed-off-by: Phillip Lougher <plougher@redhat.com>
> ---
>  kernel/sysctl.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/kernel/sysctl.c b/kernel/sysctl.c
> index f487f25..72a5302 100644
> --- a/kernel/sysctl.c
> +++ b/kernel/sysctl.c
> @@ -713,7 +713,7 @@ static struct ctl_table kern_table[] = {
>                .data           = &dmesg_restrict,
>                .maxlen         = sizeof(int),
>                .mode           = 0644,
> -               .proc_handler   = proc_dointvec_minmax,
> +               .proc_handler   = proc_dmesg_restrict,
>                .extra1         = &zero,
>                .extra2         = &one,
>        },
> @@ -722,7 +722,7 @@ static struct ctl_table kern_table[] = {
>                .data           = &kptr_restrict,
>                .maxlen         = sizeof(int),
>                .mode           = 0644,
> -               .proc_handler   = proc_dmesg_restrict,
> +               .proc_handler   = proc_dointvec_minmax,
>                .extra1         = &zero,
>                .extra2         = &two,
>        },
> --
> 1.7.9.5
>



-- 
Kees Cook
ChromeOS Security
