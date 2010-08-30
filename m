Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753506Ab0H3WJw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 18:09:52 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:43295 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751125Ab0H3WJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 18:09:51 -0400
Date: Mon, 30 Aug 2010 23:28:00 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Greg KH <gregkh@suse.de>, Jiri Slaby <jslaby@suse.cz>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC 0/5] tty: move stuff around
Message-ID: <20100830232800.3cb768fc@lxorguk.ukuu.org.uk>
In-Reply-To: <201008302333.22447.arnd@arndb.de>
References: <1283115995-4734-1-git-send-email-arnd@arndb.de>
	<20100830184737.GA21339@suse.de>
	<201008302333.22447.arnd@arndb.de>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> drivers/char/tty_*      -> tty/*
> drivers/char/{vt stuff} -> tty/vt/
> drivers/char/hvc_*      -> drivers/tty/hvc/hvc_*
> drivers/serial/*        -> drivers/tty/serial/*

There are dead bits in there too we should prune 68xxx stuff mostly

> drivers/usb/serial      -> drivers/usb/serial
> 
> cyclades,moxa,mxser     -> drivers/tty/hw/
> 
> stallion,istallion,
> epca,specialix,ip2,
> riscom,isicom           -> drivers/staging/tty/*

isicom has users and gets tested a bit, not sure about ip2/specialix.

> generic_serial,vme_scc,
> ser_a2232,sx,rio        -> drivers/staging/generic_serial/*
> 
> amiserial,nozomi,
> serial167,synclink      -> drivers/tty/hw (?)

Why /hw - its a tty driver so drivers/tty - the non hw stuff is now in
tty/

serial167 is dead/staging stuff, synclink* are used

> bfin_jtag_comm          -> drivers/tty/hvc/hvc_bfin_jtag (?)

Nothing to do with hvc

> rocket,ipwireless       -> drivers/staging/tty/* (?)

Rocket is used, ipwireless I think is also used

Alan
