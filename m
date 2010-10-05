Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757932Ab0JEI14 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 04:27:56 -0400
Received: from senator.holtmann.net ([87.106.208.187]:50714 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755412Ab0JEI1y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 04:27:54 -0400
Subject: Re: [PATCH 6/6] This patch adds support for using the ST-Ericsson
 CG2900
From: Marcel Holtmann <marcel@holtmann.org>
To: Par-Gunnar Hjalmdahl <pghatwork@gmail.com>
Cc: "Gustavo F. Padovan" <padovan@profusion.mobi>,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, Pavan Savoy <pavan_savoy@sify.com>
In-Reply-To: <AANLkTimdAxaF2gyXXXgYtjQ5+3eXuTpnpQ5n2KFtDwth@mail.gmail.com>
References: <AANLkTimOai9_92VuJUZMo26es9Wsu_6d+z36Sv_Q4i+L@mail.gmail.com>
	 <20100927164502.GB30310@vigoh>
	 <AANLkTimdAxaF2gyXXXgYtjQ5+3eXuTpnpQ5n2KFtDwth@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 05 Oct 2010 10:27:50 +0200
Message-ID: <1286267270.17473.36.camel@aeonflux>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Par-Gunnar,

> > * Par-Gunnar Hjalmdahl <par-gunnar.p.hjalmdahl@stericsson.com> [2010-09-24 15:52:16 +0200]:
> >
> >> This patch adds support for using the ST-Ericsson CG2900
> >>  connectivity controller as a driver for the BlueZ Bluetooth
> >>  stack.
> >>  This patch registers as a driver into the BlueZ framework and, when
> >>  opened by BlueZ, it registers as user for bt_cmd, bt_acl, and bt_evt
> >>  channels.
> >
> > First of all your your commit message and subject should be improved.
> > The subject should bee something like:
> >
> > "Bluetooth: Add support for ST-Ericsson CG2900"
> >
> > and in the commit message you explain the details of the patch.
> > And normally we do not use the BlueZ word in kernelspace.
> >
> 
> OK. This is the first patch I've created within the community and of
> course there are bound to be errors... ;-)
> Since it was part of a big patch delivery I used quite similar names
> across the different patches and I understand that this is an error
> since the different patches are targeting different communities.
> 
> >>
> >> Signed-off-by: Par-Gunnar Hjalmdahl <par-gunnar.p.hjalmdahl@stericsson.com>
> >> ---
> >>  drivers/bluetooth/Kconfig      |    7 +
> >>  drivers/bluetooth/Makefile     |    2 +
> >>  drivers/bluetooth/cg2900_hci.c |  896 ++++++++++++++++++++++++++++++++++++++++
> >>  3 files changed, 905 insertions(+), 0 deletions(-)
> >>  create mode 100644 drivers/bluetooth/cg2900_hci.c
> >
> > Your patch looks a way complicated to a UART driver. Look at the others
> > drivers at drivers/bluetooth/ and see how we implemented other UART
> > drivers.
> >
> 
> Well, mainly that's because it is not a UART driver. It is a driver
> against CG2900 which currently have only UART as transport but quite
> soon will get SPI as transport as well. For this Bluetooth driver the
> actual physical transport used is not known. It just knows it has a
> reliable transport below which delivers complete Bluetooth packets.

inside the Bluetooth driver please just use BT_DBG. That is hooked up
into dynamic_debug feature of the kernel and you can do whatever you
need for debugging.

I will not accept huge debug frameworks in the Bluetooth subsystem. Use
what the kernel offers you. You selective control based on every single
debug statement. It doesn't get better than that.

Regards

Marcel


