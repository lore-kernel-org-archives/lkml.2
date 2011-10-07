Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758587Ab1JGH23 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 03:28:29 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:40128 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751454Ab1JGH22 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 03:28:28 -0400
MIME-Version: 1.0
In-Reply-To: <1317499438-14058-13-git-send-email-arnd@arndb.de>
References: <1317499438-14058-1-git-send-email-arnd@arndb.de> <1317499438-14058-13-git-send-email-arnd@arndb.de>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Fri, 7 Oct 2011 15:28:07 +0800
Message-ID: <CAMPhdO-1ZZ28Z7affqgXWqwnbbAEhyC3_Tbgtdp2v+s4bqqQRQ@mail.gmail.com>
Subject: Re: [PATCH 12/26] ARM: pxa: pxa95x/saarb depends on pxa3xx code
To: Arnd Bergmann <arnd@arndb.de>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Jason Chagas <jason.chagas@marvell.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 2, 2011 at 4:03 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> saarb uses pxa3xx_map_io and pxa3xx_handle_irq, which are part
> of the pxa3xx code. This makes sure the necessary header and
> implementation is used when building the board file.
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  arch/arm/mach-pxa/Makefile |    2 +-
>  arch/arm/mach-pxa/saarb.c  |    2 ++
>  2 files changed, 3 insertions(+), 1 deletions(-)
>
> diff --git a/arch/arm/mach-pxa/Makefile b/arch/arm/mach-pxa/Makefile
> index cc39d17..be0f7df 100644
> --- a/arch/arm/mach-pxa/Makefile
> +++ b/arch/arm/mach-pxa/Makefile
> @@ -19,7 +19,7 @@ endif
>  obj-$(CONFIG_PXA25x)           += mfp-pxa2xx.o clock-pxa2xx.o pxa2xx.o pxa25x.o
>  obj-$(CONFIG_PXA27x)           += mfp-pxa2xx.o clock-pxa2xx.o pxa2xx.o pxa27x.o
>  obj-$(CONFIG_PXA3xx)           += mfp-pxa3xx.o clock-pxa3xx.o pxa3xx.o smemc.o pxa3xx-ulpi.o
> -obj-$(CONFIG_PXA95x)           += mfp-pxa3xx.o clock-pxa3xx.o pxa95x.o smemc.o
> +obj-$(CONFIG_PXA95x)           += mfp-pxa3xx.o clock-pxa3xx.o pxa3xx.o pxa95x.o smemc.o
>  obj-$(CONFIG_CPU_PXA300)       += pxa300.o
>  obj-$(CONFIG_CPU_PXA320)       += pxa320.o
>  obj-$(CONFIG_CPU_PXA930)       += pxa930.o
> diff --git a/arch/arm/mach-pxa/saarb.c b/arch/arm/mach-pxa/saarb.c
> index ebd6379..829c514 100644
> --- a/arch/arm/mach-pxa/saarb.c
> +++ b/arch/arm/mach-pxa/saarb.c
> @@ -25,6 +25,8 @@
>  #include <mach/mfp-pxa930.h>
>  #include <mach/gpio.h>
>
> +#include <mach/pxa930.h>
> +
>  #include "generic.h"
>
>  #define SAARB_NR_IRQS  (IRQ_BOARD_START + 40)
> --
> 1.7.5.4
>
>

PXA95x is actually PJ4 based, which is ARMv7/v6 compatible, not
like it's predecessor PXA93x. Although they are currently sharing
some code, I expect a fork in the near future. To cause less confusion
here, I'd propose to further introduce pxa95x.h, and to remove
the unnecessary #include of <mach/mfp.h> and <mach/mfp-pxa930.h>

diff --git a/arch/arm/mach-pxa/Makefile b/arch/arm/mach-pxa/Makefile
index cc39d17..be0f7df 100644
--- a/arch/arm/mach-pxa/Makefile
+++ b/arch/arm/mach-pxa/Makefile
@@ -19,7 +19,7 @@ endif
 obj-$(CONFIG_PXA25x)		+= mfp-pxa2xx.o clock-pxa2xx.o pxa2xx.o pxa25x.o
 obj-$(CONFIG_PXA27x)		+= mfp-pxa2xx.o clock-pxa2xx.o pxa2xx.o pxa27x.o
 obj-$(CONFIG_PXA3xx)		+= mfp-pxa3xx.o clock-pxa3xx.o pxa3xx.o smemc.o
pxa3xx-ulpi.o
-obj-$(CONFIG_PXA95x)		+= mfp-pxa3xx.o clock-pxa3xx.o pxa95x.o smemc.o
+obj-$(CONFIG_PXA95x)		+= mfp-pxa3xx.o clock-pxa3xx.o pxa3xx.o pxa95x.o smemc.o
 obj-$(CONFIG_CPU_PXA300)	+= pxa300.o
 obj-$(CONFIG_CPU_PXA320)	+= pxa320.o
 obj-$(CONFIG_CPU_PXA930)	+= pxa930.o
diff --git a/arch/arm/mach-pxa/include/mach/pxa95x.h
b/arch/arm/mach-pxa/include/mach/pxa95x.h
new file mode 100644
index 0000000..cbb097c
--- /dev/null
+++ b/arch/arm/mach-pxa/include/mach/pxa95x.h
@@ -0,0 +1,7 @@
+#ifndef __MACH_PXA95X_H
+#define __MACH_PXA95X_H
+
+#include <mach/pxa3xx.h>
+#include <mach/mfp-pxa930.h>
+
+#endif /* __MACH_PXA95X_H */
diff --git a/arch/arm/mach-pxa/saarb.c b/arch/arm/mach-pxa/saarb.c
index ebd6379..aebd5d9 100644
--- a/arch/arm/mach-pxa/saarb.c
+++ b/arch/arm/mach-pxa/saarb.c
@@ -21,9 +21,8 @@

 #include <mach/irqs.h>
 #include <mach/hardware.h>
-#include <mach/mfp.h>
-#include <mach/mfp-pxa930.h>
 #include <mach/gpio.h>
+#include <mach/pxa95x.h>

 #include "generic.h"
