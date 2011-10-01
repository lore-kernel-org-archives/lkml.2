Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751718Ab1JAV74 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Oct 2011 17:59:56 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:62650 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751093Ab1JAV7v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Oct 2011 17:59:51 -0400
MIME-Version: 1.0
In-Reply-To: <CAA879TP_uNBd871yVFy1_dk_-5siOwtK8xM_D8MzYqJW2vFnUA@mail.gmail.com>
References: <CAA879TP_uNBd871yVFy1_dk_-5siOwtK8xM_D8MzYqJW2vFnUA@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 1 Oct 2011 14:59:30 -0700
X-Google-Sender-Auth: TRTL_Bs_aE-LHzsYX6Ynf0Xaa4M
Message-ID: <CA+55aFxBp0GjPujpt=JYWLC3mjBeSiCn8=jfpPxJHo4bTejhDA@mail.gmail.com>
Subject: Re: taskstats root only breaking iotop
To: Guillaume Chazarain <guichaz@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Balbir Singh <bsingharora@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 1, 2011 at 2:54 PM, Guillaume Chazarain <guichaz@gmail.com> wrote:
>
> With taskstats being root only, what's the benefit of making the stats
> imprecise (not that it matters to iotop)?

I think the question should be: why is it *ever* a good idea to let
*anybody* read how many bytes anybody has read.

If you want that kind of detail, do "strace". Don't do that abortion
that is taskstats.

> - byte level stats only if ptrace_may_access() though iotop can
> certainly live with 1k rounded values

Again, do a real trace.

Right now, TASKSTATS is a total and utter disaster. I want to make it
*less* used, not more. And I sure as hell don't want to make it even
*more* of a burden on the kernel by having to do the whole ptrace
check on each and every task.

Seriously. TASKSTATS is crap. It should die. I was *this* close to
deciding to just rip it out entirely. The whole thing is badly
designed, it's known-broken wrt namespaces, and it's a crazy idea to
begin with.

Castrating it a bit and limiting it to root-only made it just
palatable enough that I felt it didn't need to be removed entirely.

But if it gets annoying enough and people try to extend it to be even
more complicated, my response to that will just be "No. HELL NO!".

Especially since I haven't heard a peep about the fact that it was
totally broken wrt namespaces despite reporting it to the people who
were ostensibly in charge of it..

No new complications. People should work at fixing the mess that it
is, rather than trying to make it even messier.

                   Linus
