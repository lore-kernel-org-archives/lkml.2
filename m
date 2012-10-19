Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932927Ab2JSQDP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 12:03:15 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:45598 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932191Ab2JSQDN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 12:03:13 -0400
MIME-Version: 1.0
In-Reply-To: <1350647942-5260-1-git-send-email-ffainelli@freebox.fr>
References: <1350647942-5260-1-git-send-email-ffainelli@freebox.fr>
Date: Fri, 19 Oct 2012 09:03:12 -0700
X-Google-Sender-Auth: 9bzmEP9Yzgcom05tF17DuCsobKg
Message-ID: <CAGXu5j+sNV2XCBCA4HQOXyS66MVzzcJDottFdh9hDW5LcD45HA@mail.gmail.com>
Subject: Re: [PATCH] pstore/ram: fix undefined usage of rounddown_pow_of_two.
From: Kees Cook <keescook@chromium.org>
To: Florian Fainelli <ffainelli@freebox.fr>
Cc: cbouatmailru@gmail.com, ccross@android.com, tony.luck@intel.com,
        linux-kernel@vger.kernel.org, Maxime Bizon <mbizon@freebox.fr>,
        stable@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 19, 2012 at 4:59 AM, Florian Fainelli <ffainelli@freebox.fr> wrote:
> From: Maxime Bizon <mbizon@freebox.fr>
>
> record_size / console_size / ftrace_size can be 0 (this is how you
> disable the feature), but rounddown_pow_of_two(0) is undefined. This problem
> has been present since commit 1894a253 (ramoops: Move to fs/pstore/ram.c).
>
> Signed-off-by: Maxime Bizon <mbizon@freebox.fr>
> Signed-off-by: Florian Fainelli <ffainelli@freebox.fr>
> CC: stable@vger.kernel.org
> ---
>  fs/pstore/ram.c |   12 ++++++++----
>  1 file changed, 8 insertions(+), 4 deletions(-)
>
> diff --git a/fs/pstore/ram.c b/fs/pstore/ram.c
> index 1a4f6da..0c2ae26 100644
> --- a/fs/pstore/ram.c
> +++ b/fs/pstore/ram.c
> @@ -374,10 +374,14 @@ static int __devinit ramoops_probe(struct platform_device *pdev)
>                 goto fail_out;
>         }
>
> -       pdata->mem_size = rounddown_pow_of_two(pdata->mem_size);
> -       pdata->record_size = rounddown_pow_of_two(pdata->record_size);
> -       pdata->console_size = rounddown_pow_of_two(pdata->console_size);
> -       pdata->ftrace_size = rounddown_pow_of_two(pdata->ftrace_size);
> +       if (pdata->mem_size)
> +               pdata->mem_size = rounddown_pow_of_two(pdata->mem_size);

Nice catch!

Instead of the == 0 check, what about using !is_power_of_2(size) ?

-Kees

-- 
Kees Cook
Chrome OS Security
