Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757108Ab0KJQ4L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 11:56:11 -0500
Received: from adelie.canonical.com ([91.189.90.139]:60602 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757049Ab0KJQ4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 11:56:08 -0500
Message-ID: <4CDACEA2.8010406@canonical.com>
Date: Wed, 10 Nov 2010 08:56:02 -0800
From: John Johansen <john.johansen@canonical.com>
Organization: Canonical
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: wzt.wzt@gmail.com
CC: linux-kernel@vger.kernel.org, apparmor@lists.ubuntu.com,
        linux-security-module@vger.kernel.org
Subject: Re: [PATCH] APPARMOR: Fix memory leak of apparmor_init()
References: <20101110080515.GA2722@localhost.localdomain>
In-Reply-To: <20101110080515.GA2722@localhost.localdomain>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/10/2010 12:05 AM, wzt.wzt@gmail.com wrote:
> set_init_cxt() allocted sizeof(struct aa_task_cxt) bytes for cxt, 
> if register_security() failed, it will cause memory leak.
> 
> Signed-off-by: Zhitong Wang <zhitong.wangzt@alibaba-inc.com>
> 
yep, thanks again Zhitong

Signed-off-by: John Johansen <john.johansen@canonical.com>

> ---
>  security/apparmor/lsm.c |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/security/apparmor/lsm.c b/security/apparmor/lsm.c
> index cf1de44..b7106f1 100644
> --- a/security/apparmor/lsm.c
> +++ b/security/apparmor/lsm.c
> @@ -922,7 +922,7 @@ static int __init apparmor_init(void)
>  	error = register_security(&apparmor_ops);
>  	if (error) {
>  		AA_ERROR("Unable to register AppArmor\n");
> -		goto register_security_out;
> +		goto set_init_cxt_out;
>  	}
>  
>  	/* Report that AppArmor successfully initialized */
> @@ -936,6 +936,9 @@ static int __init apparmor_init(void)
>  
>  	return error;
>  
> +set_init_cxt_out:
> +	aa_free_task_context(current->real_cred->security);
> +
>  register_security_out:
>  	aa_free_root_ns();
>  
> @@ -944,7 +947,6 @@ alloc_out:
>  
>  	apparmor_enabled = 0;
>  	return error;
> -
>  }
>  
>  security_initcall(apparmor_init);

