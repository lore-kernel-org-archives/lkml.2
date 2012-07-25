Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933132Ab2GYOC1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 10:02:27 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:59653 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932927Ab2GYOC0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 10:02:26 -0400
From: "Mohammed, Afzal" <afzal@ti.com>
To: Sergei Shtylyov <sshtylyov@mvista.com>
CC: "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "rob@landley.net" <rob@landley.net>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "Nori, Sekhar" <nsekhar@ti.com>, "Hilman, Kevin" <khilman@ti.com>,
        "a.zummo@towertech.it" <a.zummo@towertech.it>,
        "tony@atomide.com" <tony@atomide.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>
Subject: RE: [PATCH v2 1/6] rtc: omap: kicker mechanism support
Thread-Topic: [PATCH v2 1/6] rtc: omap: kicker mechanism support
Thread-Index: AQHNaixpB26Cq/HdyEunZERxKJvZgJc5fQyAgACHmiA=
Date: Wed, 25 Jul 2012 14:01:21 +0000
Message-ID: <C8443D0743D26F4388EA172BF4E2A7A93E9AD898@DBDE01.ent.ti.com>
References: <cover.1343191280.git.afzal@ti.com>
 <ecf6520fc9d5da53b670675a71ebece3d006cbb8.1343191280.git.afzal@ti.com>
 <500FD551.9070002@mvista.com>
In-Reply-To: <500FD551.9070002@mvista.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.170.142]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sergei,

On Wed, Jul 25, 2012 at 16:45:29, Sergei Shtylyov wrote:

> > +/* OMAP_RTC_KICKER values */
> > +#define	KICK0_VALUE			(0x83e70b13)
> > +#define	KICK1_VALUE			(0x95a4f1e0)
> 
>     Parens not needed around simple literals.

Thanks for catching it

> 
> >   static void __iomem	*rtc_base;
> >
> >   #define rtc_read(addr)		__raw_readb(rtc_base + (addr))
> >   #define rtc_write(val, addr)	__raw_writeb(val, rtc_base + (addr))
> >
> > +#define rtc_writel(val, addr)	writel(val, rtc_base + (addr))
> > +
> 
>     Why not __raw_writel() like the above functions?

This driver would be used in AM335X, it being ARMv7, writel would be
safe (existing __raw_readb/__raw_writeb too needs to be replaced)

Regards
Afzal
