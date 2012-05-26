Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751222Ab2EZEZP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 00:25:15 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:51611 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998Ab2EZEZO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 00:25:14 -0400
Subject: Re: exit_mmap BUG_ON in 2.6.23 (and Add qdisc __NET_XMIT_STOLEN)
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Sam Portolla <samportolla@yahoo.com>
Cc: Hugh Dickins <hughd@google.com>, "kaber@trash.net" <kaber@trash.net>,
        "jarkao2@gmail.com" <jarkao2@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <1337992130.90506.YahooMailNeo@web121305.mail.ne1.yahoo.com>
References: <1337406674.48432.YahooMailNeo@web121303.mail.ne1.yahoo.com>
	 <alpine.LSU.2.00.1205191301430.10539@eggly.anvils>
	 <1337992130.90506.YahooMailNeo@web121305.mail.ne1.yahoo.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 26 May 2012 06:25:09 +0200
Message-ID: <1338006309.10135.15.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-05-25 at 17:28 -0700, Sam Portolla wrote:

Please don't top post on this list

> 
> [pease cc samPortolla@yahoo.com on the replies; not a member of this
> mailer]
> 
> Hi Hugh,
> 
> Thank you!  It turns out our 2.6.23 kernel does not have this old
> patch, I am also adding Jarek, David and Patrick who were involved in
> the below fix for their insights:
> 
> 
> commit 378a2f090f7a478704a372a4869b8a9ac206234e
> Date:   Mon Aug 4 22:31:03 2008 -0700
> net_sched: Add qdisc __NET_XMIT_STOLEN flag
> In this failure case below, as well as some others, the ethernet
> driver printed a transmit timeout just before the crash.
> 
> It seems since we don't have the above patch, the kernel qdisc Tx
> packet path for fragmented packets can be messed up and corrupt the
> skb  it passes to drivers, which in the historic case that led to
> above fix, caused an skb NULL ptr de-ref in the driver itself (which
> we also saw once). 
> 
> Jarek, David or Patrick,
> 
> Could the lack of above patch cause the kernel to also falsely detect
> transmit timeouts on various drivers as it can not properly keep track
> of packets transmitted? Can you please elaborate so  a newbie like me
> can understand?
> 
> Is the above commit the sole one required for the kernel panic/skb
> NULL de-ref driver issue or is there more needed fixes later on that
> can be backported to an older kernel (2.6.23 GNU/Linux x86_64)?
> 

Transmit timeouts are because of races in some network drivers.

The device stay in XOFF state for too long time (forever as a matter of
fact once the race triggered)

Since 2.6.23 we fixed a lot of them, but still races still exist.



