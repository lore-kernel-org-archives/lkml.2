Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752856Ab1AXAAz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jan 2011 19:00:55 -0500
Received: from tundra.namei.org ([65.99.196.166]:36183 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752481Ab1AXAAy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jan 2011 19:00:54 -0500
Date: Mon, 24 Jan 2011 11:00:41 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Jesper Juhl <jj@chaosbits.net>
cc: David Howells <dhowells@redhat.com>, David Safford <safford@us.ibm.com>,
        keyrings@linux-nfs.org, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] trusted keys: Fix a memory leak in trusted_update().
In-Reply-To: <alpine.LNX.2.00.1101232237020.30955@swampdragon.chaosbits.net>
Message-ID: <alpine.LRH.2.00.1101241100220.30644@tundra.namei.org>
References: <alpine.LNX.2.00.1101232237020.30955@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 23 Jan 2011, Jesper Juhl wrote:

> One failure path in security/keys/trusted_defined.c::trusted_update() does 
> not free 'new_p' while the others do. This patch makes sure we also free 
> it in the remaining path (if datablob_parse() returns different from 
> Opt_update).
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>

Applied to
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#for-linus

with filename change fixups.


> ---
>  trusted_defined.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/security/keys/trusted_defined.c b/security/keys/trusted_defined.c
> index 2836c6d..bae582b 100644
> --- a/security/keys/trusted_defined.c
> +++ b/security/keys/trusted_defined.c
> @@ -1032,6 +1032,7 @@ static int trusted_update(struct key *key, const void *data, size_t datalen)
>  	ret = datablob_parse(datablob, new_p, new_o);
>  	if (ret != Opt_update) {
>  		ret = -EINVAL;
> +		kfree(new_p);
>  		goto out;
>  	}
>  	/* copy old key values, and reseal with new pcrs */
> 
> 
> -- 
> Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
> Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
> Plain text mails only, please.
> 

-- 
James Morris
<jmorris@namei.org>
