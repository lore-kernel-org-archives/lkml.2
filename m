Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966526Ab2JZUx3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 16:53:29 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:49166 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965143Ab2JZUxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 16:53:25 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: Re: [GIT PULL] at91: fixes for 3.7-rc3
Date: Fri, 26 Oct 2012 20:53:11 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: Olof Johansson <olof@lixom.net>,
        "linux-arm-kernel" <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        "Jean-Christophe PLAGNIOL-VILLARD" <plagnioj@jcrosoft.com>,
        "Ludovic Desroches" <ludovic.desroches@atmel.com>,
        voice <voice.shen@atmel.com>, "Wu, Josh" <Josh.wu@atmel.com>,
        marek.belisko@open-nandra.com, ivan.shugov@gmail.com
References: <5088F131.5040600@atmel.com>
In-Reply-To: <5088F131.5040600@atmel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201210262053.11498.arnd@arndb.de>
X-Provags-ID: V02:K0:SFo9/Aeb0zMvO0LFv1XNp7m0TqfPG0o9uCHPIlK85+g
 ylW0E2dZDkWKOzW4Nuqb+hQmAlEAxB5wv39C6ytNjl7FdYZnfe
 D5iw7VZuJwt5E1fm1BjLu8uP9NvOdGd+jF6qhv+cfAzX6Sc45F
 jQ66tI8xaz6iL6GmWN3yHSL7E3Zu0r7MW1h7PVf9ad3fxfFbZd
 ALP68BObczMocMLZ0FO1jVbML0ft3RsDYsT0/I7oxIzp9C9GxQ
 +gLPBuiqGx2IwG1LeqTFoHHqbg3zTeiMvr4kev/GFLuOmSLxAC
 4puPcXu+m01hvPqkVaXQW762RNdh+mVrlLDYBaa1PqFNbE48mp
 /Ds233O28x+7RmwuNnIE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 25 October 2012, Nicolas Ferre wrote:
>       ARM: at91: fix external interrupts in non-DT case

This patch now leads to build errors with at91x40_defconfig,
which I've fixed up by applying the patch below on top.

Please yell if this is not the right fix.

	Arnd

commit 3a8852afde01682083028ee427e0678f9bbddd75
Author: Arnd Bergmann <arnd@arndb.de>
Date:   Fri Oct 26 22:49:09 2012 +0200

    ARM: at91: fix at91x40 build
    
    patch 738a0fd7 "ARM: at91: fix external interrupts in non-DT case"
    fixed a run-time error on some at91 platforms but did not apply
    the same change to at91x40, which now doesn't build.
    
    This changes at91x40 in the same way that the other platforms
    were changed.
    
    Signed-off-by: Arnd Bergmann <arnd@arndb.de>

diff --git a/arch/arm/mach-at91/at91x40.c b/arch/arm/mach-at91/at91x40.c
index 6bd7300..bb7f544 100644
--- a/arch/arm/mach-at91/at91x40.c
+++ b/arch/arm/mach-at91/at91x40.c
@@ -88,6 +88,6 @@ void __init at91x40_init_interrupts(unsigned int priority[NR_AIC_IRQS])
 	if (!priority)
 		priority = at91x40_default_irq_priority;
 
-	at91_aic_init(priority);
+	at91_aic_init(priority, at91_extern_irq);
 }
 
