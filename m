Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752631Ab1LVOBP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 09:01:15 -0500
Received: from merlin.infradead.org ([205.233.59.134]:49805 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751689Ab1LVOBM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 09:01:12 -0500
Message-ID: <1324562457.24803.24.camel@twins>
Subject: Re: Subject: [PATCH 2/2] priority System V Semaphores
From: Peter Zijlstra <peterz@infradead.org>
To: Raz <raziebe@gmail.com>
Cc: Manfred Spraul <manfred@colorfullife.com>, linux-rt-users@vger.kernel.org,
        linux-kernel@vger.kernel.org, Lior Brafman <LBrafman@manz.com>,
        Torsten Scherer <TScherer@manz.com>,
        Rasty Slutsker <RSlutsker@manz.com>
Date: Thu, 22 Dec 2011 15:00:57 +0100
In-Reply-To: <CAPB=Z-oaKQz_bSPag3H+i81cLVahSmvAzmSNYnmfYt_Kn8sGPQ@mail.gmail.com>
References: <1324419795.20886.3.camel@raz>
	 <4EF2261F.4050002@colorfullife.com> <1324500515.5467.18.camel@raz>
	 <1324544352.24803.9.camel@twins>
	 <CAPB=Z-oaKQz_bSPag3H+i81cLVahSmvAzmSNYnmfYt_Kn8sGPQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-12-22 at 15:00 +0200, Raz wrote:

> please correct me if am wrong, " posix semaphores
> are implemented with pi mutex. ..?" 

Probably not, that would be pointless. They might be implemented using a
mutex, but I've already looked at glibc this month and my eyes can't
handle more.

> I need a counting semaphore.
> vxWorks priority/fifo semaphores are different from posix semaphores in
> that the behaviour is defined on the semaphore and not the thread.

That doesn't make them sane locking primitives.

> Q: what happens if I want one posix semahore to be FIFO and another
> posix semaphore to be PRIO while both are used by the same
> thread.should i to change policies each time ?

If you need a counting semaphore your program is very likely not a
correct real-time application. So who cares what order things are woken
up in.

Semaphores don't have lock owners, therefore priority inheritance and
related schemes don't work, therefore you suffer from priority inversion
and thus your program is invalid.

Seriously, forget semaphores exist, they're a hysterical accident.
