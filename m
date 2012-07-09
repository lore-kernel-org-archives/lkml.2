Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751365Ab2GIR0n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 13:26:43 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:46807 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750981Ab2GIR0l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 13:26:41 -0400
MIME-Version: 1.0
In-Reply-To: <CAE9FiQVDW23eLzjNk6ibGq+8KAG9kC2=7g-Eh6p0k3GrxG0LmQ@mail.gmail.com>
References: <Pine.LNX.4.64.1205311412210.11510@info> <CAErSpo7p6XGmsi0Q0PAbWofs9-91taz2Px=VxzL2KEoWWYJwSA@mail.gmail.com>
 <Pine.LNX.4.64.1206010915580.26561@info> <4FC988CF.5030602@gmail.com>
 <20120706180635.GB17196@google.com> <Pine.LNX.4.64.1207061631270.26974@info>
 <CAE9FiQV5DHZoeXf-bSfuYGUSzmwtdVqGNfhHh7LJ3LBax++Rig@mail.gmail.com>
 <Pine.LNX.4.64.1207070017440.13732@info> <CAE9FiQVDW23eLzjNk6ibGq+8KAG9kC2=7g-Eh6p0k3GrxG0LmQ@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 9 Jul 2012 11:26:19 -0600
Message-ID: <CAErSpo6F6V3pzJTMy1Ay1wr8xZCMjgWD78RUDM7yb=DgGNmSUg@mail.gmail.com>
Subject: Re: [Bug 43331] Re: Bug on bootup of Linux kernel on Panasonic
 Toughbook S10
To: Yinghai Lu <yinghai@kernel.org>
Cc: Bill Unruh <unruh@physics.ubc.ca>, Jiang Liu <liuj97@gmail.com>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        bugzilla-daemon@bugzilla.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> looks like they do not bios update for S10 yet.
>
> http://www.panasonic.com/business/toughbook/computer-support-bios.asp#CF-U1
>
> maybe you can try to email or call their support.

Please stop suggesting a BIOS upgrade.  The BIOS is totally out of our
control, and if the current BIOS works with Windows but not Linux,
99.99% of users will just run Windows.  Those users will just give up
on Linux, and we'll never even hear about it.

Fortunately, Bill is a sophisticated user who cared enough to report
the issue, so we have a chance to do something about it.  What we need
is for Linux to deal with this situation better, and that *IS* in our
control.

For example, we could detect the BAR being read-only when we size it.
We could use the read-only address to derive the worst-case BAR size
(32K in this case).  We could mark it as IORESOURCE_PCI_FIXED and use
that to avoid trying to move it.  We could log a message to this
effect so the next time it will take 10 minutes instead of 6 weeks to
diagnose the problem.

The end result for Bill will be the same (an unexpected message while
booting), but we can at least make the message intelligible rather
than "BAR 0: error updating (0xdfa00004 != 0xfed98004)".
