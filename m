Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755320Ab1LVNAr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 08:00:47 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:54967 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755202Ab1LVNAn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 08:00:43 -0500
MIME-Version: 1.0
In-Reply-To: <1324544352.24803.9.camel@twins>
References: <1324419795.20886.3.camel@raz> <4EF2261F.4050002@colorfullife.com>
 <1324500515.5467.18.camel@raz> <1324544352.24803.9.camel@twins>
From: Raz <raziebe@gmail.com>
Date: Thu, 22 Dec 2011 15:00:21 +0200
Message-ID: <CAPB=Z-oaKQz_bSPag3H+i81cLVahSmvAzmSNYnmfYt_Kn8sGPQ@mail.gmail.com>
Subject: Re: Subject: [PATCH 2/2] priority System V Semaphores
To: Peter Zijlstra <peterz@infradead.org>
Cc: Manfred Spraul <manfred@colorfullife.com>, linux-rt-users@vger.kernel.org,
        linux-kernel@vger.kernel.org, Lior Brafman <LBrafman@manz.com>,
        Torsten Scherer <TScherer@manz.com>,
        Rasty Slutsker <RSlutsker@manz.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 22, 2011 at 10:59 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, 2011-12-21 at 22:48 +0200, raz ben yehuda wrote:
>> Vxworks is the use case. And there are plenty of companies with
>> vxWorks software and in i believe they will migrate sooner or later to
>> PreemptRT.  My current company uses old wrapper software that implements
>> vxWorks semaphores as system V semaphores. vxWorks semaphores have a priority
>> feature which is widely used.
>> I will probably change it some time in the future to posix semaphores , but posix
>> semaphores are implemented in glibc with futexes and atomic ops and i rather
>> mess with kernel and not glibc. funny , but true. glibc is harder.
>
> Semaphores are a fscking trainwreck for real-time programming. Don't use
> them, full stop. If you do, you're doing it wrong, it's really that
> simple.
>
> Use PI mutexes, which are already fully supported in glibc, no extra
> patching needed.
>
> Full NAK for any and all priority fudging for any semaphore
> implementation.
please correct me if am wrong, " posix semaphores
are implemented with pi mutex. ..?" I need a counting semaphore.
vxWorks priority/fifo semaphores are different from posix semaphores in
that the behaviour is defined on the semaphore and not the thread.
Q: what happens if I want one posix semahore to be FIFO and another
posix semaphore to be PRIO while both are used by the same
thread.should i to change policies each time ?
