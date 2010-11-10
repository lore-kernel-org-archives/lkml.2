Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757059Ab0KJQvJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 11:51:09 -0500
Received: from adelie.canonical.com ([91.189.90.139]:34569 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757029Ab0KJQvH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 11:51:07 -0500
Message-ID: <4CDACD74.7090502@canonical.com>
Date: Wed, 10 Nov 2010 08:51:00 -0800
From: John Johansen <john.johansen@canonical.com>
Organization: Canonical
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: wzt.wzt@gmail.com
CC: linux-kernel@vger.kernel.org, apparmor@lists.ubuntu.com,
        linux-security-module@vger.kernel.org
Subject: Re: [PATCH] APPARMOR: Fix memory leak of alloc_namespace()
References: <20101110033155.GA2873@localhost.localdomain>
In-Reply-To: <20101110033155.GA2873@localhost.localdomain>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/09/2010 07:31 PM, wzt.wzt@gmail.com wrote:
> policy->name is a substring of policy->hname, if prefix is not NULL, it will 
> allocted strlen(prefix) + strlen(name) + 3 bytes to policy->hname in policy_init(). 
> use kzfree(ns->base.name) will casue memory leak if alloc_namespace() failed.
> 
> Signed-off-by: Zhitong Wang <zhitong.wangzt@alibaba-inc.com>
yes, thank you.

Signed-off-by: John Johansen <john.johansen@canonical.com>

> 
> ---
>  security/apparmor/policy.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/security/apparmor/policy.c b/security/apparmor/policy.c
> index 52cc865..4f0eade 100644
> --- a/security/apparmor/policy.c
> +++ b/security/apparmor/policy.c
> @@ -306,7 +306,7 @@ static struct aa_namespace *alloc_namespace(const char *prefix,
>  	return ns;
>  
>  fail_unconfined:
> -	kzfree(ns->base.name);
> +	kzfree(ns->base.hname);
>  fail_ns:
>  	kzfree(ns);
>  	return NULL;
