Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754805Ab0K3JCu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 04:02:50 -0500
Received: from serv04.lahn.de ([213.239.197.57]:33827 "EHLO serv04.lahn.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751792Ab0K3JCr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 04:02:47 -0500
Date: Tue, 30 Nov 2010 09:59:44 +0100
From: Michael Leun <lkml20101129@newton.leun.net>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: 2.6.35 -> 2.6.36 panic when vlan and promisc with tg3
Message-ID: <20101130095944.41b5f7b6@xenia.leun.net>
In-Reply-To: <4CF442FA.4070701@candelatech.com>
References: <20101129201716.1d0257c4@xenia.leun.net>
	<4CF442FA.4070701@candelatech.com>
Organization: Not Organized
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Nov 2010 16:19:06 -0800
Ben Greear <greearb@candelatech.com> wrote:

> On 11/29/2010 11:17 AM, Michael Leun wrote:
> > UG: unable to handle kernel paging request at 01cc921c
> > IP: [<c034bfce>] vlan_hwaccel_do_receive+0x59/0xd0
> > *pdpt = 0000000036a2a001 *pde = 0000000000000000
> > Oops: 0002 [#1] SMP
> > last sysfs
> >
> > Then machine dead.
> >
> > In 2.6.35.x this did not happen (but vlans broken - cannot see vlan
> > tags with tcpdump),
> 
> Try this patch:
> 
> http://permalink.gmane.org/gmane.linux.network/176566
> 
> It looks like this hasn't made it into stable yet?

> > To reproduce:
> >
> > ip link set eth0 up
> > vconfig add eth0 2
> > ip link set eth0 promisc on

It makes it better - it does not crash anymore on this commands - but
if you add an "tcpdump -i eth0 -n" at the end it does. So,
unfortunately no real solution.

I guess, "dropping packet no one is interested in" (as noted in the
patch) does not work very well if tcpdump is actually interested?

-- 
MfG,

Michael Leun

