Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752214Ab1AQSf0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 13:35:26 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:14666 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212Ab1AQSfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 13:35:25 -0500
Date: Mon, 17 Jan 2011 19:35:25 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
cc: safford@watson.ibm.com, safford@us.ibm.com, dhowells@redhat.com,
        jmorris@namei.org, keyrings@linux-nfs.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] trusted-keys: check for NULL before using it
In-Reply-To: <201101170041.p0H0ffFE086481@www262.sakura.ne.jp>
Message-ID: <alpine.LNX.2.00.1101171935140.27021@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1101132100190.11347@swampdragon.chaosbits.net> <1295011682.7804.2.camel@localhost.localdomain> <201101142245.GGI86457.OQFFFMOtVOHJLS@I-love.SAKURA.ne.jp> <201101142307.EHC56742.FVtMFHOOFSQJOL@I-love.SAKURA.ne.jp>
 <alpine.LNX.2.00.1101161504050.8049@swampdragon.chaosbits.net> <201101170039.p0H0d1f5085735@www262.sakura.ne.jp> <201101170041.p0H0ffFE086481@www262.sakura.ne.jp>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Jan 2011, Tetsuo Handa wrote:

> >From 8118c3d0d6f2b291d56e2f4475f2aa5156299cf3 Mon Sep 17 00:00:00 2001
> From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> Date: Mon, 17 Jan 2011 09:25:34 +0900
> Subject: [PATCH 2/3] trusted-keys: check for NULL before using it
> 
> TSS_rawhmac() checks for data != NULL before using it.
> We should do the same thing for TSS_authhmac().
> 
> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> ---
>  security/keys/trusted_defined.c |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/security/keys/trusted_defined.c b/security/keys/trusted_defined.c
> index 7b21795..f7d0677 100644
> --- a/security/keys/trusted_defined.c
> +++ b/security/keys/trusted_defined.c
> @@ -148,6 +148,11 @@ static int TSS_authhmac(unsigned char *digest, const unsigned char *key,
>  		if (dlen == 0)
>  			break;
>  		data = va_arg(argp, unsigned char *);
> +		if (!data) {
> +			ret = -EINVAL;
> +			va_end(argp);
> +			goto out;
> +		}
>  		ret = crypto_shash_update(&sdesc->shash, data, dlen);
>  		if (ret < 0) {
>  			va_end(argp);
> 
Looks good to me..

Reviewed-by: Jesper Juhl <jj@chaosbits.net>


-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please.

