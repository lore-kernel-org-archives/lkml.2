Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754803Ab0HZXyG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 19:54:06 -0400
Received: from mail.vyatta.com ([76.74.103.46]:36487 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752015Ab0HZXyE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 19:54:04 -0400
Date: Thu, 26 Aug 2010 16:53:59 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: Marc Aurele La France <tsi@ualberta.ca>
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
        Ben Hutchings <bhutchings@solarflare.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        "Pekka Savola (ipv6)" <pekkas@netcore.fi>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>
Subject: Re: RFC: MTU for serving NFS on Infiniband
Message-ID: <20100826165359.3b79b27d@nehalam>
In-Reply-To: <alpine.WNT.2.00.1008260835020.2008@cluij.ucs.ualberta.ca>
References: <alpine.LNX.2.00.1008230842290.9325@abcyxhiz.aict.ualberta.ca>
	<20100823080543.319143e3@nehalam>
	<alpine.WNT.2.00.1008240856170.2000@cluij.ucs.ualberta.ca>
	<1282672647.2302.15.camel@achroite.uk.solarflarecom.com>
	<alpine.WNT.2.00.1008241338470.1132@cluij.ucs.ualberta.ca>
	<1282688441.22839.34.camel@localhost>
	<20100824153920.63360072@s6510>
	<alpine.WNT.2.00.1008251408520.632@cluij.ucs.ualberta.ca>
	<1282823827.2476.663.camel@edumazet-laptop>
	<alpine.WNT.2.00.1008260835020.2008@cluij.ucs.ualberta.ca>
Organization: Vyatta
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Aug 2010 08:43:42 -0600 (Mountain Daylight Time)
Marc Aurele La France <tsi@ualberta.ca> wrote:

> On Thu, 26 Aug 2010, Eric Dumazet wrote:
> > Le jeudi 26 août 2010 à 05:40 -0600, Marc Aurele La France a écrit :
> 
> >> Steady now.  There's no need to YELL nor be arrogant.  You and I both know
> >> there's a place for NFS over UDP.  That's not changing any time soon.  While
> >> I'm aware of the issue you brought up, it is separate from the one at hand in
> >> this discussion.
> 
> >> I do want to thank you, however, for reminding me of TCP.  It's something
> >> 20/20 hindsight says I should have checked out before starting this thread.
> >> Logistically, it'll be a few days before I can do so though.  If that allows
> >> me to increase the MTU all the way up to 65520, then this UDP thing will
> >> likely remain unresolved.
> 
> > Unfortunately, your infiniband device lacks NETIF_F_SG support.
> 
> Oh, the device itself probably has something similar, but ipoib 
> (IP-over-Infiniband) doesn't export that capability.
> 
> > MTU a bit larger than PAGE_SIZE-overhead will need high order
> > allocations ?
> 
> Right.  And a 65520 MTU allocates sk_buff's with 128K contiguous payloads.

Infiniband device driver needs to be fixed to do SG and checksum offload.
Otherwise it is insane to try and run large MTU over it. I even wonder if
the dev_change_mtu() function should reject > PAGESIZE mtu for devices
that don't do scatter/gather or at least a raise a warning.
