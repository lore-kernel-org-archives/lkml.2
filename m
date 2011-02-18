Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932339Ab1BRRB7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 12:01:59 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:58796 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932234Ab1BRRB4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 12:01:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=bAoAq2zKvSN7Yg+CX4gLNmDJValMlgCK+pk5yZEjvjXu7tnLGXjcgh5gGGrTl9XnsN
         dxcC7At6DbTKK0dnUGbXNFNHE4W+oM5A/3RUgJ7KTIGjnvfArw2nHb1cKvCG4x3BgrJ/
         U0CgQQ+4muRe4kHXxDUg63f6lFmtDAbtbzRJA=
MIME-Version: 1.0
In-Reply-To: <b5dceec3591728e7dfa4d9fb2e978780e55420c5.1296818921.git.segoon@openwall.com>
References: <cover.1296818921.git.segoon@openwall.com>
	<b5dceec3591728e7dfa4d9fb2e978780e55420c5.1296818921.git.segoon@openwall.com>
Date: Fri, 18 Feb 2011 20:01:55 +0300
Message-ID: <AANLkTinrXQsF_MfHZJbACGnw0=iWQ4otdMUL3GhMDNbf@mail.gmail.com>
Subject: Re: [PATCH 08/20] mfd: ab3100: world-writable debugfs *_priv files
From: Vasiliy Kulikov <segooon@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/2/4 Vasiliy Kulikov <segoon@openwall.com>:
> Don't allow everybody to change device hardware registers.

Ping.

> Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
> ---
>  Compile tested only.
>
>  drivers/mfd/ab3100-core.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/mfd/ab3100-core.c b/drivers/mfd/ab3100-core.c
> index 4193af5..1707d22 100644
> --- a/drivers/mfd/ab3100-core.c
> +++ b/drivers/mfd/ab3100-core.c
> @@ -613,7 +613,7 @@ static void ab3100_setup_debugfs(struct ab3100 *ab3100)
>        ab3100_get_priv.ab3100 = ab3100;
>        ab3100_get_priv.mode = false;
>        ab3100_get_reg_file = debugfs_create_file("get_reg",
> -                               S_IWUGO, ab3100_dir, &ab3100_get_priv,
> +                               S_IWUSR, ab3100_dir, &ab3100_get_priv,
>                                &ab3100_get_set_reg_fops);
>        if (!ab3100_get_reg_file) {
>                err = -ENOMEM;
> @@ -623,7 +623,7 @@ static void ab3100_setup_debugfs(struct ab3100 *ab3100)
>        ab3100_set_priv.ab3100 = ab3100;
>        ab3100_set_priv.mode = true;
>        ab3100_set_reg_file = debugfs_create_file("set_reg",
> -                               S_IWUGO, ab3100_dir, &ab3100_set_priv,
> +                               S_IWUSR, ab3100_dir, &ab3100_set_priv,
>                                &ab3100_get_set_reg_fops);
>        if (!ab3100_set_reg_file) {
>                err = -ENOMEM;
> --
> 1.7.0.4
>
>
