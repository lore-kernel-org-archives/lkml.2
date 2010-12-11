Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751570Ab0LKTrT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Dec 2010 14:47:19 -0500
Received: from netrider.rowland.org ([192.131.102.5]:60724 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751557Ab0LKTrR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Dec 2010 14:47:17 -0500
Date: Sat, 11 Dec 2010 14:47:17 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Larry Finger <Larry.Finger@lwfinger.net>
cc: pali.rohar@gmail.com, Greg Kroah-Hartman <gregkh@suse.de>,
        USB list <linux-usb@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC/RFT] OHCI: Fix for regression in 2.6.37-rc1 since commit
 3df7169e7
In-Reply-To: <4D03AACB.8020205@lwfinger.net>
Message-ID: <Pine.LNX.4.44L0.1012111438260.14704-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 11 Dec 2010, Larry Finger wrote:

> > I don't see anything wrong with any of this.  Where's the problem?
> 
> The problem is that I get thousands of the "unable to enumerate" messages in the
> logs. That PORT_OWNER does not seem to apply to this port. Everything seems to
> work, but the log spamming is intolerable.

Everything seems to work for the EHCI controller, the one you were 
looking at.  But the OHCI controller isn't working, so that's where you 
need to concentrate your attention.  ISTR before your computer broke 
you were trying to figure out why certain parts of the ohci-hcd 
initialization code weren't getting called.

> I find the USB structure on this box to be confusing. The output of lsusb is
> 
> Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
> Bus 001 Device 002: ID 04f2:b016 Chicony Electronics Co., Ltd VGA 30fps UVC Webcam
> Bus 001 Device 005: ID 07d1:3300 D-Link System
> Bus 002 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
> Bus 003 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
> Bus 004 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
> 
> There are 3 external USB ports, which are ports 3, 4, and 5 on the Bus 001 hub.

There's probably at least one internal port, where that Chicony webcam
is connected.  Unless it's using an external port?

> That is the one with iSerial of 1 0000:00:02.1. The other hubs do not seem to be
> connected to anything.

Bus 2 probably is not connected to anything.  My guess is that bus 3 is 
also connected to the three external ports and bus 4 is not wired up.

Alan Stern

