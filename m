Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752211Ab0LFJGH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 04:06:07 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:59046 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751808Ab0LFJGE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 04:06:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Q9X8HBx8FZ2T6HYXGNtCfVXQYqP6cejUK2Rq4B8EWzKR6sP/89Dw5LHg98YvTfvfzC
         Ig09KFM4mxu1B2FY2xBWtQVk4Z4FlWRAxSEtreSXhZkr7MY2a+r0YC3lg/utSCNHdQ7f
         zMdcQ708MiZuugxXYGezFYicxoARl9DbZ1lEw=
MIME-Version: 1.0
In-Reply-To: <AANLkTim7brB0JecKXDNddt0am=Um457Kfbm6bRG_yzFM@mail.gmail.com>
References: <AANLkTi=XTUau_GbASJEUBgsZ_FYYmRAX6W43YtRdv2wS@mail.gmail.com>
	<20101022135130.617f0ce8@lxorguk.ukuu.org.uk>
	<AANLkTinj93zAXJAipB3HjE62Xa1Z=9k9gPBxaT=+MLtg@mail.gmail.com>
	<20101029172443.61f7b067@pyx>
	<AANLkTimiyxiKzT=9pKXLFACkc6C=nTD2dtBR7PcgjhOL@mail.gmail.com>
	<AANLkTim7brB0JecKXDNddt0am=Um457Kfbm6bRG_yzFM@mail.gmail.com>
Date: Mon, 6 Dec 2010 10:06:02 +0100
Message-ID: <AANLkTik4T=PsMzB+umSQPLDPmeD-6sebgCtrQRePH_2h@mail.gmail.com>
Subject: Re: [PATCH 5/9] mfd: Add UART support for the ST-Ericsson CG2900.
From: Par-Gunnar Hjalmdahl <pghatwork@gmail.com>
To: Vitaly Wool <vitalywool@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linus.walleij@stericsson.com,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Marcel Holtmann <marcel@holtmann.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vitaly,

2010/12/3 Vitaly Wool <vitalywool@gmail.com>:
> Hi Par,
>
> On Fri, Dec 3, 2010 at 10:16 AM, Par-Gunnar Hjalmdahl
> <pghatwork@gmail.com> wrote:
>> 2010/10/29 Alan Cox <alan@lxorguk.ukuu.org.uk>:
>
>> By the way, I will soon release a new patch set for CG2900 (hopefully
>> next week), which contains major rework. It's hard to explain
>> everything here and now but changes include:
>>  - Reuse of existing HCI line discipline under /drivers/bluetooth/.
>> Line discipline has been modified so it is selectable from protocol if
>> line discipline should register to Bluetooth stack or not.
>
> So is it true that if there's the other chip with similar
> functionality I have to implement support for, I'll have to pretty
> much duplicate your line discipline driver?
>

What will be in the protocol file, i.e. the same level as hci_h4.c,
hci_bcsp.c, etc, will be to ~80% vendor specific. The only H4 channels
that are in a standardized specification are the Bluetooth channels
1-4. Other channels such as FM and GPS are vendor specific. I've seen
that for example TI has the same channels for FM and GPS, but these
channels, 8 and 9, are in no way standardized. The CG2900 also carries
a number of other channels, such as debug and device channels, which
I'm pretty sure is individual for this chip.
This identification of the channels is also only one function, even
though it is an important function. There are also a lot of other code
regarding baud rate settings, low power handling, etc that I'm
positive will not apply to chips of other vendors. It is of course
possible that other chips from ST-Ericsson, current and future, will
be able to reuse this file, but as I said I doubt that other vendors
might be able to use it.

> Isn't it better to have a new line discipline that the standard
> drivers (H4, LL, ...) will be applicable to?
>
> ~Vitaly
>

I'm not certain what you mean. We are modifying the line discipline a
bit, but the only thing we have needed to do with existing protocol
drivers has been to add a boolean parameter for the protocol settings
(so they will register to the Bluetooth stack). I don't see why we
should create a new line discipline driver and then move the existing
protocol drivers to this.

/P-G
