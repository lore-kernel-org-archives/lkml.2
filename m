Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752161Ab0LFMZq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 07:25:46 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:47577 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752014Ab0LFMZo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 07:25:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=iUMS6Oapoi36FRXGLKSvtGbAWgZbmJaU+Mza9YfEDpogmcqEkeGt1hIMNBzcPLPB1X
         glMlBYZicO1WZjwhs2/XnTzEwNsqH3Jqr3pSQhwbuGsvBqX/k2DzENO9g3e5LtHNRyxB
         d5cz7Z8TGM6ObOFjDLmWJ814Jm2cUJuLyfEpk=
MIME-Version: 1.0
In-Reply-To: <AANLkTikMAWikj9HQ76YVeHr7pMoFK6ME2=HHpuQ1kUxq@mail.gmail.com>
References: <AANLkTi=XTUau_GbASJEUBgsZ_FYYmRAX6W43YtRdv2wS@mail.gmail.com>
	<20101022135130.617f0ce8@lxorguk.ukuu.org.uk>
	<AANLkTinj93zAXJAipB3HjE62Xa1Z=9k9gPBxaT=+MLtg@mail.gmail.com>
	<20101029172443.61f7b067@pyx>
	<AANLkTimiyxiKzT=9pKXLFACkc6C=nTD2dtBR7PcgjhOL@mail.gmail.com>
	<AANLkTim7brB0JecKXDNddt0am=Um457Kfbm6bRG_yzFM@mail.gmail.com>
	<AANLkTik4T=PsMzB+umSQPLDPmeD-6sebgCtrQRePH_2h@mail.gmail.com>
	<AANLkTimjACtU_Mx5mDHkm9OpVJ4ueNWgZPsX3YjL0cTi@mail.gmail.com>
	<AANLkTikMAWikj9HQ76YVeHr7pMoFK6ME2=HHpuQ1kUxq@mail.gmail.com>
Date: Mon, 6 Dec 2010 13:25:42 +0100
Message-ID: <AANLkTi=V+89hmBP8iqz13xMhYVfnBkbiVnk=FY=OBE8T@mail.gmail.com>
Subject: Re: [PATCH 5/9] mfd: Add UART support for the ST-Ericsson CG2900.
From: Vitaly Wool <vitalywool@gmail.com>
To: Par-Gunnar Hjalmdahl <pghatwork@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linus.walleij@stericsson.com,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Marcel Holtmann <marcel@holtmann.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Par,

> Well, from what I can see LL is an extension of the H4, basically it
> adds sleep mode handling in a vendor specific way to the normal H4
> protocol. So it is also based on the hci_h4 just as our file is. But
> our file has basically nothing in common with what has been for the LL
> file. We don't support any of the LL sleep commands for example.
> So if I would make a driver for a combo chip supporting LL, I would
> either modify the existing hci_ll.c or I would make a new file based
> on hci_ll.c. There is not much you could really reuse from our new
> file. Basically it would be the handling of any common channels, so if
> you would for example have the same specification of FM and GPS you
> could maybe save around 20 lines of common code, but you would
> probably have to add a lot of more code just to keep the solution
> generic.

Right, but this gives me the hard time seeing how your implementation
is applicable to other multi-functional chips with similar
functionality.

> One major difference is also that hci_ll never changes baud rate or
> other settings. I assume that is done from hciattach during startup
> instead. But we cannot run with that since we have to shut down the
> chip when no user is connected in order to save power. This means that
> we have to add vendor specific commands in order to for example set
> baud rate. And then you run into these vendor specific problems. If
> there would be a standardized specification on how to set baud rate
> and how to put chip in sleep I assume things could be solved
> differently, but that is not the case.

Again, there are at least TI and Broadcom chips that support HCI_LL
and if they were to use your implementation of the core, they would
have had to add 2 more implementations of the corresponding line
discipline driver.

> As a quick answer to your question: that would depend on the
> difference between the different controllers, I guess. But CG2900
> doesn't support the LL protocol so it is not an issue for that.

Right, but if you are only aiming cg2000, why would you create a
framework for that?  I initially thought your solution was generic
enough to handle other "many-in-one" Bluetooth chips but I'm
completely unsure about that now.

Thanks,
   Vitaly
