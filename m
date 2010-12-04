Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755501Ab0LDRjv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Dec 2010 12:39:51 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:43155 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754657Ab0LDRjt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Dec 2010 12:39:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=wzNHmgj4hu3/d1KW011WffV59YmD6mKgKPEduMGVjLmbnFeR8CYAu7NOpd/PNb0+UE
         DhPTfFUfbG233EN29pQ5vNr6NFu9M/9gofuZj+QVxHQG5wLB+0cFKjf3rLEzXdDfJIUP
         SQKAatNjrLOTzHPDkOQ06WCdaPaVdzdorh2cU=
MIME-Version: 1.0
In-Reply-To: <1290281700.28711.9.camel@maggy.simson.net>
References: <1289783580.495.58.camel@maggy.simson.net>
	<1289811438.2109.474.camel@laptop>
	<1289820766.16406.45.camel@maggy.simson.net>
	<1289821590.16406.47.camel@maggy.simson.net>
	<20101115125716.GA22422@redhat.com>
	<1289856350.14719.135.camel@maggy.simson.net>
	<20101116130413.GA29368@redhat.com>
	<1289917109.5169.131.camel@maggy.simson.net>
	<20101116150319.GA3475@redhat.com>
	<1289922108.5169.185.camel@maggy.simson.net>
	<20101116172804.GA9930@elte.hu>
	<1290281700.28711.9.camel@maggy.simson.net>
Date: Sat, 4 Dec 2010 12:39:48 -0500
X-Google-Sender-Auth: 0STZxN6wsFulkcHK0CZ96l0Y9kM
Message-ID: <AANLkTinz12n9OKkCV8XRF8n1vKytO_aj26i-ytcAhFgN@mail.gmail.com>
Subject: Re: [PATCH v4] sched: automated per session task groups
From: Colin Walters <walters@verbum.org>
To: Mike Galbraith <efault@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>, Oleg Nesterov <oleg@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 20, 2010 at 2:35 PM, Mike Galbraith <efault@gmx.de> wrote:

> A recurring complaint from CFS users is that parallel kbuild has a negative
> impact on desktop interactivity.  This patch implements an idea from Linus,
> to automatically create task groups.  This patch only per session autogroups,
> but leaves the way open for enhancement.

Resurrecting this thread a bit, one question I didn't see discussed is simply:

Why doesn't "nice" work for this?  On my Fedora 14 system, "ps alxf"
shows almost everything in my session is running at the default nice
0.  The only exceptions are "/usr/libexec/tracker-miner-fs" at 19, and
pulseaudio at -11.

I don't know What would happen if say the scheduler effectively
group-scheduled each nice value?  Then, what we tell people to do is
run "nice make".  Which in fact, has been documented as a thing to do
for decades.  Actually I tend to use "ionice" too, which is also
useful if any of your desktop applications happen to make the mistake
of doing I/O in the mainloop (emacs fsync()ing in UI thread, I'm
looking at you).

Quickly testing kernel-2.6.35.6-48.fc14.x86_64 on a "Intel(R)
Core(TM)2 Quad CPU    Q9400  @ 2.66GHz", the difference between "make
-j 128" and "nice make -j 128" is quite noticeable.  As you'd expect.
The CFS docs already say:

"The CFS scheduler has a much stronger handling of nice levels and SCHED_BATCH
than the previous vanilla scheduler: both types of workloads are isolated much
more aggressively"

Does it just need to be even more aggressive, and people use "nice"?
