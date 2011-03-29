Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752905Ab1C2Fsr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 01:48:47 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:53788 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752433Ab1C2Fsq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 01:48:46 -0400
Date: Mon, 28 Mar 2011 22:48:39 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: sedat.dilek@gmail.com
Cc: Josh Triplett <josh@joshtriplett.org>,
        linux-next <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        "Theodore Ts'o" <tytso@mit.edu>, Jens Axboe <axboe@kernel.dk>,
        Tejun Heo <tj@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Nick Piggin <npiggin@kernel.dk>
Subject: Re: linux-next: Tree for March 25 (Call trace:
 RCU|workqueues|block|VFS|ext4 related?)
Message-ID: <20110329054839.GE2272@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <AANLkTikpq2CiSTk9Br7DdkVt=E1p8OFGa+Ls2BzkkhcO@mail.gmail.com>
 <20110327032529.GC2322@linux.vnet.ibm.com>
 <20110327050720.GA31424@linux.vnet.ibm.com>
 <AANLkTimpbGGcxNJUDMjdg1wijYhvXQ3KySvRYnEsUYsy@mail.gmail.com>
 <20110327213220.GE2322@linux.vnet.ibm.com>
 <AANLkTi=ti+PVC8N-3Bt2fzuHHQz6kuMdUPeb3Gudn7EU@mail.gmail.com>
 <20110328040823.GG2322@linux.vnet.ibm.com>
 <AANLkTinQiDSXLP1o-HfdedYOMKtnsbBrcOfuqw9sFf2X@mail.gmail.com>
 <20110328132436.GL2322@linux.vnet.ibm.com>
 <AANLkTi=TrwVs-0w9iK9Wbq5RpMomxFw20uEJmTYgsM4_@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=TrwVs-0w9iK9Wbq5RpMomxFw20uEJmTYgsM4_@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 29, 2011 at 06:39:45AM +0200, Sedat Dilek wrote:
> [...]
> >> BTW, today's linux-next (next-20110328) is still freaky, I applied the
> >> revert-rcu-patches patchset and all is fine.
> >
> > I reverted back to the commit preceding the one you pointed out last night
> > my time, so the upcoming -next should be less freaky.
> >
> 
> Makes sense.
> Looks like the "old" commits are now in boost.2011.03.25b GIT branch [1]?

Yep.  I keep them always, digital packrat that I am.

I will be posting updates.

> I have attached the result from rcu-torture for linux-next (20110329)
> as I wanted to see what is logged (loaded rcutorture module 3x normal,
> 1x with verbose=1).

Yep, that is expected output.  Now I just need to work out what else
is messed up.

							Thanx, Paul

> - Sedat -
> 
> [1] http://git.us.kernel.org/?p=linux/kernel/git/paulmck/linux-2.6-rcu.git;a=shortlog;h=refs/heads/boost.2011.03.25b

