Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753562Ab0LFP3A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 10:29:00 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:41909 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753456Ab0LFP26 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 10:28:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=n7+IaUgUxjWZ4AzlNSDxqPd1zPK+p0sXBHCZ19kWpGf7Xg7BZKZiCtqo5vzCLYz8O9
         stJAEqTpABSiJ+dcXaBfTJxt3U2uK+QvtqAGrZ+2ys+fvbqERYL6BZcYQTUtHLiS7ntn
         21A3BqRyFGYEW8Xkgj0aRs+4PO2IVFYsjxktY=
MIME-Version: 1.0
In-Reply-To: <201012061615.28093.arnd@arndb.de>
References: <AANLkTi=XTUau_GbASJEUBgsZ_FYYmRAX6W43YtRdv2wS@mail.gmail.com>
	<201012061506.04364.arnd@arndb.de>
	<AANLkTikUeH2BL3svwydt1kGGuzn7C8QxiqRqMZPXHhZ_@mail.gmail.com>
	<201012061615.28093.arnd@arndb.de>
Date: Mon, 6 Dec 2010 16:28:57 +0100
Message-ID: <AANLkTi=upn_ieeW_OXzKaHsrEumH2F_fMn07P6-97qb1@mail.gmail.com>
Subject: Re: [PATCH 5/9] mfd: Add UART support for the ST-Ericsson CG2900.
From: Vitaly Wool <vitalywool@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Par-Gunnar Hjalmdahl <pghatwork@gmail.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, linus.walleij@stericsson.com,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marcel Holtmann <marcel@holtmann.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 6, 2010 at 4:15 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> Yes, that makes sense. I'm probably missing something here, but
> it seems to me that hci_ll is only about the power management stuff
> on TI (and broadcom, as you say) chips, and the multi-protocol
> support is currently handled in hci_ldisc by allowing multiple
> protocols like h4 and ll to be registered. It that correct?

Yeah, it's basic for TI and it's supported by Broadcom although they
have their own protocol for power saving.

But I was trying to make a different point here. On a basic level,
there's this cg2000 chip from STE that does BT, FM and GPS. There's
the chip from TI that does BT, FM and GPS, and there's the Broadcom
chip that does BT+FM. They all use HCI to access the other functions
of the combo chip and they do it in a really simiar way, with the
differences mostly in power management techniques. So I think it's
quite sensible to have some kind of framework that is suitable for
such devices.

> One aspect that Par-Gunnar mentioned was that the multi-protocol
> stuff for cg2900 and I suspect other similar devices would also
> need to work with non-UART-based HCIs, which don't use hci_uart_proto
> but would need something similar. Also, hci_uart is currently not
> modular, e.g. you cannot build hci_ll as a loadable module
> as you'd need for dynamic registration.

But generally speaking, isn't a line discipline/driver attached to a
tty? We can use dumb tty for e. g. SPI and still be able to use
hci_ll, right?

Thanks,
   Vitaly
