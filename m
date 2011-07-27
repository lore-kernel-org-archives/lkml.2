Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755953Ab1G0V4L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 17:56:11 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:36166 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755699Ab1G0VtR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 17:49:17 -0400
From: kernelmail.jms@gmail.com
To: paulmck@linux.vnet.ibm.com
Subject: Re: Fw: RCU boot debug patch
Date: Wed, 27 Jul 2011 22:47:49 +0100
User-Agent: KMail/1.13.6 (Linux/3.0.0-test+; KDE/4.6.2; x86_64; ; )
Cc: RKK <kulkarni.ravi4@gmail.com>, kernelmail.jms@gmail.com,
        linux-kernel@vger.kernel.org, cmm@us.ibm.com
References: <20110719224142.GT2357@linux.vnet.ibm.com> <CAM=x7SYYSPGhqYmEAUqe6pc2N=Djg-aG31P5nSmPGDsMORBmyA@mail.gmail.com> <20110722022937.GB2408@linux.vnet.ibm.com>
In-Reply-To: <20110722022937.GB2408@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201107272247.50613.kernelmail.jms@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 22 July 2011 03:29:37 Paul E. McKenney wrote:
> On Thu, Jul 21, 2011 at 11:09:57AM +0530, RKK wrote:
> > On Wed, Jul 20, 2011 at 9:39 PM, Paul E. McKenney
> > 
> > <paulmck@linux.vnet.ibm.com> wrote:
> > > On Wed, Jul 20, 2011 at 09:23:06PM +0530, RKK wrote:
> > >> Hi Paul
> > >> 
> > >> >> On Wed, Jul 20, 2011 at 4:11 AM, Paul E. McKenney
> > >> >> 
> > >> >> <paulmck@linux.vnet.ibm.com> wrote:
> > >> >> > Hello, Julie and Ravi,
> > >> >> > 
> > >> >> > Although we arrived at a patch that worked for both of you, we
> > >> >> > never did identify exactly which RCU callback (or other issue)
> > >> >> > that was causing the problem.  It would be good to do this in
> > >> >> > case there is some other problem lurking that might bite us in
> > >> >> > the future.  Mingming has therefore put together the following
> > >> >> > diagnostic patch which should identify the callbacks, please see
> > >> >> > below.
> > >> >> > 
> > >> >> > So could you please run this and let us know what you find?
> > >> >> >  There should at least be a message for artificial_callback().
> > >> >> 
> > >> >>  Do i need to  apply this patch on today's Linus master or on -rc7
> > >> >> ?
> > >> > 
> > >> > Please do not use -rc7, as that would reproduce your hang.  Linus
> > >> > master tree would be best, but -rc7 with the fix applied would work
> > >> > fine as well.
> > >> 
> > >> Ok. will apply against Linus Master tree and get back to you sometime
> > >> later tonight.
> >
> > 
> >
> > I applied and booted into today's Linus master tree today . it booted
> > fine.  Im attaching the dmesg output for you. you want anyother info?
> 
> Thank you again for the testing, Ravi!
> 
> It appears that you are running with CONFIG_TREE_RCU=y, and therefore
> CONFIG_RCU_BOOST=n.  It looks like I do need to take a look at a few
> additional things.  Again, thank you for testing this!
> 
>                                                         Thanx, Paul
> 
> > Warm Regards,
> > Ravi Kulkarni.

Sorry, Ravi and Paul, been away and only just picked up the thread.
I applied Mingming's patch to a clean 3.0 from Linus' tree (RCU_BOOST=n).
It booted fine but there were so many of the 'RCU scheduler...' messages I actually saw them briefly
before the KDE  desktop login prompt appeared. They comprise about half of the dmesg log output,
sorry about the length, I can post an abbreviated version if that's more helpful.

>A debug patch to verify if there is RCU callbacks before the rcu scheduler is active
So something gives me the impression we may have an answer somewhere in this dmesg for this... ;-)

Here is my dmesg (the whole thing):

