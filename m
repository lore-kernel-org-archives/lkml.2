Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752171Ab2LCTni (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 14:43:38 -0500
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:45529 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751880Ab2LCTnh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 14:43:37 -0500
X-Greylist: delayed 626 seconds by postgrey-1.27 at vger.kernel.org; Mon, 03 Dec 2012 14:43:37 EST
Date: Mon, 3 Dec 2012 20:33:10 +0100
From: Andreas Mohr <andi@lisas.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [YASB] Re: Linux 3.7-rc7
Message-ID: <20121203193310.GA32762@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyetqyMa2BQu7kE=cqFdAysUh9gV=O5as5Chgg1EMCW7g@mail.gmail.com>
X-Priority: none
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

JFYI: Yet Another Suspend Breakage, it seems (hopefully someone
can contribute to and further nail down this issue).


Working:
vmlinuz-3.7.0-rc5-00068-gc5e35d6 (HEAD possibly unknown?)

Failing:
vmlinuz-3.7.0-rc7-00179-g2db18aa (HEAD 3c46f3d6406b1d0c53575774b2d1fd013cd7f76f)


Athlon XP 32bit VIA 8K5A2+.


Florian Fainelli (1):
      x86/ce4100: Fix pm_poweroff

sounds like it *might* happen to be a candidate (I could try to add a
revert on top, of certain likely candidates).


I started some initial pm debugging (Documentation/power/basic-pm-debugging.txt), and it started hanging once progressing from "devices" to "platform"
in /sys/power/pm_test .

I could do more invasive debugging (and unloading modules at random, too),
however given that I'm currently spending almost days
debugging my third(!) non-working USB storage device in one year,
I'm somewhat less inclined.
As a side note, support status in (admittedly terribly complex,
and certainly very challenging given Windows' usual dirty non-spec tricks
in this area as well) USB storage areas seems to be nothing short of *terrible*.
At the current rate, there's an almost one-in-three chance to end up
with a dud when shopping for storage devices, it seems.
This situation should DEFINITELY see improvement,
ideally via a concerted effort (and finally get those lazy vendors
involved, too!).

It really cannot be that hard to buy devices at random
and plug into a large selection of random hardware
to verify that everything works in a most compatible way!!
Internet forums are full of stories about device failures on *Linux*,
with some of the usual recommendations being
"oh yeah, you need to disable ehci_hcd" (what a terrible "workaround")
or "use irqpoll" (dito)
[none of which helped in my two remaining cases].

So, all the usual problems (suspend breakage, USB storage) alive and kicking...

</rant>
</asbestos>

Crawling back into my corner,

Andreas Mohr

-- 
GNU/Linux. It's not the software that's free, it's you.
