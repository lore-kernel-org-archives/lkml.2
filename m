Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754783Ab1GEJ2b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 05:28:31 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:44866 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754467Ab1GEJ2a convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 05:28:30 -0400
From: Richard Weinberger <richard@nod.at>
To: vitalivanov@gmail.com
Subject: Re: [PATCH 1/4] uml: cow_user.c warning corrections
Date: Tue, 5 Jul 2011 11:28:24 +0200
User-Agent: KMail/1.13.7 (Linux/2.6.37.6-0.5-desktop; KDE/4.6.4; x86_64; ; )
Cc: Jeff Dike <jdike@addtoit.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        user-mode-linux-devel@lists.sourceforge.net,
        lkml <linux-kernel@vger.kernel.org>
References: <1309821341.4527.5.camel@vitaliy-Vostro-1400>
In-Reply-To: <1309821341.4527.5.camel@vitaliy-Vostro-1400>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201107051128.25262.richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag 05 Juli 2011, 01:15:41 schrieb Vitaliy Ivanov:
> From 6201d3e862fca8670b206338dc90303ea0acc77d Mon Sep 17 00:00:00 2001
> From: Vitaliy Ivanov <vitalivanov@gmail.com>
> Date: Tue, 5 Jul 2011 01:57:51 +0300
> Subject: [PATCH 1/4] uml: cow_user.c warning corrections
> MIME-Version: 1.0
> Content-Type: text/plain; charset=UTF-8
> Content-Transfer-Encoding: 8bit
> 
> arch/um/drivers/cow_user.c: In function ‘absolutize’:
> arch/um/drivers/cow_user.c:189:7: warning: ignoring return value of
> ‘chdir’, declared with attribute warn_unused_result

What compiler flags are you using?
Using the default settings this warning does not show up.
Most of the "ignoring return value" are totally useless.

> Signed-off-by: Vitaliy Ivanov <vitalivanov@gmail.com>
> ---
>  arch/um/drivers/cow_user.c |    6 +++++-
>  1 files changed, 5 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/um/drivers/cow_user.c b/arch/um/drivers/cow_user.c
> index 93f227a..9cbb426 100644
> --- a/arch/um/drivers/cow_user.c
> +++ b/arch/um/drivers/cow_user.c
> @@ -186,7 +186,11 @@ static int absolutize(char *to, int size, char *from)
>  		strcat(to, "/");
>  		strcat(to, from);
>  	}
> -	chdir(save_cwd);
> +	if (chdir(save_cwd)) {
> +		cow_printf("absolutize : Can't cd to '%s' - "
> +			   "errno = %d\n", save_cwd, errno);
> +		return -1;
> +	}

I don't think that this check is needed nor chdir() to save_cwd can fail.
Because we obtain it by calling getcwd() and never change it...

Thanks,
//richard
