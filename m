Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756312Ab1JCOww (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 10:52:52 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:44393 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756247Ab1JCOwr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 10:52:47 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFxBp0GjPujpt=JYWLC3mjBeSiCn8=jfpPxJHo4bTejhDA@mail.gmail.com>
References: <CAA879TP_uNBd871yVFy1_dk_-5siOwtK8xM_D8MzYqJW2vFnUA@mail.gmail.com>
	<CA+55aFxBp0GjPujpt=JYWLC3mjBeSiCn8=jfpPxJHo4bTejhDA@mail.gmail.com>
Date: Mon, 3 Oct 2011 20:22:45 +0530
Message-ID: <CAKTCnzmM1sNqf4udk+osgYgY6zk8tQYx7DN0K02MBHuRCOYShQ@mail.gmail.com>
Subject: Re: taskstats root only breaking iotop
From: Balbir Singh <bsingharora@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Guillaume Chazarain <guichaz@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Vasiliy Kulikov <segoon@openwall.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 2, 2011 at 3:29 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Sat, Oct 1, 2011 at 2:54 PM, Guillaume Chazarain <guichaz@gmail.com> wrote:
> >
> > With taskstats being root only, what's the benefit of making the stats
> > imprecise (not that it matters to iotop)?
>
> I think the question should be: why is it *ever* a good idea to let
> *anybody* read how many bytes anybody has read.
>
> If you want that kind of detail, do "strace". Don't do that abortion
> that is taskstats.
>
> > - byte level stats only if ptrace_may_access() though iotop can
> > certainly live with 1k rounded values
>
> Again, do a real trace.
>
> Right now, TASKSTATS is a total and utter disaster. I want to make it
> *less* used, not more. And I sure as hell don't want to make it even
> *more* of a burden on the kernel by having to do the whole ptrace
> check on each and every task.
>
> Seriously. TASKSTATS is crap. It should die. I was *this* close to
> deciding to just rip it out entirely. The whole thing is badly
> designed, it's known-broken wrt namespaces, and it's a crazy idea to
> begin with.
>

Namespaces came in later, much later after taskstats. I think your
biased and not even thinking about your bias. What was badly designed?
It was reviewed several times in the community and tested for
performance. I've tried convincing you before, but I need a constant
supply of energy drinks to keep this fight going. How about we be
practical about the issue at hand, IOW

1. What would a better design look like
2. What can we do to fix the broken namespace
3. The theoretical security issues might exist (I say might), but no
one has demonstrated an attack with it. I agree on the ssh key size
issue being exposed via io portion of taskstats, but beyond that I;d a
dummies guide to help me understand.


Balbir Singh
