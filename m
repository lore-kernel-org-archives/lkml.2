Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756119Ab0H3Vde (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 17:33:34 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:60593 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756080Ab0H3Vdd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 17:33:33 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Greg KH <gregkh@suse.de>, Jiri Slaby <jslaby@suse.cz>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [RFC 0/5] tty: move stuff around
Date: Mon, 30 Aug 2010 23:33:22 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35+; KDE/4.5.0; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <1283115995-4734-1-git-send-email-arnd@arndb.de> <20100830184737.GA21339@suse.de>
In-Reply-To: <20100830184737.GA21339@suse.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201008302333.22447.arnd@arndb.de>
X-Provags-ID: V02:K0:7vgu/GGreH06Lrm+Ufjo7BXnzwHKXpjcFM3cc/p7vLt
 hdgvyLohNOI0iszA6vq+RJe50MNpstTA7aR16M1FDCI6Yb4bcV
 i/Agz3MhAdpF4PDMf6aU+8NAWL+2hCPCBL4A5SVeIDACwu6qsP
 ZdqGDkjA8wwXpfavhEHwQugHlj+b52K5o4LkN24uH0WNxaVQYn
 0QViuiHIbJy3vzK8MqcSw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 30 August 2010 20:47:37 Greg KH wrote:
> On Sun, Aug 29, 2010 at 11:06:30PM +0200, Arnd Bergmann wrote:
> > Hi Greg,
> > 
> > After fighting with the BKL removal in tty, I realized that the
> > files in drivers/char could use a reorganization to split the
> > tty files from those drivers that have nothing to do with ttys.
> 
> <snip>
> 
> I like the idea, and after you've worked out with Alan which ones should
> be "deleted" and others moved around, I'll be glad to apply these types
> of patches.
> 
> Oh, we shouldn't just delete the drivers, we can move them to
> drivers/staging/ where they will then be removed after 2 kernel releases
> if no one steps up to fix/maintain them.  That's the "proper" way to
> depreciate a driver.

Ok, I was already wondering if this would be the right way.


With the feedback I have so far, I think we have

drivers/char/tty_*      -> tty/*
drivers/char/{vt stuff} -> tty/vt/
drivers/char/hvc_*      -> drivers/tty/hvc/hvc_*
drivers/serial/*        -> drivers/tty/serial/*
drivers/usb/serial      -> drivers/usb/serial

cyclades,moxa,mxser     -> drivers/tty/hw/

stallion,istallion,
epca,specialix,ip2,
riscom,isicom           -> drivers/staging/tty/*

generic_serial,vme_scc,
ser_a2232,sx,rio        -> drivers/staging/generic_serial/*

amiserial,nozomi,
serial167,synclink      -> drivers/tty/hw (?)

bfin_jtag_comm          -> drivers/tty/hvc/hvc_bfin_jtag (?)

rocket,ipwireless       -> drivers/staging/tty/* (?)

I'll wait a few days for other suggestions and then prepare
a new patch series.

	Arnd
