Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754920Ab2CYCdU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2012 22:33:20 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:53137 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753741Ab2CYCdS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2012 22:33:18 -0400
MIME-Version: 1.0
In-Reply-To: <57375.1332641134@turing-police.cc.vt.edu>
References: <CABqErrHS6C6RVMKChaPGACoaWoXCKf+6dS5KFrWG04+DnZO6Dw@mail.gmail.com>
	<201203240553.32526.gene.heskett@gmail.com>
	<57375.1332641134@turing-police.cc.vt.edu>
Date: Sun, 25 Mar 2012 13:33:16 +1100
X-Google-Sender-Auth: dLhd5edoJMhIV9jT-lDf6jIswfM
Message-ID: <CABqErrE-rRbrrx9ErPFX2aKe=dCdMSxjtUSVx=PxUEwdcJCdMA@mail.gmail.com>
Subject: Re: [ANNOUNCE] BFS CPU scheduler version 0.420 AKA "Smoking" for
 linux kernel 3.3.0
From: Con Kolivas <kernel@kolivas.org>
To: Valdis.Kletnieks@vt.edu
Cc: Gene Heskett <gene.heskett@gmail.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25 March 2012 13:05,  <Valdis.Kletnieks@vt.edu> wrote:
> On Sat, 24 Mar 2012 05:53:32 -0400, Gene Heskett said:
>
>> I for one am happy to see this, Con.  I have been running an earlier patch
>> as pclos applies it to 2.6.38.8, and I must say the desktop interactivity
>> is very much improved over the non-bfs version.
>
> I'va always wondered what people are using to measure interactivity. Do we have
> some hard numbers from scheduler traces, or is it a "feels faster"?  And if
> it's a subjective thing, how are people avoiding confirmation bias (where you
> decide it feels faster because it's the new kernel and *should* feel faster)?
> Anybody doing blinded boots, where a random kernel old/new is booted and the
> user grades the performance without knowing which one was actually running?
>
> And yes, this can be a real issue - anybody who's been a aysadmin for
> a while will have at least one story of scheduling an upgrade, scratching it
> at the last minute, and then having users complain about how the upgrade
> ruined performance and introduced bugs...
>

I would say the vast majority of -ck/BFS users rely purely on
subjective feeling. On the other hand I have done numerous benchmarks
in the past trying to show the bound latencies of bfs are better than
mainline on regular workloads which is not surprising since BFS is
deterministic with respect to its latencies whereas mainline is not
(except on uniprocessor). I also documented interbench numbers showing
worst case latencies are bound better with BFS but since interbench is
a complicated benchmark that also displays fairness, most people don't
know how to read the values. Since I was never out to displace the
mainline scheduler but to demonstrate alternatives and provide a
standard for comparison I didn't bother with the benchmarks much
further than the occasional one I've posted. Since the main mailing
list seems distinctly disinterested in said results, I've only
published the throughput benchmarks as a kind of baseline regression
point to show that BFS' throughput is not significantly adversely
affected on the commodity hardware that people are using it on.

A comprehensive comparison of (an earlier BFS) compared to CFS and the
old O(1) scheduler evaluating throughput and fairness was in the
excellent thesis by Joseph T. Meehean entitled "Towards Transparent
CPU Scheduling":
http://research.cs.wisc.edu/wind/Publications/meehean-thesis11.html

A few of the latency benchmarks that still remain published on my site
can be found here:
http://ck.kolivas.org/patches/bfs/bfs404-cfs/
http://ck.kolivas.org/patches/bfs/2.6.35v2.6.35-ck1-interbench.log

Note how old they are. Not much has been done to repeat them since
then, but BFS' main design has not drastically changed in that time.
Some may be found on the old mailing list posts, but not a lot has
been documented with regards to this.

Some throughput benchmarks:
http://ck.kolivas.org/patches/bfs/benchmark3-results-for-announcement-20110410.txt

Current version:
http://s14.postimage.org/4gr5z8nxr/anova_x3360.png
http://postimage.org/image/wavusknl1/

Yes the results are from relatively simple benchmarks and limited in
scope. Yes there is hardly a decent benchmark for either interactivity
or responsiveness (interbench and contest were my attempt to benchmark
both of those).
Here's my very brief summary of the difference between interactivity
and responsiveness as I see it that I wrote many years ago:
http://ck.kolivas.org/readme.interactivity

Regards,
Con
