Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756454Ab2GCNrP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 09:47:15 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:50483 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818Ab2GCNrO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 09:47:14 -0400
Message-ID: <1341323230.3292.10.camel@nayuki.kepstin.ca>
Subject: Re: long boot delays caused by 070ad7e7 floppy change
From: Calvin Walton <calvin.walton@kepstin.ca>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, Jiri Kosina <jkosina@suse.cz>,
        linux-kernel@vger.kernel.org, shemminger@vyatta.com
Date: Tue, 03 Jul 2012 09:47:10 -0400
In-Reply-To: <CA+55aFwre6s=orjUaNKJA=51Fc1mxu_XGX80Bex4Sn-=mWPx5Q@mail.gmail.com>
References: <20120702224648.GA20361@tassilo.jf.intel.com>
	 <CA+55aFwre6s=orjUaNKJA=51Fc1mxu_XGX80Bex4Sn-=mWPx5Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-07-02 at 16:01 -0700, Linus Torvalds wrote:
> On Mon, Jul 2, 2012 at 3:46 PM, Andi Kleen <andi@firstfloor.org> wrote:
> >
> > One of my test systems has a new 20s+ boot delay in 3.5rc*
> > It takes the floppy driver that long to determine I don't
> > have a floppy
> 
> Can you enable debug output ("floppy=debug" iirc) to give more details
> of what happens leading up to the delay? Maybe the timing of the debug
> messages would give some hints too..

I'm seeing the same issue, so I've given this a try. Here are the
messages printed when floppy debugging is enabled:

[    0.000000] floppy0: Setting flag 0x1
...
[    0.703201] 00:07: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    0.703506] Non-volatile memory driver v1.3
[    0.714318] floppy0: reschedule timeout lock fdc
[    1.651396] Refined TSC clocksource calibration: 2698.759 MHz.
[    1.651548] Switching to clocksource tsc
[   20.729798] floppy0: reschedule timeout do wakeup
[   20.732654] floppy0: no floppy controllers found
[   20.733220] loop: module loaded
[   20.733394] ahci 0000:00:1f.2: version 3.0
[   20.733430] ahci 0000:00:1f.2: irq 42 for MSI/MSI-X

The 'reschedule timeout' messages are only printed when debugging is
enabled. Hopefully that can give someone a hint as to what's going on?
-- 
Calvin Walton <calvin.walton@kepstin.ca>

