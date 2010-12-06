Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753441Ab0LFPPm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 10:15:42 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:54810 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753181Ab0LFPPj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 10:15:39 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Vitaly Wool <vitalywool@gmail.com>
Subject: Re: [PATCH 5/9] mfd: Add UART support for the ST-Ericsson CG2900.
Date: Mon, 6 Dec 2010 16:15:27 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: "Par-Gunnar Hjalmdahl" <pghatwork@gmail.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, linus.walleij@stericsson.com,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marcel Holtmann <marcel@holtmann.org>
References: <AANLkTi=XTUau_GbASJEUBgsZ_FYYmRAX6W43YtRdv2wS@mail.gmail.com> <201012061506.04364.arnd@arndb.de> <AANLkTikUeH2BL3svwydt1kGGuzn7C8QxiqRqMZPXHhZ_@mail.gmail.com>
In-Reply-To: <AANLkTikUeH2BL3svwydt1kGGuzn7C8QxiqRqMZPXHhZ_@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201012061615.28093.arnd@arndb.de>
X-Provags-ID: V02:K0:/KCFo9nCJYvkX8D9ielJm9+VfEjaoMgow2QOi6C4SL5
 XDW3szXY9BmPANAi8md6KgO1wUtnf9rKq/3triUJAsXLS2rXNF
 Nd/vqUiivRqGz9EqMTeqx9MhH6WpeP6TtMI5K9YcANSJIi3b/o
 ViK5bY++teDwp+sH9ImFagOf3n+OOta2vu+mWTAedryAerO+58
 zPMYcGc2X9nhZyfMhF/OQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 06 December 2010, Vitaly Wool wrote:
> On Mon, Dec 6, 2010 at 3:06 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> 
> > hci_ll is not the line discipline but the a TI specific uart protocol.
> > The line discipline driver (hci_ldisc.c) is shared across all protocols
> > (h4, ll, ...) and gets extended slightly so it can deal with cg2900
> > in addition to the existing HCIs. The rest of the cg2900 support is
> > about adding more hci_uart_protos.
> 
> I was referring to hci_ll as to the line discipline driver, not the
> line discipline itself.
> 
> The thing is, there are different Bluetooth combo chips which use HCI
> to encapsulate commands to the sub-chips behind, and there's also the
> implementation for TI chip doing that which is in the mainline. So
> instead of keeping reinventing the wheel, I think it's fairly
> beneficial for everything if we finally agree on something that works
> for all the combo chips of the type.

Yes, that makes sense. I'm probably missing something here, but
it seems to me that hci_ll is only about the power management stuff
on TI (and broadcom, as you say) chips, and the multi-protocol
support is currently handled in hci_ldisc by allowing multiple
protocols like h4 and ll to be registered. It that correct?

One aspect that Par-Gunnar mentioned was that the multi-protocol
stuff for cg2900 and I suspect other similar devices would also
need to work with non-UART-based HCIs, which don't use hci_uart_proto
but would need something similar. Also, hci_uart is currently not
modular, e.g. you cannot build hci_ll as a loadable module
as you'd need for dynamic registration.

	Arnd
