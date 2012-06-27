Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753367Ab2F0NKJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 09:10:09 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:36922 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863Ab2F0NKH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 09:10:07 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19u4zUygaIfnwhSiEY84U4F
Date: Wed, 27 Jun 2012 06:10:02 -0700
From: Tony Lindgren <tony@atomide.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Russell King <linux@arm.linux.org.uk>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] ARM: omap: remove unused cpu detection macros
Message-ID: <20120627131002.GH3483@atomide.com>
References: <1340745209.1911.15.camel@x61.thuisdomein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340745209.1911.15.camel@x61.thuisdomein>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Paul Bolle <pebolle@tiscali.nl> [120626 14:18]:
> Now that OMAP730 and OMAP850 support is mostly unified, there's no
> need for separate cpu detection macros for these architectures. At
> least, currently there isn't, because both macros are unused.
> cpu_is_7xx() seems to cover all possible uses.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> 0) Entirely untested!

Seems to work :)
 
> 1) And now the IS_OMAP_TYPE() macro "calls" for 730 and 850 are unused.
> Not sure whether they should be removed too.

Yes those can go now too, I've applied the updated patch
below into fixes-non-critical along with the first patch
in this series.
 
> 2) Note that cpu_is_omap343x(), cpu_is_omap447x(), and cpu_is_omap2423()
> are all unused too. Reserved for future use, I guess.

It seems that at least 447x will be used soon. The others
we should be able to remove.

Regards,

Tony
 

Author: Paul Bolle <pebolle@tiscali.nl>
Date:   Tue Jun 26 23:13:29 2012 +0200

    ARM: OMAP: remove unused cpu detection macros
    
    Now that OMAP730 and OMAP850 support is mostly unified, there's no
    need for separate cpu detection macros for these architectures. At
    least, currently there isn't, because both macros are unused.
    cpu_is_7xx() seems to cover all possible uses.
    
    Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
    [tony@atomide.com: updated to also to remove related IS_OMAP_TYPE]
    Signed-off-by: Tony Lindgren <tony@atomide.com>

diff --git a/arch/arm/plat-omap/include/plat/cpu.h b/arch/arm/plat-omap/include/plat/cpu.h
index f2bdf15..e79e913 100644
--- a/arch/arm/plat-omap/include/plat/cpu.h
+++ b/arch/arm/plat-omap/include/plat/cpu.h
@@ -239,8 +239,6 @@ IS_AM_SUBCLASS(335x, 0x335)
  * Macros to detect individual cpu types.
  * These are only rarely needed.
  * cpu_is_omap310():	True for OMAP310
- * cpu_is_omap730():	True for OMAP730
- * cpu_is_omap850():	True for OMAP850
  * cpu_is_omap1510():	True for OMAP1510
  * cpu_is_omap1610():	True for OMAP1610
  * cpu_is_omap1611():	True for OMAP1611
@@ -264,8 +262,6 @@ static inline int is_omap ##type (void)			\
 }
 
 IS_OMAP_TYPE(310, 0x0310)
-IS_OMAP_TYPE(730, 0x0730)
-IS_OMAP_TYPE(850, 0x0850)
 IS_OMAP_TYPE(1510, 0x1510)
 IS_OMAP_TYPE(1610, 0x1610)
 IS_OMAP_TYPE(1611, 0x1611)
@@ -281,8 +277,6 @@ IS_OMAP_TYPE(3505, 0x3517)
 IS_OMAP_TYPE(3517, 0x3517)
 
 #define cpu_is_omap310()		0
-#define cpu_is_omap730()		0
-#define cpu_is_omap850()		0
 #define cpu_is_omap1510()		0
 #define cpu_is_omap1610()		0
 #define cpu_is_omap5912()		0
@@ -304,19 +298,9 @@ IS_OMAP_TYPE(3517, 0x3517)
 
 /*
  * Whether we have MULTI_OMAP1 or not, we still need to distinguish
- * between 730 vs 850, 310 vs. 1510 and 1611B/5912 vs. 1710.
+ * between 310 vs. 1510 and 1611B/5912 vs. 1710.
  */
 
-#if defined(CONFIG_ARCH_OMAP730)
-# undef  cpu_is_omap730
-# define cpu_is_omap730()		is_omap730()
-#endif
-
-#if defined(CONFIG_ARCH_OMAP850)
-# undef  cpu_is_omap850
-# define cpu_is_omap850()		is_omap850()
-#endif
-
 #if defined(CONFIG_ARCH_OMAP15XX)
 # undef  cpu_is_omap310
 # undef  cpu_is_omap1510
