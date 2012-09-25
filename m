Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752835Ab2IYFUG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 01:20:06 -0400
Received: from londo.lunn.ch ([80.238.139.98]:44222 "EHLO londo.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751953Ab2IYFUE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 01:20:04 -0400
Date: Tue, 25 Sep 2012 07:19:34 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/6] ARM: dove: Fix tauros2 device tree init
Message-ID: <20120925051934.GJ14266@lunn.ch>
References: <1348531338-16624-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1348531338-16624-3-git-send-email-sebastian.hesselbarth@gmail.com>
 <5061073C.4010002@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5061073C.4010002@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 25, 2012 at 03:22:04AM +0200, Sebastian Hesselbarth wrote:
> On 09/25/2012 02:02 AM, Sebastian Hesselbarth wrote:
> >During the review process of dove DT patches, Tauros2 cache
> >init call was changed and DT support added. This patch fixes
> >the call to Tauros2 init and adds a DT node. Moreover, plat/irq.h
> >include was missing from mach-dove/common.c.
> > ...
> >diff --git a/arch/arm/mach-dove/common.c b/arch/arm/mach-dove/common.c
> >index b37bef1..343a4bc 100644
> >--- a/arch/arm/mach-dove/common.c
> >+++ b/arch/arm/mach-dove/common.c
> >@@ -32,6 +32,7 @@
> >  #include<linux/irq.h>
> >  #include<plat/time.h>
> >  #include<linux/platform_data/usb-ehci-orion.h>
> >+#include<plat/irq.h>
> >  #include<plat/common.h>
> >  #include<plat/addr-map.h>
> >  #include "common.h"
> >@@ -399,7 +400,7 @@ static void __init dove_dt_init(void)
> >  		(dove_tclk + 499999) / 1000000);
> >
> >  #ifdef CONFIG_CACHE_TAUROS2
> >-	tauros2_init();
> >+	tauros2_init(0);
> >  #endif
> >  	dove_setup_cpu_mbus();
> >
> 
> I thought about the importance of the individual patches and
> except 2/6 all can wait for the next release cycle if too late.
> 
> But 2/6 is important because the change in tauros2_init
> breaks build on dove.

Hi Sebastian

Interestingly, kisskb does not show this break:

http://kisskb.ellerman.id.au/kisskb/config/308/

and yesterdays build does not have the parameter to tauros2_init().
Is the cache not enabled in dove_defconfig?

Andrew
