Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756114Ab0KSRwJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 12:52:09 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43158 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755989Ab0KSRwI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 12:52:08 -0500
MIME-Version: 1.0
In-Reply-To: <20101119.084302.71115175.davem@davemloft.net>
References: <C47257FC-498A-41B0-BC94-C81C72601D53@mit.edu> <20101119.082944.226775934.davem@davemloft.net>
 <20101119163430.GA12353@tango.0pointer.de> <20101119.084302.71115175.davem@davemloft.net>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 19 Nov 2010 09:51:14 -0800
Message-ID: <AANLkTiksmvcLKGx7-u5CnTnZU6dgOgg7wem6qf384zUg@mail.gmail.com>
Subject: Re: [RFC/RFT PATCH v3] sched: automated per tty task groups
To: David Miller <davem@davemloft.net>
Cc: mzxreary@0pointer.de, tytso@mit.edu, bgamari.foss@gmail.com,
        a.p.zijlstra@chello.nl, debiandev@gmail.com, alan@lxorguk.ukuu.org.uk,
        dhaval.giani@gmail.com, efault@gmx.de, vgoyal@redhat.com,
        oleg@redhat.com, markus@trippelsdorf.de,
        mathieu.desnoyers@efficios.com, mingo@elte.hu,
        linux-kernel@vger.kernel.org, balbir@linux.vnet.ibm.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Guys, calm down. It's really not -that- much of a deal.

We can do both. There is basically zero cost in the kernel: you can
disabled the feature, and it's not like it's a maintenance headache
(all the complexity that matters is the group scheduling itself, not
the autogroup code that is well separated). And the kernel approach is
useful to just take an otherwise unmodified system and just make it
have nice default behavior.

And the user level approach? I think it's fine too. If you run systemd
for other reasons (or if the gnome people add it to the task launcher
or whatever), doing it there isn't wrong. I personally think it's
somewhat disgusting to have a user-level callback with processes etc
just to clean up a group, but whatever.  As long as it's not common,
who cares?

And you really _can_ combine them. As mentioned, I'd be nervous about
AIM benchmarks. I keep mentioning AIM, but that's because it has shown
odd tty issues before. Back when the RT guys wanted to do that crazy
blocking BKL thing (replace the spinlock with a semaphore), AIM7
plummeted by 40%. And people were looking all over the place (file
locking etc), and the tty layer was the biggest reason iirc.

Now, I don't know if AIM7 actually uses setsid() heavily etc, and it's
possible it never hits it at all and only does read/write/kill. And
it's not like AIM7 is the main thing we should look at regardless. But
the point is that we know that there are some tty-heavy loads that are
relevant, and it's very possible that a hybrid approach with "tty's
handled automatically by the kernel, window manager does others in
user space" would be a good way to avoid the (potential) nasty side of
something that has a lot of short-lived tty connections.

So guys, calm down. We don't need to hate each other.

                        Linus
