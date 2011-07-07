Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754172Ab1GGQsy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 12:48:54 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:33463 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753561Ab1GGQsy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 12:48:54 -0400
From: Richard Weinberger <richard@nod.at>
To: Vitaliy Ivanov <vitalivanov@gmail.com>
Subject: Re: [PATCH 3/3] uml: os-Linux/main.c memory leak fix
Date: Thu, 7 Jul 2011 18:48:49 +0200
User-Agent: KMail/1.13.7 (Linux/2.6.37.6-0.5-desktop; KDE/4.6.5; x86_64; ; )
Cc: Jeff Dike <jdike@addtoit.com>, user-mode-linux-devel@lists.sourceforge.net,
        LKML <linux-kernel@vger.kernel.org>
References: <1310056668.3528.51.camel@vivanov>
In-Reply-To: <1310056668.3528.51.camel@vivanov>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201107071848.50411.richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag 07 Juli 2011, 18:37:48 schrieb Vitaliy Ivanov:
> >From 6db3c87f57e3e61d968da79f01fb21ba17fd5bc0 Mon Sep 17 00:00:00 2001
> 
> From: Vitaliy Ivanov <vitalivanov@gmail.com>
> Date: Thu, 7 Jul 2011 19:29:06 +0300
> Subject: [PATCH 3/3] uml: os-Linux/main.c memory leak fix
> 
> We should cleanup memory even though 'putenv' fails.
> 
> Signed-off-by: Vitaliy Ivanov <vitalivanov@gmail.com>
> ---
>  arch/um/os-Linux/main.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/um/os-Linux/main.c b/arch/um/os-Linux/main.c
> index fb2a97a..67fe012 100644
> --- a/arch/um/os-Linux/main.c
> +++ b/arch/um/os-Linux/main.c
> @@ -107,8 +107,8 @@ static void setup_env_path(void)
>  	snprintf(new_path, path_len, "PATH=%s" UML_LIB_PATH, old_path);
>  	if (putenv(new_path)) {
>  		perror("couldn't putenv to set a new PATH");
> -		free(new_path);
>  	}
> +	free(new_path);

Uhhh, this will kill the PATH variable.
putenv() does not copy the string...

Thanks,
//richard
