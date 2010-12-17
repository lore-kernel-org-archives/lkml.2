Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753964Ab0LQMS3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 07:18:29 -0500
Received: from eu1sys200aog120.obsmtp.com ([207.126.144.149]:60669 "EHLO
	eu1sys200aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753221Ab0LQMS2 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 07:18:28 -0500
From: Par-Gunnar HJALMDAHL <par-gunnar.p.hjalmdahl@stericsson.com>
To: Vitaly Wool <vitalywool@gmail.com>
Cc: Pavan Savoy <pavan_savoy@sify.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, Samuel Ortiz <sameo@linux.intel.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        Lukasz Rymanowski <Lukasz.Rymanowski@tieto.com>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Par-Gunnar Hjalmdahl <pghatwork@gmail.com>
Date: Fri, 17 Dec 2010 13:17:35 +0100
Subject: RE: [PATCH 07/11] Bluetooth: Add UART API functions to ldisc
Thread-Topic: [PATCH 07/11] Bluetooth: Add UART API functions to ldisc
Thread-Index: Acud3zjwnjkIeSyTRDWzMpsTXIty1gAA9AIA
Message-ID: <AFCDDB4A3EA003429EEF1E7B211FDBBA33489D2B4F@EXDCVYMBSTM005.EQ1STM.local>
References: <1292585094-28544-1-git-send-email-par-gunnar.p.hjalmdahl@stericsson.com>
 <AANLkTi=f6XPbsUiTSiFru2tj_XsQSu=-h898b0R2AePo@mail.gmail.com>
In-Reply-To: <AANLkTi=f6XPbsUiTSiFru2tj_XsQSu=-h898b0R2AePo@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vitaly,

> -----Original Message-----
> From: Vitaly Wool [mailto:vitalywool@gmail.com]
> Sent: den 17 december 2010 12:41
> To: Par-Gunnar HJALMDAHL
> Cc: Pavan Savoy; Alan Cox; Arnd Bergmann; Samuel Ortiz; Marcel
> Holtmann; linux-kernel@vger.kernel.org; linux-
> bluetooth@vger.kernel.org; Lukasz Rymanowski; Linus WALLEIJ; Par-Gunnar
> Hjalmdahl
> Subject: Re: [PATCH 07/11] Bluetooth: Add UART API functions to ldisc
> 
> Hi Par,
> 
> On Fri, Dec 17, 2010 at 12:24 PM, Par-Gunnar Hjalmdahl
> <par-gunnar.p.hjalmdahl@stericsson.com> wrote:
> > This patch adds new functions to control break and flow
> > as well as changing UART baud rate directly through the ldisc API
> > rather then using the TTY API directly.
> 
> What do you need that for?
> 

For the break and flow control it is a means for the protocol driver to set break and flow using only the hci_uart structure, i.e. without interfacing directly towards tty. This is of course not 100% necessary to make it work, but it means a clean API where the protocol drivers can perform their tasks without performing different operations on different stack levels. As it was before write was performed using hci_uart structure while flow control was done using tty structure and API, even though you could consider these functions to be similar (not in functionality of course but from a stack level perspective).

For baud rate changes it also simplifies handling a bit, since the new function also implements using the proper mutexes and calling right termios functions. It should work simply (as long as you don't want different baud rates for TX and RX which should be pretty rare).

> > It also adds a boolean parameter so it is optional to register
> > to the Bluetooth stack (for drivers where a separate module
> > registers to the Bluetooth stack instead).
> 
> I never liked this idea and I don't like it now as it scatters the
> changes needed to support devices you are aiming to support with your
> changes.
> 

OK. Sadly I can't do much about how you feel towards the change. In my opinion this is probably the best reuse we can get of existing protocols and parts. There is so much that is vendor specific if you look at for example cg2900_uart.c that it is not much you could do generic.

> Thanks,
>    Vitaly
