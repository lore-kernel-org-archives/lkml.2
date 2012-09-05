Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759593Ab2IEVlk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 17:41:40 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:65075 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754878Ab2IEVlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 17:41:37 -0400
MIME-Version: 1.0
In-Reply-To: <20120827183813.GA23991@www.outflux.net>
References: <20120827183813.GA23991@www.outflux.net>
Date: Wed, 5 Sep 2012 14:41:36 -0700
X-Google-Sender-Auth: LGKqK97Entq7PJdBSU-49W8atVc
Message-ID: <CAGXu5jLwhXtZj1KZjV-P6ugDF0uWzYfWKq-eSfwgiGqWYc3E4w@mail.gmail.com>
Subject: Re: [PATCH] Yama: handle 32-bit userspace prctl
From: Kees Cook <keescook@chromium.org>
To: James Morris <james.l.morris@oracle.com>
Cc: Kees Cook <keescook@chromium.org>,
        John Johansen <john.johansen@canonical.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi James,

Any chance this can get into security-next as well? It'll need to go
back to stable, but it's a small enough corner-case that I don't mind
it not landing in 3.6 directly. I'm happy if it gets into 3.6.x stable
at some point.

Thanks!

-Kees

On Mon, Aug 27, 2012 at 11:38 AM, Kees Cook <keescook@chromium.org> wrote:
> When running a 64-bit kernel and receiving prctls from a 32-bit
> userspace, the "-1" used as an unsigned long will end up being
> misdetected. The kernel is looking for 0xffffffffffffffff instead of
> 0xffffffff. Since prctl lacks a distinct compat interface, Yama needs
> to handle this translation itself. As such, support either value as
> meaning PR_SET_PTRACER_ANY, to avoid breaking the ABI for 64-bit.
>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> Cc: stable@vger.kernel.org
> ---
>  security/yama/yama_lsm.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/security/yama/yama_lsm.c b/security/yama/yama_lsm.c
> index 0cc99a3..dcd6178 100644
> --- a/security/yama/yama_lsm.c
> +++ b/security/yama/yama_lsm.c
> @@ -143,7 +143,7 @@ static int yama_task_prctl(int option, unsigned long arg2, unsigned long arg3,
>                 if (arg2 == 0) {
>                         yama_ptracer_del(NULL, myself);
>                         rc = 0;
> -               } else if (arg2 == PR_SET_PTRACER_ANY) {
> +               } else if (arg2 == PR_SET_PTRACER_ANY || (int)arg2 == -1) {
>                         rc = yama_ptracer_add(NULL, myself);
>                 } else {
>                         struct task_struct *tracer;
> --
> 1.7.0.4
>
>
> --
> Kees Cook
> Chrome OS Security



-- 
Kees Cook
Chrome OS Security
