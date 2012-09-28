Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031151Ab2I1UNv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 16:13:51 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:59762 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932154Ab2I1UNs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 16:13:48 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Alessandro Rubini <rubini@unipv.it>
Subject: Re: [PATCH 13/24] ARM: nomadik: use __iomem pointers for MMIO
Date: Fri, 28 Sep 2012 20:13:34 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        will.deacon@arm.com, rmk+kernel@arm.linux.org.uk, nico@linaro.org,
        linus.walleij@linaro.org, STEricsson_nomadik_linux@list.st.com
References: <1347658492-11608-14-git-send-email-arnd@arndb.de> <1347658492-11608-1-git-send-email-arnd@arndb.de> <20120915113356.GA31284@mail.gnudd.com>
In-Reply-To: <20120915113356.GA31284@mail.gnudd.com>
MIME-Version: 1.0
Content-Type: Text/Plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-Id: <201209282013.34638.arnd@arndb.de>
X-Provags-ID: V02:K0:ujdaiWU+PKWdyi4IK8ZM1U21ZiO8Z5k2wwKhArTi0Mu
 4GINIwCyqGJ1g7e/jpg31dJSv4DKjTESquA6kspVjKhQ14J1Tk
 zdYzIiYenwTGy0yZtnVUoKiMMqzsaLn7sl21GcCBYlaP3o4Zh7
 4f9nk30V4WpwlruZzXgRQMeesN4JZiNd7zy4XfOiCVYLnBzeW0
 OXWy6yrvZa2H7AKKgLHEZ9bV/irUa8ewxTSbBRBKEBMhF05tm6
 KHjjx6XMSxlVtmRT4VJYXo4oHFNMnlSgcxOy0IFrn5UOXlqKQF
 6sPwWvoWhl2RF1goetLqpV/efGSR2GlZ/Sqx1SS05Mq6B7KA/u
 F5wYWsOB2QaV0QwJrsS4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 15 September 2012, Alessandro Rubini wrote:
> > -     .options        = NAND_COPYBACK | NAND_CACHEPRG | NAND_NO_PADDING \
> > -                     | NAND_NO_READRDY,
> > +     .options        = NAND_COPYBACK | NAND_CACHEPRG | NAND_NO_PADDING,
> 
> This is not clear to me, and it looks unrelated. But I admit I haven't
> studied what happened to NAND_NO_READRDY lately.
> 
> If this hunk is desired and not just something else
> that slipped in, then
> 
>   Acked-by: Alessandro Rubini <rubini@unipv.it>

I've added the patch below to the next/fixes-non-critical branch now,
to avoid the build error in linux-next.

	Arnd

>From 06f8ab806e9e180966e812f6e47a0735bba638d8 Mon Sep 17 00:00:00 2001
From: Arnd Bergmann <arnd@arndb.de>
Date: Sun, 23 Sep 2012 22:57:22 +0000
Subject: [PATCH] ARM: nomadik: remove NAND_NO_READRDY use

The nhk8815 board files uses NAND_NO_READRDY in its platform data, but
this macro is getting removed because it was not being used anywhere.

Without this patch, building nhk8815_defconfig results in:

arch/arm/mach-nomadik/board-nhk8815.c:118:6: error: 'NAND_NO_READRDY' undeclared here (not in a function)

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Alessandro Rubini <rubini@unipv.it>
Cc: Linus Walleij <linus.walleij@linaro.org>

diff --git a/arch/arm/mach-nomadik/board-nhk8815.c b/arch/arm/mach-nomadik/board-nhk8815.c
index 381c080..92a0026 100644
--- a/arch/arm/mach-nomadik/board-nhk8815.c
+++ b/arch/arm/mach-nomadik/board-nhk8815.c
@@ -112,8 +112,7 @@ static struct mtd_partition nhk8815_partitions[] = {
 static struct nomadik_nand_platform_data nhk8815_nand_data = {
 	.parts		= nhk8815_partitions,
 	.nparts		= ARRAY_SIZE(nhk8815_partitions),
-	.options	= NAND_COPYBACK | NAND_CACHEPRG | NAND_NO_PADDING \
-			| NAND_NO_READRDY,
+	.options	= NAND_COPYBACK | NAND_CACHEPRG | NAND_NO_PADDING,
 	.init		= nhk8815_nand_init,
 };
 
