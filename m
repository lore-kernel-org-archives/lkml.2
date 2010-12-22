Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752669Ab0LVKEX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 05:04:23 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33708 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752401Ab0LVKEV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 05:04:21 -0500
Date: Wed, 22 Dec 2010 02:00:41 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Linux-kernel <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: Re: VERY slow scrolling on radeon graphics card: debugging a timing
 issue?
Message-Id: <20101222020041.c168bf87.akpm@linux-foundation.org>
In-Reply-To: <4D0FC36D.9010304@msgid.tls.msk.ru>
References: <4D0FC36D.9010304@msgid.tls.msk.ru>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc dri-devel)

On Mon, 20 Dec 2010 23:58:21 +0300 Michael Tokarev <mjt@tls.msk.ru> wrote:

> Hello.
> 
> A weird problem here, and I'm looking for help in
> an attempt to solve it.
> 
> Ever since KMS went into kernel and I tried turning
> it on, the scrolling speed on the resulting "text"
> console (with kms it works in one of graphics modes
> hence "text" in quotes) become really _awful_.
> 
> For example, running `dmesg' (which has ~2000 lines)
> on the console takes about 2.5 _minutes_ (!) to
> complete, -- which means the speed is about 10 lines
> per second.  On an old notebook I have, with some also
> nvidia card, the same operation completes in about
> 0.8 sec.
> 
> The lines goes up in a slow motion, I can watch every
> new line appearing and scrolling.
> 
> It was this way for a long time, and I almost gave up --
> in X everything works ok, and in order to speed up
> booting again I just added "quiet" option to the kernel
> command line, to avoid scrolling of kernel messages.
> 
> But yesterday I noticed something else entirely, which
> make me hope the problem actually _can_ be solved.
> 
> The thing is: that same scrolling becomes much faster
> when I "do something" else while it scrolls up.  First
> I noticed this when I wanted to switch to another vt
> while it were scrolling -- I held down Ctrl key on my
> keyboard, and out of the sudden the scroll speed up
> dramatically.
> 
> It turned out I can speed the thing to about 10 times
> by generating some load: hit and hold a key on the
> keyboard (generates interrupts?), run kernel compile
> in the background (generates disk interrupts?), move
> mouse...
> 
> While doing "something", the same scrolling completes
> in about 8 seconds instead of 2m30s.  Dramatic improvement.
> 
> Now, when I hold a key or move mouse, the scrolling
> is "jumpy" - sometimes it slows down back to original
> "slow" form for a bit, and sometimes it jumps a few
> lines in one go.
> 
> I tried to disable cpufreq (selecting "performance"
> governor) - this changes exactly nothing.
> 
> Next someone suggested the "perf" tool.  And this one
> is even more interesting: while `perf top' is running
> (on another console or X), the scrolling is.. fast
> again, as if I were moving my mouse!  Once I stop
> `perf top', it becomes slow again.  So the bug
> disappears while you watch it.
> 
> And there I'm stuck again.  I asked in #radeon, but
> there, Alex Deucher told me that he has no clue and
> that the behavour is weird (it is weird indeed).
> 
> Any hints on where to go from there are apprecated.
> 
> The hardware is an AMD780g-based motherboard with
> and Athlon CPU, I've seen the same behavour from
> many other similar boards.  Kernels - all up to
> the current 2.6.36.2, sine the old days when kms
> for radeon first appeared in staging.
> 
> I know kms/fbcon scrolling is slow on radeon because
> it uses completely unoptimized bitblt routines (even
> when the hw is pretty much capable of doing all that
> stuff internally).  But what I see here is something
> different - the 8 sec to scroll 2000 lines is the
> result from the un-optimal bitblt, not the 2m30s.
> 
> Thanks!
> 
> /mjt
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
