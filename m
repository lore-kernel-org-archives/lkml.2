Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752684Ab0LWKsz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 05:48:55 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:40832 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752491Ab0LWKsx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 05:48:53 -0500
MIME-Version: 1.0
X-Originating-IP: [192.163.20.232]
In-Reply-To: <AFCDDB4A3EA003429EEF1E7B211FDBBA3348A3A516@EXDCVYMBSTM005.EQ1STM.local>
References: <1292584829-28279-1-git-send-email-par-gunnar.p.hjalmdahl@stericsson.com>
	<AANLkTimCYea+G7Z+o-2BDCGHbRobM2n+VJLLcDO6g=9d@mail.gmail.com>
	<AANLkTi=J1AdOgxA_S9p9Ts65PL3Mi5NXXWMf0f-=0AwN@mail.gmail.com>
	<AFCDDB4A3EA003429EEF1E7B211FDBBA3348A3A516@EXDCVYMBSTM005.EQ1STM.local>
Date: Thu, 23 Dec 2010 16:18:52 +0530
Message-ID: <AANLkTikxnWZNwf7AO0XnD0Y59Sdk9DMCsGtmap=H_gNk@mail.gmail.com>
Subject: Re: [PATCH 00/11] mfd and bluetooth: Add CG2900 support
From: Pavan Savoy <pavan_savoy@sify.com>
To: Par-Gunnar HJALMDAHL <par-gunnar.p.hjalmdahl@stericsson.com>
Cc: Vitaly Wool <vitalywool@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        Lukasz Rymanowski <Lukasz.Rymanowski@tieto.com>,
        Par-Gunnar Hjalmdahl <pghatwork@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

P-G, Vitaly,

>
> I would say our design would map like this:
> common-hci-module: cg2900_core
> serial, spi, i2c,... : cg2900_uart together with hci_ldisc (for other transports it would be different files)
> bt, ti-radio, st-e-radio,...: cg2900_chip together with btcg2900 and other users per channel (cg2900_char_devices for users in User space)
> So it is not a 1-to-1 mapping for the upper parts. I would draw it like this:
>
>                               bt   st-e-radio  st-e-gps
>                                |         |          |
>                                +---------+----------+
>                                          |
>                   ti-xx                st-e cg2900...
>                     |                    |
>                     +---------+----------+
>                               |
>                       common-hci-module
>                               |
>                   +-----------+-----------+
>                   |        |       |      |
>                 serial    spi     i2c    ...

regarding the architecture above suggested...
Is having the common-hci-module, only way ?
Why is this dependency on bluetooth at all?

for example: today I don't compile my kernel with BT support, but
still want to use
the chip for FM & GPS, It should be possible correct ?
Even in TI case, although the firmware download is HCI-VS way, we
don't use hci_core
to interpret the responses...

instead of common-hci-module, why not create a algo-driver layer 'ala
i2c ? where individual drivers can register their receive handlers for
data interpretation ?

>
> The reason for this difference I've gone through before. Basically there are so many special behaviors and needed handling that is individual for each chip (like startup and shutdown and in the case of CG2900 flow control over FM and BT channels for audio commands). If you then look at the users I guess it would be possible to have one BT user, but it would have to be modified to handle vendor specific commands (as btcg2900 does with BT_ENABLE command). As Arnd has drawn for FM and GPS the users would be completely individual since they don't have a standardized  interface.
>
> /P-G
>
