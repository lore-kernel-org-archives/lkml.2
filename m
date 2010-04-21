Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755577Ab0DUTYG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 15:24:06 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:33209 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755324Ab0DUTYD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 15:24:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=SrCc0Uj1kZ8DqWHeDqwVva6qrkI0IhNgtpI15CQeIj1c90nEcbUoBcBZSpkUBifhTJ
         GzQxCIRPldO7yPxlw2DRGNn3iBH6a4hSuHj4y6HGSjLF1WMK/evhcRfYlLqsajt20lnX
         oT0obj2U5DgdMZePqW5+AmUxqjQGLhRIMexww=
MIME-Version: 1.0
In-Reply-To: <1271854016.10448.172.camel@gandalf.stny.rr.com>
References: <s2uc5b2c05b1004191348p517c8ac4z32104ea91dd1ca67@mail.gmail.com>
	 <1271755208.1676.422.camel@laptop>
	 <k2nc5b2c05b1004201456j846b15a0oaa261d16740b5e33@mail.gmail.com>
	 <1271804453.10448.168.camel@gandalf.stny.rr.com>
	 <t2nc5b2c05b1004202216pd159c9b4mbfc1dc7658fc20e7@mail.gmail.com>
	 <1271839772.1776.58.camel@laptop>
	 <1271854016.10448.172.camel@gandalf.stny.rr.com>
Date: Wed, 21 Apr 2010 21:24:02 +0200
Message-ID: <x2mc5b2c05b1004211224s7825933dh531f2ed030610e9e@mail.gmail.com>
Subject: Re: Considerations on sched APIs under RT patch
From: Primiano Tucci <p.tucci@gmail.com>
To: rostedt@goodmis.org
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       tglx <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Actually, we do better than that. With adaptive locks, if the process on
> the other CPU is still running, the high priority task will spin until
> the other process releases the lock or goes to sleep. If it goes to
> sleep, then the high prio task will also sleep, otherwise it just spins
> and takes the lock when it is released.
>
> -- Steve

It sounds more reasonable now.
I know that in a preemptible kernel even syscalls can be preempted.
that absolutely fair except for those syscalls (such as setaffinity,
setpriority) that control the scheduler.

Going back to my original problem, the real question is:
Is it sure that calling a scheduler api won't induce a re-scheduling
of the caller process (e.g. as in the case of a lock held by another
processor)? It would be very unpleasant if the scheduling apis can
induce re-scheduling, making the realization of a Real Time scheduling
infrastructure completely un-deterministic.

If I have clearly understood your replies it seems that my problem is
due to an *old* kernel version that still uses rw_lock into the
setaffinity! Is it right?

Thank you for your extremely valuable support.
Primiano

--
 Primiano Tucci
 http://www.primianotucci.com
