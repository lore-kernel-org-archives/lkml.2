Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933305Ab0J3AIa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 20:08:30 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:51676 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751345Ab0J3AI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 20:08:28 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Par-Gunnar Hjalmdahl" <pghatwork@gmail.com>
Subject: Re: [PATCH 5/9] mfd: Add UART support for the ST-Ericsson CG2900.
Date: Sat, 30 Oct 2010 02:09:11 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linus.walleij@stericsson.com,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lukasz.Rymanowski@tieto.com
References: <AANLkTi=XTUau_GbASJEUBgsZ_FYYmRAX6W43YtRdv2wS@mail.gmail.com> <AANLkTinh3D8V8UaN8FyCouwUQ98A4RRWEHXU7Tr9XMbs@mail.gmail.com> <AANLkTimyR7f=PdQbxxBLCnznTA4PT1TWEFiNX3C_qaZo@mail.gmail.com>
In-Reply-To: <AANLkTimyR7f=PdQbxxBLCnznTA4PT1TWEFiNX3C_qaZo@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201010300209.11220.arnd@arndb.de>
X-Provags-ID: V02:K0:61vQaYbktu54DVEj5UANg6+FgWfC72mgLmFFSVVBV21
 q1Jwd2RiDUMdkcBa8cmFPDVKMb3FyboZ0ObRwXfF3HUSc67hay
 VOvEXlQYYGMO7mhnqz3XViCY9z3NLRfiHshQo6FwweS6Zzh15c
 Pdr9cpn7hzA77UzDZzsBlLZX3MEGZ7BpkehcAxy9m3r/16dUBE
 2K/H5uGADk2kfbhB72kjQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 29 October 2010, Par-Gunnar Hjalmdahl wrote:
> I might have been a bit too quick there.
> The actual channel matching and packet creation is done in hci_h4.c
> while ldisc registration is done in hci_ldisc.c.
> So it might to be enough to create a new hci_h4-cg2900.c (or similar
> name) that can separate the right channels.

That sounds good, but would that still be h4?

There are currently six UART protocols that have drivers in Linux:
H4, bcsp, 3Weire, h4ds, ll and ath3k.

Can cg2900 be simply another one of those, or is it different
from the others?

> We must however do changes
> to hci_ldisc as well since it seems to always register to the
> Bluetooth stack here, which we definitely don't want since that is
> handled by btcg2900.c.

Can you elaborate? You said earlier that cg2900 is a standard HCI
with some extensions. If that's the case, why do you need your own
btcg2900 driver to handle bluetooth instead of the regular hci code?

> Also note that this ldisc issue is only valid when using UART as
> transport. We will also support SPI and then we will probably run into
> completely new, interesting problems. :-)

Is the link layer on SPI different from the UART variant? Maybe you cna
just add a SPI TTY driver if that doesn't exist yet and bind the same
ldisc to the SPI device.

	Arnd
