Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754614Ab0KERVW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 13:21:22 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:35186 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754377Ab0KERVR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 13:21:17 -0400
Date: Fri, 5 Nov 2010 17:19:52 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Par-Gunnar Hjalmdahl <pghatwork@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linus.walleij@stericsson.com,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lukasz.Rymanowski@tieto.com
Subject: Re: [PATCH 5/9] mfd: Add UART support for the ST-Ericsson CG2900.
Message-ID: <20101105171952.7ac6cf2b@lxorguk.ukuu.org.uk>
In-Reply-To: <AANLkTimEYAmocFh_c-KftpL2zRm+LaHzgJOBX31iicLj@mail.gmail.com>
References: <AANLkTi=XTUau_GbASJEUBgsZ_FYYmRAX6W43YtRdv2wS@mail.gmail.com>
	<AANLkTinh3D8V8UaN8FyCouwUQ98A4RRWEHXU7Tr9XMbs@mail.gmail.com>
	<20101029172214.25b14c2a@pyx>
	<201010300201.01940.arnd@arndb.de>
	<20101031120429.1ca38140@pyx>
	<AANLkTimEYAmocFh_c-KftpL2zRm+LaHzgJOBX31iicLj@mail.gmail.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  - Introduce a new ldisc called N_H4_COMBO with a ldisc driver
> accordingly that will be placed under drivers/char

That seems sensible. That code should also be entirely hardware
independent.

> solution more complex than actually needed. We think that creating a
> new ldisc creates a cleaner solution. It will to some extent remind of
> hci_ldisc, but it will not register to any framework except tty.

Ok. So presumably both the SPI and the tty interfaces would then use the
same library code to do the demux - or are the protocols different ?
 
> We've thought about if we should switch cg2900 to a bus, but after
> discussing this we feel that CG2900 has such individual
> characteristics that it could be hard to create a bus that would suite
> it. We therefore will keep the MFD type. We might in the future add
> new chips to the driver, but they will most likely not require so much
> rework of the driver that we will have to create something completely
> new. We will rather create a lib file that contains common code to
> reduce total code size of the driver.

No particular opinion either way. Whatever works best and keeps it
modular.
