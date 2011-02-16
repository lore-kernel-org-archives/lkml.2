Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755460Ab1BPWno (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 17:43:44 -0500
Received: from faui03.informatik.uni-erlangen.de ([131.188.30.103]:61178 "EHLO
	faui03.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753139Ab1BPWnm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 17:43:42 -0500
X-Greylist: delayed 541 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 Feb 2011 17:43:42 EST
Date: Wed, 16 Feb 2011 23:34:38 +0100
From: Alexander Wuerstlein <arw@arw.name>
To: franois romieu <romieu@fr.zoreil.com>
Cc: Hayes <hayeswang@realtek.com>, "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org
Subject: r8169 hangs machine on kernel boot (bisected)
Message-ID: <20110216223438.GZ15516@cip.informatik.uni-erlangen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Echelon-Scan: plutonium bomb dirty irak allah satan bush victory c4 cocaine
 saddam wtc holy war believe god cia nsa
X-Echelon-Result: Terrorist
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I've just tried to boot a new computer featuring a Realtek r8168 onboard
(lspci calls it Realtek Semiconductor Co., Ltd. RTL8111/8168B PCI
Express Gigabit Ethernet controller [10ec:8168] (rev 04), see [1])
network chip with kernel 2.6.38-rc5 and current git. Both hang on boot
just after USB device initialization and just before the kernel usually
does DHCP. The previous 2.6.37 didn't hang on boot, but showed strange
behaviour (only 10MBit half duplex on autonegotiation, tons of errors on
the switch interface[2]) which is why I tried the newer kernel in hopes
that there would be fixes.

I bisected the hang-before-dhcp bug down to commit 'r8169: magic.'
(b646d90053f887c1bc243191e693a9b02d09f2c2, also see [1]). Since the
commit really does its description justice and looks like some weird
hardware magic, I'd like to ask the wizards on how to proceed with
fixing it.



Ciao,

Alexander Wuerstlein.

[1] Kernel .config, lspci, bisect log:
    http://wwwcip.cs.fau.de/~snalwuer/kernel-r8169/
[2] the Realtek-supplied r8168 doesn't show those problems
[3] feel free to criticise my Cc:, I wasn't quite sure...
