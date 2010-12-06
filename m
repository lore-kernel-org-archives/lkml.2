Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752344Ab0LFJqq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 04:46:46 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:63481 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752014Ab0LFJqp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 04:46:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=nFI1bc714xw43fTBLG4QmBTpobtZoZofQgAmd4q1+S+kA6nyAFogBzam7Iby9inX6w
         VMeiziyI/kbAU+3howY0YaCTj5H/Zc7yxaelOHaRiYHTYlgh7OOny1YFF699p61sMYD1
         jileX538CQYEM+2SGAUgV+bI7Hrame+Y13Phc=
MIME-Version: 1.0
In-Reply-To: <AANLkTik4T=PsMzB+umSQPLDPmeD-6sebgCtrQRePH_2h@mail.gmail.com>
References: <AANLkTi=XTUau_GbASJEUBgsZ_FYYmRAX6W43YtRdv2wS@mail.gmail.com>
	<20101022135130.617f0ce8@lxorguk.ukuu.org.uk>
	<AANLkTinj93zAXJAipB3HjE62Xa1Z=9k9gPBxaT=+MLtg@mail.gmail.com>
	<20101029172443.61f7b067@pyx>
	<AANLkTimiyxiKzT=9pKXLFACkc6C=nTD2dtBR7PcgjhOL@mail.gmail.com>
	<AANLkTim7brB0JecKXDNddt0am=Um457Kfbm6bRG_yzFM@mail.gmail.com>
	<AANLkTik4T=PsMzB+umSQPLDPmeD-6sebgCtrQRePH_2h@mail.gmail.com>
Date: Mon, 6 Dec 2010 10:46:43 +0100
Message-ID: <AANLkTimjACtU_Mx5mDHkm9OpVJ4ueNWgZPsX3YjL0cTi@mail.gmail.com>
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

Hi Par,

On Mon, Dec 6, 2010 at 10:06 AM, Par-Gunnar Hjalmdahl
<pghatwork@gmail.com> wrote:

>> So is it true that if there's the other chip with similar
>> functionality I have to implement support for, I'll have to pretty
>> much duplicate your line discipline driver?
>>
>
> What will be in the protocol file, i.e. the same level as hci_h4.c,
> hci_bcsp.c, etc, will be to ~80% vendor specific. The only H4 channels
> that are in a standardized specification are the Bluetooth channels
> 1-4. Other channels such as FM and GPS are vendor specific. I've seen
> that for example TI has the same channels for FM and GPS, but these
> channels, 8 and 9, are in no way standardized. The CG2900 also carries
> a number of other channels, such as debug and device channels, which
> I'm pretty sure is individual for this chip.
> This identification of the channels is also only one function, even
> though it is an important function. There are also a lot of other code
> regarding baud rate settings, low power handling, etc that I'm
> positive will not apply to chips of other vendors. It is of course
> possible that other chips from ST-Ericsson, current and future, will
> be able to reuse this file, but as I said I doubt that other vendors
> might be able to use it.

Wait. What level of abstraction is this file at if even some future
STE chips are not guaranteed to work with it? Is it at a level of
hardcoding the GPIO numbers?

>> Isn't it better to have a new line discipline that the standard
>> drivers (H4, LL, ...) will be applicable to?

> I'm not certain what you mean. We are modifying the line discipline a
> bit, but the only thing we have needed to do with existing protocol
> drivers has been to add a boolean parameter for the protocol settings
> (so they will register to the Bluetooth stack). I don't see why we
> should create a new line discipline driver and then move the existing
> protocol drivers to this.

Okay, let me try to be more specific. There's for instance
drivers/bluetooth/hci_ll.c which is the line discipline driver that is
meant to work with any BT chip supporting LL protocol. Your solution
seems to imply that one will have to create a variation of this
implementation for each BT chip supporting LL that will use your
shared transport implementation. Is it really the case?

Thanks,
   Vitaly
