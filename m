Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758755Ab1LONV5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 08:21:57 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46280 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089Ab1LONVz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 08:21:55 -0500
Message-ID: <4EE9F46A.9090603@canonical.com>
Date: Thu, 15 Dec 2011 05:21:46 -0800
From: John Johansen <john.johansen@canonical.com>
Organization: Canonical
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111124 Thunderbird/8.0
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, James Morris <jmorris@namei.org>,
        linux-security-module@vger.kernel.org
Subject: Re: [PATCH 8/15] apparmor: fix module parameter handling
References: <87pqfqsf4r.fsf@rustcorp.com.au>
In-Reply-To: <87pqfqsf4r.fsf@rustcorp.com.au>
X-Enigmail-Version: 1.4a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/14/2011 07:11 PM, Rusty Russell wrote:
> The 'aabool' wrappers actually pass off to the 'bool' parse functions,
> so you should use the same check function.  Similarly for aauint and
> uint.
> 
yep, thanks Rusty

> (Note that 'bool' module parameters also allow 'int', which is why you
> got away with this, but that's changing very soon.)
> 
> Cc: John Johansen <john.johansen@canonical.com>
> Cc: James Morris <jmorris@namei.org>
> Cc: linux-security-module@vger.kernel.org
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Acked-by: John Johansen <john.johansen@canonical.com>

> ---
>  security/apparmor/lsm.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/security/apparmor/lsm.c b/security/apparmor/lsm.c
> --- a/security/apparmor/lsm.c
> +++ b/security/apparmor/lsm.c
> @@ -671,7 +671,7 @@ static struct security_operations apparm
>  
>  static int param_set_aabool(const char *val, const struct kernel_param *kp);
>  static int param_get_aabool(char *buffer, const struct kernel_param *kp);
> -#define param_check_aabool(name, p) __param_check(name, p, int)
> +#define param_check_aabool param_check_bool
>  static struct kernel_param_ops param_ops_aabool = {
>  	.set = param_set_aabool,
>  	.get = param_get_aabool
> @@ -679,7 +679,7 @@ static struct kernel_param_ops param_ops
>  
>  static int param_set_aauint(const char *val, const struct kernel_param *kp);
>  static int param_get_aauint(char *buffer, const struct kernel_param *kp);
> -#define param_check_aauint(name, p) __param_check(name, p, int)
> +#define param_check_aauint param_check_uint
>  static struct kernel_param_ops param_ops_aauint = {
>  	.set = param_set_aauint,
>  	.get = param_get_aauint
> @@ -687,7 +687,7 @@ static struct kernel_param_ops param_ops
>  
>  static int param_set_aalockpolicy(const char *val, const struct kernel_param *kp);
>  static int param_get_aalockpolicy(char *buffer, const struct kernel_param *kp);
> -#define param_check_aalockpolicy(name, p) __param_check(name, p, int)
> +#define param_check_aalockpolicy param_check_bool
>  static struct kernel_param_ops param_ops_aalockpolicy = {
>  	.set = param_set_aalockpolicy,
>  	.get = param_get_aalockpolicy

