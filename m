Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752825Ab1BESCT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 13:02:19 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:33222 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752021Ab1BESCS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 13:02:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:from:date:x-google-sender-auth:message-id
         :subject:to:content-type;
        b=dN9JoevsGwfdoM4jXkBTSK8y/dTbWbzidYQNZppDhzEgmOHZKiWBV5D8Pa5OQl79gg
         kJh9S6s7TgspCfNnbprquu5JB4kNhravL8/clWv/45frCqm4jwnk4603nlh8HjEd/O8i
         Cn2Oum9EkE5tm/w/RLgmwTjARCdKHpHr2KA74=
MIME-Version: 1.0
From: Andrew Lutomirski <luto@mit.edu>
Date: Sat, 5 Feb 2011 13:01:57 -0500
X-Google-Sender-Auth: bcf0ZBdw0ugCU34D05BoShuL9L4
Message-ID: <AANLkTikSwviozL+ezdvqengQpag4cpbLxR+vgs_JKXbZ@mail.gmail.com>
Subject: Logitech autosuspend + runtime_pm loses input
To: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        pm list <linux-pm@lists.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have a Logitech MX Revolution (a cordless mouse receiver) plugged
into a Logitech G15 (a keyboard w/ a hub) plugged into an Intel Cougar
Point EHCI controller.  (Results are the same on an xHCI controller,
though.)

With autosuspend *or* runtime PM off, everything works.  (Well, the
G15 is buggy and occasionally crashes and doesn't recover until
powercycled, but that even happens on Windows.)  With runtime PM
enabled on the whole tree, I have problems with autosuspend.

If I enable autosuspend on just the mouse by doing:

echo 2 >./1-1/1-1.2/1-1.2.3/power/autosuspend
(where that device is Bus 001 Device 005: ID 046d:c51a Logitech, Inc.
MX Revolution/G7 Cordless Mouse), then after about two seconds of not
moving the mouse, the mouse ignores the first second or so of motion
when I start moving it again.

If I enable autosuspend on just part of the keyboard by doing:

echo 2 >./1-1/1-1.2/1-1.2.1/power/autosuspend
(that's Bus 001 Device 004: ID 046d:c221 Logitech, Inc. G11/G15
Keyboard / Keyboard)

then after a couple seconds of not typing, my next keystroke is lost or delayed.

It seems to be enough to turn off runtime PM (via power/control) OR
turn off autosuspend on the keyboard device to make the keyboard work
and on the mouse device to make the mouse work.

Is this a case of "don't do that, you fool," or is there a legitimate
bug to be fixed in the runtime pm code?

My motherboard is Intel DH67GD (ordered just before they canceled
production) with latest BIOS.