function free_object_rcu
[    0.166707] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.166732] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.167652] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.167678] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.167704] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.167730] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.167756] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.167781] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.167807] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.167833] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.167859] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.167885] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.167914] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.167941] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.167967] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.168007] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.168033] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.168058] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.168084] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.168110] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.168135] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.168161] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.168186] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.168212] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.168237] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.168263] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.168288] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.168314] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.168339] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.168365] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.168390] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.168416] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.168441] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.168470] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.168496] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.168522] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.168547] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.168572] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.168598] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.168623] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.168649] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.168674] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.168700] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.168725] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.168751] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.168776] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.168802] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.168827] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.168852] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.168877] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.168903] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.168928] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.168954] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.169004] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.169034] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.169060] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.169085] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.169111] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.169136] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.169162] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.169188] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.169213] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.169239] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.169264] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.169290] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.169315] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.169357] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.169405] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.169430] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.169468] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.169497] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.169544] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.169583] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.169641] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.169667] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.169693] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.169718] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.169765] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.169807] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.169865] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.169891] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.169916] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.169941] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.170011] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.170051] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.170113] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.170139] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.170164] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.170190] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.170236] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.170275] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.170333] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.170360] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.170385] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.170410] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.170460] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.170500] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.170558] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.170584] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.170610] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.170635] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.170682] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.170715] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.170741] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.170770] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.170817] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.170850] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.170876] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.170901] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.170949] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.171000] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.171026] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.171052] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.171099] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.171136] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.171162] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.171188] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.171235] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.171268] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.171294] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.171319] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.171367] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.171400] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.171426] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.171451] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.171502] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.171549] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.171589] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.171624] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.171650] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.171697] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.171730] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.171756] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.171781] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.171832] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.171865] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.171891] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.171916] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.171941] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.171967] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.172007] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.172055] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.172101] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.172144] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.172179] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.172205] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.172253] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.172286] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.172312] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.172338] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.172385] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.172419] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.172445] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.172470] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.172496] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.172524] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.172550] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.172576] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.172601] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.172627] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.172675] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.172723] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.172763] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.172798] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.172824] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.172866] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.172920] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.172949] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.172997] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.173035] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.173061] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.173086] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.173112] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.173138] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.173185] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.173235] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.173275] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.173309] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.173335] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.173382] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.173427] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.173467] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.173501] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.173527] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.173577] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.173623] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.173662] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.173697] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.173723] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.173770] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.173819] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.173859] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.173893] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.173919] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.173966] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.174022] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.174049] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.174074] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.174121] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.174154] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.174184] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.174210] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.174257] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.174310] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.174343] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.174369] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.174394] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.174441] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.174473] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.174503] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.174528] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.174575] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.174608] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.174634] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.174659] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.174706] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.174739] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.174765] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.174790] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.174815] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.174841] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.174867] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.174917] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.174991] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.175024] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.175050] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.175076] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.175123] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.175155] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.175181] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.175206] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.175257] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.175289] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.175315] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.175341] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.175387] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.175420] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.175446] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.175471] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.175497] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.175522] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.175548] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.175598] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.175651] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.175684] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.175710] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.175735] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.175782] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.175815] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.175841] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.175866] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.175916] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.175949] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.175994] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.176020] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.176067] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.176100] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.176125] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.176151] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.176190] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.176229] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.176267] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.176293] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.176332] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.176386] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.176411] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.176437] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.176471] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.176497] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.176547] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.176580] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.176609] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.176635] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.176682] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.176715] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.176741] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.176767] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.176813] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.176846] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.176872] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.176898] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.176923] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.176948] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.176991] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.177044] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.177098] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.177131] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.177157] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.177182] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.177229] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.177262] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.177288] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.177313] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.177363] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.177396] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.177422] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.177447] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.177494] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.177527] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.177553] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.177578] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.177604] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.177629] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.177655] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.177680] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.177706] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.177734] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.177760] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.177786] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.177811] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.177858] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.177904] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.177943] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.178006] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.178032] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.178082] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.178129] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.178168] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.178203] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.178229] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.178276] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.178308] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.178334] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.178360] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.178410] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.178443] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.178469] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.178494] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.178519] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.178545] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.178571] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.178596] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.178622] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.178647] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.178673] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.178698] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.178724] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.178749] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.178775] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.178800] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.178850] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.178904] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.178950] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.179008] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.179043] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.179069] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.179108] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.179150] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.179185] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.179211] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.179258] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.179290] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.179316] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.179342] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.179367] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.179393] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.179419] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.179444] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.179469] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.179495] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.179545] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.179599] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.179645] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.179685] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.179720] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.179746] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.179785] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.179827] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.179862] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.179888] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.179927] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.179995] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.180021] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.180056] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.180082] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.180129] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.180161] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.180191] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.180217] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.180242] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.180268] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.180294] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.180341] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.180387] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.180426] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.180460] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.180486] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.180528] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.180568] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.180602] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.180628] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.180667] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.180713] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.180739] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.180773] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.180798] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.180848] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.180881] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.180907] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.180933] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.180958] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.181002] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.181028] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.181053] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.181081] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.181107] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.181154] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.181180] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.181205] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.181252] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.181301] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.181341] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.181375] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.181401] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.181440] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.181486] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.181525] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.181553] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.181581] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.181607] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.181633] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.181936] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.181962] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.182018] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.182044] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.182069] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.182095] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.182121] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.182147] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.182172] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.182198] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.182224] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.182249] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.182275] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.182301] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.182326] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.182351] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.182377] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.182402] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.182427] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.182453] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.182478] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.182504] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.182529] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.182558] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.182584] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.182609] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.182635] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.182682] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.182728] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.182767] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.182802] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.182828] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.182853] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.182879] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.182905] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.182947] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.183021] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.183047] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.183072] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.183107] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.183133] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.183180] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.183212] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.183238] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.183264] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.183292] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.183318] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.183344] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.183392] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.183437] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.183477] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.183512] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.183541] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.183581] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.183630] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.183670] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.183697] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.183723] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.183749] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.183774] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.184106] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.184132] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.184157] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.184183] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.184208] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.184235] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.184261] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.184286] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.184312] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.184338] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.184363] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.184389] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.184414] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.184440] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.184466] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.184491] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.184520] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.184545] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.184571] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.184597] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.184622] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.184647] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.184674] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.184700] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.184725] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.184751] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.184777] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.184824] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.184871] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.184913] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.184948] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.184993] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.185019] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.185047] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.185073] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.185112] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.185166] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.185192] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.185217] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.185252] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.185277] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.185328] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.185361] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.185387] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.185412] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.185438] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.185463] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.185489] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.185537] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.185582] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.185622] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.185660] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.185685] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.185725] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.185771] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.185810] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.185837] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.185863] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.185888] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.185914] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.186245] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.186271] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.186297] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.186322] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.186348] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.186373] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.186399] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.186424] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.186450] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.186478] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.186504] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.186530] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.186555] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.186581] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.186606] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.186632] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.186657] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.186682] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.186708] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.186734] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.186759] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.186784] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.186810] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.186835] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.186861] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.186887] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.186912] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.186963] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.187025] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.187065] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.187100] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.187125] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.187150] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.187176] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.187205] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.187245] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.187301] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.187327] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.187352] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.187387] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.187412] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.187460] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.187493] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.187518] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.187544] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.187569] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.187594] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.187620] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.187667] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.187717] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.187757] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.187791] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.187817] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.187856] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.187902] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.187942] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.187989] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.188019] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.188045] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.188070] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.188372] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.188398] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.188427] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.188452] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.188478] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.188504] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.188529] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.188555] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.188581] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.188606] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.188632] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.188657] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.188683] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.188708] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.188734] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.188759] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.188785] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.188810] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.188836] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.188861] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.188886] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.188912] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.188937] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.188965] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.189004] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.189030] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.189055] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.189105] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.189151] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.189191] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.189225] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.189251] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.189276] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.189302] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.189328] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.189371] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.189425] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.189451] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.189476] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.189510] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.189536] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.189583] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.189616] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.189642] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.189667] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.189695] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.189721] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.189747] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.189794] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.189840] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.189880] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.189914] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.189940] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.190011] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.190061] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.190101] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.190128] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.190154] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.190180] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.190205] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.190511] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.190537] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.190563] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.190588] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.190614] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.190639] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.190665] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.190690] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.190716] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.190741] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.190767] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.190793] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.190818] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.190844] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.190869] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.190894] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.190926] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.190952] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.190997] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.191023] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.191049] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.191074] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.191100] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.191125] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.191151] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.191176] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.191202] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.191249] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.191295] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.191337] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.191372] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.191398] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.191423] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.191449] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.191475] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.191514] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.191568] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.191593] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.191618] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.191653] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.191679] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.191729] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.191763] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.191788] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.191814] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.191839] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.191864] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.191890] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.191937] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.192000] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.192040] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.192078] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.192104] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.192143] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.192189] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.192228] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.192256] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.192281] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.192307] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.192332] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.192639] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.192665] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.192690] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.192716] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.192741] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.192768] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.192793] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.192819] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.192844] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.192873] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.192900] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.192925] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.192951] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.192995] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.193022] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.193047] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.193073] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.193098] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.193124] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.193149] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.193175] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.193200] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.193225] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.193251] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.193277] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.193302] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.193329] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.193382] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.193429] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.193468] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.193503] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.193529] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.193554] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.193580] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.193605] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.193644] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.193701] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.193727] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.193752] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.193787] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.193813] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.193860] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.193893] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.193918] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.193944] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.193995] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.194022] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.194048] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.194095] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.194131] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.194157] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.194183] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.194230] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.194263] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.194288] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.194314] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.194361] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.194407] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.194453] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.194488] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.194514] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.194561] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.194593] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.194619] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.194645] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.194671] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.194696] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.194722] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.194769] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.194818] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.194858] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.194893] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.194918] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.194943] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.194986] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.195012] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.195060] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.195106] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.195149] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.195184] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.195210] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.195235] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.195260] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.195286] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.195333] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.195387] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.195419] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.195445] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.195470] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.195499] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.195524] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.195550] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.195598] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.195643] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.195683] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.195718] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.195743] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.195783] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.195840] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.195865] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.195890] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.195925] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.195950] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.196016] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.196049] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.196075] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.196100] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.196147] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.196184] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.196210] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.196235] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.196261] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.196286] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.196312] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.196359] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.196408] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.196447] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.196482] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.196508] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.196559] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.196593] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.196619] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.196644] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.196670] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.196695] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.196721] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.196769] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.196824] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.196878] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.196925] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.196964] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.197007] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.197033] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.197059] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.197084] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.197124] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.197171] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.197214] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.197241] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.197266] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.197292] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.197317] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.197357] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.197403] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.197442] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.197469] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.197494] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.197520] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.197545] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.197574] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.197600] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.197626] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.197666] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.197720] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.197746] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.197771] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.197806] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.197831] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.197871] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.197929] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.197958] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.198011] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.198046] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.198072] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.198120] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.198153] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.198179] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.198204] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.198318] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.198344] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.198370] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.198395] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.198420] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.198446] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.198471] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.198585] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.198612] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.198637] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.198663] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.198688] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.198714] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.198739] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.198787] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.198833] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.198872] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.198910] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.198936] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.198998] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.199037] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.199072] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.199098] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.199137] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.199184] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.199209] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.199248] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.199273] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.199321] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.199354] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.199380] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.199405] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.199452] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.199485] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.199511] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.199536] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.199586] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.199619] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.199645] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.199670] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.199717] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.199750] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.199776] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.199802] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.199827] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.199853] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.199879] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.199926] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.199994] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.200034] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.200069] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.200094] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.200133] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.200173] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.200208] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.200233] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.200272] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.200322] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.200348] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.200382] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.200408] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.200455] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.200487] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.200514] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.200539] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.200585] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.200622] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.200648] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.200673] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.200720] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.200753] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.200778] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.200803] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.200850] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.200883] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.200909] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.200934] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.200959] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.201005] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.201034] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.201082] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.201129] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.201168] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.201203] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.201228] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.201267] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.201307] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.201345] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.201371] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.201410] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.201457] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.201483] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.201517] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.201543] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.201594] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.201627] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.201653] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.201681] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.201729] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.201762] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.201788] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.201813] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.201860] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.201893] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.201919] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.201944] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.202018] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.202055] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.202082] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.202107] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.202132] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.202158] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.202184] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.202231] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.202277] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.202317] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.202351] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.202377] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.202420] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.202459] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.202494] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.202520] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.202559] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.202606] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.202632] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.202666] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.202692] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.202743] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.202776] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.202802] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.202828] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.202875] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.202908] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.202933] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.202959] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.203024] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.203057] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.203086] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.203112] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.203159] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.203192] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.203218] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.203243] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.203269] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.203295] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.203320] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.203368] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.203414] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.203457] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.203492] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.203518] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.203557] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.203596] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.203631] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.203657] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.203696] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.203745] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.203771] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.203806] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.203832] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.203879] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.203911] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.203937] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.203963] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.204024] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.204056] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.204082] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.204108] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.204159] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.204191] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.204217] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.204243] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.204290] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.204323] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.204348] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.204374] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.204399] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.204425] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.204451] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.204501] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.204547] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.204587] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.204622] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.204647] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.204686] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.204726] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.204760] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.204786] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.204829] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.204876] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.204901] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.204936] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.204985] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.205035] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.205068] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.205094] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.205123] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.205173] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.205206] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.205232] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.205258] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.205305] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.205337] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.205363] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.205389] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.205436] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.205468] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.205494] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.205523] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.205548] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.205574] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.205600] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.205648] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.205693] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.205733] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.205768] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.205793] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.205832] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.205875] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.205910] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.205936] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.206001] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.206049] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.206074] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.206109] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.206135] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.206182] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.206219] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.206245] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.206271] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.206318] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.206350] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.206376] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.206401] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.206448] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.206481] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.206507] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.206532] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.206582] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.206615] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.206641] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.206667] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.206692] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.206717] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.206743] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.206790] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.206837] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.206876] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.206914] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.206940] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.206997] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.207037] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.207072] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.207098] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.207137] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.207184] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.207210] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.207247] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.207274] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.207321] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.207354] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.207380] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.207405] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.207452] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.207485] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.207511] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.207537] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.207587] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.207620] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.207646] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.207671] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.207719] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.207751] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.207777] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.207803] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.207828] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.207854] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.207880] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.207905] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.207931] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.207957] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.208027] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.208073] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.208127] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.208153] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.208178] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.208213] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.208238] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.208277] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.208335] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.208361] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.208386] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.208421] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.208446] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.208494] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.208527] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.208553] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.208578] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.208607] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.208633] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.208659] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.208709] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.208756] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.208809] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.208835] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.208860] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.208894] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.208920] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.208959] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.209035] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.209061] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.209087] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.209121] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.209147] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.209194] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.209227] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.209253] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.209278] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.209304] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.209329] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.209355] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.209406] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.209452] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.209506] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.209531] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.209557] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.209591] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.209617] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.209656] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.209714] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.209740] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.209765] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.209800] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.209825] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.209873] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.209906] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.209932] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.209957] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.210009] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.210035] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.210061] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.210112] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.210159] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.210213] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.210238] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.210264] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.210298] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.210324] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.210363] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.210421] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.210446] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.210472] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.210506] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.210532] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.210579] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.210612] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.210638] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.210664] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.210689] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.210714] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.210740] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.210765] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.210791] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.210820] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.210868] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.210922] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.210986] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.211026] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.211061] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.211087] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.211137] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.211171] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.211196] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.211222] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.211261] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.211314] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.211340] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.211366] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.211400] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.211426] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.211476] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.211509] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.211535] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.211560] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.211585] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.211611] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.211637] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.211684] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.211730] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.211769] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.211807] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.211833] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.211873] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.211927] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.211952] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.211996] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.212031] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.212057] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.212104] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.212141] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.212171] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.212196] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.212222] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.212247] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.212273] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.212321] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.212367] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.212406] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.212441] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.212466] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.212492] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.212521] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.212547] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.212572] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.212597] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.212623] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.212670] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.212716] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.212756] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.212791] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.212817] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.212859] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.212913] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.212939] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.212964] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.213012] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.213038] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.213085] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.213118] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.213144] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.213169] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.213220] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.213253] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.213279] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.213305] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.213330] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.213356] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.213382] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.213421] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.213475] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.213500] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.213525] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.213560] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.213589] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.213637] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.213669] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.213695] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.213721] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.213768] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.213814] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.213853] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.213891] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.213917] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.213957] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.214023] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.214058] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.214084] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.214123] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.214177] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.214202] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.214228] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.214266] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.214292] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.214339] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.214372] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.214398] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.214423] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.214470] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.214503] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.214529] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.214554] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.214605] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.214638] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.214664] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.214689] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.214715] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.214741] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.214766] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.214813] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.214860] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.214899] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.214937] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.214988] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.215029] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.215070] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.215104] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.215130] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.215179] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.215212] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.215238] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.215263] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.215307] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.215363] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.215389] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.215415] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.215450] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.215477] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.215526] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.215560] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.215586] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.215611] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.215637] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.215666] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.215695] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.215743] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.215791] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.215850] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.215877] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.215902] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.215942] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.216003] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.216039] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.216064] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.216107] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.216148] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.216182] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.216208] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.216255] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.216288] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.216314] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.216339] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.216390] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.216423] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.216448] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.216474] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.216521] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.216554] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.216580] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.216605] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.216652] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.216687] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.216713] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.216739] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.216778] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.216825] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.216851] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.216886] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.216911] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.216951] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.217019] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.217048] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.217083] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.217109] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.217148] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.217188] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.217222] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.217248] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.217295] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.217328] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.217353] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.217379] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.217430] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.217463] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.217489] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.217514] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.217561] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.217593] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.217619] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.217645] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.217692] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.217727] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.217754] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.217779] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.217826] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.217858] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.217884] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.217909] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.217957] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.218016] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.218042] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.218067] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.218110] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.218158] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.218184] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.218218] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.218243] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.218269] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.218294] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.218320] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.218346] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.218372] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.218398] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.218423] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.218449] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.218474] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.218499] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.220216] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.220272] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.220326] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.220352] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.220381] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.220407] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.220433] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.220481] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.220521] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.220547] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.220572] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.220621] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.220660] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.220687] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.220712] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.220767] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.220807] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.220833] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.220858] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.220906] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.220946] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.220990] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.221016] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.221041] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.221069] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.221094] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.221145] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.221200] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.221239] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.221265] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.221290] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.221337] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.221377] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.221406] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.221431] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.221487] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.221537] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.221562] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.221588] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.221613] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.221668] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.221722] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.221747] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.221773] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.221798] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.221824] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.221849] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.221875] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.221922] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.222002] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.222042] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.222069] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.222097] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.222145] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.222184] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.222210] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.222236] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.222291] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.222341] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.222366] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.222391] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.222420] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.222476] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.222525] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.222551] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.222576] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.222602] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.222627] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.222653] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.222678] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.222703] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.222727] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.222751] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.222775] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.222851] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.222899] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.222952] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.222997] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.223023] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.223057] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.223083] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.223127] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.223166] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.223201] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.223226] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.223266] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.223305] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.223340] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.223365] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.223405] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.223448] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.223483] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.223509] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.223549] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.223588] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.223622] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.223648] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.223673] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.223699] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.223724] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.223775] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.223821] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.223860] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.223895] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.223920] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.223960] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.224013] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.224052] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.224078] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.224128] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.224161] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.224187] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.224213] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.224259] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.224292] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.224318] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.224344] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.224369] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.224395] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.224420] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.224471] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.224517] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.224556] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.224590] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.224616] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.224655] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.224695] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.224729] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.224755] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.224805] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.224838] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.224864] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.224889] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.224936] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.224991] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.225017] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.225042] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.225068] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.225096] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.225121] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.225146] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.225171] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.225195] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.225223] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
[    0.227026] ftrace: allocating 29786 entries in 117 pages
[    0.229579] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.239586] CPU0: Intel(R) Core(TM)2 Duo CPU     T8300  @ 2.40GHz stepping 06
[    0.239972] Performance Events: PEBS fmt0+, Core2 events, Intel PMU driver.
[    0.239972] ... version:                2
[    0.239972] ... bit width:              40
[    0.239972] ... generic registers:      2
[    0.239972] ... value mask:             000000ffffffffff
[    0.239972] ... max period:             000000007fffffff
[    0.239972] ... fixed-purpose events:   3
[    0.239972] ... event mask:             0000000700000003
[    0.240328] NMI watchdog enabled, takes one hw-pmu counter.
[    0.256310] lockdep: fixing up alternatives.
[    0.295417] Booting Node   0, Processors  #1 Ok.
[    0.295422] smpboot cpu 1: start_ip = 9a000
[    0.367086] NMI watchdog enabled, takes one hw-pmu counter.
[    0.367224] Brought up 2 CPUs
[    0.367227] Total of 2 processors activated (9572.14 BogoMIPS).
[    0.369496] devtmpfs: initialized
[    0.371093] kworker/u:0 used greatest stack depth: 5000 bytes left
[    0.375084] Time: 21:15:41  Date: 07/27/11
[    0.375647] NET: Registered protocol family 16
[    0.383351] ACPI: bus type pci registered
[    0.385066] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf8000000-0xfbffffff] (base 0xf8000000)
[    0.385070] PCI: MMCONFIG at [mem 0xf8000000-0xfbffffff] reserved in E820
[    0.412175] PCI: Using configuration type 1 for base access
[    0.412181] dmi type 0xB1 record - unknown flag
[    0.556250] bio: create slab <bio-0> at 0
[    0.566698] ACPI: EC: Look up EC in DSDT
[    0.652507] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    0.706676] ACPI: SSDT 00000000bfe82880 00043 (v01  LMPWR  DELLLOM 00001001 INTL 20050624)
[    0.708884] ACPI: Dynamic OEM Table Load:
[    0.708887] ACPI: SSDT           (null) 00043 (v01  LMPWR  DELLLOM 00001001 INTL 20050624)
[    0.721324] ACPI: SSDT 00000000bfe72cb4 002C8 (v01  PmRef  Cpu0Ist 00003000 INTL 20050624)
[    0.724717] ACPI: Dynamic OEM Table Load:
[    0.724721] ACPI: SSDT           (null) 002C8 (v01  PmRef  Cpu0Ist 00003000 INTL 20050624)
[    0.729826] ACPI: SSDT 00000000bfe7264a 005E5 (v01  PmRef  Cpu0Cst 00003001 INTL 20050624)
[    0.732020] ACPI: Dynamic OEM Table Load:
[    0.732023] ACPI: SSDT           (null) 005E5 (v01  PmRef  Cpu0Cst 00003001 INTL 20050624)
[    0.745423] ACPI: SSDT 00000000bfe72f7c 000C4 (v01  PmRef  Cpu1Ist 00003000 INTL 20050624)
[    0.748490] ACPI: Dynamic OEM Table Load:
[    0.748493] ACPI: SSDT           (null) 000C4 (v01  PmRef  Cpu1Ist 00003000 INTL 20050624)
[    0.753808] ACPI: SSDT 00000000bfe72c2f 00085 (v01  PmRef  Cpu1Cst 00003000 INTL 20050624)
[    0.756354] ACPI: Dynamic OEM Table Load:
[    0.756358] ACPI: SSDT           (null) 00085 (v01  PmRef  Cpu1Cst 00003000 INTL 20050624)
[    0.763595] ACPI: Interpreter enabled
[    0.763599] ACPI: (supports S0 S3 S4 S5)
[    0.764717] ACPI: Using IOAPIC for interrupt routing
[    1.354603] ACPI: No dock devices found.
[    1.354609] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    1.617802] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    2.118995] pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7]
[    2.118999] pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff]
[    2.119002] pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff]
[    2.119004] pci_root PNP0A03:00: host bridge window [mem 0x000d0000-0x000dffff]
[    2.119007] pci_root PNP0A03:00: host bridge window [mem 0xc0000000-0xf7ffffff]
[    2.119009] pci_root PNP0A03:00: host bridge window [mem 0xfc000000-0xfebfffff]
[    2.119012] pci_root PNP0A03:00: host bridge window [mem 0xfec10000-0xfecfffff]
[    2.119014] pci_root PNP0A03:00: host bridge window [mem 0xfed1c000-0xfed1ffff]
[    2.119017] pci_root PNP0A03:00: host bridge window [mem 0xfed90000-0xfed9ffff]
[    2.119019] pci_root PNP0A03:00: host bridge window [mem 0xfeda7000-0xfedfffff]
[    2.119022] pci_root PNP0A03:00: host bridge window [mem 0xfee10000-0xff9fffff]
[    2.119024] pci_root PNP0A03:00: host bridge window [mem 0xffc00000-0xffdfffff]
[    2.119027] pci_root PNP0A03:00: host bridge window [mem 0x140000000-0x337ffffff]
[    2.119209] pci 0000:00:00.0: [8086:2a00] type 0 class 0x000600
[    2.119356] pci 0000:00:01.0: [8086:2a01] type 1 class 0x000604
[    2.119449] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    2.119455] pci 0000:00:01.0: PME# disabled
[    2.119569] pci 0000:00:1a.0: [8086:2834] type 0 class 0x000c03
[    2.119661] pci 0000:00:1a.0: reg 20: [io  0x6f20-0x6f3f]
[    2.119768] pci 0000:00:1a.1: [8086:2835] type 0 class 0x000c03
[    2.119859] pci 0000:00:1a.1: reg 20: [io  0x6f00-0x6f1f]
[    2.119964] pci 0000:00:1a.7: [8086:283a] type 0 class 0x000c03
[    2.120003] pci 0000:00:1a.7: reg 10: [mem 0xfed1c400-0xfed1c7ff]
[    2.120147] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    2.120154] pci 0000:00:1a.7: PME# disabled
[    2.120214] pci 0000:00:1b.0: [8086:284b] type 0 class 0x000403
[    2.120249] pci 0000:00:1b.0: reg 10: [mem 0xf7ffc000-0xf7ffffff 64bit]
[    2.120391] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    2.120398] pci 0000:00:1b.0: PME# disabled
[    2.120456] pci 0000:00:1c.0: [8086:283f] type 1 class 0x000604
[    2.120603] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    2.120610] pci 0000:00:1c.0: PME# disabled
[    2.120673] pci 0000:00:1c.1: [8086:2841] type 1 class 0x000604
[    2.120832] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    2.120839] pci 0000:00:1c.1: PME# disabled
[    2.120906] pci 0000:00:1c.3: [8086:2845] type 1 class 0x000604
[    2.121053] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    2.121059] pci 0000:00:1c.3: PME# disabled
[    2.121122] pci 0000:00:1c.4: [8086:2847] type 1 class 0x000604
[    2.121269] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    2.121276] pci 0000:00:1c.4: PME# disabled
[    2.121339] pci 0000:00:1c.5: [8086:2849] type 1 class 0x000604
[    2.121486] pci 0000:00:1c.5: PME# supported from D0 D3hot D3cold
[    2.121492] pci 0000:00:1c.5: PME# disabled
[    2.121557] pci 0000:00:1d.0: [8086:2830] type 0 class 0x000c03
[    2.121648] pci 0000:00:1d.0: reg 20: [io  0x6f80-0x6f9f]
[    2.122091] pci 0000:00:1d.1: [8086:2831] type 0 class 0x000c03
[    2.122182] pci 0000:00:1d.1: reg 20: [io  0x6f60-0x6f7f]
[    2.122263] pci 0000:00:1d.2: [8086:2832] type 0 class 0x000c03
[    2.122354] pci 0000:00:1d.2: reg 20: [io  0x6f40-0x6f5f]
[    2.122456] pci 0000:00:1d.7: [8086:2836] type 0 class 0x000c03
[    2.122494] pci 0000:00:1d.7: reg 10: [mem 0xfed1c000-0xfed1c3ff]
[    2.122639] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    2.122646] pci 0000:00:1d.7: PME# disabled
[    2.122706] pci 0000:00:1e.0: [8086:2448] type 1 class 0x000604
[    2.122859] pci 0000:00:1f.0: [8086:2811] type 0 class 0x000601
[    2.123026] pci 0000:00:1f.0: quirk: [io  0x1000-0x107f] claimed by ICH6 ACPI/GPIO/TCO
[    2.123035] pci 0000:00:1f.0: quirk: [io  0x1080-0x10bf] claimed by ICH6 GPIO
[    2.123041] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0900 (mask 007f)
[    2.123049] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 3 PIO at 0c80 (mask 003f)
[    2.123127] pci 0000:00:1f.1: [8086:2850] type 0 class 0x000101
[    2.123153] pci 0000:00:1f.1: reg 10: [io  0x01f0-0x01f7]
[    2.123172] pci 0000:00:1f.1: reg 14: [io  0x03f4-0x03f7]
[    2.123191] pci 0000:00:1f.1: reg 18: [io  0x0170-0x0177]
[    2.123209] pci 0000:00:1f.1: reg 1c: [io  0x0374-0x0377]
[    2.123228] pci 0000:00:1f.1: reg 20: [io  0x6fa0-0x6faf]
[    2.123325] pci 0000:00:1f.2: [8086:2829] type 0 class 0x000106
[    2.123367] pci 0000:00:1f.2: reg 10: [io  0x6eb0-0x6eb7]
[    2.123386] pci 0000:00:1f.2: reg 14: [io  0x6eb8-0x6ebb]
[    2.123405] pci 0000:00:1f.2: reg 18: [io  0x6ec0-0x6ec7]
[    2.123423] pci 0000:00:1f.2: reg 1c: [io  0x6ec8-0x6ecb]
[    2.123442] pci 0000:00:1f.2: reg 20: [io  0x6ee0-0x6eff]
[    2.123460] pci 0000:00:1f.2: reg 24: [mem 0xfed1c800-0xfed1cfff]
[    2.123538] pci 0000:00:1f.2: PME# supported from D3hot
[    2.123544] pci 0000:00:1f.2: PME# disabled
[    2.123597] pci 0000:00:1f.3: [8086:283e] type 0 class 0x000c05
[    2.123623] pci 0000:00:1f.3: reg 10: [mem 0xf7ffbf00-0xf7ffbfff]
[    2.123923] pci 0000:00:1f.3: reg 20: [io  0x10c0-0x10df]
[    2.124434] pci 0000:01:00.0: [10de:01b3] type 1 class 0x000604
[    2.124456] pci 0000:01:00.0: reg 10: [mem 0xf7efc000-0xf7efffff]
[    2.124546] pci 0000:01:00.0: PME# supported from D0 D3hot D3cold
[    2.124553] pci 0000:01:00.0: PME# disabled
[    2.124574] pci 0000:01:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    2.124658] pci 0000:00:01.0: PCI bridge to [bus 01-04]
[    2.124663] pci 0000:00:01.0:   bridge window [io  0xd000-0xefff]
[    2.124669] pci 0000:00:01.0:   bridge window [mem 0xf0f00000-0xf7efffff]
[    2.124678] pci 0000:00:01.0:   bridge window [mem 0xc0000000-0xdfffffff 64bit pref]
[    2.124794] pci 0000:02:00.0: [10de:01b3] type 1 class 0x000604
[    2.124888] pci 0000:02:00.0: PME# supported from D0 D3hot D3cold
[    2.124894] pci 0000:02:00.0: PME# disabled
[    2.124911] pci 0000:02:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    2.124951] pci 0000:02:01.0: [10de:01b3] type 1 class 0x000604
[    2.125045] pci 0000:02:01.0: PME# supported from D0 D3hot D3cold
[    2.125050] pci 0000:02:01.0: PME# disabled
[    2.125067] pci 0000:02:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    2.125135] pci 0000:01:00.0: PCI bridge to [bus 02-04]
[    2.125145] pci 0000:01:00.0:   bridge window [io  0xd000-0xefff]
[    2.125151] pci 0000:01:00.0:   bridge window [mem 0xf0f00000-0xf7dfffff]
[    2.125160] pci 0000:01:00.0:   bridge window [mem 0xc0000000-0xdfffffff 64bit pref]
[    2.125279] pci 0000:03:00.0: [10de:060c] type 0 class 0x000300
[    2.125305] pci 0000:03:00.0: reg 10: [mem 0xf6000000-0xf6ffffff]
[    2.125334] pci 0000:03:00.0: reg 14: [mem 0xc0000000-0xcfffffff 64bit pref]
[    2.125362] pci 0000:03:00.0: reg 1c: [mem 0xf4000000-0xf5ffffff 64bit]
[    2.125381] pci 0000:03:00.0: reg 24: [io  0xef00-0xef7f]
[    2.125400] pci 0000:03:00.0: reg 30: [mem 0xf7d00000-0xf7d1ffff pref]
[    2.126754] pci 0000:02:00.0: PCI bridge to [bus 03-03]
[    2.126764] pci 0000:02:00.0:   bridge window [io  0xe000-0xefff]
[    2.126770] pci 0000:02:00.0:   bridge window [mem 0xf4000000-0xf7dfffff]
[    2.126780] pci 0000:02:00.0:   bridge window [mem 0xc0000000-0xcfffffff 64bit pref]
[    2.126897] pci 0000:04:00.0: [10de:060c] type 0 class 0x000302
[    2.126920] pci 0000:04:00.0: reg 10: [mem 0xf1000000-0xf1ffffff]
[    2.126945] pci 0000:04:00.0: reg 14: [mem 0xd0000000-0xdfffffff 64bit pref]
[    2.126970] pci 0000:04:00.0: reg 1c: [mem 0xf2000000-0xf3ffffff 64bit]
[    2.126987] pci 0000:04:00.0: reg 24: [io  0xdf00-0xdf7f]
[    2.127003] pci 0000:04:00.0: reg 30: [mem 0xf0f00000-0xf0f1ffff pref]
[    2.128710] pci 0000:02:01.0: PCI bridge to [bus 04-04]
[    2.128720] pci 0000:02:01.0:   bridge window [io  0xd000-0xdfff]
[    2.128727] pci 0000:02:01.0:   bridge window [mem 0xf0f00000-0xf3ffffff]
[    2.128736] pci 0000:02:01.0:   bridge window [mem 0xd0000000-0xdfffffff 64bit pref]
[    2.128876] pci 0000:00:1c.0: PCI bridge to [bus 0b-0b]
[    2.128884] pci 0000:00:1c.0:   bridge window [io  0xf000-0x0000] (disabled)
[    2.128891] pci 0000:00:1c.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    2.128903] pci 0000:00:1c.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    2.129178] pci 0000:0c:00.0: [8086:4229] type 0 class 0x000280
[    2.129306] pci 0000:0c:00.0: reg 10: [mem 0xf0efe000-0xf0efffff 64bit]
[    2.129867] pci 0000:0c:00.0: PME# supported from D0 D3hot D3cold
[    2.129885] pci 0000:0c:00.0: PME# disabled
[    2.130113] pci 0000:00:1c.1: PCI bridge to [bus 0c-0c]
[    2.130121] pci 0000:00:1c.1:   bridge window [io  0xf000-0x0000] (disabled)
[    2.130128] pci 0000:00:1c.1:   bridge window [mem 0xf0e00000-0xf0efffff]
[    2.130140] pci 0000:00:1c.1:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    2.130255] pci 0000:00:1c.3: PCI bridge to [bus 0d-0e]
[    2.130262] pci 0000:00:1c.3:   bridge window [io  0xc000-0xcfff]
[    2.130269] pci 0000:00:1c.3:   bridge window [mem 0xf0c00000-0xf0dfffff]
[    2.130281] pci 0000:00:1c.3:   bridge window [mem 0xe0000000-0xe01fffff 64bit pref]
[    2.130450] pci 0000:0f:00.0: [1971:0000] type 0 class 0x00ff00
[    2.130482] pci 0000:0f:00.0: reg 10: [mem 0xef000000-0xefffffff]
[    2.130725] pci 0000:0f:00.0: PME# supported from D0 D1 D2 D3hot
[    2.130734] pci 0000:0f:00.0: PME# disabled
[    2.130783] pci 0000:0f:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    2.130810] pci 0000:00:1c.4: PCI bridge to [bus 0f-0f]
[    2.130817] pci 0000:00:1c.4:   bridge window [io  0xf000-0x0000] (disabled)
[    2.130824] pci 0000:00:1c.4:   bridge window [mem 0xef000000-0xf0bfffff]
[    2.130836] pci 0000:00:1c.4:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    2.131053] pci 0000:09:00.0: [14e4:1672] type 0 class 0x000200
[    2.131097] pci 0000:09:00.0: reg 10: [mem 0xeeff0000-0xeeffffff 64bit]
[    2.131302] pci 0000:09:00.0: PME# supported from D3hot D3cold
[    2.131311] pci 0000:09:00.0: PME# disabled
[    2.132756] pci 0000:00:1c.5: PCI bridge to [bus 09-09]
[    2.132763] pci 0000:00:1c.5:   bridge window [io  0xf000-0x0000] (disabled)
[    2.132771] pci 0000:00:1c.5:   bridge window [mem 0xeef00000-0xeeffffff]
[    2.132783] pci 0000:00:1c.5:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    2.132894] pci 0000:05:01.0: [1180:0832] type 0 class 0x000c00
[    2.132930] pci 0000:05:01.0: reg 10: [mem 0xeeeff800-0xeeefffff]
[    2.133069] pci 0000:05:01.0: supports D1 D2
[    2.133071] pci 0000:05:01.0: PME# supported from D0 D1 D2 D3hot D3cold
[    2.133112] pci 0000:05:01.0: PME# disabled
[    2.133161] pci 0000:05:01.1: [1180:0822] type 0 class 0x000805
[    2.133195] pci 0000:05:01.1: reg 10: [mem 0xeeeff500-0xeeeff5ff]
[    2.133334] pci 0000:05:01.1: supports D1 D2
[    2.133337] pci 0000:05:01.1: PME# supported from D0 D1 D2 D3hot D3cold
[    2.133345] pci 0000:05:01.1: PME# disabled
[    2.133393] pci 0000:05:01.2: [1180:0592] type 0 class 0x000880
[    2.133429] pci 0000:05:01.2: reg 10: [mem 0xeeeff600-0xeeeff6ff]
[    2.133567] pci 0000:05:01.2: supports D1 D2
[    2.133569] pci 0000:05:01.2: PME# supported from D0 D1 D2 D3hot D3cold
[    2.133577] pci 0000:05:01.2: PME# disabled
[    2.133625] pci 0000:05:01.3: [1180:0852] type 0 class 0x000880
[    2.133659] pci 0000:05:01.3: reg 10: [mem 0xeeeff700-0xeeeff7ff]
[    2.133810] pci 0000:05:01.3: supports D1 D2
[    2.133813] pci 0000:05:01.3: PME# supported from D0 D1 D2 D3hot D3cold
[    2.133821] pci 0000:05:01.3: PME# disabled
[    2.133939] pci 0000:00:1e.0: PCI bridge to [bus 05-05] (subtractive decode)
[    2.133946] pci 0000:00:1e.0:   bridge window [io  0xf000-0x0000] (disabled)
[    2.133953] pci 0000:00:1e.0:   bridge window [mem 0xeee00000-0xeeefffff]
[    2.133965] pci 0000:00:1e.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    2.133976] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    2.133986] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    2.133997] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    2.134007] pci 0000:00:1e.0:   bridge window [mem 0x000d0000-0x000dffff] (subtractive decode)
[    2.134016] pci 0000:00:1e.0:   bridge window [mem 0xc0000000-0xf7ffffff] (subtractive decode)
[    2.134026] pci 0000:00:1e.0:   bridge window [mem 0xfc000000-0xfebfffff] (subtractive decode)
[    2.134036] pci 0000:00:1e.0:   bridge window [mem 0xfec10000-0xfecfffff] (subtractive decode)
[    2.134046] pci 0000:00:1e.0:   bridge window [mem 0xfed1c000-0xfed1ffff] (subtractive decode)
[    2.134056] pci 0000:00:1e.0:   bridge window [mem 0xfed90000-0xfed9ffff] (subtractive decode)
[    2.134065] pci 0000:00:1e.0:   bridge window [mem 0xfeda7000-0xfedfffff] (subtractive decode)
[    2.134075] pci 0000:00:1e.0:   bridge window [mem 0xfee10000-0xff9fffff] (subtractive decode)
[    2.134085] pci 0000:00:1e.0:   bridge window [mem 0xffc00000-0xffdfffff] (subtractive decode)
[    2.134095] pci 0000:00:1e.0:   bridge window [mem 0x140000000-0x337ffffff] (subtractive decode)
[    2.134188] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    2.156735] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIE._PRT]
[    2.162144] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.AGP_._PRT]
[    2.164327] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.AGP_.SLI_.SLI0._PRT]
[    2.166837] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.AGP_.SLI_.SLI1._PRT]
[    2.169664] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
[    2.173398] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP02._PRT]
[    2.176356] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP04._PRT]
[    2.179337] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP05._PRT]
[    2.182975] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP06._PRT]
[    2.185761]  pci0000:00: Requesting ACPI _OSC control (0x1d)
[    2.185781]  pci0000:00: ACPI _OSC request failed (AE_NOT_FOUND), returned control mask: 0x1d
[    2.185783] ACPI _OSC control for PCIe not granted, disabling ASPM
[    2.784725] ACPI: PCI Interrupt Link [LNKA] (IRQs 9 10 11) *7
[    2.787371] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 7) *10
[    2.791594] ACPI: PCI Interrupt Link [LNKC] (IRQs 9 10 11) *4
[    2.795061] ACPI: PCI Interrupt Link [LNKD] (IRQs *5 7 9 10 11)
[    2.797793] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
[    2.800924] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 *10 11 12 14 15)
[    2.806251] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 *9 10 11 12 14 15)
[    2.808473] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    2.812135] vgaarb: device added: PCI:0000:03:00.0,decodes=io+mem,owns=io+mem,locks=none
[    2.812254] vgaarb: loaded
[    2.812256] vgaarb: bridge control possible 0000:03:00.0
[    2.814619] SCSI subsystem initialized
[    2.815942] libata version 3.00 loaded.
[    2.818956] usbcore: registered new interface driver usbfs
[    2.819588] usbcore: registered new interface driver hub
[    2.820969] usbcore: registered new device driver usb
[    2.827872] wmi: Mapper loaded
[    2.829206] Advanced Linux Sound Architecture Driver Version 1.0.24.
[    2.829209] PCI: Using ACPI for IRQ routing
[    2.832581] PCI: pci_cache_line_size set to 64 bytes
[    2.833799] reserve RAM buffer: 000000000009f000 - 000000000009ffff 
[    2.833839] reserve RAM buffer: 00000000bfe72000 - 00000000bfffffff 
[    2.836906] Bluetooth: Core ver 2.16
[    2.837582] NET: Registered protocol family 31
[    2.837582] Bluetooth: HCI device and connection manager initialized
[    2.837582] Bluetooth: HCI socket layer initialized
[    2.839075] cfg80211: Calling CRDA to update world regulatory domain
[    2.839762] NetLabel: Initializing
[    2.839765] NetLabel:  domain hash size = 128
[    2.839766] NetLabel:  protocols = UNLABELED CIPSOv4
[    2.839932] NetLabel:  unlabeled traffic allowed by default
[    2.841036] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    2.841036] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    2.841036] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
[    2.846025] Switching to clocksource hpet
[    2.846104] Switched to NOHz mode on CPU #0
[    2.846104] Switched to NOHz mode on CPU #1
[    2.978526] pnp: PnP ACPI init
[    2.978602] ACPI: bus type pnp registered
[    3.235219] pnp 00:00: [bus 00-ff]
[    3.235229] pnp 00:00: [io  0x0000-0x0cf7 window]
[    3.235238] pnp 00:00: [io  0x0cf8-0x0cff]
[    3.235246] pnp 00:00: [io  0x0d00-0xffff window]
[    3.235254] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    3.235262] pnp 00:00: [mem 0x000d0000-0x000dffff window]
[    3.235270] pnp 00:00: [mem 0xc0000000-0xf7ffffff window]
[    3.235278] pnp 00:00: [mem 0xfc000000-0xfebfffff window]
[    3.235286] pnp 00:00: [mem 0xfec10000-0xfecfffff window]
[    3.235294] pnp 00:00: [mem 0xfed1c000-0xfed1ffff window]
[    3.235302] pnp 00:00: [mem 0xfed90000-0xfed9ffff window]
[    3.235310] pnp 00:00: [mem 0xfeda7000-0xfedfffff window]
[    3.235318] pnp 00:00: [mem 0xfee10000-0xff9fffff window]
[    3.235327] pnp 00:00: [mem 0xffc00000-0xffdfffff window]
[    3.235335] pnp 00:00: [mem 0x140000000-0x337ffffff window]
[    3.236050] pnp 00:00: Plug and Play ACPI device, IDs PNP0a03 (active)
[    3.236442] pnp 00:01: [irq 12]
[    3.236986] pnp 00:01: Plug and Play ACPI device, IDs PNP0f13 (active)
[    3.237668] pnp 00:02: [io  0x0060]
[    3.237677] pnp 00:02: [io  0x0064]
[    3.237684] pnp 00:02: [io  0x0062]
[    3.237692] pnp 00:02: [io  0x0066]
[    3.237710] pnp 00:02: [irq 1]
[    3.238641] pnp 00:02: Plug and Play ACPI device, IDs PNP0303 (active)
[    3.238955] pnp 00:03: [io  0x0070-0x0071]
[    3.238972] pnp 00:03: [irq 8]
[    3.238981] pnp 00:03: [io  0x0072-0x0077]
[    3.239509] pnp 00:03: Plug and Play ACPI device, IDs PNP0b00 (active)
[    3.239869] pnp 00:04: [io  0x0061]
[    3.239877] pnp 00:04: [io  0x0063]
[    3.239885] pnp 00:04: [io  0x0065]
[    3.239893] pnp 00:04: [io  0x0067]
[    3.240525] pnp 00:04: Plug and Play ACPI device, IDs PNP0800 (active)
[    3.240842] pnp 00:05: [io  0x0c80-0x0cff]
[    3.243127] system 00:05: [io  0x0c80-0x0cff] could not be reserved
[    3.243135] system 00:05: Plug and Play ACPI device, IDs PNP0c01 (active)
[    3.243638] pnp 00:06: [dma 4]
[    3.243646] pnp 00:06: [io  0x0000-0x000f]
[    3.243654] pnp 00:06: [io  0x0080-0x0085]
[    3.243662] pnp 00:06: [io  0x0087-0x008f]
[    3.243670] pnp 00:06: [io  0x00c0-0x00df]
[    3.243678] pnp 00:06: [io  0x0010-0x001f]
[    3.243685] pnp 00:06: [io  0x0090-0x0091]
[    3.243693] pnp 00:06: [io  0x0093-0x009f]
[    3.244415] pnp 00:06: Plug and Play ACPI device, IDs PNP0200 (active)
[    3.244730] pnp 00:07: [io  0x00f0-0x00ff]
[    3.244748] pnp 00:07: [irq 13]
[    3.245512] pnp 00:07: Plug and Play ACPI device, IDs PNP0c04 (active)
[    3.246875] pnp 00:08: [mem 0xfed00000-0xfed003ff]
[    3.247960] system 00:08: [mem 0xfed00000-0xfed003ff] has been reserved
[    3.247966] system 00:08: Plug and Play ACPI device, IDs PNP0103 PNP0c01 (active)
[    3.251870] pnp 00:09: [io  0x0900-0x097f]
[    3.251879] pnp 00:09: [io  0x0092]
[    3.251887] pnp 00:09: [io  0x00b2-0x00b3]
[    3.251895] pnp 00:09: [io  0x0020-0x0021]
[    3.251902] pnp 00:09: [io  0x00a0-0x00a1]
[    3.251911] pnp 00:09: [irq 0 disabled]
[    3.251919] pnp 00:09: [io  0x04d0-0x04d1]
[    3.251927] pnp 00:09: [io  0x1000-0x1005]
[    3.251935] pnp 00:09: [io  0x1008-0x100f]
[    3.252358] pnp 00:09: disabling [io  0x1000-0x1005] because it overlaps 0000:00:1f.0 BAR 13 [io  0x1000-0x107f]
[    3.252362] pnp 00:09: disabling [io  0x1008-0x100f] because it overlaps 0000:00:1f.0 BAR 13 [io  0x1000-0x107f]
[    3.253939] system 00:09: [io  0x0900-0x097f] has been reserved
[    3.253958] system 00:09: [io  0x04d0-0x04d1] has been reserved
[    3.253964] system 00:09: Plug and Play ACPI device, IDs PNP0c01 (active)
[    3.254299] pnp 00:0a: [io  0xf400-0xf4fe]
[    3.254307] pnp 00:0a: [io  0x0086]
[    3.254315] pnp 00:0a: [io  0x1006-0x1007]
[    3.254323] pnp 00:0a: [io  0x100a-0x1059]
[    3.254331] pnp 00:0a: [io  0x1080-0x10bf]
[    3.254339] pnp 00:0a: [io  0x10c0-0x10df]
[    3.254346] pnp 00:0a: [io  0x1010-0x102f]
[    3.254354] pnp 00:0a: [io  0x0809]
[    3.254623] pnp 00:0a: disabling [io  0x1006-0x1007] because it overlaps 0000:00:1f.0 BAR 13 [io  0x1000-0x107f]
[    3.254627] pnp 00:0a: disabling [io  0x100a-0x1059] because it overlaps 0000:00:1f.0 BAR 13 [io  0x1000-0x107f]
[    3.254630] pnp 00:0a: disabling [io  0x1010-0x102f] because it overlaps 0000:00:1f.0 BAR 13 [io  0x1000-0x107f]
[    3.256124] system 00:0a: [io  0xf400-0xf4fe] has been reserved
[    3.256147] system 00:0a: [io  0x1080-0x10bf] has been reserved
[    3.256165] system 00:0a: [io  0x10c0-0x10df] has been reserved
[    3.256184] system 00:0a: [io  0x0809] has been reserved
[    3.256190] system 00:0a: Plug and Play ACPI device, IDs PNP0c01 (active)
[    3.608549] pnp 00:0b: [mem 0x00000000-0x0009efff]
[    3.608559] pnp 00:0b: [mem 0x0009f000-0x0009ffff]
[    3.608567] pnp 00:0b: [mem 0x000c0000-0x000cffff]
[    3.608575] pnp 00:0b: [mem 0x000e0000-0x000fffff]
[    3.608583] pnp 00:0b: [mem 0x00100000-0xbfe71fff]
[    3.608591] pnp 00:0b: [mem 0xbfe72000-0xbfefffff]
[    3.608599] pnp 00:0b: [mem 0xbff00000-0xbfffffff]
[    3.608607] pnp 00:0b: [mem 0xffe00000-0xffffffff]
[    3.608615] pnp 00:0b: [mem 0xffa00000-0xffbfffff]
[    3.608623] pnp 00:0b: [mem 0xfec00000-0xfec0ffff]
[    3.608631] pnp 00:0b: [mem 0xfee00000-0xfee0ffff]
[    3.608639] pnp 00:0b: [mem 0xfed20000-0xfed8ffff]
[    3.608646] pnp 00:0b: [mem 0xfeda0000-0xfeda3fff]
[    3.608654] pnp 00:0b: [mem 0xfeda4000-0xfeda4fff]
[    3.608662] pnp 00:0b: [mem 0xfeda5000-0xfeda5fff]
[    3.608670] pnp 00:0b: [mem 0xfeda6000-0xfeda6fff]
[    3.608678] pnp 00:0b: [mem 0xfed1c800-0xfed1cfff]
[    3.608686] pnp 00:0b: [mem 0xfed18000-0xfed1bfff]
[    3.608695] pnp 00:0b: [mem 0xf8000000-0xfbffffff]
[    3.610206] system 00:0b: [mem 0x00000000-0x0009efff] could not be reserved
[    3.610429] system 00:0b: [mem 0x0009f000-0x0009ffff] could not be reserved
[    3.610465] system 00:0b: [mem 0x000c0000-0x000cffff] could not be reserved
[    3.610499] system 00:0b: [mem 0x000e0000-0x000fffff] could not be reserved
[    3.610534] system 00:0b: [mem 0x00100000-0xbfe71fff] could not be reserved
[    3.610553] system 00:0b: [mem 0xbfe72000-0xbfefffff] has been reserved
[    3.610572] system 00:0b: [mem 0xbff00000-0xbfffffff] has been reserved
[    3.610590] system 00:0b: [mem 0xffe00000-0xffffffff] has been reserved
[    3.610609] system 00:0b: [mem 0xffa00000-0xffbfffff] has been reserved
[    3.610642] system 00:0b: [mem 0xfec00000-0xfec0ffff] could not be reserved
[    3.610661] system 00:0b: [mem 0xfee00000-0xfee0ffff] has been reserved
[    3.610679] system 00:0b: [mem 0xfed20000-0xfed8ffff] has been reserved
[    3.610699] system 00:0b: [mem 0xfeda0000-0xfeda3fff] has been reserved
[    3.610718] system 00:0b: [mem 0xfeda4000-0xfeda4fff] has been reserved
[    3.610736] system 00:0b: [mem 0xfeda5000-0xfeda5fff] has been reserved
[    3.610754] system 00:0b: [mem 0xfeda6000-0xfeda6fff] has been reserved
[    3.610773] system 00:0b: [mem 0xfed1c800-0xfed1cfff] has been reserved
[    3.610791] system 00:0b: [mem 0xfed18000-0xfed1bfff] has been reserved
[    3.610809] system 00:0b: [mem 0xf8000000-0xfbffffff] has been reserved
[    3.610816] system 00:0b: Plug and Play ACPI device, IDs PNP0c01 (active)
[    3.612583] pnp: PnP ACPI: found 12 devices
[    3.612586] ACPI: ACPI bus type pnp unregistered
[    3.670854] PCI: max bus depth: 3 pci_try_num: 4
[    3.672882] pci 0000:00:1c.5: BAR 15: assigned [mem 0xe0200000-0xe03fffff 64bit pref]
[    3.672895] pci 0000:00:1c.5: BAR 13: assigned [io  0x2000-0x2fff]
[    3.672908] pci 0000:00:1c.4: BAR 15: assigned [mem 0xe0400000-0xe05fffff 64bit pref]
[    3.672919] pci 0000:00:1c.4: BAR 13: assigned [io  0x3000-0x3fff]
[    3.672932] pci 0000:00:1c.1: BAR 15: assigned [mem 0xe0600000-0xe07fffff 64bit pref]
[    3.672943] pci 0000:00:1c.1: BAR 13: assigned [io  0x4000-0x4fff]
[    3.672955] pci 0000:00:1c.0: BAR 14: assigned [mem 0xe0800000-0xe09fffff]
[    3.672968] pci 0000:00:1c.0: BAR 15: assigned [mem 0xe0a00000-0xe0bfffff 64bit pref]
[    3.672979] pci 0000:00:1c.0: BAR 13: assigned [io  0x5000-0x5fff]
[    3.673066] pci 0000:02:00.0: PCI bridge to [bus 03-03]
[    3.673071] pci 0000:02:00.0:   bridge window [io  0xe000-0xefff]
[    3.673079] pci 0000:02:00.0:   bridge window [mem 0xf4000000-0xf7dfffff]
[    3.673085] pci 0000:02:00.0:   bridge window [mem 0xc0000000-0xcfffffff 64bit pref]
[    3.673095] pci 0000:02:01.0: PCI bridge to [bus 04-04]
[    3.673100] pci 0000:02:01.0:   bridge window [io  0xd000-0xdfff]
[    3.673107] pci 0000:02:01.0:   bridge window [mem 0xf0f00000-0xf3ffffff]
[    3.673114] pci 0000:02:01.0:   bridge window [mem 0xd0000000-0xdfffffff 64bit pref]
[    3.673123] pci 0000:01:00.0: PCI bridge to [bus 02-04]
[    3.673127] pci 0000:01:00.0:   bridge window [io  0xd000-0xefff]
[    3.673135] pci 0000:01:00.0:   bridge window [mem 0xf0f00000-0xf7dfffff]
[    3.673141] pci 0000:01:00.0:   bridge window [mem 0xc0000000-0xdfffffff 64bit pref]
[    3.673150] pci 0000:00:01.0: PCI bridge to [bus 01-04]
[    3.673154] pci 0000:00:01.0:   bridge window [io  0xd000-0xefff]
[    3.673160] pci 0000:00:01.0:   bridge window [mem 0xf0f00000-0xf7efffff]
[    3.673166] pci 0000:00:01.0:   bridge window [mem 0xc0000000-0xdfffffff 64bit pref]
[    3.673174] pci 0000:00:1c.0: PCI bridge to [bus 0b-0b]
[    3.673178] pci 0000:00:1c.0:   bridge window [io  0x5000-0x5fff]
[    3.673188] pci 0000:00:1c.0:   bridge window [mem 0xe0800000-0xe09fffff]
[    3.673195] pci 0000:00:1c.0:   bridge window [mem 0xe0a00000-0xe0bfffff 64bit pref]
[    3.673206] pci 0000:00:1c.1: PCI bridge to [bus 0c-0c]
[    3.673211] pci 0000:00:1c.1:   bridge window [io  0x4000-0x4fff]
[    3.673220] pci 0000:00:1c.1:   bridge window [mem 0xf0e00000-0xf0efffff]
[    3.673227] pci 0000:00:1c.1:   bridge window [mem 0xe0600000-0xe07fffff 64bit pref]
[    3.673239] pci 0000:00:1c.3: PCI bridge to [bus 0d-0e]
[    3.673243] pci 0000:00:1c.3:   bridge window [io  0xc000-0xcfff]
[    3.673252] pci 0000:00:1c.3:   bridge window [mem 0xf0c00000-0xf0dfffff]
[    3.673259] pci 0000:00:1c.3:   bridge window [mem 0xe0000000-0xe01fffff 64bit pref]
[    3.673271] pci 0000:00:1c.4: PCI bridge to [bus 0f-0f]
[    3.673276] pci 0000:00:1c.4:   bridge window [io  0x3000-0x3fff]
[    3.673285] pci 0000:00:1c.4:   bridge window [mem 0xef000000-0xf0bfffff]
[    3.673292] pci 0000:00:1c.4:   bridge window [mem 0xe0400000-0xe05fffff 64bit pref]
[    3.673303] pci 0000:00:1c.5: PCI bridge to [bus 09-09]
[    3.673308] pci 0000:00:1c.5:   bridge window [io  0x2000-0x2fff]
[    3.673317] pci 0000:00:1c.5:   bridge window [mem 0xeef00000-0xeeffffff]
[    3.673324] pci 0000:00:1c.5:   bridge window [mem 0xe0200000-0xe03fffff 64bit pref]
[    3.673336] pci 0000:00:1e.0: PCI bridge to [bus 05-05]
[    3.673338] pci 0000:00:1e.0:   bridge window [io  disabled]
[    3.673348] pci 0000:00:1e.0:   bridge window [mem 0xeee00000-0xeeefffff]
[    3.673354] pci 0000:00:1e.0:   bridge window [mem pref disabled]
[    3.673417] pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    3.673424] pci 0000:00:01.0: setting latency timer to 64
[    3.673438] pci 0000:01:00.0: setting latency timer to 64
[    3.673451] pci 0000:02:00.0: setting latency timer to 64
[    3.673465] pci 0000:02:01.0: setting latency timer to 64
[    3.673478] pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    3.673485] pci 0000:00:1c.0: setting latency timer to 64
[    3.673527] pci 0000:00:1c.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    3.673535] pci 0000:00:1c.1: setting latency timer to 64
[    3.673580] pci 0000:00:1c.3: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    3.673588] pci 0000:00:1c.3: setting latency timer to 64
[    3.673601] pci 0000:00:1c.4: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    3.673608] pci 0000:00:1c.4: setting latency timer to 64
[    3.673622] pci 0000:00:1c.5: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    3.673629] pci 0000:00:1c.5: setting latency timer to 64
[    3.673643] pci 0000:00:1e.0: setting latency timer to 64
[    3.673649] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    3.673651] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    3.673654] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    3.673656] pci_bus 0000:00: resource 7 [mem 0x000d0000-0x000dffff]
[    3.673659] pci_bus 0000:00: resource 8 [mem 0xc0000000-0xf7ffffff]
[    3.673661] pci_bus 0000:00: resource 9 [mem 0xfc000000-0xfebfffff]
[    3.673663] pci_bus 0000:00: resource 10 [mem 0xfec10000-0xfecfffff]
[    3.673666] pci_bus 0000:00: resource 11 [mem 0xfed1c000-0xfed1ffff]
[    3.673668] pci_bus 0000:00: resource 12 [mem 0xfed90000-0xfed9ffff]
[    3.673671] pci_bus 0000:00: resource 13 [mem 0xfeda7000-0xfedfffff]
[    3.673673] pci_bus 0000:00: resource 14 [mem 0xfee10000-0xff9fffff]
[    3.673676] pci_bus 0000:00: resource 15 [mem 0xffc00000-0xffdfffff]
[    3.673678] pci_bus 0000:00: resource 16 [mem 0x140000000-0x337ffffff]
[    3.673681] pci_bus 0000:01: resource 0 [io  0xd000-0xefff]
[    3.673683] pci_bus 0000:01: resource 1 [mem 0xf0f00000-0xf7efffff]
[    3.673686] pci_bus 0000:01: resource 2 [mem 0xc0000000-0xdfffffff 64bit pref]
[    3.673688] pci_bus 0000:02: resource 0 [io  0xd000-0xefff]
[    3.673691] pci_bus 0000:02: resource 1 [mem 0xf0f00000-0xf7dfffff]
[    3.673693] pci_bus 0000:02: resource 2 [mem 0xc0000000-0xdfffffff 64bit pref]
[    3.673696] pci_bus 0000:03: resource 0 [io  0xe000-0xefff]
[    3.673698] pci_bus 0000:03: resource 1 [mem 0xf4000000-0xf7dfffff]
[    3.673701] pci_bus 0000:03: resource 2 [mem 0xc0000000-0xcfffffff 64bit pref]
[    3.673704] pci_bus 0000:04: resource 0 [io  0xd000-0xdfff]
[    3.673706] pci_bus 0000:04: resource 1 [mem 0xf0f00000-0xf3ffffff]
[    3.673709] pci_bus 0000:04: resource 2 [mem 0xd0000000-0xdfffffff 64bit pref]
[    3.673712] pci_bus 0000:0b: resource 0 [io  0x5000-0x5fff]
[    3.673714] pci_bus 0000:0b: resource 1 [mem 0xe0800000-0xe09fffff]
[    3.673716] pci_bus 0000:0b: resource 2 [mem 0xe0a00000-0xe0bfffff 64bit pref]
[    3.673719] pci_bus 0000:0c: resource 0 [io  0x4000-0x4fff]
[    3.673721] pci_bus 0000:0c: resource 1 [mem 0xf0e00000-0xf0efffff]
[    3.673724] pci_bus 0000:0c: resource 2 [mem 0xe0600000-0xe07fffff 64bit pref]
[    3.673726] pci_bus 0000:0d: resource 0 [io  0xc000-0xcfff]
[    3.673729] pci_bus 0000:0d: resource 1 [mem 0xf0c00000-0xf0dfffff]
[    3.673731] pci_bus 0000:0d: resource 2 [mem 0xe0000000-0xe01fffff 64bit pref]
[    3.673734] pci_bus 0000:0f: resource 0 [io  0x3000-0x3fff]
[    3.673736] pci_bus 0000:0f: resource 1 [mem 0xef000000-0xf0bfffff]
[    3.673739] pci_bus 0000:0f: resource 2 [mem 0xe0400000-0xe05fffff 64bit pref]
[    3.673741] pci_bus 0000:09: resource 0 [io  0x2000-0x2fff]
[    3.673743] pci_bus 0000:09: resource 1 [mem 0xeef00000-0xeeffffff]
[    3.673746] pci_bus 0000:09: resource 2 [mem 0xe0200000-0xe03fffff 64bit pref]
[    3.673748] pci_bus 0000:05: resource 1 [mem 0xeee00000-0xeeefffff]
[    3.673751] pci_bus 0000:05: resource 4 [io  0x0000-0x0cf7]
[    3.673753] pci_bus 0000:05: resource 5 [io  0x0d00-0xffff]
[    3.673755] pci_bus 0000:05: resource 6 [mem 0x000a0000-0x000bffff]
[    3.673758] pci_bus 0000:05: resource 7 [mem 0x000d0000-0x000dffff]
[    3.673760] pci_bus 0000:05: resource 8 [mem 0xc0000000-0xf7ffffff]
[    3.673762] pci_bus 0000:05: resource 9 [mem 0xfc000000-0xfebfffff]
[    3.673765] pci_bus 0000:05: resource 10 [mem 0xfec10000-0xfecfffff]
[    3.673767] pci_bus 0000:05: resource 11 [mem 0xfed1c000-0xfed1ffff]
[    3.673769] pci_bus 0000:05: resource 12 [mem 0xfed90000-0xfed9ffff]
[    3.673772] pci_bus 0000:05: resource 13 [mem 0xfeda7000-0xfedfffff]
[    3.673774] pci_bus 0000:05: resource 14 [mem 0xfee10000-0xff9fffff]
[    3.673776] pci_bus 0000:05: resource 15 [mem 0xffc00000-0xffdfffff]
[    3.673779] pci_bus 0000:05: resource 16 [mem 0x140000000-0x337ffffff]
[    3.673985] NET: Registered protocol family 2
[    3.674810] IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    3.677593] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
[    3.682839] TCP bind hash table entries: 65536 (order: 10, 5242880 bytes)
[    3.687931] TCP: Hash tables configured (established 524288 bind 65536)
[    3.688023] TCP reno registered
[    3.688129] UDP hash table entries: 2048 (order: 6, 393216 bytes)
[    3.688519] UDP-Lite hash table entries: 2048 (order: 6, 393216 bytes)
[    3.690434] NET: Registered protocol family 1
[    3.691420] RPC: Registered named UNIX socket transport module.
[    3.691424] RPC: Registered udp transport module.
[    3.691426] RPC: Registered tcp transport module.
[    3.691429] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    3.691497] pci 0000:00:1a.0: uhci_check_and_reset_hc: cmd = 0x0080
[    3.691499] pci 0000:00:1a.0: Performing full reset
[    3.691539] pci 0000:00:1a.1: uhci_check_and_reset_hc: cmd = 0x0080
[    3.691541] pci 0000:00:1a.1: Performing full reset
[    3.691773] pci 0000:00:1d.0: uhci_check_and_reset_hc: cmd = 0x0080
[    3.691775] pci 0000:00:1d.0: Performing full reset
[    3.691813] pci 0000:00:1d.1: uhci_check_and_reset_hc: cmd = 0x0080
[    3.691815] pci 0000:00:1d.1: Performing full reset
[    3.691852] pci 0000:00:1d.2: uhci_check_and_reset_hc: cmd = 0x0080
[    3.691854] pci 0000:00:1d.2: Performing full reset
[    3.692207] pci 0000:03:00.0: Boot video device
[    3.692427] PCI: CLS 64 bytes, default 64
[    3.693049] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    3.693053] Placing 64MB software IO TLB between ffff8800bbe6d000 - ffff8800bfe6d000
[    3.693055] software IO TLB at phys 0xbbe6d000 - 0xbfe6d000
[    3.693095] Simple Boot Flag at 0x79 set to 0x1
[    3.703775] microcode: CPU0 sig=0x10676, pf=0x80, revision=0x60c
[    3.703830] microcode: CPU1 sig=0x10676, pf=0x80, revision=0x60c
[    3.704373] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    3.707416] audit: initializing netlink socket (disabled)
[    3.707521] type=2000 audit(1311801344.706:1): initialized
[    3.740568] Kprobe smoke test started
[    3.784140] Kprobe smoke test passed successfully
[    3.798538] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    3.813113] kworker/u:0 used greatest stack depth: 4792 bytes left
[    3.881780] VFS: Disk quotas dquot_6.5.2
[    3.882566] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    3.895607] msgmni has been set to 7889
[    3.896808] SELinux:  Registering netfilter hooks
[    3.901500] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    3.901520] io scheduler noop registered
[    3.901523] io scheduler deadline registered
[    3.902478] io scheduler cfq registered (default)
[    3.902481] start plist test
[    3.903869] end plist test
[    3.905821] pcieport 0000:00:01.0: setting latency timer to 64
[    3.905952] pcieport 0000:00:01.0: irq 40 for MSI/MSI-X
[    3.906920] pcieport 0000:00:1c.0: setting latency timer to 64
[    3.907052] pcieport 0000:00:1c.0: irq 41 for MSI/MSI-X
[    3.907620] pcieport 0000:00:1c.1: setting latency timer to 64
[    3.907735] pcieport 0000:00:1c.1: irq 42 for MSI/MSI-X
[    3.908728] pcieport 0000:00:1c.3: setting latency timer to 64
[    3.908845] pcieport 0000:00:1c.3: irq 43 for MSI/MSI-X
[    3.909682] pcieport 0000:00:1c.4: setting latency timer to 64
[    3.909798] pcieport 0000:00:1c.4: irq 44 for MSI/MSI-X
[    3.910369] pcieport 0000:00:1c.5: setting latency timer to 64
[    3.910485] pcieport 0000:00:1c.5: irq 45 for MSI/MSI-X
[    3.912731] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    3.915615] ACPI: AC Adapter [AC] (on-line)
[    3.918629] input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input0
[    3.921207] ACPI: Lid Switch [LID]
[    3.921950] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input1
[    3.922428] ACPI: Power Button [PBTN]
[    3.923212] input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input2
[    3.923233] ACPI: Sleep Button [SBTN]
[    4.108713] acpi device:33: registered as cooling_device0
[    4.114554] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A03:00/device:2e/device:2f/device:30/LNXVIDEO:00/input/input3
[    4.114579] ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)
[    4.115655] ACPI Warning: For \_SB_.PCI0.AGP_.SLI_.SLI1.VID1._DOD: Return Package has no elements (empty) (20110413/nspredef-456)
[    4.116985] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A03:00/device:2e/device:2f/device:35/LNXVIDEO:01/input/input4
[    4.117035] ACPI: Video Device [VID1] (multi-head: yes  rom: no  post: no)
[    4.117428] ACPI: acpi_idle registered with cpuidle
[    4.121809] Monitor-Mwait will be used to enter C-1 state
[    4.121924] Monitor-Mwait will be used to enter C-2 state
[    4.122219] Monitor-Mwait will be used to enter C-3 state
[    4.122240] Marking TSC unstable due to TSC halts in idle
[    4.268021] thermal LNXTHERM:00: registered as thermal_zone0
[    4.268024] ACPI: Thermal Zone [THM] (50 C)
[    4.269809] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    4.632129] Non-volatile memory driver v1.3
[    4.632132] Linux agpgart interface v0.103
[    4.632595] [drm] Initialized drm 1.1.0 20060810
[    4.664977] brd: module loaded
[    4.681722] loop: module loaded
[    4.686548] ahci 0000:00:1f.2: version 3.0
[    4.686579] ahci 0000:00:1f.2: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    4.686795] ahci 0000:00:1f.2: irq 46 for MSI/MSI-X
[    4.686949] ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 3 ports 3 Gbps 0x5 impl SATA mode
[    4.686953] ahci 0000:00:1f.2: flags: 64bit ncq sntf pm led clo pio slum part ccc ems 
[    4.686961] ahci 0000:00:1f.2: setting latency timer to 64
[    4.699116] scsi0 : ahci
[    4.700866] scsi1 : ahci
[    4.702883] scsi2 : ahci
[    4.719262] ACPI: Battery Slot [BAT0] (battery present)
[    4.722998] ata1: SATA max UDMA/133 abar m2048@0xfed1c800 port 0xfed1c900 irq 46
[    4.723019] ata2: DUMMY
[    4.723022] ata3: SATA max UDMA/133 abar m2048@0xfed1c800 port 0xfed1ca00 irq 46
[    4.723858] ata_piix 0000:00:1f.1: version 2.13
[    4.723884] ata_piix 0000:00:1f.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    4.724251] ata_piix 0000:00:1f.1: setting latency timer to 64
[    4.730804] scsi3 : ata_piix
[    4.732466] scsi4 : ata_piix
[    4.748763] ata4: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x6fa0 irq 14
[    4.748766] ata5: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x6fa8 irq 15
[    4.749093] ata5: port disabled. ignoring.
[    4.752321] e1000: Intel(R) PRO/1000 Network Driver - version 7.3.21-k8-NAPI
[    4.752323] e1000: Copyright (c) 1999-2006 Intel Corporation.
[    4.752785] e100: Intel(R) PRO/100 Network Driver, 3.5.24-k2-NAPI
[    4.752787] e100: Copyright(c) 1999-2006 Intel Corporation
[    4.753361] tg3.c:v3.119 (May 18, 2011)
[    4.753417] tg3 0000:09:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    4.753437] tg3 0000:09:00.0: setting latency timer to 64
[    4.774477] tg3 0000:09:00.0: eth0: Tigon3 [partno(BCM95754m) rev b002] (PCI Express) MAC address 00:21:9b:f9:25:cc
[    4.774481] tg3 0000:09:00.0: eth0: attached PHY is 5787 (10/100/1000Base-T Ethernet) (WireSpeed[1], EEE[0])
[    4.774484] tg3 0000:09:00.0: eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] TSOcap[1]
[    4.774487] tg3 0000:09:00.0: eth0: dma_rwctrl[76180000] dma_mask[64-bit]
[    4.775065] sky2: driver version 1.28
[    4.777500] console [netcon0] enabled
[    4.777502] netconsole: network logging started
[    4.780330] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    4.780334] ehci_hcd: block sizes: qh 104 qtd 96 itd 192 sitd 96
[    4.780499] ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 22 (level, low) -> IRQ 22
[    4.780567] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[    4.780572] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[    4.781144] drivers/usb/core/inode.c: creating file 'devices'
[    4.781272] drivers/usb/core/inode.c: creating file '001'
[    4.782759] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
[    4.782802] ehci_hcd 0000:00:1a.7: reset hcs_params 0x102204 dbg=1 cc=2 pcc=2 ordered !ppc ports=4
[    4.782807] ehci_hcd 0000:00:1a.7: reset hcc_params 6871 thresh 7 uframes 1024 64 bit addr
[    4.782943] ehci_hcd 0000:00:1a.7: debug port 1
[    4.782949] ehci_hcd 0000:00:1a.7: reset command 0000002 (park)=0 ithresh=0 period=1024 Reset HALT
[    4.786833] ehci_hcd 0000:00:1a.7: cache line size of 64 is not supported
[    4.786836] ehci_hcd 0000:00:1a.7: supports USB remote wakeup
[    4.787063] ehci_hcd 0000:00:1a.7: irq 22, io mem 0xfed1c400
[    4.787068] ehci_hcd 0000:00:1a.7: reset command 0080002 (park)=0 ithresh=8 period=1024 Reset HALT
[    4.790945] ehci_hcd 0000:00:1a.7: init command 0010001 (park)=0 ithresh=1 period=1024 RUN
[    4.796043] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[    4.796684] usb usb1: default language 0x0409
[    4.796884] usb usb1: udev 1, busnum 1, minor = 0
[    4.796887] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    4.796889] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.796892] usb usb1: Product: EHCI Host Controller
[    4.796894] usb usb1: Manufacturer: Linux 3.0.0-test+ ehci_hcd
[    4.796896] usb usb1: SerialNumber: 0000:00:1a.7
[    4.798337] usb usb1: usb_probe_device
[    4.798340] usb usb1: configuration #1 chosen from 1 choice
[    4.798592] usb usb1: adding 1-0:1.0 (config #1, interface 0)
[    4.799336] hub 1-0:1.0: usb_probe_interface
[    4.799338] hub 1-0:1.0: usb_probe_interface - got id
[    4.799341] hub 1-0:1.0: USB hub found
[    4.799470] hub 1-0:1.0: 4 ports detected
[    4.799481] hub 1-0:1.0: standalone hub
[    4.799483] hub 1-0:1.0: no power switching (usb 1.0)
[    4.799485] hub 1-0:1.0: individual port over-current protection
[    4.799488] hub 1-0:1.0: power on to power good time: 20ms
[    4.799719] hub 1-0:1.0: local power source is good
[    4.799731] hub 1-0:1.0: trying to enable port power on non-switchable hub
[    4.800134] drivers/usb/core/inode.c: creating file '001'
[    4.801129] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    4.801194] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    4.801199] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    4.801251] drivers/usb/core/inode.c: creating file '002'
[    4.802215] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
[    4.802253] ehci_hcd 0000:00:1d.7: reset hcs_params 0x103206 dbg=1 cc=3 pcc=2 ordered !ppc ports=6
[    4.802257] ehci_hcd 0000:00:1d.7: reset hcc_params 6871 thresh 7 uframes 1024 64 bit addr
[    4.802351] ehci_hcd 0000:00:1d.7: debug port 1
[    4.802356] ehci_hcd 0000:00:1d.7: reset command 0000002 (park)=0 ithresh=0 period=1024 Reset HALT
[    4.806243] ehci_hcd 0000:00:1d.7: cache line size of 64 is not supported
[    4.806246] ehci_hcd 0000:00:1d.7: supports USB remote wakeup
[    4.806449] ehci_hcd 0000:00:1d.7: irq 20, io mem 0xfed1c000
[    4.806454] ehci_hcd 0000:00:1d.7: reset command 0080002 (park)=0 ithresh=8 period=1024 Reset HALT
[    4.810328] ehci_hcd 0000:00:1d.7: init command 0010001 (park)=0 ithresh=1 period=1024 RUN
[    4.816130] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    4.816546] usb usb2: default language 0x0409
[    4.816742] usb usb2: udev 1, busnum 2, minor = 128
[    4.816745] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    4.816747] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.816750] usb usb2: Product: EHCI Host Controller
[    4.816752] usb usb2: Manufacturer: Linux 3.0.0-test+ ehci_hcd
[    4.816754] usb usb2: SerialNumber: 0000:00:1d.7
[    4.817889] usb usb2: usb_probe_device
[    4.817892] usb usb2: configuration #1 chosen from 1 choice
[    4.817970] usb usb2: adding 2-0:1.0 (config #1, interface 0)
[    4.818571] hub 2-0:1.0: usb_probe_interface
[    4.818574] hub 2-0:1.0: usb_probe_interface - got id
[    4.818576] hub 2-0:1.0: USB hub found
[    4.818658] hub 2-0:1.0: 6 ports detected
[    4.818670] hub 2-0:1.0: standalone hub
[    4.818672] hub 2-0:1.0: no power switching (usb 1.0)
[    4.818674] hub 2-0:1.0: individual port over-current protection
[    4.818676] hub 2-0:1.0: power on to power good time: 20ms
[    4.818785] hub 2-0:1.0: local power source is good
[    4.818797] hub 2-0:1.0: trying to enable port power on non-switchable hub
[    4.819379] drivers/usb/core/inode.c: creating file '001'
[    4.820591] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    4.820593] ohci_hcd: block sizes: ed 80 td 96
[    4.821148] uhci_hcd: USB Universal Host Controller Interface driver
[    4.821315] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    4.821346] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[    4.821351] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    4.821397] drivers/usb/core/inode.c: creating file '003'
[    4.822182] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
[    4.822220] uhci_hcd 0000:00:1a.0: detected 2 ports
[    4.822227] uhci_hcd 0000:00:1a.0: uhci_check_and_reset_hc: cmd = 0x0000
[    4.822229] uhci_hcd 0000:00:1a.0: Performing full reset
[    4.822246] uhci_hcd 0000:00:1a.0: supports USB remote wakeup
[    4.822285] uhci_hcd 0000:00:1a.0: irq 20, io base 0x00006f20
[    4.822642] usb usb3: default language 0x0409
[    4.822839] usb usb3: udev 1, busnum 3, minor = 256
[    4.822842] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    4.822844] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.822847] usb usb3: Product: UHCI Host Controller
[    4.822849] usb usb3: Manufacturer: Linux 3.0.0-test+ uhci_hcd
[    4.822851] usb usb3: SerialNumber: 0000:00:1a.0
[    4.824526] usb usb3: usb_probe_device
[    4.824530] usb usb3: configuration #1 chosen from 1 choice
[    4.824608] usb usb3: adding 3-0:1.0 (config #1, interface 0)
[    4.825209] hub 3-0:1.0: usb_probe_interface
[    4.825212] hub 3-0:1.0: usb_probe_interface - got id
[    4.825214] hub 3-0:1.0: USB hub found
[    4.825300] hub 3-0:1.0: 2 ports detected
[    4.825312] hub 3-0:1.0: standalone hub
[    4.825314] hub 3-0:1.0: no power switching (usb 1.0)
[    4.825316] hub 3-0:1.0: individual port over-current protection
[    4.825319] hub 3-0:1.0: power on to power good time: 2ms
[    4.825433] hub 3-0:1.0: local power source is good
[    4.825445] hub 3-0:1.0: trying to enable port power on non-switchable hub
[    4.825722] drivers/usb/core/inode.c: creating file '001'
[    4.826309] ehci_hcd 0000:00:1a.7: HS companion for 0000:00:1a.0
[    4.826857] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    4.826885] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[    4.826890] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[    4.826938] drivers/usb/core/inode.c: creating file '004'
[    4.827727] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
[    4.827765] uhci_hcd 0000:00:1a.1: detected 2 ports
[    4.827772] uhci_hcd 0000:00:1a.1: uhci_check_and_reset_hc: cmd = 0x0000
[    4.827774] uhci_hcd 0000:00:1a.1: Performing full reset
[    4.827791] uhci_hcd 0000:00:1a.1: supports USB remote wakeup
[    4.827990] uhci_hcd 0000:00:1a.1: irq 21, io base 0x00006f00
[    4.828694] usb usb4: default language 0x0409
[    4.828892] usb usb4: udev 1, busnum 4, minor = 384
[    4.828894] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    4.828897] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.828899] usb usb4: Product: UHCI Host Controller
[    4.828901] usb usb4: Manufacturer: Linux 3.0.0-test+ uhci_hcd
[    4.828903] usb usb4: SerialNumber: 0000:00:1a.1
[    4.829970] usb usb4: usb_probe_device
[    4.829974] usb usb4: configuration #1 chosen from 1 choice
[    4.830488] usb usb4: adding 4-0:1.0 (config #1, interface 0)
[    4.831087] hub 4-0:1.0: usb_probe_interface
[    4.831089] hub 4-0:1.0: usb_probe_interface - got id
[    4.831091] hub 4-0:1.0: USB hub found
[    4.831174] hub 4-0:1.0: 2 ports detected
[    4.831186] hub 4-0:1.0: standalone hub
[    4.831188] hub 4-0:1.0: no power switching (usb 1.0)
[    4.831190] hub 4-0:1.0: individual port over-current protection
[    4.831192] hub 4-0:1.0: power on to power good time: 2ms
[    4.831294] hub 4-0:1.0: local power source is good
[    4.831306] hub 4-0:1.0: trying to enable port power on non-switchable hub
[    4.831578] drivers/usb/core/inode.c: creating file '001'
[    4.831886] ehci_hcd 0000:00:1a.7: HS companion for 0000:00:1a.1
[    4.832708] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    4.832736] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    4.832741] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    4.832786] drivers/usb/core/inode.c: creating file '005'
[    4.833577] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 5
[    4.833614] uhci_hcd 0000:00:1d.0: detected 2 ports
[    4.833620] uhci_hcd 0000:00:1d.0: uhci_check_and_reset_hc: cmd = 0x0000
[    4.833623] uhci_hcd 0000:00:1d.0: Performing full reset
[    4.833640] uhci_hcd 0000:00:1d.0: supports USB remote wakeup
[    4.833682] uhci_hcd 0000:00:1d.0: irq 20, io base 0x00006f80
[    4.834261] usb usb5: default language 0x0409
[    4.834458] usb usb5: udev 1, busnum 5, minor = 512
[    4.834460] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    4.834463] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.834465] usb usb5: Product: UHCI Host Controller
[    4.834467] usb usb5: Manufacturer: Linux 3.0.0-test+ uhci_hcd
[    4.834469] usb usb5: SerialNumber: 0000:00:1d.0
[    4.835530] usb usb5: usb_probe_device
[    4.835533] usb usb5: configuration #1 chosen from 1 choice
[    4.835611] usb usb5: adding 5-0:1.0 (config #1, interface 0)
[    4.836825] hub 5-0:1.0: usb_probe_interface
[    4.836828] hub 5-0:1.0: usb_probe_interface - got id
[    4.836830] hub 5-0:1.0: USB hub found
[    4.836914] hub 5-0:1.0: 2 ports detected
[    4.836926] hub 5-0:1.0: standalone hub
[    4.836928] hub 5-0:1.0: no power switching (usb 1.0)
[    4.836930] hub 5-0:1.0: individual port over-current protection
[    4.836933] hub 5-0:1.0: power on to power good time: 2ms
[    4.837070] hub 5-0:1.0: local power source is good
[    4.837082] hub 5-0:1.0: trying to enable port power on non-switchable hub
[    4.837385] drivers/usb/core/inode.c: creating file '001'
[    4.837853] ehci_hcd 0000:00:1d.7: HS companion for 0000:00:1d.0
[    4.838473] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    4.838501] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    4.838505] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    4.838555] drivers/usb/core/inode.c: creating file '006'
[    4.839332] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 6
[    4.839369] uhci_hcd 0000:00:1d.1: detected 2 ports
[    4.839376] uhci_hcd 0000:00:1d.1: uhci_check_and_reset_hc: cmd = 0x0000
[    4.839378] uhci_hcd 0000:00:1d.1: Performing full reset
[    4.839396] uhci_hcd 0000:00:1d.1: supports USB remote wakeup
[    4.839434] uhci_hcd 0000:00:1d.1: irq 21, io base 0x00006f60
[    4.839763] usb usb6: default language 0x0409
[    4.839962] usb usb6: udev 1, busnum 6, minor = 640
[    4.839964] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
[    4.839967] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.839969] usb usb6: Product: UHCI Host Controller
[    4.839971] usb usb6: Manufacturer: Linux 3.0.0-test+ uhci_hcd
[    4.839973] usb usb6: SerialNumber: 0000:00:1d.1
[    4.841519] usb usb6: usb_probe_device
[    4.841522] usb usb6: configuration #1 chosen from 1 choice
[    4.841604] usb usb6: adding 6-0:1.0 (config #1, interface 0)
[    4.842247] hub 6-0:1.0: usb_probe_interface
[    4.842250] hub 6-0:1.0: usb_probe_interface - got id
[    4.842252] hub 6-0:1.0: USB hub found
[    4.842336] hub 6-0:1.0: 2 ports detected
[    4.842347] hub 6-0:1.0: standalone hub
[    4.842349] hub 6-0:1.0: no power switching (usb 1.0)
[    4.842351] hub 6-0:1.0: individual port over-current protection
[    4.842354] hub 6-0:1.0: power on to power good time: 2ms
[    4.842457] hub 6-0:1.0: local power source is good
[    4.842470] hub 6-0:1.0: trying to enable port power on non-switchable hub
[    4.842742] drivers/usb/core/inode.c: creating file '001'
[    4.843388] ehci_hcd 0000:00:1d.7: HS companion for 0000:00:1d.1
[    4.843737] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 22 (level, low) -> IRQ 22
[    4.843767] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    4.843772] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    4.843817] drivers/usb/core/inode.c: creating file '007'
[    4.844596] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 7
[    4.844636] uhci_hcd 0000:00:1d.2: detected 2 ports
[    4.844643] uhci_hcd 0000:00:1d.2: uhci_check_and_reset_hc: cmd = 0x0000
[    4.844645] uhci_hcd 0000:00:1d.2: Performing full reset
[    4.844662] uhci_hcd 0000:00:1d.2: supports USB remote wakeup
[    4.844703] uhci_hcd 0000:00:1d.2: irq 22, io base 0x00006f40
[    4.845234] usb usb7: default language 0x0409
[    4.845432] usb usb7: udev 1, busnum 7, minor = 768
[    4.845434] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
[    4.845437] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.845439] usb usb7: Product: UHCI Host Controller
[    4.845441] usb usb7: Manufacturer: Linux 3.0.0-test+ uhci_hcd
[    4.845443] usb usb7: SerialNumber: 0000:00:1d.2
[    4.846507] usb usb7: usb_probe_device
[    4.846510] usb usb7: configuration #1 chosen from 1 choice
[    4.846604] usb usb7: adding 7-0:1.0 (config #1, interface 0)
[    4.847449] hub 7-0:1.0: usb_probe_interface
[    4.847452] hub 7-0:1.0: usb_probe_interface - got id
[    4.847454] hub 7-0:1.0: USB hub found
[    4.847539] hub 7-0:1.0: 2 ports detected
[    4.847551] hub 7-0:1.0: standalone hub
[    4.847553] hub 7-0:1.0: no power switching (usb 1.0)
[    4.847555] hub 7-0:1.0: individual port over-current protection
[    4.847557] hub 7-0:1.0: power on to power good time: 2ms
[    4.847660] hub 7-0:1.0: local power source is good
[    4.847672] hub 7-0:1.0: trying to enable port power on non-switchable hub
[    4.847944] drivers/usb/core/inode.c: creating file '001'
[    4.848442] ehci_hcd 0000:00:1d.7: HS companion for 0000:00:1d.2
[    4.849939] usbcore: registered new interface driver usblp
[    4.849942] Initializing USB Mass Storage driver...
[    4.850432] usbcore: registered new interface driver usb-storage
[    4.850434] USB Mass Storage support registered.
[    4.851125] usbcore: registered new interface driver libusual
[    4.851964] i8042: PNP: PS/2 Controller [PNP0303:KBC,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
[    4.856141] serio: i8042 KBD port at 0x60,0x64 irq 1
[    4.856224] serio: i8042 AUX port at 0x60,0x64 irq 12
[    4.858149] mousedev: PS/2 mouse device common for all mice
[    4.862920] rtc_cmos 00:03: RTC can wake from S4
[    4.864066] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
[    4.864152] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    4.864749] i801_smbus 0000:00:1f.3: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    4.866399] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input5
[    4.870294] device-mapper: ioctl: 4.20.0-ioctl (2011-02-02) initialised: dm-devel@redhat.com
[    4.870917] Bluetooth: Generic Bluetooth USB driver ver 0.6
[    4.873855] usbcore: registered new interface driver btusb
[    4.878614] cpuidle: using governor ladder
[    4.888460] cpuidle: using governor menu
[    4.888464] EFI Variables Facility v0.08 2004-May-17
[    4.889599] dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
[    4.899280] ehci_hcd 0000:00:1a.7: GetStatus port:2 status 001803 0  ACK POWER sig=j CSC CONNECT
[    4.899303] hub 1-0:1.0: port 2: status 0501 change 0001
[    4.899417] ehci_hcd 0000:00:1a.7: GetStatus port:3 status 001803 0  ACK POWER sig=j CSC CONNECT
[    4.899439] hub 1-0:1.0: port 3: status 0501 change 0001
[    4.904370] usbcore: registered new interface driver usbhid
[    4.904373] usbhid: USB HID core driver
[    4.912257] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
[    4.912431] HDA Intel 0000:00:1b.0: irq 47 for MSI/MSI-X
[    4.912667] HDA Intel 0000:00:1b.0: setting latency timer to 64
[    4.919334] ehci_hcd 0000:00:1d.7: GetStatus port:6 status 001803 0  ACK POWER sig=j CSC CONNECT
[    4.919357] hub 2-0:1.0: port 6: status 0501 change 0001
[    4.920810] ata4.00: ATAPI: TSSTcorp DVD+/-RW TS-L632H, D400, max UDMA/33
[    4.925099] uhci_hcd 0000:00:1a.0: port 2 portsc 008a,00
[    4.931273] uhci_hcd 0000:00:1a.1: port 1 portsc 008a,00
[    4.937399] hub 5-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    4.942388] hub 6-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    4.942541] ata4.00: configured for UDMA/33
[    4.948098] uhci_hcd 0000:00:1d.2: port 2 portsc 0082,00
[    4.999315] hub 1-0:1.0: state 7 ports 4 chg 000c evt 0000
[    4.999398] hub 1-0:1.0: port 2, status 0501, change 0000, 480 Mb/s
[    5.025100] ALSA device list:
[    5.025103]   #0: HDA Intel at 0xf7ffc000 irq 47
[    5.025279] Netfilter messages via NETLINK v0.30.
[    5.025404] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[    5.027585] ctnetlink v0.93: registering with nfnetlink.
[    5.029070] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    5.030060] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    5.030867] ip_tables: (C) 2000-2006 Netfilter Core Team
[    5.031187] TCP cubic registered
[    5.031190] Initializing XFRM netlink socket
[    5.034933] NET: Registered protocol family 10
[    5.041477] ip6_tables: (C) 2000-2006 Netfilter Core Team
[    5.041822] IPv6 over IPv4 tunneling driver
[    5.046972] NET: Registered protocol family 17
[    5.047177] Registering the dns_resolver key type
[    5.049408] PM: Hibernation image not present or could not be loaded.
[    5.049523] registered taskstats version 1
[    5.050362] ehci_hcd 0000:00:1a.7: port 2 full speed --> companion
[    5.050370] ehci_hcd 0000:00:1a.7: GetStatus port:2 status 003801 0  ACK POWER OWNER sig=j CONNECT
[    5.050487] hub 1-0:1.0: port 2 not reset yet, waiting 50ms
[    5.060024] ata3.00: ATA-8: ST9160411ASG, DE17, max UDMA/133
[    5.060028] ata3.00: 312581808 sectors, multi 8: LBA48 NCQ (depth 31/32)
[    5.061594] ata1.00: ATA-8: ST9160411ASG, DE17, max UDMA/133
[    5.061598] ata1.00: 312581808 sectors, multi 8: LBA48 NCQ (depth 31/32)
[    5.061853] kmemleak: Kernel memory leak detector initialized
[    5.061864] kmemleak: Automatic memory scanning thread started
[    5.068954]   Magic number: 3:982:298
[    5.101073] ehci_hcd 0000:00:1a.7: GetStatus port:2 status 003002 0  ACK POWER OWNER sig=se0 CSC
[    5.101376] hub 1-0:1.0: port 3, status 0501, change 0000, 480 Mb/s
[    5.102913] ata3.00: configured for UDMA/133
[    5.107113] ata1.00: configured for UDMA/133
[    5.108490] scsi 0:0:0:0: Direct-Access     ATA      ST9160411ASG     DE17 PQ: 0 ANSI: 5
[    5.111937] sd 0:0:0:0: [sda] 312581808 512-byte logical blocks: (160 GB/149 GiB)
[    5.112999] sd 0:0:0:0: [sda] Write Protect is off
[    5.113020] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    5.113358] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    5.119197] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    5.121889] scsi 2:0:0:0: Direct-Access     ATA      ST9160411ASG     DE17 PQ: 0 ANSI: 5
[    5.124671] sd 2:0:0:0: [sdb] 312581808 512-byte logical blocks: (160 GB/149 GiB)
[    5.125879] sd 2:0:0:0: [sdb] Write Protect is off
[    5.125883] sd 2:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    5.126401] sd 2:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    5.132222] sd 2:0:0:0: Attached scsi generic sg1 type 0
[    5.137097] scsi 3:0:0:0: CD-ROM            TSSTcorp DVD+-RW TS-L632H D400 PQ: 0 ANSI: 5
[    5.142464]  sda: sda1 sda2 sda3
[    5.146524] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
[    5.146536] cdrom: Uniform CD-ROM driver Revision: 3.20
[    5.148949] sd 0:0:0:0: [sda] Attached SCSI disk
[    5.150950] sr 3:0:0:0: Attached scsi CD-ROM sr0
[    5.152361] ehci_hcd 0000:00:1a.7: port 3 full speed --> companion
[    5.152366] ehci_hcd 0000:00:1a.7: GetStatus port:3 status 003801 0  ACK POWER OWNER sig=j CONNECT
[    5.152397] hub 1-0:1.0: port 3 not reset yet, waiting 50ms
[    5.152718] sr 3:0:0:0: Attached scsi generic sg2 type 5
[    5.157522]  sdb: sdb1
[    5.161537] sd 2:0:0:0: [sdb] Attached SCSI disk
[    5.203101] ehci_hcd 0000:00:1a.7: GetStatus port:3 status 003002 0  ACK POWER OWNER sig=se0 CSC
[    5.203275] hub 2-0:1.0: state 7 ports 6 chg 0040 evt 0000
[    5.203316] hub 2-0:1.0: port 6, status 0501, change 0000, 480 Mb/s
[    5.254619] ehci_hcd 0000:00:1d.7: port 6 high speed
[    5.254624] ehci_hcd 0000:00:1d.7: GetStatus port:6 status 001005 0  ACK POWER sig=se0 PE CONNECT
[    5.305097] usb 2-6: new high speed USB device number 2 using ehci_hcd
[    5.356372] ehci_hcd 0000:00:1d.7: port 6 high speed
[    5.356377] ehci_hcd 0000:00:1d.7: GetStatus port:6 status 001005 0  ACK POWER sig=se0 PE CONNECT
[    5.427376] usb 2-6: skipped 1 descriptor after configuration
[    5.427379] usb 2-6: skipped 7 descriptors after interface
[    5.427388] usb 2-6: skipped 1 descriptor after endpoint
[    5.427391] usb 2-6: skipped 19 descriptors after interface
[    5.427401] usb 2-6: skipped 1 descriptor after endpoint
[    5.427707] usb 2-6: default language 0x0409
[    5.428873] usb 2-6: udev 2, busnum 2, minor = 129
[    5.428884] usb 2-6: New USB device found, idVendor=05a9, idProduct=2640
[    5.428886] usb 2-6: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    5.428889] usb 2-6: Product: Laptop Integrated Webcam
[    5.428891] usb 2-6: Manufacturer: OmniVision Technologies, Inc. -2640-07.07.20.3
[    5.429995] usb 2-6: usb_probe_device
[    5.429999] usb 2-6: configuration #1 chosen from 1 choice
[    5.430263] usb 2-6: adding 2-6:1.0 (config #1, interface 0)
[    5.431673] usb 2-6: adding 2-6:1.1 (config #1, interface 1)
[    5.432358] drivers/usb/core/inode.c: creating file '002'
[    5.432560] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0004
[    5.432586] uhci_hcd 0000:00:1a.0: port 2 portsc 0093,00
[    5.432648] hub 3-0:1.0: port 2, status 0101, change 0001, 12 Mb/s
[    5.511611] Synaptics Touchpad, model: 1, fw: 6.3, id: 0x1a0b1, caps: 0xa04793/0x300000/0x0
[    5.511651] serio: Synaptics pass-through port at isa0060/serio1/input0
[    5.536111] hub 3-0:1.0: debounce: port 2: total 100ms stable 100ms status 0x101
[    5.550167] input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio1/input/input6
[    5.554710] md: Waiting for all devices to be available before autodetect
[    5.554713] md: If you don't use raid, use raid=noautodetect
[    5.557914] md: Autodetecting RAID arrays.
[    5.557917] md: Scanned 0 and added 0 devices.
[    5.557919] md: autorun ...
[    5.557920] md: ... autorun DONE.
[    5.586642] EXT3-fs: barriers not enabled
[    5.607979] kjournald starting.  Commit interval 5 seconds
[    5.608263] EXT3-fs (sda3): mounted filesystem with writeback data mode
[    5.608385] VFS: Mounted root (ext3 filesystem) readonly on device 8:3.
[    5.638144] usb 3-2: new full speed USB device number 2 using uhci_hcd
[    5.665568] devtmpfs: mounted
[    5.674540] Freeing unused kernel memory: 3048k freed
[    5.676221] Write protecting the kernel read-only data: 10240k
[    5.677587] Freeing unused kernel memory: 240k freed
[    5.682080] Freeing unused kernel memory: 984k freed
[    5.758078] usb 3-2: ep0 maxpacket = 8
[    5.784571] usb 3-2: default language 0x0409
[    5.798601] usb 3-2: udev 2, busnum 3, minor = 257
[    5.798604] usb 3-2: New USB device found, idVendor=0a5c, idProduct=4500
[    5.798607] usb 3-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    5.798609] usb 3-2: Product: BCM2045B2
[    5.798611] usb 3-2: Manufacturer: Broadcom
[    5.799569] usb 3-2: usb_probe_device
[    5.799573] usb 3-2: configuration #1 chosen from 1 choice
[    5.801685] usb 3-2: adding 3-2:1.0 (config #1, interface 0)
[    5.802286] hub 3-2:1.0: usb_probe_interface
[    5.802288] hub 3-2:1.0: usb_probe_interface - got id
[    5.802291] hub 3-2:1.0: USB hub found
[    5.803590] hub 3-2:1.0: 3 ports detected
[    5.803603] hub 3-2:1.0: compound device; port removable status: FFF
[    5.803605] hub 3-2:1.0: ganged power switching
[    5.803607] hub 3-2:1.0: global over-current protection
[    5.803610] hub 3-2:1.0: power on to power good time: 100ms
[    5.804528] hub 3-2:1.0: hub controller current requirement: 100mA
[    5.804531] hub 3-2:1.0: 100mA bus power budget for each child
[    5.805625] hub 3-2:1.0: local power source is good
[    5.805628] hub 3-2:1.0: no over-current condition exists
[    5.805639] hub 3-2:1.0: enabling power on all ports
[    5.808745] drivers/usb/core/inode.c: creating file '002'
[    5.808938] hub 4-0:1.0: state 7 ports 2 chg 0000 evt 0002
[    5.808963] uhci_hcd 0000:00:1a.1: port 1 portsc 0093,00
[    5.809054] hub 4-0:1.0: port 1, status 0101, change 0001, 12 Mb/s
[    5.909591] hub 3-2:1.0: port 1: status 0101 change 0001
[    5.911574] hub 3-2:1.0: port 2: status 0101 change 0001
[    5.913126] hub 4-0:1.0: debounce: port 1: total 100ms stable 100ms status 0x101
[    5.913559] hub 3-2:1.0: port 3: status 0101 change 0001
[    5.954064] usb usb5: suspend_rh (auto-stop)
[    5.954071] usb usb6: suspend_rh (auto-stop)
[    5.954114] usb usb7: suspend_rh (auto-stop)
[    6.014093] uhci_hcd 0000:00:1a.0: reserve dev 2 ep81-INT, period 128, phase 0, 12 us
[    6.015146] usb 4-1: new full speed USB device number 2 using uhci_hcd
[    6.136058] usb 4-1: ep0 maxpacket = 8
[    6.161656] usb 4-1: skipped 1 descriptor after interface
[    6.164640] usb 4-1: default language 0x0409
[    6.172667] usb 4-1: udev 2, busnum 4, minor = 385
[    6.172670] usb 4-1: New USB device found, idVendor=046d, idProduct=c251
[    6.172673] usb 4-1: New USB device strings: Mfr=0, Product=2, SerialNumber=0
[    6.172676] usb 4-1: Product: GamePanel LCD
[    6.173598] usb 4-1: usb_probe_device
[    6.173602] usb 4-1: configuration #1 chosen from 1 choice
[    6.175670] usb 4-1: adding 4-1:1.0 (config #1, interface 0)
[    6.176272] usbhid 4-1:1.0: usb_probe_interface
[    6.176275] usbhid 4-1:1.0: usb_probe_interface - got id
[    6.195296] usbhid 4-1:1.0: looking for a minor, starting at 96
[    6.197920] generic-usb 0003:046D:C251.0001: hiddev0,hidraw0: USB HID v1.11 Device [GamePanel LCD] on usb-0000:00:1a.1-1/input0
[    6.198333] drivers/usb/core/inode.c: creating file '002'
[    6.198520] hub 7-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    6.198525] hub 1-0:1.0: state 7 ports 4 chg 0000 evt 0008
[    6.198572] hub 3-2:1.0: state 7 ports 3 chg 000e evt 0000
[    6.200600] hub 3-2:1.0: port 1, status 0101, change 0000, 12 Mb/s
[    6.265592] usb 3-2.1: new full speed USB device number 3 using uhci_hcd
[    6.368680] usb 3-2.1: skipped 1 descriptor after interface
[    6.373588] usb 3-2.1: default language 0x0409
[    6.381578] usb 3-2.1: udev 3, busnum 3, minor = 258
[    6.381581] usb 3-2.1: New USB device found, idVendor=413c, idProduct=8126
[    6.381584] usb 3-2.1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    6.381586] usb 3-2.1: Product: BCM2045
[    6.381588] usb 3-2.1: Manufacturer: Broadcom Corp
[    6.382492] usb 3-2.1: usb_probe_device
[    6.382496] usb 3-2.1: configuration #1 chosen from 1 choice
[    6.384724] usb 3-2.1: adding 3-2.1:1.0 (config #1, interface 0)
[    6.385301] btusb 3-2.1:1.0: usb_probe_interface
[    6.385304] btusb 3-2.1:1.0: usb_probe_interface - got id
[    6.387978] uhci_hcd 0000:00:1a.0: reserve dev 3 ep81-INT, period 1, phase 0, 23 us
[    6.388352] usb 3-2.1: adding 3-2.1:1.1 (config #1, interface 1)
[    6.389323] usb 3-2.1: adding 3-2.1:1.2 (config #1, interface 2)
[    6.389921] btusb 3-2.1:1.2: usb_probe_interface
[    6.389924] btusb 3-2.1:1.2: usb_probe_interface - got id
[    6.390489] usb 3-2.1: adding 3-2.1:1.3 (config #1, interface 3)
[    6.391052] btusb 3-2.1:1.3: usb_probe_interface
[    6.391055] btusb 3-2.1:1.3: usb_probe_interface - got id
[    6.391107] drivers/usb/core/inode.c: creating file '003'
[    6.391288] hub 3-2:1.0: 400mA power budget left
[    6.391584] hub 3-2:1.0: port 2, status 0101, change 0000, 12 Mb/s
[    6.454582] usb 3-2.2: new full speed USB device number 4 using uhci_hcd
[    6.493279] hostname used greatest stack depth: 4224 bytes left
[    6.495841] hwclock used greatest stack depth: 3912 bytes left
[    6.536069] usb 3-2.2: ep0 maxpacket = 8
[    6.562603] usb 3-2.2: skipped 1 descriptor after interface
[    6.566594] usb 3-2.2: default language 0x0409
[    6.574628] usb 3-2.2: udev 4, busnum 3, minor = 259
[    6.574631] usb 3-2.2: New USB device found, idVendor=0a5c, idProduct=4502
[    6.574634] usb 3-2.2: New USB device strings: Mfr=1, Product=0, SerialNumber=0
[    6.574637] usb 3-2.2: Manufacturer: Broadcom Corp
[    6.575505] usb 3-2.2: usb_probe_device
[    6.575509] usb 3-2.2: configuration #1 chosen from 1 choice
[    6.578702] usb 3-2.2: adding 3-2.2:1.0 (config #1, interface 0)
[    6.579298] usbhid 3-2.2:1.0: usb_probe_interface
[    6.579301] usbhid 3-2.2:1.0: usb_probe_interface - got id
[    6.584255] input: Broadcom Corp as /devices/pci0000:00/0000:00:1a.0/usb3/3-2/3-2.2/3-2.2:1.0/input/input7
[    6.584421] uhci_hcd 0000:00:1a.0: reserve dev 4 ep81-INT, period 8, phase 4, 17 us
[    6.586275] generic-usb 0003:0A5C:4502.0002: input,hidraw1: USB HID v1.11 Keyboard [Broadcom Corp] on usb-0000:00:1a.0-2.2/input0
[    6.586448] drivers/usb/core/inode.c: creating file '004'
[    6.586626] hub 3-2:1.0: 400mA power budget left
[    6.587592] hub 3-2:1.0: port 3, status 0101, change 0000, 12 Mb/s
[    6.613572] plymouthd used greatest stack depth: 3088 bytes left
[    6.650606] usb 3-2.3: new full speed USB device number 5 using uhci_hcd
[    6.732074] usb 3-2.3: ep0 maxpacket = 8
[    6.757579] usb 3-2.3: skipped 1 descriptor after interface
[    6.760602] usb 3-2.3: default language 0x0409
[    6.768626] usb 3-2.3: udev 5, busnum 3, minor = 260
[    6.768629] usb 3-2.3: New USB device found, idVendor=0a5c, idProduct=4503
[    6.768632] usb 3-2.3: New USB device strings: Mfr=1, Product=0, SerialNumber=0
[    6.768635] usb 3-2.3: Manufacturer: Broadcom Corp
[    6.769529] usb 3-2.3: usb_probe_device
[    6.769533] usb 3-2.3: configuration #1 chosen from 1 choice
[    6.772709] usb 3-2.3: adding 3-2.3:1.0 (config #1, interface 0)
[    6.773321] usbhid 3-2.3:1.0: usb_probe_interface
[    6.773324] usbhid 3-2.3:1.0: usb_probe_interface - got id
[    6.779293] input: Broadcom Corp as /devices/pci0000:00/0000:00:1a.0/usb3/3-2/3-2.3/3-2.3:1.0/input/input8
[    6.781942] generic-usb 0003:0A5C:4503.0003: input,hidraw2: USB HID v1.11 Mouse [Broadcom Corp] on usb-0000:00:1a.0-2.3/input0
[    6.782691] drivers/usb/core/inode.c: creating file '005'
[    6.782876] hub 3-2:1.0: 400mA power budget left
[    6.782881] hub 3-2:1.0: state 7 ports 3 chg 0000 evt 0008
[    7.171140] mountall used greatest stack depth: 2784 bytes left
[    8.476690] uhci_hcd 0000:00:1a.0: release dev 3 ep81-INT, period 1, phase 0, 23 us
[    9.321316] udev[1191]: starting version 167
[   11.098029] Linux video capture interface: v2.00
[   11.262510] r852 0000:05:01.3: PCI INT B -> GSI 18 (level, low) -> IRQ 18
[   11.263781] r852: driver loaded successfully
[   11.518090] sdhci: Secure Digital Host Controller Interface driver
[   11.518094] sdhci: Copyright(c) Pierre Ossman
[   11.920395] input: Dell WMI hotkeys as /devices/virtual/input/input9
[   11.940487] uvcvideo 2-6:1.0: usb_probe_interface
[   11.940492] uvcvideo 2-6:1.0: usb_probe_interface - got id
[   11.940622] uvcvideo: Found UVC 1.00 device Laptop Integrated Webcam (05a9:2640)
[   11.941512] uvcvideo: UVC non compliance - GET_DEF(PROBE) not supported. Enabling workaround.
[   11.944903] input: Laptop Integrated Webcam as /devices/pci0000:00/0000:00:1d.7/usb2/2-6/2-6:1.0/input/input10
[   11.946748] usbcore: registered new interface driver uvcvideo
[   11.946751] USB Video Class driver (v1.1.0)
[   11.952384] sdhci-pci 0000:05:01.1: SDHCI controller found [1180:0822] (rev 22)
[   11.952407] sdhci-pci 0000:05:01.1: PCI INT B -> GSI 18 (level, low) -> IRQ 18
[   11.957572] Registered led device: mmc0::
[   11.960431] mmc0: SDHCI controller on PCI [0000:05:01.1] using DMA
[   12.222343] firewire_ohci 0000:05:01.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[   12.232007] usb 2-6: link qh1024-0001/ffff88013642b080 start 1 [1/0 us]
[   12.232126] usb 2-6: unlink qh1024-0001/ffff88013642b080 start 1 [1/0 us]
[   12.275747] firewire_ohci: Added fw-ohci device 0000:05:01.0, OHCI v1.10, 4 IR + 4 IT contexts, quirks 0x1
[   12.778900] firewire_core: created device fw0: GUID 364fc00033661c90, S400
[   13.252192] iwl4965: Intel(R) Wireless WiFi 4965 driver for Linux, in-tree:d
[   13.252195] iwl4965: Copyright(c) 2003-2011 Intel Corporation
[   13.252469] iwl4965 0000:0c:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[   13.252506] iwl4965 0000:0c:00.0: setting latency timer to 64
[   13.252632] iwl4965 0000:0c:00.0: Detected Intel(R) Wireless WiFi Link 4965AGN, REV=0x4
[   13.296066] iwl4965 0000:0c:00.0: device EEPROM VER=0x36, CALIB=0x5
[   13.296117] iwl4965 0000:0c:00.0: Tunable channels: 13 802.11bg, 19 802.11a channels
[   13.296536] iwl4965 0000:0c:00.0: irq 48 for MSI/MSI-X
[   13.692588] iwl4965 0000:0c:00.0: loaded firmware version 228.61.2.24
[   13.694283] Registered led device: phy0-led
[   13.696608] ieee80211 phy0: Selected rate control algorithm 'iwl-4965-rs'
[   15.742263] Adding 506040k swap on /dev/sda2.  Priority:-1 extents:1 across:506040k 
[   16.166803] nouveau 0000:03:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   16.166813] nouveau 0000:03:00.0: setting latency timer to 64
[   16.178589] [drm] nouveau 0000:03:00.0: Detected an NV50 generation card (0x092600a2)
[   16.194296] [drm] nouveau 0000:03:00.0: Attempting to load BIOS image from PRAMIN
[   16.304296] [drm] nouveau 0000:03:00.0: ... appears to be valid
[   16.304300] [drm] nouveau 0000:03:00.0: BIT BIOS found
[   16.304304] [drm] nouveau 0000:03:00.0: Bios version 62.92.2c.00
[   16.304307] [drm] nouveau 0000:03:00.0: TMDS table version 2.0
[   16.304309] [drm] nouveau 0000:03:00.0: Found Display Configuration Block version 4.0
[   16.304312] [drm] nouveau 0000:03:00.0: Raw DCB entry 0: 01000323 00010034
[   16.304315] [drm] nouveau 0000:03:00.0: Raw DCB entry 1: 04011310 00000028
[   16.304317] [drm] nouveau 0000:03:00.0: Raw DCB entry 2: 02021312 00000030
[   16.304320] [drm] nouveau 0000:03:00.0: Raw DCB entry 3: 010323f1 00c0c080
[   16.304322] [drm] nouveau 0000:03:00.0: Raw DCB entry 4: 0000000e 00000000
[   16.304325] [drm] nouveau 0000:03:00.0: DCB connector table: VHER 0x40 5 16 4
[   16.304328] [drm] nouveau 0000:03:00.0:   0: 0x00000041: type 0x41 idx 0 tag 0xff
[   16.304331] [drm] nouveau 0000:03:00.0:   1: 0x00001130: type 0x30 idx 1 tag 0x07
[   16.304334] [drm] nouveau 0000:03:00.0:   2: 0x00000210: type 0x10 idx 2 tag 0xff
[   16.304337] [drm] nouveau 0000:03:00.0:   3: 0x00000211: type 0x11 idx 3 tag 0xff
[   16.304340] [drm] nouveau 0000:03:00.0:   4: 0x00000213: type 0x13 idx 4 tag 0xff
[   16.304345] [drm] nouveau 0000:03:00.0: Parsing VBIOS init table 0 at offset 0xC582
[   16.329702] [drm] nouveau 0000:03:00.0: Parsing VBIOS init table 1 at offset 0xC933
[   16.333319] [drm] nouveau 0000:03:00.0: Parsing VBIOS init table 2 at offset 0xD6AE
[   16.333330] [drm] nouveau 0000:03:00.0: Parsing VBIOS init table 3 at offset 0xD7D0
[   16.334421] [drm] nouveau 0000:03:00.0: Parsing VBIOS init table 4 at offset 0xDA00
[   16.334424] [drm] nouveau 0000:03:00.0: Parsing VBIOS init table at offset 0xDA65
[   16.354523] [drm] nouveau 0000:03:00.0: 0xDA65: Condition still not met after 20ms, skipping following opcodes
[   16.376412] [drm] nouveau 0000:03:00.0: 4 available performance level(s)
[   16.376418] [drm] nouveau 0000:03:00.0: 0: memory 100MHz core 200MHz shader 400MHz voltage 850mV fanspeed 100% timing 0
[   16.376423] [drm] nouveau 0000:03:00.0: 1: memory 301MHz core 275MHz shader 550MHz voltage 850mV fanspeed 100% timing 1
[   16.376427] [drm] nouveau 0000:03:00.0: 2: memory 301MHz core 383MHz shader 767MHz voltage 850mV fanspeed 100% timing 1
[   16.376432] [drm] nouveau 0000:03:00.0: 3: memory 799MHz core 500MHz shader 1250MHz voltage 1000mV fanspeed 100% timing 3
[   16.376463] [drm] nouveau 0000:03:00.0: c: memory 300MHz core 275MHz shader 550MHz voltage 850mV
[   16.378291] [TTM] Zone  kernel: Available graphics memory: 2021814 kiB.
[   16.378294] [TTM] Initializing pool allocator.
[   16.378549] [drm] nouveau 0000:03:00.0: Detected 512MiB VRAM
[   16.395600] [drm] nouveau 0000:03:00.0: 512 MiB GART (aperture)
[   16.439557] [drm] nouveau 0000:03:00.0: ACPI backlight interface available, not registering our own
[   16.444592] [drm] nouveau 0000:03:00.0: DCB encoder 1 unknown
[   16.444596] [drm] nouveau 0000:03:00.0: TV-1 has no encoders, removing
[   16.448528] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[   16.448531] [drm] No driver support for vblank timestamp query.
[   16.538908] EXT3-fs (sda3): using internal journal
[   16.707617] [drm] nouveau 0000:03:00.0: allocated 1920x1200 fb: 0x40000000, bo ffff88013496fc00
[   16.726596] fbcon: nouveaufb (fb0) is primary device
[   16.863281] EXT3-fs: barriers not enabled
[   16.876333] kjournald starting.  Commit interval 5 seconds
[   16.879705] EXT3-fs (sdb1): using internal journal
[   16.879717] EXT3-fs (sdb1): mounted filesystem with writeback data mode
[   18.012963] Console: switching to colour frame buffer device 240x75
[   18.016868] fb0: nouveaufb frame buffer device
[   18.016869] drm: registered panic notifier
[   18.016983] [drm] Initialized nouveau 0.0.16 20090420 for 0000:03:00.0 on minor 0
[   18.017091] nouveau 0000:04:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[   18.017099] nouveau 0000:04:00.0: setting latency timer to 64
[   18.049376] [drm] nouveau 0000:04:00.0: Detected an NV50 generation card (0x092600a2)
[   18.064419] [drm] nouveau 0000:04:00.0: Attempting to load BIOS image from PRAMIN
[   18.064429] [drm] nouveau 0000:04:00.0: ... BIOS signature not found
[   18.064431] [drm] nouveau 0000:04:00.0: Attempting to load BIOS image from PROM
[   18.252485] [drm] nouveau 0000:04:00.0: ... appears to be valid
[   18.252491] [drm] nouveau 0000:04:00.0: BIT BIOS found
[   18.252494] [drm] nouveau 0000:04:00.0: Bios version 62.92.2c.00
[   18.252498] [drm] nouveau 0000:04:00.0: TMDS table version 2.0
[   18.252500] [drm] nouveau 0000:04:00.0: Found Display Configuration Block version 4.0
[   18.252503] [drm] nouveau 0000:04:00.0: Raw DCB entry 0: 01000323 00010034
[   18.252506] [drm] nouveau 0000:04:00.0: Raw DCB entry 1: 0000000e 00000000
[   18.252509] [drm] nouveau 0000:04:00.0: DCB connector table: VHER 0x40 5 16 4
[   18.252512] [drm] nouveau 0000:04:00.0:   0: 0x00000041: type 0x41 idx 0 tag 0xff
[   18.252520] [drm] nouveau 0000:04:00.0: Adaptor not initialised, running VBIOS init tables.
[   18.252523] [drm] nouveau 0000:04:00.0: Parsing VBIOS init table 0 at offset 0xC582
[   18.280141] [drm] nouveau 0000:04:00.0: Parsing VBIOS init table 1 at offset 0xC933
[   18.283029] [drm] nouveau 0000:04:00.0: Parsing VBIOS init table 2 at offset 0xD6AE
[   18.283075] [drm] nouveau 0000:04:00.0: Parsing VBIOS init table 3 at offset 0xD7D0
[   18.284196] [drm] nouveau 0000:04:00.0: Parsing VBIOS init table 4 at offset 0xDA00
[   18.290489] [drm] nouveau 0000:04:00.0: Parsing VBIOS init table at offset 0xDA65
[   18.330187] [drm] nouveau 0000:04:00.0: 4 available performance level(s)
[   18.330192] [drm] nouveau 0000:04:00.0: 0: memory 100MHz core 200MHz shader 400MHz voltage 850mV fanspeed 100% timing 0
[   18.330197] [drm] nouveau 0000:04:00.0: 1: memory 301MHz core 275MHz shader 550MHz voltage 850mV fanspeed 100% timing 1
[   18.330201] [drm] nouveau 0000:04:00.0: 2: memory 301MHz core 383MHz shader 767MHz voltage 850mV fanspeed 100% timing 1
[   18.330206] [drm] nouveau 0000:04:00.0: 3: memory 799MHz core 500MHz shader 1250MHz voltage 1000mV fanspeed 100% timing 3
[   18.330238] [drm] nouveau 0000:04:00.0: c: memory 300MHz core 275MHz shader 550MHz voltage 850mV
[   18.334406] [drm] nouveau 0000:04:00.0: Detected 512MiB VRAM
[   18.351927] [drm] nouveau 0000:04:00.0: 512 MiB GART (aperture)
[   18.394796] [drm] nouveau 0000:04:00.0: ACPI backlight interface available, not registering our own
[   18.397494] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[   18.397497] [drm] No driver support for vblank timestamp query.
[   18.413422] No connectors reported connected with modes
[   18.413810] [drm] Cannot find any crtc or sizes - going 1024x768
[   18.417727] [drm] nouveau 0000:04:00.0: allocated 1024x768 fb: 0x40000000, bo ffff880134901000
[   18.419716] fb1: nouveaufb frame buffer device
[   18.419734] [drm] Initialized nouveau 0.0.16 20090420 for 0000:04:00.0 on minor 1
[   19.132623] chown used greatest stack depth: 2688 bytes left
[   27.244310] uhci_hcd 0000:00:1a.0: reserve dev 3 ep81-INT, period 1, phase 0, 23 us
[   27.343839] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   27.353174] tg3 0000:09:00.0: irq 49 for MSI/MSI-X
[   27.411364] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   28.709996] uhci_hcd 0000:00:1a.0: reserve dev 5 ep81-INT, period 8, phase 4, 14 us
[   78.916646] wlan0: authenticate with 00:18:f6:aa:6e:25 (try 1)
[   78.924794] wlan0: authenticated
[   78.925268] wlan0: associate with 00:18:f6:aa:6e:25 (try 1)
[   78.927884] wlan0: RX AssocResp from 00:18:f6:aa:6e:25 (capab=0x411 status=0 aid=2)
[   78.927887] wlan0: associated
[   78.954527] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[   89.778067] wlan0: no IPv6 routers present
[  102.860517] kmemleak: 6 new suspected memory leaks (see /sys/kernel/debug/kmemleak)
[  105.425340] ehci_hcd 0000:00:1d.7: reused qh ffff88013642b080 schedule
[  105.425345] usb 2-6: link qh1024-0001/ffff88013642b080 start 1 [1/0 us]
[  105.439527] usb 2-6: unlink qh1024-0001/ffff88013642b080 start 1 [1/0 us]


