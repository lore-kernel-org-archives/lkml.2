Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932795Ab1CSBiW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 21:38:22 -0400
Received: from netrider.rowland.org ([192.131.102.5]:45879 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756191Ab1CSBiP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 21:38:15 -0400
Date: Fri, 18 Mar 2011 21:38:13 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Mihai =?utf-8?q?Don=C8=9Bu?= <mihai.dontu@gmail.com>
cc: =?utf-8?q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <linux-wireless@vger.kernel.org>
Subject: Re: [b43] usb device disconnects automatically after 1s
In-Reply-To: <201103190048.27759.mihai.dontu@gmail.com>
Message-ID: <Pine.LNX.4.44L0.1103182132040.20570-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 19 Mar 2011, Mihai Donțu wrote:

> > Another thing you can try is to get usbmon traces under both 2.6.37 and
> > 2.6.38.  Instructions are in the kernel source file
> > Documentation/usb/usbmon.txt.
> 
> I'm unable to get a usbmon dump on 2.6.37. Strangely, the only USB device 
> making noise (on 0u) is my mouse's wireless receiver. I had no such problem on 
> 2.6.38 though.

I noticed your config has CONFIG_USB_EHCI_TT_NEWSCHED disabled.  You 
really should enable it (although I doubt that it is responsible for 
this problem, since 2.6.37 works without it).

The 2.6.38 usbmon trace shows pretty much what you might expect: The 
device connects and is initialized and enumerated normally, then 2 
seconds later it disconnects.  We really need to see a 2.6.37 usbmon 
trace to compare for differences.

Can you try again?  If usbmon isn't working, there's something _very_ 
strange going on.

Alan Stern

