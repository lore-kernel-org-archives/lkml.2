Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932221Ab1GELZ7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 07:25:59 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:61471 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932177Ab1GELZ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 07:25:58 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Jean-Christophe PLAGNIOL-VILLARD" <plagnioj@jcrosoft.com>
Subject: Re: [PATCH] AT91: add AT91SAM9X5 dummy configuration variable
Date: Tue, 5 Jul 2011 13:25:47 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>, balbi@ti.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        avictor.za@gmail.com
References: <1309260927-11411-1-git-send-email-nicolas.ferre@atmel.com> <4E118679.4090908@atmel.com> <20110705053229.GC27909@game.jcrosoft.org>
In-Reply-To: <20110705053229.GC27909@game.jcrosoft.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201107051325.47417.arnd@arndb.de>
X-Provags-ID: V02:K0:TSjcjYoWdT0Okmej/CAbQz+Vl96yUQiA1gCQz5J9yEc
 inBGwfZ9bvMtd5DbABH0YdltKF7/y4MEx/LKeZFCTazfL1slPO
 ps37k4lVA6tV3k0OQfkmGY9GENLn/9wb7j5R/Szb2giZ5NQYdl
 mrJcx+aZ1/WzGF+wW6rmkJZ2syOugbpnEmSPBfK/5XtGLI2FHX
 mghFWToF9Fx9KafNJaYoQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 05 July 2011, Jean-Christophe PLAGNIOL-VILLARD wrote:
> > You have convinced me.
> > But I will have to remove the other dependencies that I mentioned before
> > in the thread.
> > 
> > We can drop this patch.
> I prefer to hide the platform specific driver other wise we will have a huge
> menu entry in Kconfig with unrelated drivers that can not be used at all on
> the selected mach

I fear it's too late for that. You already have to decide on many thousands
of configuration options, most of which are totally irrelevant for a
particular system.

IMHO, the two much better ways to deal with SOC-specific device drivers
are defconfig files and/or specific defaults, like

config ABX500_CORE
        bool "ST-Ericsson ABX500 Mixed Signal Circuit register functions"
        default ARCH_U300 || ARCH_U8500

This lets everybody choose whether they would like to build the driver
or not, which is very useful for allyesconfig/allnoconfig/randconfig
builds. At the same time, the default gets it right in almost all
other cases.

	Arnd
