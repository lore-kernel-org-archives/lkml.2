Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752422Ab0JPPz2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 11:55:28 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:41097 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751492Ab0JPPz1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 11:55:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=x7TDoY9HHCxj5W4h4J4smbH8l3aJNw94Cp3PvIbuBHEQHDB/LXcaJbpiPT9JFMRxWZ
         8QpsMXThC+PM+CJaiUUvAz/r2Fxtxb0W8Tq4yz/jHo2DhxdqvjjzL04YmotnJmlyjHW0
         oyIRKB+r6xn8/4s96JoNCGnXGRu9aCsymV5R0=
Date: Sat, 16 Oct 2010 17:54:32 +0200
From: Paolo Ornati <ornati@gmail.com>
To: Paolo Ornati <ornati@gmail.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Vasily Khoruzhick <anarsoul@gmail.com>,
        Simon Farnsworth <simon.farnsworth@onelan.co.uk>,
        intel-gfx@lists.freedesktop.org, Sitsofe Wheeler <sitsofe@yahoo.com>,
        Venkatesh Pallipadi <venki@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [Intel-gfx] Interrupt latency on some 945GM platforms -- and
 TCP/IP silent data corruption?
Message-ID: <20101016175432.58e35ce3@gmail.com>
In-Reply-To: <20100925122820.37c01ea3@gmail.com>
References: <201009132336.17310.anarsoul@gmail.com>
 <201009171002.09187.simon.farnsworth@onelan.co.uk>
 <4b4d1e0a-b1ad-40f1-a829-6d4726d2b2d3@email.android.com>
 <201009171550.48480.anarsoul@gmail.com>
 <20100921202607.2b46ffca@gmail.com>
 <20100921155653.440afea4@jbarnes-desktop>
 <20100925122820.37c01ea3@gmail.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 25 Sep 2010 12:28:20 +0200
Paolo Ornati <ornati@gmail.com> wrote:

> UPDATE: "processor.max_cstate=2" doesn't solve the sporadic flicker
> problem.
> 
> The patch, applied on top of 2.6.35.4, freezes the laptop on boot.
> 
> Summary:
> 	nohz=off		good
> 	processor.max_cstate=1	good
> 	processor.max_cstate=2	bad

Maybe it's not related but who knows...

on this laptop (Asus x5dij / Core(TM)2 Duo CPU T6570) I've another
problem: sporadic silent data corruption over TCP/IP!

The problem is not easy to reproduce, maybe it's something like this?
	http://www.zdnet.com/blog/ou/realtek-silent-data-corruption-caused-by-firmware/663

I've first noticed it in two ways:
	- I download an ISO and sometimes it has wrong MD5, looking
	closer I find that only a few bytes (in one place) are wrong
	- ssh detects HMAC corruption

When I've tried to reproduce it doing a lot of automated fast tranfers
over a gigabit LAN it all worked fine... ;)

The intersesting thing is that "processor.max_cstate=1" seems to have
cured this problem too!

Network controller is this:

03:00.0 Ethernet controller: Atheros Communications Atheros AR8121/AR8113/AR8114 PCI-E Ethernet Controller (rev b0)

Full lspci:
00:00.0 Host bridge: Intel Corporation Mobile 4 Series Chipset Memory Controller Hub (rev 09)
00:02.0 VGA compatible controller: Intel Corporation Mobile 4 Series Chipset Integrated Graphics Controller (rev 09)
00:02.1 Display controller: Intel Corporation Mobile 4 Series Chipset Integrated Graphics Controller (rev 09)
00:1a.0 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #4 (rev 03)
00:1a.1 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #5 (rev 03)
00:1a.2 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #6 (rev 03)
00:1a.7 USB Controller: Intel Corporation 82801I (ICH9 Family) USB2 EHCI Controller #2 (rev 03)
00:1b.0 Audio device: Intel Corporation 82801I (ICH9 Family) HD Audio Controller (rev 03)
00:1c.0 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express Port 1 (rev 03)
00:1c.1 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express Port 2 (rev 03)
00:1c.5 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express Port 6 (rev 03)
00:1d.0 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #1 (rev 03)
00:1d.1 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #2 (rev 03)
00:1d.2 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #3 (rev 03)
00:1d.7 USB Controller: Intel Corporation 82801I (ICH9 Family) USB2 EHCI Controller #1 (rev 03)
00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev 93)
00:1f.0 ISA bridge: Intel Corporation ICH9M LPC Interface Controller (rev 03)
00:1f.2 SATA controller: Intel Corporation ICH9M/M-E SATA AHCI Controller (rev 03)
02:00.0 Network controller: Atheros Communications Inc. AR9285 Wireless Network Adapter (PCI-Express) (rev 01)
03:00.0 Ethernet controller: Atheros Communications Atheros AR8121/AR8113/AR8114 PCI-E Ethernet Controller (rev b0)

-- 
	Paolo Ornati
	Linux 2.6.35.7 on x86_64
