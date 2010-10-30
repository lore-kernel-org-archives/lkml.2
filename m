Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762179Ab0J3AA0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 20:00:26 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:52527 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209Ab0J3AAY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 20:00:24 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 5/9] mfd: Add UART support for the ST-Ericsson CG2900.
Date: Sat, 30 Oct 2010 02:01:01 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: "Par-Gunnar Hjalmdahl" <pghatwork@gmail.com>, linus.walleij@stericsson.com,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lukasz.Rymanowski@tieto.com
References: <AANLkTi=XTUau_GbASJEUBgsZ_FYYmRAX6W43YtRdv2wS@mail.gmail.com> <AANLkTinh3D8V8UaN8FyCouwUQ98A4RRWEHXU7Tr9XMbs@mail.gmail.com> <20101029172214.25b14c2a@pyx>
In-Reply-To: <20101029172214.25b14c2a@pyx>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201010300201.01940.arnd@arndb.de>
X-Provags-ID: V02:K0:qbiQUrlGirhsJZUCbclM72Fg7+jzFPEE+yLD69U7l87
 cV/ClNU1StjEZWtByARV9Xn6itFByvjtu8z0wQDtIGLeTTxVbG
 P8TyN4npntXnXlmw3BpSzkanBqbu2tKbywHfXx/Ztod7b/2V/e
 xo+98O+qFKWjimTT6tNS56SISXOBpJUu/uKRjBaIHUZ4TXEoQj
 JPNhHttaDkYapzDQ0kDBw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 29 October 2010, Alan Cox wrote:

> > line discipline then even though that could cause other problems. I do
> > not know if it is possible to add a condition in Kconfig otherwise so
> > the CG2900 ldisc cannot be active while the "normal" ldisc driver is
> > selected.
> 
> Not sure I follow the concern here ?

It's about the ldisc number. Both bluetooth and cg2900 register themselves
to ldisc 15 (N_HCI). A user doing TIOCSETD can only get one of the two.

The solution would not be to make the two ldisc implementations mutually
exclusive, but to make cg2900 use a new ldisc number, e.g. N_HCI_CG2900.
However, I'm still not convinced that this is actually necessary, we might
be able to add hooks into the existing N_HCI implementation for the
extensions in cg2900.

	Arnd
