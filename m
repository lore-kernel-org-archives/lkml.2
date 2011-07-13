Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751955Ab1GMVFw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 17:05:52 -0400
Received: from casper.infradead.org ([85.118.1.10]:59530 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751812Ab1GMVFu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 17:05:50 -0400
Message-ID: <4E1E08A9.4030807@infradead.org>
Date: Wed, 13 Jul 2011 18:05:45 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110624 Thunderbird/5.0
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@xenotime.net>
CC: lkml <linux-kernel@vger.kernel.org>, linux-kbuild@vger.kernel.org,
        linux-media@vger.kernel.org
Subject: Re: [PATCH 1/9] stringify: add HEX_STRING()
References: <20110710125109.c72f9c2d.rdunlap@xenotime.net>
In-Reply-To: <20110710125109.c72f9c2d.rdunlap@xenotime.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 10-07-2011 16:51, Randy Dunlap escreveu:
> From: Randy Dunlap <rdunlap@xenotime.net>
> 
> Add HEX_STRING(value) to stringify.h so that drivers can
> convert kconfig hex values (without leading "0x") to useful
> hex constants.
> 
> Several drivers/media/radio/ drivers need this.  I haven't
> checked if any other drivers need to do this.
> 
> Alternatively, kconfig could produce hex config symbols with
> leading "0x".

Hi Randy,

After applying patch 1/9 and 2/9 over 3.0-rc7+media patches, I'm
now getting this error:

drivers/media/radio/radio-aimslab.c:52:1: error: invalid suffix "x20f" on integer constant

$ grep 20f .config
CONFIG_RADIO_RTRACK_PORT=20f

$ gcc --version
gcc (GCC) 4.4.5 20110214 (Red Hat 4.4.5-6)

Before this patch, this were working (or, at least, weren't producing
any error).

Perhaps the breakage on your compilation happened due to another
patch at the tree? If so, the better would be to apply this patch
series together with the ones that caused the breakage, to avoid
bisect troubles.

> 
> Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
> ---
>  include/linux/stringify.h |    7 +++++++
>  1 file changed, 7 insertions(+)
> 
> NOTE: The other 8 patches are on lkml and linux-media mailing lists.
> 
> --- linux-next-20110707.orig/include/linux/stringify.h
> +++ linux-next-20110707/include/linux/stringify.h
> @@ -9,4 +9,11 @@
>  #define __stringify_1(x...)	#x
>  #define __stringify(x...)	__stringify_1(x)
>  
> +/*
> + * HEX_STRING(value) is useful for CONFIG_ values that are in hex,
> + * but kconfig does not put a leading "0x" on them.
> + */
> +#define HEXSTRINGVALUE(h, value)	h##value
> +#define HEX_STRING(value)		HEXSTRINGVALUE(0x, value)
> +
>  #endif	/* !__LINUX_STRINGIFY_H */

