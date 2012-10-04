Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965543Ab2JDI2T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 04:28:19 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:58846 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964998Ab2JDI2Q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 04:28:16 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Jean-Christophe PLAGNIOL-VILLARD" <plagnioj@jcrosoft.com>
Subject: Re: [PATCH 08/17] ARM: at91: unused variable in at91_pm_verify_clocks
Date: Thu, 4 Oct 2012 08:28:11 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@infradead.org, arm@kernel.org,
        linux-kernel@vger.kernel.org, Nicolas Ferre <nicolas.ferre@atmel.com>
References: <1349195816-2225-1-git-send-email-arnd@arndb.de> <1349195816-2225-9-git-send-email-arnd@arndb.de> <20121002185540.GB5117@game.jcrosoft.org>
In-Reply-To: <20121002185540.GB5117@game.jcrosoft.org>
MIME-Version: 1.0
Content-Type: Text/Plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-Id: <201210040828.11226.arnd@arndb.de>
X-Provags-ID: V02:K0:f3ND7wkfkHEO0pdIZ+DZAEopXC84vR/8tckYhRmGuTq
 bgw+mPlztZq/jdvwA870AUpUyCixQi8b9K1R8cu1IrDtzk4lwQ
 +ZDfisolg5ug1821dUn6E8cx1U66xMJPRX7l72gTvpy1tLua0g
 W/AP+7VF3JQ2EGWLyfidXGdgj63dWS0IqJXkSq9GDh0gSAlvu7
 5VAiFl6mqPa5wbOMo9Z3JHVQbuN500Rs9zgRpZr2VKDe6emLx/
 mr9W0nSs/9aYdH/zJqBK3aGi63jaqWDwcbmrQ+StFbXk14lSep
 Ra/TMjLt/Lg3E9ufQ4XCcyNnImsXFrD4jmVtkS+lujKltul23y
 5PpdNCTS6xNRxHGvjtsQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 02 October 2012, Jean-Christophe PLAGNIOL-VILLARD wrote:
> >  	unsigned long scsr;
> > +#ifdef CONFIG_AT91_PROGRAMMABLE_CLOCKS
> >  	int i;
> > +#endif
> please is if (IS_ENBLED())
> 
> #ifdef drop code coverage
> 

Ok, agreed. Here is the new version:

>From bacd47abb36104665261c84f6f85bba7aef8a521 Mon Sep 17 00:00:00 2001
From: Arnd Bergmann <arnd@arndb.de>
Date: Mon, 30 Apr 2012 13:00:32 +0000
Subject: [PATCH] ARM: at91: unused variable in at91_pm_verify_clocks

The code using the variable 'i' in this function is conditional which
results in a harmless compiler warning. Using the IS_ENABLED macro
instead of #ifdef makes the code look nicer and gets rid of the
warning.

Without this patch, building at91sam9263_defconfig results in:

/home/arnd/linux-arm/arch/arm/mach-at91/pm.c: In function 'at91_pm_verify_clocks':
/home/arnd/linux-arm/arch/arm/mach-at91/pm.c:137:6: warning: unused variable 'i' [-Wunused-variable]

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>

diff --git a/arch/arm/mach-at91/pm.c b/arch/arm/mach-at91/pm.c
index 2c2d865..5315f05 100644
--- a/arch/arm/mach-at91/pm.c
+++ b/arch/arm/mach-at91/pm.c
@@ -153,7 +153,9 @@ static int at91_pm_verify_clocks(void)
 		}
 	}
 
-#ifdef CONFIG_AT91_PROGRAMMABLE_CLOCKS
+	if (!IS_ENABLED(CONFIG_AT91_PROGRAMMABLE_CLOCKS))
+		return 1;
+
 	/* PCK0..PCK3 must be disabled, or configured to use clk32k */
 	for (i = 0; i < 4; i++) {
 		u32 css;
@@ -167,7 +169,6 @@ static int at91_pm_verify_clocks(void)
 			return 0;
 		}
 	}
-#endif
 
 	return 1;
 }

