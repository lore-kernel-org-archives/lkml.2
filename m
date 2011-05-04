Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754884Ab1EDPeU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 11:34:20 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:47455 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751608Ab1EDPeS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 11:34:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=NgWO8jk47iJzTweQTS5fbGG/u0U2F0qbIJD04xyzK6lCiKWLoMlqcYy2yV8IZH5N0t
         anFXA5zMJuba2/1rbISRiPA0vcc8SaqHsdGITMtgCyvNktmmG9cb+U7pOZjwlyCtjWCQ
         B1oBvXaQqJk+7vYBJ2m0SmshqYr7xb8MCA75w=
Message-ID: <4DC171EB.6030900@googlemail.com>
Date: Wed, 04 May 2011 17:34:03 +0200
From: Dirk Behme <dirk.behme@googlemail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: Alessio Igor Bogani <abogani@kernel.org>
CC: Rusty Russell <rusty@rustcorp.com.au>, Tim Abbott <tabbott@ksplice.com>,
        Anders Kaseorg <andersk@ksplice.com>, Tim Bird <tim.bird@am.sony.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Embedded <linux-embedded@vger.kernel.org>,
        Jason Wessel <jason.wessel@windriver.com>
Subject: Re: [PATCH] module: Use binary search in lookup_symbol()
References: <1304455330-2728-1-git-send-email-abogani@kernel.org>
In-Reply-To: <1304455330-2728-1-git-send-email-abogani@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03.05.2011 22:42, Alessio Igor Bogani wrote:
> This work was supported by a hardware donation from the CE Linux Forum.
>
> Signed-off-by: Alessio Igor Bogani<abogani@kernel.org>
> ---
>   kernel/module.c |    6 ++----
>   1 files changed, 2 insertions(+), 4 deletions(-)
>
> diff --git a/kernel/module.c b/kernel/module.c
> index 6a34337..a1f841e 100644
> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@ -2055,10 +2055,8 @@ static const struct kernel_symbol *lookup_symbol(const char *name,
>   	const struct kernel_symbol *stop)
>   {
>   	const struct kernel_symbol *ks = start;
> -	for (; ks<  stop; ks++)
> -		if (strcmp(ks->name, name) == 0)
> -			return ks;
> -	return NULL;
> +	return bsearch(ks->name, start, stop - start,
> +			sizeof(struct kernel_symbol), cmp_name);
>   }
>
>   static int is_exported(const char *name, unsigned long value,

How is this patch related to patch 4/4

http://marc.info/?l=linux-kernel&m=130296062420328&w=1

of the recently sent patch set? Is it a replacement? Or an add on to 
this (i.e. patch #5)?

Many thanks

Dirk
