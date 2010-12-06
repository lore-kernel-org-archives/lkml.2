Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753882Ab0LFQy5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 11:54:57 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:61517 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753058Ab0LFQy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 11:54:56 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Vitaly Wool <vitalywool@gmail.com>
Subject: Re: [PATCH 5/9] mfd: Add UART support for the ST-Ericsson CG2900.
Date: Mon, 6 Dec 2010 17:54:44 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: "Par-Gunnar Hjalmdahl" <pghatwork@gmail.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, linus.walleij@stericsson.com,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marcel Holtmann <marcel@holtmann.org>
References: <AANLkTi=XTUau_GbASJEUBgsZ_FYYmRAX6W43YtRdv2wS@mail.gmail.com> <201012061615.28093.arnd@arndb.de> <AANLkTi=upn_ieeW_OXzKaHsrEumH2F_fMn07P6-97qb1@mail.gmail.com>
In-Reply-To: <AANLkTi=upn_ieeW_OXzKaHsrEumH2F_fMn07P6-97qb1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201012061754.44592.arnd@arndb.de>
X-Provags-ID: V02:K0:mFjnWAB5wW4aXWzaAt9nCLSn243+6yTce+/MALSKqBO
 wOGAGI83FmgobynE4ONd1N1/ot29xpPVk/hh+hJJDrJEipWkET
 4wu2fkrBqoalBcS1fywSnu5wQ7VfHN4Sew1Pb0fGYqEtMh0VYa
 qRfP23r0Ru2KM4tqMBuqQdMAEFpEFp3lxqj0rRAVZdv6GXD8+t
 WvqybQCxwqT16GOoMvjpw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 06 December 2010, Vitaly Wool wrote:
> On Mon, Dec 6, 2010 at 4:15 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> > Yes, that makes sense. I'm probably missing something here, but
> > it seems to me that hci_ll is only about the power management stuff
> > on TI (and broadcom, as you say) chips, and the multi-protocol
> > support is currently handled in hci_ldisc by allowing multiple
> > protocols like h4 and ll to be registered. It that correct?
> 
> Yeah, it's basic for TI and it's supported by Broadcom although they
> have their own protocol for power saving.
> 
> But I was trying to make a different point here. On a basic level,
> there's this cg2000 chip from STE that does BT, FM and GPS. There's
> the chip from TI that does BT, FM and GPS, and there's the Broadcom
> chip that does BT+FM. They all use HCI to access the other functions
> of the combo chip and they do it in a really simiar way, with the
> differences mostly in power management techniques. So I think it's
> quite sensible to have some kind of framework that is suitable for
> such devices.

Yes, I agree 100% in principle. I could not find the code that 
Broadcom/TI FM and GPS stuff so far, can you point us to that?

The cg2900 solution for this was to use MFD (plus another layer
in the posted version, but that will go away I assume). Using
MFD is not the only possibility here, but I could not see anything
wrong with it either. Do you think we can move them all over to
use MFD infrastructure?

> > One aspect that Par-Gunnar mentioned was that the multi-protocol
> > stuff for cg2900 and I suspect other similar devices would also
> > need to work with non-UART-based HCIs, which don't use hci_uart_proto
> > but would need something similar. Also, hci_uart is currently not
> > modular, e.g. you cannot build hci_ll as a loadable module
> > as you'd need for dynamic registration.
> 
> But generally speaking, isn't a line discipline/driver attached to a
> tty? We can use dumb tty for e. g. SPI and still be able to use
> hci_ll, right?

I suggested that as well, but the point was made that this would
add an unnecessary indirection for the SPI case, which is not
really much like a serial port. It's certainly possible to do it
like you say, but if we add a way to register the high-level
protocols with an HCI-like multi-function device, we could
also do it in a way that does not rely on tty-ldisc but keeps it
as one of the options.

	Arnd