> [  688.623078] rcu-torture:--- Start of test: nreaders=2 nfakewriters=4 stat_interval=0 verbose=0 test_no_idle_hz=0 shuffle_interval=3 stutter=5 irqreader=1 fqs_duration=0 fqs_holdoff=0 fqs_stutter=3 test_boost=1/0 test_boost_interval=7 test_boost_duration=4
> [  788.672108] rcu-torture: rtc:   (null) ver: 12030 tfle: 0 rta: 12030 rtaf: 0 rtf: 12025 rtmbe: 0 rtbke: 0 rtbre: 0 rtbae: 0 rtbafe: 0 rtbf: 0 rtb: 0 nt: 20281
> [  788.672118] rcu-torture: Reader Pipe:  30198896 782 0 0 0 0 0 0 0 0 0
> [  788.672123] rcu-torture: Reader Batch:  30196680 2998 0 0 0 0 0 0 0 0 0
> [  788.672128] rcu-torture: Free-Block Circulation:  12029 12027 12025 12025 12025 12025 12025 12025 12025 12025 0
> [  788.672158] rcu-torture:--- End of test: SUCCESS: nreaders=2 nfakewriters=4 stat_interval=0 verbose=0 test_no_idle_hz=0 shuffle_interval=3 stutter=5 irqreader=1 fqs_duration=0 fqs_holdoff=0 fqs_stutter=3 test_boost=1/0 test_boost_interval=7 test_boost_duration=4
> [  923.777108] rcu-torture:--- Start of test: nreaders=2 nfakewriters=4 stat_interval=0 verbose=0 test_no_idle_hz=0 shuffle_interval=3 stutter=5 irqreader=1 fqs_duration=0 fqs_holdoff=0 fqs_stutter=3 test_boost=1/0 test_boost_interval=7 test_boost_duration=4
> [ 1023.820120] rcu-torture: rtc:   (null) ver: 12206 tfle: 0 rta: 12206 rtaf: 0 rtf: 12203 rtmbe: 0 rtbke: 0 rtbre: 0 rtbae: 0 rtbafe: 0 rtbf: 0 rtb: 0 nt: 20509
> [ 1023.820130] rcu-torture: Reader Pipe:  31024643 786 0 0 0 0 0 0 0 0 0
> [ 1023.820135] rcu-torture: Reader Batch:  31022307 3122 0 0 0 0 0 0 0 0 0
> [ 1023.820140] rcu-torture: Free-Block Circulation:  12205 12203 12203 12203 12203 12203 12203 12203 12203 12203 0
> [ 1023.820171] rcu-torture:--- End of test: SUCCESS: nreaders=2 nfakewriters=4 stat_interval=0 verbose=0 test_no_idle_hz=0 shuffle_interval=3 stutter=5 irqreader=1 fqs_duration=0 fqs_holdoff=0 fqs_stutter=3 test_boost=1/0 test_boost_interval=7 test_boost_duration=4
> [ 1292.474530] rcu-torture:--- Start of test: nreaders=2 nfakewriters=4 stat_interval=0 verbose=0 test_no_idle_hz=0 shuffle_interval=3 stutter=5 irqreader=1 fqs_duration=0 fqs_holdoff=0 fqs_stutter=3 test_boost=1/0 test_boost_interval=7 test_boost_duration=4
> [ 1392.504192] rcu-torture: rtc:   (null) ver: 12248 tfle: 0 rta: 12248 rtaf: 0 rtf: 12245 rtmbe: 0 rtbke: 0 rtbre: 0 rtbae: 0 rtbafe: 0 rtbf: 0 rtb: 0 nt: 21087
> [ 1392.504201] rcu-torture: Reader Pipe:  31674422 790 0 0 0 0 0 0 0 0 0
> [ 1392.504207] rcu-torture: Reader Batch:  31672026 3186 0 0 0 0 0 0 0 0 0
> [ 1392.504212] rcu-torture: Free-Block Circulation:  12247 12246 12245 12245 12245 12245 12245 12245 12245 12245 0
> [ 1392.504242] rcu-torture:--- End of test: SUCCESS: nreaders=2 nfakewriters=4 stat_interval=0 verbose=0 test_no_idle_hz=0 shuffle_interval=3 stutter=5 irqreader=1 fqs_duration=0 fqs_holdoff=0 fqs_stutter=3 test_boost=1/0 test_boost_interval=7 test_boost_duration=4
> [ 1601.082101] rcu-torture:--- Start of test: nreaders=2 nfakewriters=4 stat_interval=0 verbose=1 test_no_idle_hz=0 shuffle_interval=3 stutter=5 irqreader=1 fqs_duration=0 fqs_holdoff=0 fqs_stutter=3 test_boost=1/0 test_boost_interval=7 test_boost_duration=4
> [ 1601.082114] rcu-torture:Creating rcu_torture_writer task
> [ 1601.082239] rcu-torture:Creating rcu_torture_fakewriter task
> [ 1601.082261] rcu-torture:rcu_torture_writer task started
> [ 1601.087257] rcu-torture:Creating rcu_torture_fakewriter task
> [ 1601.087300] rcu-torture:rcu_torture_fakewriter task started
> [ 1601.090700] rcu-torture:Creating rcu_torture_fakewriter task
> [ 1601.090742] rcu-torture:rcu_torture_fakewriter task started
> [ 1601.090754] rcu-torture:Creating rcu_torture_fakewriter task
> [ 1601.090773] rcu-torture:rcu_torture_fakewriter task started
> [ 1601.090784] rcu-torture:Creating rcu_torture_reader task
> [ 1601.090802] rcu-torture:rcu_torture_fakewriter task started
> [ 1601.090812] rcu-torture:Creating rcu_torture_reader task
> [ 1601.090830] rcu-torture:rcu_torture_reader task started
> [ 1601.090883] rcu-torture:rcu_torture_reader task started
> [ 1601.091303] rcu-torture:rcu_torture_stutter task started
> [ 1701.099323] rcu-torture:Stopping rcu_torture_stutter task
> [ 1701.099347] rcu-torture:rcu_torture_stutter task stopping
> [ 1701.099395] rcu-torture:Stopping rcu_torture_writer task
> [ 1701.099409] rcu-torture:rcu_torture_reader task stopping
> [ 1701.099422] rcu-torture:rcu_torture_reader task stopping
> [ 1701.099437] rcu-torture:rcu_torture_writer task stopping
> [ 1701.099456] rcu-torture:Stopping rcu_torture_reader task
> [ 1701.099497] rcu-torture:Stopping rcu_torture_reader task
> [ 1701.099535] rcu-torture:Stopping rcu_torture_fakewriter task
> [ 1701.100726] rcu-torture:rcu_torture_fakewriter task stopping
> [ 1701.104291] rcu-torture:rcu_torture_fakewriter task stopping
> [ 1701.104315] rcu-torture:Stopping rcu_torture_fakewriter task
> [ 1701.104359] rcu-torture:Stopping rcu_torture_fakewriter task
> [ 1701.131318] rcu-torture:rcu_torture_fakewriter task stopping
> [ 1701.139632] rcu-torture:rcu_torture_fakewriter task stopping
> [ 1701.139668] rcu-torture:Stopping rcu_torture_fakewriter task
> [ 1701.144211] rcu-torture: rtc:   (null) ver: 12179 tfle: 0 rta: 12179 rtaf: 0 rtf: 12177 rtmbe: 0 rtbke: 0 rtbre: 0 rtbae: 0 rtbafe: 0 rtbf: 0 rtb: 0 nt: 20951
> [ 1701.144220] rcu-torture: Reader Pipe:  31547701 757 0 0 0 0 0 0 0 0 0
> [ 1701.144226] rcu-torture: Reader Batch:  31545363 3095 0 0 0 0 0 0 0 0 0
> [ 1701.144231] rcu-torture: Free-Block Circulation:  12178 12177 12177 12177 12177 12177 12177 12177 12177 12177 0
> [ 1701.144259] rcu-torture:--- End of test: SUCCESS: nreaders=2 nfakewriters=4 stat_interval=0 verbose=1 test_no_idle_hz=0 shuffle_interval=3 stutter=5 irqreader=1 fqs_duration=0 fqs_holdoff=0 fqs_stutter=3 test_boost=1/0 test_boost_interval=7 test_boost_duration=4

