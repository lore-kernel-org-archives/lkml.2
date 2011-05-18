Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756618Ab1ERP1N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 11:27:13 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:50050 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755087Ab1ERP1L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 11:27:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=hsbvPpKRTDSJ4q8KanH1DktEVnMSMO+CT7sXgAI4wJYp7EvY14acvC3g6E80TRsiyr
         KztZB7nJOoqooQa7S+UNgDtc3Ur0PVHF53WSLRojxVYq64TPY1SdisL6ryhucuo7/8eq
         twCxwhulKXKZ7f9XB4jgNKcg5lzgiLdkYKO7c=
Message-ID: <4DD3E540.8000205@googlemail.com>
Date: Wed, 18 May 2011 17:26:56 +0200
From: Dirk Behme <dirk.behme@googlemail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: Alessio Igor Bogani <abogani@kernel.org>
CC: Rusty Russell <rusty@rustcorp.com.au>,
        Anders Kaseorg <andersk@ksplice.com>, Tim Abbott <tabbott@ksplice.com>,
        Tim Bird <tim.bird@am.sony.com>, LKML <linux-kernel@vger.kernel.org>,
        Linux Embedded <linux-embedded@vger.kernel.org>,
        Jason Wessel <jason.wessel@windriver.com>
Subject: Re: [PATCH] module: Use binary search in lookup_symbol()
References: <BANLkTinPG100vbVAN1RZWb3h9Xuu6SKJ0Q@mail.gmail.com> <1305665763-3988-1-git-send-email-abogani@kernel.org>
In-Reply-To: <1305665763-3988-1-git-send-email-abogani@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17.05.2011 22:56, Alessio Igor Bogani wrote:
> This work was supported by a hardware donation from the CE Linux Forum.
>
> Signed-off-by: Alessio Igor Bogani<abogani@kernel.org>
> ---
>   kernel/module.c |    7 ++-----
>   1 files changed, 2 insertions(+), 5 deletions(-)
>
> diff --git a/kernel/module.c b/kernel/module.c
> index 1e2b657..795bdc7 100644
> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@ -2055,11 +2055,8 @@ static const struct kernel_symbol *lookup_symbol(const char *name,
>   	const struct kernel_symbol *start,
>   	const struct kernel_symbol *stop)
>   {
> -	const struct kernel_symbol *ks = start;
> -	for (; ks<  stop; ks++)
> -		if (strcmp(ks->name, name) == 0)
> -			return ks;
> -	return NULL;
> +	return bsearch(name, start, stop - start,
> +			sizeof(struct kernel_symbol), cmp_name);
>   }
>
>   static int is_exported(const char *name, unsigned long value,

The old version with the warning is in linux-next now

http://git.kernel.org/?p=linux/kernel/git/next/linux-next.git;a=commitdiff;h=903996de9b35213aaa4162c24351a2cb2931d9ac

Best regards

Dirk
