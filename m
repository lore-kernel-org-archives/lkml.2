Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753295Ab0LFOym (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 09:54:42 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:64480 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204Ab0LFOyk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 09:54:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=mUbn+qUO5fjEA0xKfVmX7aWJxvHhLbCw3RFJkrPOfCAvVrsIwbSeVdFnk5cC8jUYuO
         hxHRsAdRhKeZDMfrPDJxkD2ZztdVzeMKou3svhcz4cDDTaDIcvmxShKo7+3XnFrBf9Qx
         PhvMkLjsbpzhcOAXRIBYHsXz0cIMJeWsbRIZ8=
MIME-Version: 1.0
In-Reply-To: <201012061506.04364.arnd@arndb.de>
References: <AANLkTi=XTUau_GbASJEUBgsZ_FYYmRAX6W43YtRdv2wS@mail.gmail.com>
	<AANLkTik4T=PsMzB+umSQPLDPmeD-6sebgCtrQRePH_2h@mail.gmail.com>
	<AANLkTimjACtU_Mx5mDHkm9OpVJ4ueNWgZPsX3YjL0cTi@mail.gmail.com>
	<201012061506.04364.arnd@arndb.de>
Date: Mon, 6 Dec 2010 15:54:39 +0100
Message-ID: <AANLkTikUeH2BL3svwydt1kGGuzn7C8QxiqRqMZPXHhZ_@mail.gmail.com>
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

Hi Arnd,

On Mon, Dec 6, 2010 at 3:06 PM, Arnd Bergmann <arnd@arndb.de> wrote:

> hci_ll is not the line discipline but the a TI specific uart protocol.
> The line discipline driver (hci_ldisc.c) is shared across all protocols
> (h4, ll, ...) and gets extended slightly so it can deal with cg2900
> in addition to the existing HCIs. The rest of the cg2900 support is
> about adding more hci_uart_protos.

I was referring to hci_ll as to the line discipline driver, not the
line discipline itself.

The thing is, there are different Bluetooth combo chips which use HCI
to encapsulate commands to the sub-chips behind, and there's also the
implementation for TI chip doing that which is in the mainline. So
instead of keeping reinventing the wheel, I think it's fairly
beneficial for everything if we finally agree on something that works
for all the combo chips of the type.

Thanks,
   Vitaly
