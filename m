Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752243Ab1GMVtv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 17:49:51 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:59453 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751623Ab1GMVtu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 17:49:50 -0400
MIME-Version: 1.0
In-Reply-To: <20110710125109.c72f9c2d.rdunlap@xenotime.net>
References: <20110710125109.c72f9c2d.rdunlap@xenotime.net>
Date: Wed, 13 Jul 2011 17:49:48 -0400
Message-ID: <CACqU3MWBb4J8rmaRv23=-_=GXppGSUdqmOqeXoqWi4ZJ7ZYewg@mail.gmail.com>
Subject: Re: [PATCH 1/9] stringify: add HEX_STRING()
From: Arnaud Lacombe <lacombar@gmail.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-kbuild@vger.kernel.org,
        linux-media@vger.kernel.org, mchehab@infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, Jul 10, 2011 at 3:51 PM, Randy Dunlap <rdunlap@xenotime.net> wrote:
> From: Randy Dunlap <rdunlap@xenotime.net>
>
> Add HEX_STRING(value) to stringify.h so that drivers can
> convert kconfig hex values (without leading "0x") to useful
> hex constants.
>
> Several drivers/media/radio/ drivers need this.  I haven't
> checked if any other drivers need to do this.
>
> Alternatively, kconfig could produce hex config symbols with
> leading "0x".
>
Actually, I used to have a patch to make hex value have a mandatory
"0x" prefix, in the Kconfig. I even fixed all the issue in the tree,
it never make it to the tree (not sure why). Here's the relevant
thread:

https://patchwork.kernel.org/patch/380591/
https://patchwork.kernel.org/patch/380621/
https://patchwork.kernel.org/patch/380601/

 - Arnaud

> Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
> ---
>  include/linux/stringify.h |    7 +++++++
>  1 file changed, 7 insertions(+)
>
> NOTE: The other 8 patches are on lkml and linux-media mailing lists.
>
> --- linux-next-20110707.orig/include/linux/stringify.h
> +++ linux-next-20110707/include/linux/stringify.h
> @@ -9,4 +9,11 @@
>  #define __stringify_1(x...)    #x
>  #define __stringify(x...)      __stringify_1(x)
>
> +/*
> + * HEX_STRING(value) is useful for CONFIG_ values that are in hex,
> + * but kconfig does not put a leading "0x" on them.
> + */
> +#define HEXSTRINGVALUE(h, value)       h##value
> +#define HEX_STRING(value)              HEXSTRINGVALUE(0x, value)
> +
that seems hackish...

>  #endif /* !__LINUX_STRINGIFY_H */
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kbuild" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
