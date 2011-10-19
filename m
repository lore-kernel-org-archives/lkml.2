Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755149Ab1JSWJn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 18:09:43 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:49849 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755102Ab1JSWJm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 18:09:42 -0400
MIME-Version: 1.0
X-Originating-IP: [71.233.110.244]
From: Edward Donovan <edward.donovan@numble.net>
Date: Wed, 19 Oct 2011 18:09:21 -0400
X-Google-Sender-Auth: Cji_JIl8AKSv5olQNQM5hkucgyk
Message-ID: <CADdbW+HXdCPfJu2RTF6zz+ujCmiu_dmZwL2iScuF53p=AaZ1Uw@mail.gmail.com>
Subject: Regression: "irqpoll" hasn't been working for me since March 16 IRQ
 tree merge
To: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Mr. Gleixner and LKML -

I am experiencing a regression in IRQ handling, in 2.6.39 and later kernels.

I have several older H-P desktops running Linux, which give irq
errors, unless the "irqpoll" boot argument is used.  With any kernel I
have built after this March 16 merge, "irqpoll" no longer helps, and I
am back to getting "irq 19: nobody cared" messages, and bad USB
performance:

  http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=5f6fb45466b2273ffb91c9cf209f164f666c33b1

  Merge branch 'irq-core-for-linus'

These errors occur with one type of configuration: when the PCI-E
video slot is used, and when the kernel is trying to use the sound
hardware on that video card, i.e. built with
the SND_HDA_INTEL option.  The irq errors then occur, whether the card
is Radeon or Nvidia, with open or closed drivers.

Unfortunately, these machines are desktops and media players, so that
setup is the way I want to use them.  Aside from this recent problem,
these machines are serving my family well.  But if it's decided
they're too old or buggy to bother with, so be it.  I don't have the
knowledge to determine whether there is a general kernel correctness
issue here.

While the kernel bugzilla is down, I have written up an Ubuntu bug report:

  https://bugs.launchpad.net/ubuntu/+source/linux/+bug/855199

and a few other users have reported the same problem, there.  Errors
logs are linked there; I can post them here if desired.

I have pulled and built a lot of snapshots to get this far, using the
http interface to git.kernel.org.  I have not been able to get at the
'tip' tree history, to further isolate these patches, and test them.
And I have no C skills at present, so I may not be able to really
analyze the code.  But I will do whatever I might to isolate the
problem--if you find it to be a problem. :)

Thank you,

Edward Donovan
