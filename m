Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752806Ab1IUJZ1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 05:25:27 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:52314 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752247Ab1IUJZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 05:25:26 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Wolfgang Grandegger <wg@grandegger.com>
Cc: SocketCAN Core Mailing List <socketcan-core@lists.berlios.de>,
        Willy Lambert <lambert.willy@gmail.com>, x86@kernel.org,
        Valdis.Kletnieks@vt.edu, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86_64: permit to configure ISA support also for x86_64 systems
Date: Wed, 21 Sep 2011 11:24:44 +0200
Message-ID: <11382509.BgAkVknI9a@wuerfel>
User-Agent: KMail/4.7.1 (Linux/3.0.0-rc1nosema+; KDE/4.7.1; x86_64; ; )
In-Reply-To: <4E79A146.2040204@grandegger.com>
References: <4E731565.5050307@grandegger.com> <201109201747.50130.arnd@arndb.de> <4E79A146.2040204@grandegger.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:PWPW0BJvhZ0tE13Tkw09QMFktucYHV4pasWhJk9sQE7
 sT0G2lLNZ7MfPmAslXCIItc+34fQsi5CSS8Uhyt1xX4w+s3l+c
 SBu5cK0KTXKjWxe28NI/lkWo2HbrYTwBZq5Cjg4MoZofd0BQYP
 EH7R5/rvuwjyAvYHysH3hKf2u26B1p4hCfsyldkNo2hstjoN6D
 Z81mP8IWKB6sTcQcoFomWYrJ7uKupftLIiRRGDDS11VON5c0m0
 SRqMS2xsRyaZozlQdt8bbOUunwgAf6Q61pHPA4+csAZai8zrhG
 Nmk1wC7D7hC0E/7nsolCwn1zM148CstULfHRTdxkq5dNzh0UXm
 8zagnLLjGyWS8ZFBdgTw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 21 September 2011 10:33:10 Wolfgang Grandegger wrote:
> 
> > Since most ISA drivers don't actually use isa_register_driver
> > (for good or bad), how about changing the Kconfig entry for
> > the ones you need to 'depends on ISA || PLAT_GRANDEGGER_PC104_ATOM'
> > or similar?
> 
> What should the PLAT_GRANDEGGER_PC104_ATOM be good for? If I replace
> isa_register_driver() with platform_driver_register(), like the serial
> 8250 driver does, HAS_IOMEM should be just fine. This would then also
> avoid the 64-bit trouble expected with old ISA drivers (enabled via
> ISA). Or have I missed something?

I was thinking of the drivers that are for ISA cards but don't actually
use the isa_register_driver() function. If you have to change the driver
to a platform driver, you are right.

The other point is that you are probably using inb/outb operations,
which I'm trying to provide only on ISA/PCMCIA/PCI based systems in
the future. Once I finish that work, you will also need to depend on
HAS_IOPORT (which currently means something else).

	Arnd
