Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933017Ab1EMJOw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 05:14:52 -0400
Received: from eu1sys200aog112.obsmtp.com ([207.126.144.133]:46288 "HELO
	eu1sys200aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932701Ab1EMJOu convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 05:14:50 -0400
MIME-Version: 1.0
In-Reply-To: <1305277666.2561.9.camel@twins>
References: <BANLkTimCpH3Nn2XnOJUKnK=dMObj1r8KEg@mail.gmail.com>
	<BANLkTi=ckPK3BV07n=hmwOeqFUs3mrazFQ@mail.gmail.com>
	<1305273950.15080.7.camel@marge.simson.net>
	<20110513082250.GB13647@elte.hu>
	<1305276066.2561.1.camel@twins>
	<20110513090537.GH13647@elte.hu>
	<1305277666.2561.9.camel@twins>
Date: Fri, 13 May 2011 11:14:47 +0200
Message-ID: <BANLkTikxS9350zKqLEHXqeXCLXpQK=Cd9A@mail.gmail.com>
Subject: Re: Sched_autogroup and niced processes
From: Carl-Johan Kjellander <carl-johan@klarna.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, Mike Galbraith <efault@gmx.de>,
        Yong Zhang <yong.zhang0@gmail.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 13, 2011 at 11:07 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Fri, 2011-05-13 at 11:05 +0200, Ingo Molnar wrote:
>> Could we somehow automate this:
>>
>>   > echo 19 > /proc/'pid of seti@home'/autogroup

Tried this.
echo 19 >/proc/23760/autogroup
echo 1 > /proc/sys/kernel/sched_autogroup_enabled

time make -j12 #seti@home, autogroup, group reniced.
real	3m9.274s
user	11m3.020s
sys	1m45.550s

So 50% increase in compilation time.

Will these autogroups remember the 19, the boinc manager starts 8
processes and it will spawn more as time goes by and it finishes
tasks.

>> and split off nice 19 tasks into separate groups and lower the group's
>> priority?
>
> Well I guess you can stack on all kinds of heuristics, do we want to?
> I'd argue for not, keep is simple.
>

I'd again argue, I use nice 19 for stuff that I want to run on the
spare cycles, I don't want them stealing time from my important work
or surfing or movie viewing.

/cjk
