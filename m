Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754858Ab2FWPrj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2012 11:47:39 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:49286 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751186Ab2FWPri (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2012 11:47:38 -0400
Date: Sat, 23 Jun 2012 11:47:33 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@oneiric
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: should there still be arch-specific 4KSTACKS support?
Message-ID: <alpine.DEB.2.02.1206231142150.14887@oneiric>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


  via some convoluted logic, i ended up doing the following search:

$ grep -r 4KSTACKS *
arch/sh/configs/r7785rp_defconfig:CONFIG_4KSTACKS=y
arch/sh/Kconfig.debug:config 4KSTACKS
arch/sh/include/asm/thread_info.h:#if defined(CONFIG_4KSTACKS)
arch/mn10300/include/asm/thread_info.h:#ifdef CONFIG_4KSTACKS
arch/m68k/Kconfig.machine:config 4KSTACKS
arch/m68k/configs/m5208evb_defconfig:# CONFIG_4KSTACKS is not set
arch/m68k/configs/m5275evb_defconfig:# CONFIG_4KSTACKS is not set
arch/m68k/configs/m5475evb_defconfig:# CONFIG_4KSTACKS is not set
arch/m68k/include/asm/thread_info.h:#ifdef CONFIG_4KSTACKS
arch/c6x/include/asm/thread_info.h:#ifdef CONFIG_4KSTACKS
drivers/lguest/interrupts_and_traps.c:	 * Depending on the CONFIG_4KSTACKS option, the Guest can have one or
kernel/lockdep.c:	 * hardirq contexts (such as on 4KSTACKS), so only
$

  so even though 4KSTACKS support was officially removed in June of
2010:

$ git show dcfa7262

there's still traces of it, some of it obviously harmless, leftover
cruft, but it would appear that both sh and m68k still provide a
4KSTACKS config option.

  how much of that can be tossed as useless?

rday

-- 

========================================================================
Robert P. J. Day                                 Ottawa, Ontario, CANADA
                        http://crashcourse.ca

Twitter:                                       http://twitter.com/rpjday
LinkedIn:                               http://ca.linkedin.com/in/rpjday
========================================================================

