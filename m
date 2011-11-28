Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753122Ab1K1Ou3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 09:50:29 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:35772 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751823Ab1K1Ou2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 09:50:28 -0500
Date: Mon, 28 Nov 2011 14:50:25 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lothar =?iso-8859-1?Q?Wa=DFmann?= <LW@KARO-electronics.de>
Cc: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Subject: Re: [BUGFIX][PATCH] drivers/regulator/core.c: fix use after free bug
Message-ID: <20111128145025.GA18958@opensource.wolfsonmicro.com>
References: <1322491117-9185-1-git-send-email-LW@KARO-electronics.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1322491117-9185-1-git-send-email-LW@KARO-electronics.de>
X-Cookie: A is for Apple.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 28, 2011 at 03:38:37PM +0100, Lothar Waßmann wrote:
> Compiling the kernel with CONFIG_PAGE_POISONING produces the following
> crash upon removal of a driver that calls regulator_unregister():

Applied with an edited commit message.

Please do try to use subject lines that match those that the
subsystem uses.  Please also try to make your commit messages more
legible.  In general I'd suggest putting the description of what you're
changing in the first paragraph of the message and if you're going to
include a backtrace editing it down to the human readable portions -
things like:

> |Unable to handle kernel paging request at virtual address ffef3fde
> |pgd = c6564000
> |[ffef3fde] *pgd=47dfe831, *pte=00000000, *ppte=00000000
> |Internal error: Oops: 1 [#1] PREEMPT
> |Modules linked in: snd_soc_mxs_pcm snd_soc_mxs_sgtl5000(-) snd_soc_mxs fixed ehci_hcd mxs_usbphy usbcore usb_common evdev snd_soc_sgtl5000 snd_soc_core regmap_spi snd_pcm snd_timer snd_page_alloc regmap_i2c gpio_pca953x tsc2007 [last unloaded: snd_mixer_oss]
> |CPU: 0    Not tainted  (3.2.0-rc1-next-20111110-karo+ #13)
> |PC is at kfree+0x44/0x17c
> |LR is at regulator_unregister+0x7c/0xac
> |pc : [<c009a6d8>]    lr : [<c0219a34>]    psr: 00000013
> |sp : c650fe80  ip : c641c7e0  fp : beffea28
> |r10: 00000000  r9 : c650e000  r8 : c7372b00
> |r7 : ffef3fde  r6 : 6b6b6b6b  r5 : c72fd70c  r4 : c0219a34
> |r3 : c09e2000  r2 : dffbfe5e  r1 : 00000000  r0 : 6b6b6b6b
> |Flags: nzcv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
> |Control: 0005317f  Table: 46564000  DAC: 00000015
> |Process modprobe (pid: 1281, stack limit = 0xc650e270)
> |Stack: (0xc650fe80 to 0xc6510000)
> |fe80: c73d17c0 c72fd70c c71b1300 c7274d80 c7372b00 c650e000 00000000 c0219a34
> |fea0: c640ab00 bf0637a0 c7372b00 bf06382c c7372b00 c7274360 c71b1300 bf040a50
> |fec0: c720abc0 bf040c44 00000000 bf0ce2b4 00000000 c650e000 c650ff48 c650e000
> |fee0: 00cc5b28 bf041128 bf0ce2b4 bf0ce278 c78bc87c bf0ce0d8 c78bc848 c023f0e0
> |ff00: c78bc848 c023dad8 c78bc848 bf0ce278 c78bc87c c023dbdc c047202c bf0ce278
> |ff20: c049c440 c023cd64 c047202c 00000080 bf0ce4ec c005d250 beffe98c c03250f4
> |ff40: 00000002 00000000 5f646e73 5f636f73 5f73786d 6c746773 30303035 c01ea700
> |ff60: c650e000 00000001 c650ff7c c001e9a0 60000013 c7321a98 beffe98c c0325888
> |ff80: 00ffea1c c87c8db6 00000001 beffea1c 00cc5ac0 00000001 00000081 c000f3c8
> |ffa0: 00000000 c000f200 beffea1c 00cc5ac0 00cc5b28 00000080 beffe984 00000000
> |ffc0: beffea1c 00cc5ac0 00000001 00000081 00cc5b28 0000c69c 00cc5acc beffea28
> |ffe0: 00cc5430 beffe990 0000a42c 4028911c 60000010 00cc5b28 aaaaaaaa aaaaaaaa

are basically content free.  It took an awful lot of commit message to
discover what the change was doing.
