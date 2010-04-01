Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756766Ab0DAOPI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 10:15:08 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:44375 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754455Ab0DAOPA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 10:15:00 -0400
Date: Thu, 1 Apr 2010 15:17:56 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Greg KH <gregkh@suse.de>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       John Kacur <jkacur@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC 0/9] BKL conversion in TTY drivers
Message-ID: <20100401151756.5e329014@lxorguk.ukuu.org.uk>
In-Reply-To: <201004011451.59712.arnd@arndb.de>
References: <1269982580-9361-1-git-send-email-arnd@arndb.de>
	<201003310957.03025.arnd@arndb.de>
	<20100331110228.2443ccd6@lxorguk.ukuu.org.uk>
	<201004011451.59712.arnd@arndb.de>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.18.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Greg, are you ok with merging these TTY patches in your tree for 2.6.35
> then? There will be at least one more respin of it for minor changes
> and anything that comes up during testing, but it's essentially what I
> posted here.

Can we please wait a bit with the tty bits. I'm slowing picking through
the job properly and there are a lot of low hanging fruit to clean up at
the driver end of things that is best done before we complicate the core
stuff.

I'll try and get some patches posted ASAP for those but for example most
of the BKL use in the drivers/char tty drivers is now done, and those
remaining are almost all in code that we should simply drop as its been
marked broken/obsolete anyway.

Arnd there is another problem I noticed in your changes - the ppp stuff
is not tty locking, its some kind of driver/network locking and I don't
claim to understand what is going on.

Another one that wants attention from someone brave is selection.c - that
isn't tty locking dependant either but relies on the callers happening
(mostly but not always!) to call it with the BKL held.

Alan
