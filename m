Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932341Ab1IRTqN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Sep 2011 15:46:13 -0400
Received: from mail-wy0-f170.google.com ([74.125.82.170]:46020 "EHLO
	mail-wy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756636Ab1IRTqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Sep 2011 15:46:11 -0400
Subject: Re: [GIT] Networking
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        David Miller <davem@davemloft.net>, akpm@linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20110918192333.GA1641@x4.trippels.de>
References: <20110918.022125.1554085675403900813.davem@davemloft.net>
	 <CA+55aFxc1tMCXKBV33PVD5BybTLBpfJAEcObvoQwbwqbKOsp7g@mail.gmail.com>
	 <20110918192333.GA1641@x4.trippels.de>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 18 Sep 2011 21:46:04 +0200
Message-ID: <1316375164.31335.18.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le dimanche 18 septembre 2011 à 21:23 +0200, Markus Trippelsdorf a
écrit :
> On 2011.09.18 at 11:06 -0700, Linus Torvalds wrote:
> > 2011/9/17 David Miller <davem@davemloft.net>:
> > >
> > > dpward (2):
> > >      net: Make flow cache namespace-aware
> > >      net: Handle different key sizes between address families in flow cache
> > >
> > > nhorman (1):
> > >      net: don't clear IFF_XMIT_DST_RELEASE in ether_setup
> > >
> > > rajan.aggarwal85@gmail.com (1):
> > >      net/can/af_can.c: Change del_timer to del_timer_sync
> > 
> > Guys, if somebody has such a broken email setup that they don't even
> > show their own name, don't take patches from them.
> > 
> > If you cannot even set up email sanely, there is zero reason to
> > believe that the patch should be good. And if the patch is trivial and
> > you want to take it despite the source of the patch being crap, please
> > spend the five seconds to fix it up.
> > 
> > Proper names are part of the commit message. Don't make it look like
> > crap. I get ugly flashbacks to SVN or CVS when I see stuff like this.
> > Don't do it.
> 
> Plus commit 946cedccbd73874 breaks the build:
> 
>   LD      init/built-in.o
>   LD      .tmp_vmlinux1
> net/built-in.o:sysctl_net.c:function tcp_v4_conn_request: error: undefined reference to 'cookie_v4_init_sequence'
> make: *** [.tmp_vmlinux1] Error 1
> 
> commit 946cedccbd7387488d2cee5da92cdfeb28d2e670
> Author: Eric Dumazet <eric.dumazet@gmail.com>
> Date:   Tue Aug 30 03:21:44 2011 +0000
> 
>     tcp: Change possible SYN flooding messages
> 
>     "Possible SYN flooding on port xxxx " messages can fill logs on servers.
> 
>     Change logic to log the message only once per listener, and add two new
>     SNMP counters to track :
> 
>     TCPReqQFullDoCookies : number of times a SYNCOOKIE was replied to client
> 
>     TCPReqQFullDrop : number of times a SYN request was dropped because
>     syncookies were not enabled.
> 
>     Based on a prior patch from Tom Herbert, and suggestions from David.
> 
> 

Oh well, trying to remove those ugly #ifdef was not so easy.
I'll cook a patch, thanks for the report



