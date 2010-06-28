Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754741Ab0F1MyM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 08:54:12 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:38012 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754456Ab0F1MyJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 08:54:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=a+IPOvcUwi34v4sO2VnJ4Lo466WHcYulACmIQQi6+AsIpAyHyFepmox7x8aq4SMGL0
         4rK/10GWKEB3VzvndUnGUEuHrvx9TeTrt+1nEHnberAEb/DELi55vjVlSH+5Dwkh3aI6
         OVIQ7CXwKrzAVnyWkjf6gfXOIiSGzE7Vnv4ZU=
Date: Mon, 28 Jun 2010 14:52:24 +0200
From: Dan Carpenter <error27@gmail.com>
To: Kulikov Vasiliy <segooon@gmail.com>
Cc: trivial@kernel.org, Kernel Janitors <kernel-janitors@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Henk de Groot <pe1dnn@amsat.org>,
       Joe Perches <joe@perches.com>, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 15/16] trivial: use ARRAY_SIZE
Message-ID: <20100628125224.GJ19184@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Kulikov Vasiliy <segooon@gmail.com>, trivial@kernel.org,
	Kernel Janitors <kernel-janitors@vger.kernel.org>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	Henk de Groot <pe1dnn@amsat.org>, Joe Perches <joe@perches.com>,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
References: <1277726143-24899-1-git-send-email-segooon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1277726143-24899-1-git-send-email-segooon@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 28, 2010 at 03:55:41PM +0400, Kulikov Vasiliy wrote:
> Change sizeof(x) / sizeof(*x) to ARRAY_SIZE(x).
> 
> Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
> ---
>  drivers/staging/wlags49_h2/hcf.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/staging/wlags49_h2/hcf.c b/drivers/staging/wlags49_h2/hcf.c
> index 390628c..c4fe0ec 100644
> --- a/drivers/staging/wlags49_h2/hcf.c
> +++ b/drivers/staging/wlags49_h2/hcf.c
> @@ -502,7 +502,7 @@ HCF_STATIC hcf_16* BASED xxxx[ ] = {
>  #endif // MSF_COMPONENT_ID
>  	NULL									//endsentinel
>    };
> -#define xxxx_PRI_IDENTITY_OFFSET	(sizeof(xxxx)/sizeof(xxxx[0]) - 3)
> +#define xxxx_PRI_IDENTITY_OFFSET	(ARRAY_SIZE(xxxx) - 3)
>  

I would say the more critical problem with this macro is that it doesn't
work unless you name all your arrays "xxxx[]" so it encourages sub par
variable names.

You could do:
#define PRI_IDENTITY_OFFSET(x) (ARRAY_SIZE(x) - 3)

regards,
dan carpenter

