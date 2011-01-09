Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752548Ab1AISsO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jan 2011 13:48:14 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:45944 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752118Ab1AISsN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jan 2011 13:48:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=ekuYxMggEtmyf49xDwV15c+6A8/4LXIWBg5s9KrVW+bSiIGqVcm42Qe2A6sruQyJ3i
         u9vMaTCkoIYc/GuwmIJOzFo50gXMLzUaHsrgZ+gt/3qUzSc2bFNvzltch7wHy1sGlxtj
         CGsPlYa06mWxW0EgfgHVlN2Xjnh2bIIUiMBwk=
MIME-Version: 1.0
In-Reply-To: <AANLkTikJMx2QxYwXS_TrKK5hcnD3G0MNvEiDO+xAZrpo@mail.gmail.com>
References: <1292584829-28279-1-git-send-email-par-gunnar.p.hjalmdahl@stericsson.com>
	<AANLkTikxnWZNwf7AO0XnD0Y59Sdk9DMCsGtmap=H_gNk@mail.gmail.com>
	<AFCDDB4A3EA003429EEF1E7B211FDBBA3348BA7DD2@EXDCVYMBSTM005.EQ1STM.local>
	<201101061946.04790.arnd@arndb.de>
	<AANLkTikJMx2QxYwXS_TrKK5hcnD3G0MNvEiDO+xAZrpo@mail.gmail.com>
Date: Sun, 9 Jan 2011 19:48:12 +0100
Message-ID: <AANLkTinAQLgRiQjHAmcj__ArUGu3+yMw=FK6urX_j=qG@mail.gmail.com>
Subject: Re: [PATCH 00/11] mfd and bluetooth: Add CG2900 support
From: Vitaly Wool <vitalywool@gmail.com>
To: Pavan Savoy <pavan_savoy@sify.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Par-Gunnar HJALMDAHL <par-gunnar.p.hjalmdahl@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        Lukasz Rymanowski <Lukasz.Rymanowski@tieto.com>,
        Par-Gunnar Hjalmdahl <pghatwork@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 9, 2011 at 7:12 PM, Pavan Savoy <pavan_savoy@sify.com> wrote:
>> This sounds wrong for both TI and ST-E: AFAICT they are actually built
>> around an HCI interface. It's unfortunate that the TI code actually got
>> merged into the kernel like this.
>
> I am not sure what does built around HCI Interface mean? Also yes, in TI- code
> we do refer to Bluetooth headers.

I think that the first and the major problem with TI code is that it
is _very_ dependent on the HCI-LL protocol.
I urge you again to sort that out first and then the whole thing will
get quite a bit clearer to all the parties.

> However the fact that I wanted to point out to Par-Gunnar was, that we
> don't want to use
> hciattach and enable HCI-UART + HCI-H4 for enabling our driver or our
> driver should not
> depend on those modules as such...

I really don't care _that_ much if we have to enable HCI interface to
bring say the FM radio up. What I do care about is the startup time
for the same FM radio, or GPS, which turns to be far longer if we go
the awkward way of launching hciattach and friends which are not in
fact needed at all. So I tend to agree with you here.

>
> The references to bluetooth headers in a certain way is inevitable
> because as he pointed
> out, firmware is downloaded as HCI-VS commands, too bad the firmware
> doesn't have any other
> means :(, But it sorts of allows violations, as in we can afford to
> have HCI-VS commands sent after
> disabling events, which would mean they need not be interpreted at all..

Well if we've got this common-hci-module Arnd was talking about, I
believe that firmware download can be sort of abstracted.

>>> > instead of common-hci-module, why not create a algo-driver layer 'ala
>>> > i2c ? where individual drivers can register their receive handlers for
>>> > data interpretation ?
>>
>> That would be what I suggested ;-)
>
> But even here too, the algos layer if you imagine which can be the
> sort of the first
> receiver of data from the transport would refer to BT headers to
> interpret the data (not just BT, but FM/GPS)
> and pass it onto other protocol/client drivers,
> The only abstraction being that different adapter drivers can register
> their own receive function
> which the algo-driver can sort of call, (again all imagination....)
>

Let's keep things simple. Could you please come up with a step-by-step
on how you would transform the existing TI solution for shared
transport into something really generic?
Or, the other option would IMHO be to start with sorting out some
obvious shared transport flaws.

Thanks,
   Vitaly
