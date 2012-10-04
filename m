Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964822Ab2JDNnR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 09:43:17 -0400
Received: from 11.mo1.mail-out.ovh.net ([188.165.48.29]:39551 "EHLO
	mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933077Ab2JDNnP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 09:43:15 -0400
X-Greylist: delayed 1200 seconds by postgrey-1.27 at vger.kernel.org; Thu, 04 Oct 2012 09:43:15 EDT
Date: Thu, 4 Oct 2012 15:05:10 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@infradead.org, arm@kernel.org,
        linux-kernel@vger.kernel.org, Nicolas Ferre <nicolas.ferre@atmel.com>
X-Ovh-Mailout: 178.32.228.1 (mo1.mail-out.ovh.net)
Subject: Re: [PATCH 08/17] ARM: at91: unused variable in
 at91_pm_verify_clocks
Message-ID: <20121004130510.GF5117@game.jcrosoft.org>
References: <1349195816-2225-1-git-send-email-arnd@arndb.de>
 <1349195816-2225-9-git-send-email-arnd@arndb.de>
 <20121002185540.GB5117@game.jcrosoft.org>
 <201210040828.11226.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201210040828.11226.arnd@arndb.de>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 9950140426886753028
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeehuddrtdeiucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfhrhhomheplfgvrghnqdevhhhrihhsthhophhhvgcurffntefipffkqffnqdggkffnnfettfffuceophhlrghgnhhiohhjsehjtghrohhsohhfthdrtghomheqnecujfgurhepfffhvffukfhfgggtuggjfgesthdttfdttdervd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeehuddrtdeiucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfhrhhomheplfgvrghnqdevhhhrihhsthhophhhvgcurffntefipffkqffnqdggkffnnfettfffuceophhlrghgnhhiohhjsehjtghrohhsohhfthdrtghomheqnecujfgurhepfffhvffukfhfgggtuggjfgesthdttfdttdervd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08:28 Thu 04 Oct     , Arnd Bergmann wrote:
> On Tuesday 02 October 2012, Jean-Christophe PLAGNIOL-VILLARD wrote:
> > >  	unsigned long scsr;
> > > +#ifdef CONFIG_AT91_PROGRAMMABLE_CLOCKS
> > >  	int i;
> > > +#endif
> > please is if (IS_ENBLED())
> > 
> > #ifdef drop code coverage
> > 
> 
> Ok, agreed. Here is the new version:
> 
> From bacd47abb36104665261c84f6f85bba7aef8a521 Mon Sep 17 00:00:00 2001
> From: Arnd Bergmann <arnd@arndb.de>
> Date: Mon, 30 Apr 2012 13:00:32 +0000
> Subject: [PATCH] ARM: at91: unused variable in at91_pm_verify_clocks
> 
> The code using the variable 'i' in this function is conditional which
> results in a harmless compiler warning. Using the IS_ENABLED macro
> instead of #ifdef makes the code look nicer and gets rid of the
> warning.
> 
> Without this patch, building at91sam9263_defconfig results in:
> 
> /home/arnd/linux-arm/arch/arm/mach-at91/pm.c: In function 'at91_pm_verify_clocks':
> /home/arnd/linux-arm/arch/arm/mach-at91/pm.c:137:6: warning: unused variable 'i' [-Wunused-variable]
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Nicolas Ferre <nicolas.ferre@atmel.com>
> Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
Acked-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>

Best Regards,
J.
