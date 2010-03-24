Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932479Ab0CXRgI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 13:36:08 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:54060 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756638Ab0CXRgE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 13:36:04 -0400
Date: Wed, 24 Mar 2010 17:39:53 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Pavan Savoy <pavan_savoy@yahoo.co.in>
Cc: Marcel Holtmann <marcel@holtmann.org>, Greg KH <gregkh@suse.de>,
       PavanSavoy <pavan_savoy@ti.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/6] drivers:misc: sources for Init manager module
Message-ID: <20100324173953.7fde7c84@lxorguk.ukuu.org.uk>
In-Reply-To: <669779.38970.qm@web94901.mail.in2.yahoo.com>
References: <20100324172647.572e3cb8@lxorguk.ukuu.org.uk>
	<669779.38970.qm@web94901.mail.in2.yahoo.com>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.18.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Which puts me back to square 1, the requirement is TTY device should be open, only when either BT, FM or GPS would want to use it.
> [with your patch one of the steps of installing ldisc would be reduced upon opening].

Perhaps but its up to you how you write your low level driver and how the
ldisc indicates it wishes to be active (eg speed B0 is used to indicate
'no carrier' in many cases)

> Actually why do I even need a TTY device in this case - right ?
> ldisc driver can do the tty->ops->write and tty_read and put it up on different interfaces like eth0/hci0 or /dev/radio0 etc..

You don't need a tty if you are simply demuxing some kind of stream of
bytes to/from the hardware and you gain nothing from the tty layer and
user space interfaces such as control signal and speed setting.

That may be even cleaner in your case as you can then then provide
suitable links between your demux and the drivers attached to it
indicating when they should be on or off.
