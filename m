Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751730Ab1JBIDp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Oct 2011 04:03:45 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:48676 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750831Ab1JBIDa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Oct 2011 04:03:30 -0400
Subject: Re: big picture UDP/IP performance question re 2.6.18 -> 2.6.32
From: Eric Dumazet <eric.dumazet@gmail.com>
To: starlight@binnacle.cx
Cc: linux-kernel@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        Willy Tarreau <w@1wt.eu>, Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <1317540066.3802.32.camel@edumazet-laptop>
References: <6.2.5.6.2.20111001215241.03a7ed48@binnacle.cx>
	 <1317540066.3802.32.camel@edumazet-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 02 Oct 2011 10:03:23 +0200
Message-ID: <1317542603.3802.48.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le dimanche 02 octobre 2011 à 09:21 +0200, Eric Dumazet a écrit :

> You might try to disable any fancy power saving mode in your machine.
> Maybe on your machine, cost to enter/exit deep sleep state is too high.
> 
> I see nothing obvious in the profile but userland processing, futex
> calls. 

Just to clarify a bit :

Sometimes, optimizing one part of the kernel can have a negative impact
on some workloads because we end up doing more sleep/wakeup of
consumers : Several threads might try to acquire a lock at the same
time, while previously they got no contention.

In 2.6.35, commit c377411f2494a (net: sk_add_backlog() take rmem_alloc
into account) changed backlog limit, avoid taking socket lock on flood,
allowing to receive 200.000 pps on a test machine instead of 100pps.
But the receiver was doing a plain

while (1)
	recv(...);

And maximum throughput was reached because task never called
scheduler...



