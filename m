Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756074Ab3AFQdA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2013 11:33:00 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:52859 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756018Ab3AFQc6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2013 11:32:58 -0500
Message-ID: <1357489955.5717.21.camel@marge.simpson.net>
Subject: Re: sched: Consequences of integrating the Per Entity Load Tracking
 Metric into the Load Balancer
From: Mike Galbraith <bitbucket@online.de>
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "svaidy@linux.vnet.ibm.com" <svaidy@linux.vnet.ibm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        Paul McKenney <paul.mckenney@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Ingo Molnar <mingo@kernel.org>, Paul Turner <pjt@google.com>,
        Venki Pallipadi <venki@google.com>,
        Robin Randhawa <robin.randhawa@arm.com>,
        Lists linaro-dev <linaro-dev@lists.linaro.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Alex Shi <alex.shi@intel.com>,
        srikar@linux.vnet.ibm.com
Date: Sun, 06 Jan 2013 17:32:35 +0100
In-Reply-To: <1357373590.5690.172.camel@marge.simpson.net>
References: <50E3B61A.3040808@linux.vnet.ibm.com>
	 <1357114354.5586.39.camel@marge.simpson.net>
	 <50E55F99.6090104@linux.vnet.ibm.com>
	 <1357373590.5690.172.camel@marge.simpson.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:nUF8FlTkV3pC3RQcCeP12nelGNPBxiJJDrmr9aDJEM4
 DpzXGQmvIZksYwv1sodlCT948K0TmEmubowAgMyFlUkETESU3k
 dInCazrcNCU4yc+m8a5eO+7G2HG+44cq25WgqLZ9wdDKMWJCea
 JXmhjNxC011rOXmICwUbSh/3YtppdlOlXVveyRKh1ncTBheRml
 nJdlOryE80cif/n6gYbcjQH8YPPySW9nWYKNHquewKjErQ/EJY
 d69q4Y8Nh2KzIYAMkK74sbSKeZV8qZIuR2Xz+N5L2gktuxkgdJ
 KxdN/WpcaAVocfZKQpaJf+YabaBDJ5zML/jEc7vSpWzKfqVaIE
 FkRbednGW5XiZw5IJl2/Cpd2bh35m6IiXIxT17/Dx+ZALyj20g
 VkZi/tgkE5CTw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-01-05 at 09:13 +0100, Mike Galbraith wrote:

> I still have a 2.6-rt problem I need to find time to squabble with, but
> maybe I'll soonish see if what you did plus what I did combined works
> out on that 4x10 core box where current is _so_ unbelievably horrible.
> Heck, it can't get any worse, and the restricted wake balance alone
> kinda sorta worked.

Actually, I flunked copy/paste 101.  Below (preeti) shows the real deal.

tbench, 3 runs, 30 secs/run
revert = 37407ea7 reverted
clients                     1          5         10        20         40         80
3.6.0.virgin            27.83     139.50    1488.76   4172.93    6983.71    8301.73
                        29.23     139.98    1500.22   4162.92    6907.16    8231.13
                        30.00     141.43    1500.09   3975.50    6847.24    7983.98

3.6.0+revert           281.08    1404.76    2802.44   5019.49    7080.97    8592.80
                       282.38    1375.70    2747.23   4823.95    7052.15    8508.45
                       270.69    1375.53    2736.29   5243.05    7058.75    8806.72

3.6.0+preeti            26.43     126.62    1027.23   3350.06    7004.22    7561.83
                        26.67     128.66     922.57   3341.73    7045.05    7662.18
                        25.54     129.20    1015.02   3337.60    6591.32    7634.33

3.6.0+best_combined    280.48    1382.07    2730.27   4786.20    6477.28    7980.07
                       276.88    1392.50    2708.23   4741.25    6590.99    7992.11
                       278.92    1368.55    2735.49   4614.99    6573.38    7921.75

3.0.51-0.7.9-default   286.44    1415.37    2794.41   5284.39    7282.57   13670.80

Something is either wrong with 3.6 itself, or the config I'm using, as
max throughput is nowhere near where it should be (see default).  On the
bright side, integrating the two does show some promise.

-Mike

