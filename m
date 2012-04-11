Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760328Ab2DKOSq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 10:18:46 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64859 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760280Ab2DKOSo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 10:18:44 -0400
MIME-Version: 1.0
In-Reply-To: <1334148270-13139-1-git-send-email-otavio@ossystems.com.br>
References: <1334148270-13139-1-git-send-email-otavio@ossystems.com.br>
Date: Wed, 11 Apr 2012 10:18:44 -0400
Message-ID: <CADkTA4OEioYy6QW251KZ7EkJ+oUaDA=CtTXkb+kUWwwtE95Neg@mail.gmail.com>
Subject: Re: [PATCH] perf: do not prefix flex and bison calls with
 CROSS_COMPILE prefix
From: Bruce Ashfield <bruce.ashfield@gmail.com>
To: Otavio Salvador <otavio@ossystems.com.br>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 11, 2012 at 8:44 AM, Otavio Salvador
<otavio@ossystems.com.br> wrote:
> Other parts of kernel calls bison and flex but do not use the
> CROSS_COMPILE prefix so this ought to be done in same way.

FWIW. I have the same fix here that I'm using with 3.4-rc2, but hadn't
gotten around to sending it out yet.

So that's a count of two without a cross prefixed flex and bison :)

Cheers,

Bruce

>
> Signed-off-by: Otavio Salvador <otavio@ossystems.com.br>
> ---
>  tools/perf/Makefile |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/tools/perf/Makefile b/tools/perf/Makefile
> index 820371f..0ae8165 100644
> --- a/tools/perf/Makefile
> +++ b/tools/perf/Makefile
> @@ -234,8 +234,8 @@ endif
>
>  export PERL_PATH
>
> -FLEX = $(CROSS_COMPILE)flex
> -BISON= $(CROSS_COMPILE)bison
> +FLEX = flex
> +BISON= bison
>
>  event-parser:
>        $(QUIET_BISON)$(BISON) -v util/parse-events.y -d -o $(OUTPUT)util/parse-events-bison.c
> --
> 1.7.9.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



-- 
"Thou shalt not follow the NULL pointer, for chaos and madness await
thee at its end"
