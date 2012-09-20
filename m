Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752718Ab2ITRFc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 13:05:32 -0400
Received: from 50-56-35-84.static.cloud-ips.com ([50.56.35.84]:41605 "EHLO
	mail.hallyn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752413Ab2ITRFb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 13:05:31 -0400
Date: Thu, 20 Sep 2012 17:06:47 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: hongfeng <hongfeng@marvell.com>
Cc: akpm@linux-foundation.org, gorcunov@openvz.org, keescook@chromium.org,
        serge.hallyn@canonical.com, ebiederm@xmission.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] poweroff: fix bug in orderly_poweroff
Message-ID: <20120920170647.GA26278@mail.hallyn.com>
References: <1348036677-28626-1-git-send-email-hongfeng@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348036677-28626-1-git-send-email-hongfeng@marvell.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting hongfeng (hongfeng@marvell.com):
> orderly_poweroff is trying to poweroff platform by two steps:
> step 1: Call userspace application to poweroff
> step 2: If userspace poweroff fail, then do a force power off if force param is set.
> 
> The bug here is, step 1 is always successful with param UMH_NO_WAIT,

Note that a changelog here explaining that you switched to UMH_WAIT_EXEC
per Eric's suggestion would be both informative and courteous.

> should change to UMH_WAIT_EXEC which will monitor whether user application successful run.

Is this actually sufficient for you?  The exec will have started, but
may for whatever (very unlikely) reason fail.  If you're happy with
it,

Acked-by: Serge Hallyn <serge.hallyn@canonical.com>

> Change-Id: I2f9ebbb90c0c2443780080ec9507c8d004e5da74
> Signed-off-by: Feng Hong <hongfeng@marvell.com>
> Acked-by: Kees Cook <keescook@chromium.org>
> ---
>  kernel/sys.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/sys.c b/kernel/sys.c
> index 241507f..a624d4c 100644
> --- a/kernel/sys.c
> +++ b/kernel/sys.c
> @@ -2204,7 +2204,7 @@ static int __orderly_poweroff(void)
>  		return -ENOMEM;
>  	}
>  
> -	ret = call_usermodehelper_fns(argv[0], argv, envp, UMH_NO_WAIT,
> +	ret = call_usermodehelper_fns(argv[0], argv, envp, UMH_WAIT_EXEC,
>  				      NULL, argv_cleanup, NULL);
>  	if (ret == -ENOMEM)
>  		argv_free(argv);
> -- 
> 1.7.0.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
