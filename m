Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756344Ab1CVCbM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 22:31:12 -0400
Received: from SpacedOut.fries.net ([67.64.210.234]:42994 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756294Ab1CVCbK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 22:31:10 -0400
Date: Mon, 21 Mar 2011 21:30:54 -0500
From: David Fries <david@fries.net>
To: Liang Bao <tim.bao@gmail.com>, Andrei Warkentin <andreiw@motorola.com>,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        Feng Tang <feng.tang@intel.com>
Subject: Re: [PATCH] work around for l2cap NULL dereference in
 l2cap_conn_start
Message-ID: <20110322023054.GF22204@spacedout.fries.net>
References: <20110211035309.GA22204@spacedout.fries.net>
 <20110214145649.GE2597@joana>
 <AANLkTi==Sh2yc2JjjY5t-NKxQexKPgPwNyWo4SMju92k@mail.gmail.com>
 <20110221043601.GB22204@spacedout.fries.net>
 <AANLkTi=b5UCdyc3ZtUFCx23uYygM7eRyGu-y_wdJ5JXi@mail.gmail.com>
 <20110227191545.GB2166@joana>
 <20110228050340.GC22204@spacedout.fries.net>
 <20110228173022.GC2165@joana>
 <20110302061910.GE22204@spacedout.fries.net>
 <20110305021257.GD9005@joana>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110305021257.GD9005@joana>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 04, 2011 at 11:12:57PM -0300, Gustavo F. Padovan wrote:
> Hi David,
> 
> * David Fries <david@fries.net> [2011-03-02 00:19:10 -0600]:
> 
> > On Mon, Feb 28, 2011 at 02:30:22PM -0300, Gustavo F. Padovan wrote:
> > > Hi David,
> > > 
> > > * David Fries <david@fries.net> [2011-02-27 23:03:40 -0600]:
> > > 
> > > > On Sun, Feb 27, 2011 at 04:15:45PM -0300, Gustavo F. Padovan wrote:
> > > > > I pushed the following patch to bluetooth-2.6 tree. It should fix the problem
> > > > > by avoiding connections to be accepted before a L2CAP info response comes:
> > > > 
> > > > Is
> > > > git://git.kernel.org/pub/scm/linux/kernel/git/padovan/bluetooth-2.6.git
> > > > the bluetooth-2.6 tree you mentioned?  I don't see your patch there.
> > > > As a side note, the inline patch in your e-mail has the tabs replaced by
> > > > spaces, once I changed them, it applied cleanly.
> > > > 
> > > > I first reverted to the base N900 kernel-power-2.6.28 46 (none of my
> > > > changes or debugging), it crashed as expected.  I then applied your
> > > > patch 743400e0, and it still crashed.  I added back the
> > > > l2cap_conn_start parent check and some debugging in af_bluetooth.c
> > > > dmesg debug output and patches follow.
> > > 
> > > I want to see a test with this patch and a recent kernel. We added many fixes
> > > to stack in the last two years. Can you test this scenario?
> > 
> > I'm sorry, but apparently not, at least this post says 2.6.37 isn't
> > going to happen for the N900 and Maemo.
> > http://forums.internettablettalk.com/showthread.php?t=70082
> > 
> > I tried 2.6.37-n900 from
> > git://gitorious.org/nokia-n900-kernel/nokia-n900-kernel.git anyway,
> > but the display visibly degrades like it isn't being updated and
> > doesn't apparently get any further.  I don't have anyway to debug it
> > further.
> 
> I think you can test this in a desktop machine.

I've not been able to reproduce the bug on my desktop, and not for a
lack of trying.
2.6.28, l2cap_conn_start doesn't dereference parent (so it wouldn't
crash there anyway)  N900 must have some backported patches.
2.6.30 first kernel with that code
2.6.30, 2.6.37+, 2.6.38-rc7+, with a debug patch to print
the sk and parent in l2cap_conn_start, only executes the BT_CONNECT2
path in l2cap_conn_start maybe only one in five or less times and I
have yet to see it (on the desktop) have a NULL parent.
This is with the following USB Bluetooth dongle,
Cambridge Silicon Radio, Ltd Bluetooth Dongle (HCI mode)

Looks like I'm not going to be any more help verifying it is or isn't
fixed with a newer bluetooth stack.  Here's a post from Liang Bao.

On Tue, Mar 15, 2011 at 10:42:07PM +0800, Liang Bao wrote:
> Hi,
>
> Sorry for get back so late. I am really crazy busy with my project. I tested
> with 2.6.35-27 kernel + ubuntu 10.10 just now and seems the issue is really
> gone. Hcidump attached for your reference. It's more than one year so it
> might need some more time to figure out the difference of logs but as said,
> I am really hard to find out that time. Wondering if you would like to
> compare this with the one I attached into the mailing list a year ago.

-- 
David Fries <david@fries.net>
http://fries.net/~david/ (PGP encryption key available)
