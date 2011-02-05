Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753522Ab1BEUOO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 15:14:14 -0500
Received: from netrider.rowland.org ([192.131.102.5]:54636 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752870Ab1BEUOM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 15:14:12 -0500
Date: Sat, 5 Feb 2011 15:14:12 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Andrew Lutomirski <luto@mit.edu>
cc: linux-kernel@vger.kernel.org, <linux-usb@vger.kernel.org>,
        pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: Logitech autosuspend + runtime_pm loses input
In-Reply-To: <AANLkTikSwviozL+ezdvqengQpag4cpbLxR+vgs_JKXbZ@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1102051511180.4210-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 5 Feb 2011, Andrew Lutomirski wrote:

> I have a Logitech MX Revolution (a cordless mouse receiver) plugged
> into a Logitech G15 (a keyboard w/ a hub) plugged into an Intel Cougar
> Point EHCI controller.  (Results are the same on an xHCI controller,
> though.)
> 
> With autosuspend *or* runtime PM off, everything works.  (Well, the
> G15 is buggy and occasionally crashes and doesn't recover until
> powercycled, but that even happens on Windows.)  With runtime PM
> enabled on the whole tree, I have problems with autosuspend.
> 
> If I enable autosuspend on just the mouse by doing:
> 
> echo 2 >./1-1/1-1.2/1-1.2.3/power/autosuspend
> (where that device is Bus 001 Device 005: ID 046d:c51a Logitech, Inc.
> MX Revolution/G7 Cordless Mouse), then after about two seconds of not
> moving the mouse, the mouse ignores the first second or so of motion
> when I start moving it again.
> 
> If I enable autosuspend on just part of the keyboard by doing:
> 
> echo 2 >./1-1/1-1.2/1-1.2.1/power/autosuspend
> (that's Bus 001 Device 004: ID 046d:c221 Logitech, Inc. G11/G15
> Keyboard / Keyboard)
> 
> then after a couple seconds of not typing, my next keystroke is lost or delayed.
> 
> It seems to be enough to turn off runtime PM (via power/control) OR
> turn off autosuspend on the keyboard device to make the keyboard work
> and on the mouse device to make the mouse work.
> 
> Is this a case of "don't do that, you fool," or is there a legitimate
> bug to be fixed in the runtime pm code?
> 
> My motherboard is Intel DH67GD (ordered just before they canceled
> production) with latest BIOS.

I don't think there is any bug in the code.  The problem lies in the 
devices; they appear to be designed so as to lose some input events 
when waking up from suspend.  This is very common among keyboard and 
mouse devices -- probably because autoresume was not used under Windows 
and hence didn't get tested.

Hence my advice is, as you guessed, "Don't do that".

Alan Stern

