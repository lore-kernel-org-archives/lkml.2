Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754027Ab1LUU3A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 15:29:00 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:60524 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753774Ab1LUU26 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 15:28:58 -0500
Message-ID: <1324499332.2621.7.camel@edumazet-laptop>
Subject: Re: BUG: unable to handle kernel NULL pointer dereference in
 ipv6_select_ident
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Chris Boot <bootc@bootc.net>
Cc: lkml <linux-kernel@vger.kernel.org>, netdev <netdev@vger.kernel.org>
Date: Wed, 21 Dec 2011 21:28:52 +0100
In-Reply-To: <4EF23BF2.4000601@bootc.net>
References: <4EF200BB.7000209@bootc.net>
	  <1324484956.2301.24.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	  <4EF2117F.6000803@bootc.net>
	  <1324488984.2301.45.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <1324490401.2301.46.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <4EF23BF2.4000601@bootc.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 21 décembre 2011 à 20:05 +0000, Chris Boot a écrit :
> On 21/12/2011 18:00, Eric Dumazet wrote:
> > Le mercredi 21 décembre 2011 à 18:36 +0100, Eric Dumazet a écrit :
> >
> >> Good point, thats a different problem then, since 3.1 is not supposed to
> >> have this bug.
> >>
> >> It seems rt->rt6i_peer points to invalid memory in your crash.
> >>
> >> (RBX=00000000000001f4)
> >>
> >> 8b 83 a4 00 00 00       mov    0xa4(%rbx),%eax    p->refcnt
> >> 1f4+a4 ->  CR2=0000000000000298
> >>
> > It would help if you can confirm latest linux tree can reproduce the
> > bug.
> 
> Hi Eric,
> 
> I just built a v3.2-rc6-140-gb9e26df with the same config as the Debian 
> 3.1.0 kernel. I can reproduce the bug just as easily with this kernel as 
> with the Debian kernel. Unfortunately I wasn't able to get an entire 
> trace, for some reason it didn't appear to be printed to the serial port 
> and hung after the (long) list of loaded kernel modules. The crash 
> happens at the same offset:
> 

Thanks !

Oh well, br_netfilter fake_rtable strikes again.

I'll cook a patch in a couple of minutes...


