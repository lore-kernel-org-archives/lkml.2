Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756638Ab0EQWxN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 18:53:13 -0400
Received: from tundra.namei.org ([65.99.196.166]:42295 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755831Ab0EQWxJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 18:53:09 -0400
Date: Tue, 18 May 2010 08:51:43 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: David Howells <dhowells@redhat.com>
cc: torvalds@osdl.org, Andrew Morton <akpm@linux-foundation.org>,
       Oleg Nesterov <oleg@redhat.com>, keyrings@linux-nfs.org,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       Dan Carpenter <error27@gmail.com>, stable@kernel.org
Subject: Re: [PATCH] KEYS: Return more accurate error codes
In-Reply-To: <20100517134235.19013.90388.stgit@warthog.procyon.org.uk>
Message-ID: <alpine.LRH.2.00.1005180851180.21768@tundra.namei.org>
References: <20100517134235.19013.90388.stgit@warthog.procyon.org.uk>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 May 2010, David Howells wrote:

> From: Dan Carpenter <error27@gmail.com>
> 
> We were using the wrong variable here so the error codes weren't being returned
> properly.  The original code returns -ENOKEY.
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>
> Signed-off-by: David Howells <dhowells@redhat.com>

Queued for Linus -- is also likely a -stable candidate.


> ---
> 
>  security/keys/process_keys.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/security/keys/process_keys.c b/security/keys/process_keys.c
> index 06c2ccf..20a38fe 100644
> --- a/security/keys/process_keys.c
> +++ b/security/keys/process_keys.c
> @@ -508,7 +508,7 @@ try_again:
>  
>  			ret = install_thread_keyring();
>  			if (ret < 0) {
> -				key = ERR_PTR(ret);
> +				key_ref = ERR_PTR(ret);
>  				goto error;
>  			}
>  			goto reget_creds;
> @@ -526,7 +526,7 @@ try_again:
>  
>  			ret = install_process_keyring();
>  			if (ret < 0) {
> -				key = ERR_PTR(ret);
> +				key_ref = ERR_PTR(ret);
>  				goto error;
>  			}
>  			goto reget_creds;
> @@ -585,7 +585,7 @@ try_again:
>  
>  	case KEY_SPEC_GROUP_KEYRING:
>  		/* group keyrings are not yet supported */
> -		key = ERR_PTR(-EINVAL);
> +		key_ref = ERR_PTR(-EINVAL);
>  		goto error;
>  
>  	case KEY_SPEC_REQKEY_AUTH_KEY:
> 

-- 
James Morris
<jmorris@namei.org>
