Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755271Ab0JTS5K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 14:57:10 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:51607 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755036Ab0JTS5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 14:57:07 -0400
Date: Wed, 20 Oct 2010 19:56:03 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Alexander Stein <alexander.stein@systec-electronic.com>
Cc: linux-arm-kernel@lists.infradead.org,
        Grant Edwards <grant.b.edwards@gmail.com>,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Subject: Re: [PATCH] Documentation about RS485 serial communications
Message-ID: <20101020195603.70395f50@lxorguk.ukuu.org.uk>
In-Reply-To: <201010201000.14905.alexander.stein@systec-electronic.com>
References: <20100408111310.524f7354@lxorguk.ukuu.org.uk>
	<201010191727.53314.alexander.stein@systec-electronic.com>
	<i9kk4o$svc$1@dough.gmane.org>
	<201010201000.14905.alexander.stein@systec-electronic.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Oct 2010 10:00:14 +0200
Alexander Stein <alexander.stein@systec-electronic.com> wrote:

> On Tuesday 19 October 2010, 19:22:32 Grant Edwards wrote:
> > Yes, the AT91 UARTs do have a built-in half-duplex mode that will
> > automatically control line direction by toggling RTS.
> > 
> > That can used to control external half-duplex hardware like an RS485
> > transceiver or any RS232-connected half-duplex device like some
> > modems.
> > 
> > Though the Atmel docs refer to it as "RS485 mode" there is no RS485
> > transceiver in the AT91 parts (AFAIK), and "RS485 mode" isn't specific
> > to RS485 - it can be used with any external half-duplex hardware.
> 
> Out of curiosity, how can I add RS485 (or whatever) support for other serial 
> devices like e.g. i.mx serial? Is there some driver independent interface 
> which only gets filled in board configs like setting some GPIO pins?

Several devices support RS485 and the like

There are two interfaces

1.	termiox	which is used in the old Unix world for sync and
other stuff on serial world. Linux now supports a bit of this interface
and has the flags so we can grow it as needed. It covers one way flow
control

2.	TIOCGSRS485/TIOCSRS486 plus struct serial_rs485 which is Linux
specific but also allows for pre/post send delays in hardware that some
chips can do.

And nothing stops you supporting both interfaces when it makes sense
