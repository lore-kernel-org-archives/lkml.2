Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755839Ab0ECTjc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 15:39:32 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:38250 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755490Ab0ECTja (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 15:39:30 -0400
Date: Mon, 3 May 2010 15:39:28 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: s2ram slow (radeon) / failing (usb)
In-Reply-To: <20100503212312.62b99fbb@neptune.home>
Message-ID: <Pine.LNX.4.44L0.1005031536420.1651-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 May 2010, Bruno [UTF-8] Prémont wrote:

> On Mon, 03 May 2010 Alan Stern <stern@rowland.harvard.edu> wrote:
> > On Mon, 3 May 2010, Bruno [UTF-8] Prémont wrote:
> > 
> > > > Did you boot with "no_console_suspend"?  Are you using a VT console
> > > > instead of X (a serial console may or may not work as well)?
> > > 
> > > Yes, I'm booting with no_console_suspend and console=ttyS0. On that
> > > system there is no X. Multiple ttys are showing up on display with
> > > KMS or VGA text mode (just the getty, all kernel and init output goes to
> > > serial console as expected)
> > 
> > You're better off sending the console output to the display (or to
> > both); I don't know how well serial consoles work with
> > no_console_suspend.
> 
> How do I tell kernel to send to both?

With something like this: console=ttyS0,115200 console=tty0

> At least when the keyboard is not plugged in I get about everything until
> the very end, last message being 'SMP alternatives: switching to UP code'
> (and the following line from dmesg after resume is 'Back to C!'

The verbose debugging in driver.c should add some messages.  If you 
still don't see anything, try putting your own printk statements in 
usb_suspend() and usb_resume() and the functions they call.

Alan Stern

