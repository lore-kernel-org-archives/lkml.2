Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753605Ab1FUOnx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 10:43:53 -0400
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:51929 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750811Ab1FUOnt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 10:43:49 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=A/nlix059rFkuzz+ettmJbKhPkYXCUbqfnZxRm1b8ZhCsbtYTFOw96zEiZKz4Qjiwmxi2qdi3DuZc7/zYpRjEhl/D4Ex2M9/9h9M5o1JjEXLl1CV2YGIOUVfc9+Hcwr5;
Date: Tue, 21 Jun 2011 07:43:44 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Stephen Boyd <bebarino@gmail.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] configs: Include MODULE_*() when CONFIG_IKCONFIG_PROC=n
Message-Id: <20110621074344.990cde5f.rdunlap@xenotime.net>
In-Reply-To: <1308636747-2360-1-git-send-email-bebarino@gmail.com>
References: <1308636747-2360-1-git-send-email-bebarino@gmail.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Jun 2011 23:12:27 -0700 Stephen Boyd wrote:

> If CONFIG_IKCONFIG=m but CONFIG_IKCONFIG_PROC=n we get a module that has
> no MODULE_LICENSE definition. Move the MODULE_*() definitions outside
> the CONFIG_IKCONFIG_PROC #ifdef to prevent this configuration from
> tainting the kernel.
> 
> Signed-off-by: Stephen Boyd <bebarino@gmail.com>
> Cc: Randy Dunlap <rdunlap@xenotime.net>

Acked-by: Randy Dunlap <rdunlap@xenotime.net>

Thanks.

> ---
>  kernel/configs.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/configs.c b/kernel/configs.c
> index b4066b4..42e8fa0 100644
> --- a/kernel/configs.c
> +++ b/kernel/configs.c
> @@ -92,8 +92,8 @@ static void __exit ikconfig_cleanup(void)
>  module_init(ikconfig_init);
>  module_exit(ikconfig_cleanup);
>  
> +#endif /* CONFIG_IKCONFIG_PROC */
> +
>  MODULE_LICENSE("GPL");
>  MODULE_AUTHOR("Randy Dunlap");
>  MODULE_DESCRIPTION("Echo the kernel .config file used to build the kernel");
> -
> -#endif /* CONFIG_IKCONFIG_PROC */
> -- 


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
