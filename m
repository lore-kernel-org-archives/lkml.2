Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755109Ab1GEJmo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 05:42:44 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:33632 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755077Ab1GEJmn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 05:42:43 -0400
From: Richard Weinberger <richard@nod.at>
To: vitalivanov@gmail.com
Subject: Re: [PATCH 2/4] uml: helper.c warning corrections
Date: Tue, 5 Jul 2011 11:42:39 +0200
User-Agent: KMail/1.13.7 (Linux/2.6.37.6-0.5-desktop; KDE/4.6.4; x86_64; ; )
Cc: Jeff Dike <jdike@addtoit.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "user-mode-linux-devel@lists.sourceforge.net" 
	<user-mode-linux-devel@lists.sourceforge.net>,
        lkml <linux-kernel@vger.kernel.org>
References: <1309821347.4527.6.camel@vitaliy-Vostro-1400>
In-Reply-To: <1309821347.4527.6.camel@vitaliy-Vostro-1400>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201107051142.39733.richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag 05 Juli 2011, 01:15:47 schrieb Vitaliy Ivanov:
> From 7296c5b9770e95cd6ad4e9e71d2d14c972abdfe1 Mon Sep 17 00:00:00 2001
> From: Vitaliy Ivanov <vitalivanov@gmail.com>
> Date: Tue, 5 Jul 2011 02:03:06 +0300
> Subject: [PATCH 2/4] uml: helper.c warning corrections
> MIME-Version: 1.0
> Content-Type: text/plain; charset=UTF-8
> Content-Transfer-Encoding: 8bit
> 
> arch/um/os-Linux/helper.c: In function ‘helper_child’:
> arch/um/os-Linux/helper.c:38:7: warning: ignoring return value of ‘write’,
> declared with attribute warn_unused_result

Same question as before...

> Signed-off-by: Vitaliy Ivanov <vitalivanov@gmail.com>
> ---
>  arch/um/os-Linux/helper.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/um/os-Linux/helper.c b/arch/um/os-Linux/helper.c
> index b6b1096..feff22d 100644
> --- a/arch/um/os-Linux/helper.c
> +++ b/arch/um/os-Linux/helper.c
> @@ -28,14 +28,14 @@ static int helper_child(void *arg)
>  {
>  	struct helper_data *data = arg;
>  	char **argv = data->argv;
> -	int err;
> +	int err, ret;
> 
>  	if (data->pre_exec != NULL)
>  		(*data->pre_exec)(data->pre_data);
>  	err = execvp_noalloc(data->buf, argv[0], argv);
> 
>  	/* If the exec succeeds, we don't get here */
> -	write(data->fd, &err, sizeof(err));
> +	CATCH_EINTR(ret = write(data->fd, &err, sizeof(err)));

Is there really a realistic chance that this write() can be interrupted?
helper_child() gets called via clone() in run_helper().

Thanks,
//richard
