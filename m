Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756602Ab1HEKaE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 06:30:04 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55757 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754426Ab1HEKaB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 06:30:01 -0400
Date: Fri, 5 Aug 2011 12:29:03 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jiri Pirko <jpirko@redhat.com>
Cc: David Miller <davem@davemloft.net>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [forcedeth bug] Re: [GIT] Networking
Message-ID: <20110805102903.GF2420@elte.hu>
References: <20110722.073339.1236244143490935644.davem@davemloft.net>
 <20110801151308.GA31256@elte.hu>
 <20110804215354.GA7056@elte.hu>
 <20110805102239.GB1928@minipsycho.orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110805102239.GB1928@minipsycho.orion>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jiri Pirko <jpirko@redhat.com> wrote:

> Thu, Aug 04, 2011 at 11:53:54PM CEST, mingo@elte.hu wrote:
> >
> >* Ingo Molnar <mingo@elte.hu> wrote:
> >
> >>  0891b0e08937: forcedeth: fix vlans
> >
> >Hm, forcedeth is still giving me trouble even on latest -git that has 
> >the above fix included.
> >
> >The symptom is a stuck interface, no packets in. There's a frame 
> >error RX packet:
> >
> > [root@mercury ~]# ifconfig eth0
> > eth0      Link encap:Ethernet  HWaddr 00:13:D4:DC:41:12  
> >           inet addr:10.0.1.13  Bcast:10.0.1.255  Mask:255.255.255.0
> >           UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
> >           RX packets:0 errors:1 dropped:0 overruns:0 frame:1
> >           TX packets:531 errors:0 dropped:0 overruns:0 carrier:0
> >           collisions:0 txqueuelen:1000 
> >           RX bytes:0 (0.0 b)  TX bytes:34112 (33.3 KiB)
> >           Interrupt:35 
> >
> >Weirdly enough a defconfig x86 bootup works just fine - it's certain 
> >.config combinations that trigger the bug. I've attached such a 
> >config.
> >
> >Note that at least once i've observed a seemingly good kernel going 
> >'bad' after a couple of minutes uptime. I've also observed 
> >intermittent behavior - apparent lost packets and a laggy network.
> >
> >I have done 3 failed attempts to bisect it any further - i got to the 
> >commit that got fixed by:
> >
> >  0891b0e08937: forcedeth: fix vlans
> >
> >... but that's something we already knew.
> >
> >Let me know if there's any data i can provide to help debug this 
> >problem.
> >
> >Thanks,
> >
> >	Ingo
> 
> Interesting.
> 
> Is DEV_HAS_VLAN set in id->driver_data (L5344) ?

How do i tell that without hacking the driver?

> If so, would you try to disable both rx an tx vlan accel using 
> ethtool and see if it helps?

Should i do that when the device is in a stuck state and see whether 
it recovers?

Also, please provide the exact ethtool command sequences i should 
try, this makes it easier for me to test exactly what you want me to 
test.

Thanks,

	Ingo
