Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754287Ab1KRIRi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 03:17:38 -0500
Received: from cust-95-128-94-82.breedbanddelft.nl ([95.128.94.82]:47514 "HELO
	abra2.bitwizard.nl" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S1752426Ab1KRIRh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 03:17:37 -0500
Date: Fri, 18 Nov 2011 09:17:35 +0100
From: Rogier Wolff <R.E.Wolff@BitWizard.nl>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: linux-kernel@vger.kernel.org, netdev <netdev@vger.kernel.org>
Subject: Re: Route cache problem.
Message-ID: <20111118081734.GA25843@bitwizard.nl>
References: <20111103143734.GA17218@bitwizard.nl> <1320333410.2344.13.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1320333410.2344.13.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Organization: BitWizard.nl
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 03, 2011 at 04:16:50PM +0100, Eric Dumazet wrote:
> Le jeudi 03 novembre 2011 à 15:37 +0100, Rogier Wolff a écrit :
> > Hi, 
> > 
> > My workstation has an incorrect route cache entry: 
> > 
> 
> What kernel version ?

Linux version 3.0.0-12-generic (from Ubunutu oneiric.)

> > assurancetourix:~> route -nC | head -2 ; route -nC | grep 234.34
> > Kernel IP routing cache
> > Source          Destination     Gateway         Flags Metric Ref    Use Iface
> > 192.168.235.8   192.168.234.34  192.168.235.251       0      0        3 eth0
> > 192.168.235.8   192.168.234.34  192.168.235.251       0      0        4 eth0
> > 192.168.235.8   192.168.234.34  192.168.235.251       0      0        2 eth0
> > 
> > (I don't know why there are three). 

Today there are four. 
> 192.168.20.108  10.37.168.112   192.168.20.254        0      1        2 eth3

That indeed got me a full complement of route cache entries. 

> Better use "ip -s route list cache" to diagnose problems (more
> information)

After doing the tos ping you suggested All TOS levels have a route
cache entry. 

192.168.234.34 from 192.168.235.8 tos 0x1c via 192.168.235.251 dev eth0 
    cache <redirected>  age 77sec ipid 0xaa09 rtt 47ms rttvar 15ms ssthresh 7 cwnd 9
192.168.234.34 tos 0x1c via 192.168.235.251 dev eth0  src 192.168.235.8 
    cache <redirected>  used 3 age 72sec ipid 0xaa09 rtt 47ms rttvar 15ms ssthresh 7 cwnd 9
192.168.234.34 from 192.168.235.8 tos 0x1c via 192.168.235.251 dev eth0 
    cache <redirected>  age 72sec ipid 0xaa09 rtt 47ms rttvar 15ms ssthresh 7 cwnd 9

> > Any suggestions? Any at all?

Last time, as well as this time, it is triggered by a network error
that leads to the 192.168.235.4 router not being able to reach 
192.168.234.34 or any other host on the 192.168.234.0/24 network. 

During that time the VPN to 192.168.234.0/24 is down, so 192.168.235.4
doesn't have a route to 192.168.234.0/24 and it is logical that
with that route gone, it sends packets for 192.168.234.0/24 to the default
router 192.168.235.251. As it sees itself forwarding packets that come
in on eth0 back to eth0, it will send a redirect. However that redirect
should somehow expire, and not survive things like dropping the route
to 192.168.234.0/24, dropping the default route, shutting down the 
interface or some time passing (that network problem was solved 20 
hours ago)...... 

	Roger. 

-- 
** R.E.Wolff@BitWizard.nl ** http://www.BitWizard.nl/ ** +31-15-2600998 **
**    Delftechpark 26 2628 XH  Delft, The Netherlands. KVK: 27239233    **
*-- BitWizard writes Linux device drivers for any device you may have! --*
The plan was simple, like my brother-in-law Phil. But unlike
Phil, this plan just might work.
