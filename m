Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752695Ab1GBQkU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jul 2011 12:40:20 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:44544 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752140Ab1GBQkQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jul 2011 12:40:16 -0400
MIME-Version: 1.0
In-Reply-To: <1309623082.26417.163.camel@gandalf.stny.rr.com>
References: <20110702030435.308336775@goodmis.org> <20110702033853.220897627@goodmis.org>
 <CAMjpGUfHw-CO=ydCew5FqG0RLQOMk8+NpVjvBdV4Nv-tiDavqg@mail.gmail.com> <1309623082.26417.163.camel@gandalf.stny.rr.com>
From: Mike Frysinger <vapier@gentoo.org>
Date: Sat, 2 Jul 2011 12:39:56 -0400
X-Google-Sender-Auth: lX-nuAluQnQma8zzx7-UMs1Hf-4
Message-ID: <CAMjpGUdnA5qd98nfB8UR-TGnCYm4F-7NVPobjWoAxXYPd4Vv=A@mail.gmail.com>
Subject: Re: [patch 03/11] blackfin/irqs: Do not trace arch_local_{*,irq_*} functions
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 2, 2011 at 12:11, Steven Rostedt wrote:
> On Sat, 2011-07-02 at 02:50 -0400, Mike Frysinger wrote:
>> On Fri, Jul 1, 2011 at 23:04, Steven Rostedt wrote:
>> > Do not trace arch_local_save_flags(), arch_local_irq_*() and friends.
>> > Although they are marked inline, gcc may still make a function out of
>> > them and add it to the pool of functions that are traced by the function
>> > tracer. This can cause undesirable results (kernel panic, triple faults,
>> > etc).
>> >
>> > Add the notrace notation to prevent them from ever being traced.
>>
>> what about putting the markings in include/asm-generic/irqflags.h ?
>> then you wouldnt have to update every arch (or at least, not as much).
>
> One of my patches do that, but it only helps superH, as that's the only
> arch that uses that header and implements function tracing.

hmm, i thought Blackfin was using that too.  guess i'll have to fix that ;).
-mike
