Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933095Ab1EMNgc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 09:36:32 -0400
Received: from eu1sys200aog118.obsmtp.com ([207.126.144.145]:45406 "HELO
	eu1sys200aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933081Ab1EMNgb convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 09:36:31 -0400
MIME-Version: 1.0
In-Reply-To: <1305292406.27263.20.camel@marge.simson.net>
References: <BANLkTimCpH3Nn2XnOJUKnK=dMObj1r8KEg@mail.gmail.com>
	<BANLkTi=ckPK3BV07n=hmwOeqFUs3mrazFQ@mail.gmail.com>
	<1305273950.15080.7.camel@marge.simson.net>
	<20110513082250.GB13647@elte.hu>
	<1305276066.2561.1.camel@twins>
	<20110513090537.GH13647@elte.hu>
	<1305277666.2561.9.camel@twins>
	<20110513092933.GL13647@elte.hu>
	<1305279990.2466.4.camel@twins>
	<20110513100411.GA21022@elte.hu>
	<1305292406.27263.20.camel@marge.simson.net>
Date: Fri, 13 May 2011 15:36:28 +0200
Message-ID: <BANLkTimvehoQkiiX5EuPB0ozVKoPk3tAbg@mail.gmail.com>
Subject: Re: Sched_autogroup and niced processes
From: Carl-Johan Kjellander <carl-johan@klarna.com>
To: Mike Galbraith <efault@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Yong Zhang <yong.zhang0@gmail.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 13, 2011 at 3:13 PM, Mike Galbraith <efault@gmx.de> wrote:
> On Fri, 2011-05-13 at 12:04 +0200, Ingo Molnar wrote:
>
>> Still, the other important problem is that we still seem to have a bug, even
>> with the cgroup set to low prio seti@home is sucking up CPU resources ...
>
> I don't see how.  Other than the expected nice 19 overrun when nice 0
> group blocks, it works fine on my little Q6600 box.

Dunno if I've done it correct, but I've set 19 to the boinc manager
autogroup and some of
the seti@home clients, but the clients of course keep changing.

boinc     1172  0.1  0.0  81896 13408 ?        SN   May09   7:00
/usr/bin/boinc --check_all_logins --redirectio --dir /var/lib/boi
boinc    18983 82.6  0.3  98172 65224 ?        RNl  08:10 364:28  \_
../../projects/setiathome.berkeley.edu/setiathome_enhanced
boinc    19162 83.0  0.4  98836 65948 ?        RNl  08:16 360:32  \_
../../projects/setiathome.berkeley.edu/setiathome_enhanced
boinc    20295 84.6  0.3  98356 65468 ?        RNl  08:57 332:42  \_
../../projects/setiathome.berkeley.edu/setiathome_enhanced
boinc    22980 82.5  0.3  97880 64992 ?        RNl  09:32 295:55  \_
../../projects/setiathome.berkeley.edu/setiathome_enhanced
boinc    23760 81.6  0.3  98064 65168 ?        RNl  09:59 270:25  \_
../../projects/setiathome.berkeley.edu/setiathome_enhanced
boinc      634 83.1  0.3  98224 65276 ?        RNl  11:02 223:24  \_
../../projects/setiathome.berkeley.edu/setiathome_enhanced
boinc    31758 83.5  0.4  99116 65736 ?        RNl  11:33 198:48  \_
../../projects/setiathome.berkeley.edu/setiathome_enhanced
boinc     5931 81.4  0.3  98456 65464 ?        RNl  14:06  68:55  \_
../../projects/setiathome.berkeley.edu/setiathome_enhan

But when I build on Intel(R) Core(TM) i7 CPU         870  @ 2.93GHz,
it's still a lot slower.

time make -j12
real	2m58.437s
user	10m58.010s
sys	1m45.610s

I can try the same thing at home on my Q6600 machine if I upgrade it,
cause of course the Core i7 doesn't actually have 8 cores, they are
just hyperthreaded. It might be a factor.

Or am doing something horribly wrong when I try to set the autogroup to 19?

/cjk
