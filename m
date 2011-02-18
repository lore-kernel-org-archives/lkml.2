Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752064Ab1BRFo0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 00:44:26 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:55421 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750841Ab1BRFoZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 00:44:25 -0500
From: hayeswang <hayeswang@realtek.com>
To: "'Alexander Wuerstlein'" <arw@arw.name>
CC: "'David S. Miller'" <davem@davemloft.net>, <linux-kernel@vger.kernel.org>,
        "'franois romieu'" <romieu@fr.zoreil.com>
References: <20110216223438.GZ15516@cip.informatik.uni-erlangen.de>
Subject: RE: r8169 hangs machine on kernel boot (bisected)
Date: Fri, 18 Feb 2011 13:44:04 +0800
X-BOX-Message-Id: p1I5i3Db017489
Message-ID: <CDC3F2AD9A574AC4B7DDDB7D64329A79@realtek.com.tw>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
Thread-Index: AcvPDLzK/hHBqZSOSJOAKk14GEN5uQAIGmig
In-Reply-To: <20110216223438.GZ15516@cip.informatik.uni-erlangen.de>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5994
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I have try the 8168DP and it wouldn't hang. I think I need more information.
Could you give the information about the motherboard and the version of BIOS.
Besides, please use the realtek driver, and dump the MAC information by using
"ethtool -d eth0". These are helpful to find out what happens. Thanks.
 
Best Regards,
Hayes


-----Original Message-----
From: Alexander Wuerstlein [mailto:arw@arw.name] 
Sent: Thursday, February 17, 2011 6:35 AM
To: franois romieu
Cc: Hayeswang; David S. Miller; linux-kernel@vger.kernel.org
Subject: r8169 hangs machine on kernel boot (bisected)

Hello,

I've just tried to boot a new computer featuring a Realtek r8168 onboard (lspci
calls it Realtek Semiconductor Co., Ltd. RTL8111/8168B PCI Express Gigabit
Ethernet controller [10ec:8168] (rev 04), see [1]) network chip with kernel
2.6.38-rc5 and current git. Both hang on boot just after USB device
initialization and just before the kernel usually does DHCP. The previous 2.6.37
didn't hang on boot, but showed strange behaviour (only 10MBit half duplex on
autonegotiation, tons of errors on the switch interface[2]) which is why I tried
the newer kernel in hopes that there would be fixes.

I bisected the hang-before-dhcp bug down to commit 'r8169: magic.'
(b646d90053f887c1bc243191e693a9b02d09f2c2, also see [1]). Since the commit
really does its description justice and looks like some weird hardware magic,
I'd like to ask the wizards on how to proceed with fixing it.



Ciao,

Alexander Wuerstlein.

[1] Kernel .config, lspci, bisect log:
    http://wwwcip.cs.fau.de/~snalwuer/kernel-r8169/
[2] the Realtek-supplied r8168 doesn't show those problems [3] feel free to
criticise my Cc:, I wasn't quite sure...

