Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754655Ab1EUJnd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 May 2011 05:43:33 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:54767 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754484Ab1EUJnb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 May 2011 05:43:31 -0400
Date: Sat, 21 May 2011 11:43:26 +0200
From: Pavel Machek <pavel@ucw.cz>
To: rpurdie@rpsys.net, lenz@cs.wisc.edu,
        kernel list <linux-kernel@vger.kernel.org>, arminlitzel@web.de,
        Cyril Hrubis <metan@ucw.cz>, thommycheck@gmail.com,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        dbaryshkov@gmail.com, omegamoon@gmail.com, eric.y.miao@gmail.com,
        utx@penguin.cz, zaurus-devel@www.linuxtogo.org,
        Marek Vasut <marek.vasut@gmail.com>
Subject: Disable CF during suspend
Message-ID: <20110521094326.GB26323@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Disable SPITZ_SCP_CF_POWER during suspend. Otherwise it eats battery,
fast. Thanks to Stanislav Brabec.
    
Signed-off-by: Pavel Machek <pavel@ucw.cz>
    
diff --git a/arch/arm/mach-pxa/include/mach/spitz.h b/arch/arm/mach-pxa/include/mach/spitz.h
index 685749a..06b7cbc 100644
--- a/arch/arm/mach-pxa/include/mach/spitz.h
+++ b/arch/arm/mach-pxa/include/mach/spitz.h
@@ -96,7 +96,7 @@
 #define SPITZ_SCP_CHRG_ON       SCOOP_GPCR_PA13  /* Keep */
 #define SPITZ_SCP_MUTE_L        SCOOP_GPCR_PA14  /* Low */
 #define SPITZ_SCP_MUTE_R        SCOOP_GPCR_PA15  /* Low */
-#define SPITZ_SCP_CF_POWER      SCOOP_GPCR_PA16  /* Keep */
+#define SPITZ_SCP_CF_POWER      SCOOP_GPCR_PA16  /* Low, CF card eats power */
 #define SPITZ_SCP_LED_ORANGE    SCOOP_GPCR_PA17  /* Keep */
 #define SPITZ_SCP_JK_A          SCOOP_GPCR_PA18  /* Low */
 #define SPITZ_SCP_ADC_TEMP_ON   SCOOP_GPCR_PA19  /* Low */
@@ -105,7 +105,7 @@
                                SPITZ_SCP_MUTE_L | SPITZ_SCP_MUTE_R | \
                                SPITZ_SCP_CF_POWER | SPITZ_SCP_JK_A | SPITZ_SCP_ADC_TEMP_ON)
 #define SPITZ_SCP_IO_OUT      (SPITZ_SCP_CHRG_ON | SPITZ_SCP_MUTE_L | SPITZ_SCP_MUTE_R)
-#define SPITZ_SCP_SUS_CLR     (SPITZ_SCP_MUTE_L | SPITZ_SCP_MUTE_R | SPITZ_SCP_JK_A | SPITZ_SCP_ADC_TEMP_ON)
+#define SPITZ_SCP_SUS_CLR     (SPITZ_SCP_MUTE_L | SPITZ_SCP_MUTE_R | SPITZ_SCP_JK_A | SPITZ_SCP_ADC_TEMP_ON | SPITZ_SCP_CF_POWER)
 #define SPITZ_SCP_SUS_SET     0
 
 #define SPITZ_SCP_GPIO_BASE	(NR_BUILTIN_GPIO)

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
