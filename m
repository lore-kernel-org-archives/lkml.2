Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755863Ab2ECNxQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 09:53:16 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:50005 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753690Ab2ECNxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 09:53:15 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Making ARM multiplatform kernels DT-only?
Date: Thu, 3 May 2012 13:50:35 +0000
User-Agent: KMail/1.12.2 (Linux/3.4.0-rc3; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        "Jean-Christophe PLAGNIOL-VILLARD" <plagnioj@jcrosoft.com>,
        Deepak Saxena <dsaxena@linaro.org>,
        "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>,
        Linus Walleij <linus.walleij@linaro.org>, shawn.guo@linaro.org,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Magnus Damm <magnus.damm@gmail.com>,
        Kukjin Kim <kgene.kim@samsung.com>, Olof Johansson <olof@lixom.net>,
        David Brown <davidb@codeaurora.org>, Nicolas Pitre <nico@fluxnic.net>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201205031350.35476.arnd@arndb.de>
X-Provags-ID: V02:K0:DaBBBk9vg9taRUk0qgE5kwBgz4nRz1L08PsIz1ab//l
 j5Tj8qXUBVCRP+sBh5oZ1of8BO+kgwfg2ctBWZIPdpSJWR+w+X
 iVT+F5Gae3zJ+76ZmPdKJsdLRWErbNbojZOyl3XKDC4Am1qbUf
 yI8n3aW14dDXHdANuWJtjcmZQYkqSRtnCRDBl6SKqNMUaus5dc
 nkKFIJn58tmUtHk+dyAwy9BCVuGbXWSVh3RyOZTeIWPHqXknum
 hmAMtUzOafCO6Iui3ee1mBBAR7iydCWQoW+kmUW5eOTUsUcp8O
 HoHs6inqw6bvheJvsMGlJBpvDAh365d2cCuDjkUn7dKdyAMlEb
 A1zb6nPD4Kye9d9fRB/4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

I've been discussing multiplatform kernels with a few people recently,
and we will have a lot of discussion sessions about this at Linaro
Connect in Hong Kong.

One question that came up repeatedly is whether we should support all
possible board files for each platform in a multiplatform kernel,
or just the ones that are already using DT probing. I would like
to get a quick poll of opinions on that and I've tried to put those
people on Cc that would be most impacted by this, i.e. the maintainers
for platforms that have both DT and non-DT board files at the moment.

My feeling is that we should just mandate DT booting for multiplatform
kernels, because it significantly reduces the combinatorial space
at compile time, avoids a lot of legacy board files that we cannot
test anyway, reduces the total kernel size and gives an incentive
for people to move forward to DT with their existing boards.

The counterargument is that we won't be able to support all the
boards we currently do when the user switches on multiplatform,
but I think that is acceptable.
Note that I would still want to allow users to build platforms
separately in order to enable the ATAG style board files, even
for platforms that are not multiplatform capable.

Other opinions?

	Arnd
