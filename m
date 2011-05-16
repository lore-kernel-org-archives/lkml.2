Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752833Ab1EPVBh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 17:01:37 -0400
Received: from mail.perches.com ([173.55.12.10]:1654 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751129Ab1EPVBg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 17:01:36 -0400
Subject: Re: [PATCH] module: Use binary search in lookup_symbol()
From: Joe Perches <joe@perches.com>
To: Alessio Igor Bogani <abogani@kernel.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        Anders Kaseorg <andersk@ksplice.com>, Tim Abbott <tabbott@ksplice.com>,
        Tim Bird <tim.bird@am.sony.com>, LKML <linux-kernel@vger.kernel.org>,
        Linux Embedded <linux-embedded@vger.kernel.org>,
        Jason Wessel <jason.wessel@windriver.com>,
        Dirk Behme <dirk.behme@googlemail.com>
In-Reply-To: <1305577420-3685-1-git-send-email-abogani@kernel.org>
References: <BANLkTi=2jW5PHB6QCaddHeZH0P=9PKWosw@mail.gmail.com>
	 <1305577420-3685-1-git-send-email-abogani@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 16 May 2011 14:01:34 -0700
Message-ID: <1305579694.2503.18.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-05-16 at 22:23 +0200, Alessio Igor Bogani wrote:
> This work was supported by a hardware donation from the CE Linux Forum.
> 
> Signed-off-by: Alessio Igor Bogani <abogani@kernel.org>
> ---
>  kernel/module.c |    6 ++----
>  1 files changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/kernel/module.c b/kernel/module.c
> index 6a34337..54355c5 100644
> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@ -2055,10 +2055,8 @@ static const struct kernel_symbol *lookup_symbol(const char *name,
>  	const struct kernel_symbol *stop)
>  {
>  	const struct kernel_symbol *ks = start;
> -	for (; ks < stop; ks++)
> -		if (strcmp(ks->name, name) == 0)
> -			return ks;
> -	return NULL;
> +	return bsearch(name, start, stop - start,
> +			sizeof(struct kernel_symbol), cmp_name);
>  }
>  
>  static int is_exported(const char *name, unsigned long value,

ks isn't used anymore.
why cmp_name and not strcmp?


