Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754459Ab2AaOHJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 09:07:09 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:35446 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752261Ab2AaOHH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 09:07:07 -0500
MIME-Version: 1.0
In-Reply-To: <1327982842-13898-1-git-send-email-sasha.levin@oracle.com>
References: <1327982842-13898-1-git-send-email-sasha.levin@oracle.com>
Date: Tue, 31 Jan 2012 09:07:06 -0500
Message-ID: <CA+5PVA5zSjyOj9nbtPQ+cUKnYcdpHZgoD8PRSSF+DEwxJLYHzA@mail.gmail.com>
Subject: Re: [PATCH] module: Remove module size limit
From: Josh Boyer <jwboyer@gmail.com>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: rusty@rustcorp.com.au, linux-kernel@vger.kernel.org,
        Sasha Levin <sasha.levin@oracle.com>,
        Tim Abbott <tim.abbott@oracle.com>, stable@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 30, 2012 at 11:07 PM, Sasha Levin <levinsasha928@gmail.com> wrote:
> Module size was limited to 64MB, this was legacy limitation due to vmalloc()
> which was removed a while ago.
>
> Limiting module size to 64MB is both pointless and affects real world use
> cases.
>
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> Cc: Tim Abbott <tim.abbott@oracle.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
> ---
>  kernel/module.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
>
> diff --git a/kernel/module.c b/kernel/module.c
> index 2c93276..3d56b6f 100644
> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@ -2380,8 +2380,7 @@ static int copy_and_check(struct load_info *info,
>                return -ENOEXEC;
>
>        /* Suck in entire file: we'll want most of it. */
> -       /* vmalloc barfs on "unusual" numbers.  Check here */
> -       if (len > 64 * 1024 * 1024 || (hdr = vmalloc(len)) == NULL)
> +       if ((hdr = vmalloc(len)) == NULL)
>                return -ENOMEM;
>
>        if (copy_from_user(hdr, umod, len) != 0) {

I could be missing something somewhere, but this is the only upper bounds
check that is in place on the overall module size.  If we remove this without
putting some other kind of sanity check, wouldn't it be possible for someone
to exhaust the entire vmalloc space for the kernel by loading a bloated module?

I would think we still want to have some form of upper bounds check to prevent
that, but maybe I'm paranoid.

As an aside, which real world use cases are blocked by having a 64MB limit?
That is already HUGE.

josh
