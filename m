Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752067Ab2E0H4p (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 03:56:45 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:34662 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751586Ab2E0H4o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 03:56:44 -0400
MIME-Version: 1.0
In-Reply-To: <20120526123858.GA1679@m.brq.redhat.com>
References: <1333574176-11388-1-git-send-email-jolsa@redhat.com>
 <20120525223646.GL27374@one.firstfloor.org> <20120526123858.GA1679@m.brq.redhat.com>
From: Ulrich Drepper <drepper@gmail.com>
Date: Sun, 27 May 2012 03:56:22 -0400
Message-ID: <CAOPLpQfveNoXkorqfk=zSp72-YXskxtDebJqhGarngaJY89Rmg@mail.gmail.com>
Subject: Re: [RFCv2 0/8] perf tool: Add new event group management
To: Jiri Olsa <jolsa@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, acme@redhat.com, a.p.zijlstra@chello.nl,
        mingo@elte.hu, paulus@samba.org, cjashfor@linux.vnet.ibm.com,
        fweisbec@gmail.com, linux-kernel@vger.kernel.org, tglx@linutronix.de
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 26, 2012 at 8:38 AM, Jiri Olsa <jolsa@redhat.com> wrote:
> If you have some ideas on this or real world examples,
> that would really help.. so far, here's the latest discussion:
> http://marc.info/?t=133357436900005&r=1&w=2

If you're looking for a definitive source, just point to the Intel
optimization manual.  Absolute values of counters are not really
useful and so they are defining many (50+) ratios which people should
investigate.  These ratios are only really accurate if the counters
are swapped in and out at the same time.

The reminds me of a detail I looked at when starting an an
implementation for this (glad you got more time to devote to it).  The
problem with ratios are that there are so many.  So efficient
scheduling is going to be important.  Many ratios use as a base the
same counters over and over again (e.g., cycle count, instruction
count, etc).  Therefore it is important to recognize when two groups
can be scheduled concurrently even if the total number of counters
needed would be high but due to intersections it is possible.

One last comment, not critical.  From a parsing point of view the
colon in the proposed syntax

    name : { counter1, counter2 }

is unnecessary.  Just one more thing people can get wrong.  How about
leaving it out?  An open curly brace to indicate a group should be
sufficient.
