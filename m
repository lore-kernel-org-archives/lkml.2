Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754037Ab1JDIEO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 04:04:14 -0400
Received: from esgaroth.petrovitsch.at ([78.47.184.11]:5172 "EHLO
	esgaroth.petrovitsch.priv.at" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751261Ab1JDIEL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 04:04:11 -0400
X-DKIM: Sendmail DKIM Filter v2.8.3 unknown-host p9483x0g032080
Subject: Re: Handling of multiple DHCP OFFERs
From: Bernd Petrovitsch <bernd@petrovitsch.priv.at>
To: johnmusbach1@gmail.com
Cc: Chris Friesen <chris.friesen@genband.com>,
        David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        Robert Hancock <hancockrwd@gmail.com>
Date: Tue, 04 Oct 2011 10:03:59 +0200
In-Reply-To: <4E8A5D74.7000507@gmail.com>
References: <loom.20111004T011704-753@post.gmane.org>
	 <20111003.192129.745977451712127515.davem@davemloft.net>
	 <4E8A46E9.2070509@genband.com> <4E8A5D74.7000507@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.2 (3.0.2-3.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1317715440.32011.21.camel@thorin>
Mime-Version: 1.0
X-DCC-STAT_FI_X86_64_VIRTUAL-Metrics: esgaroth.petrovitsch.priv.at; whitelist
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-10-03 at 19:12 -0600, Robert Hancock wrote:
> On 10/03/2011 05:36 PM, Chris Friesen wrote:
> > On 10/03/2011 05:21 PM, David Miller wrote:
> >> From: John Musbach<johnmusbach1@gmail.com>
> >> Date: Mon, 3 Oct 2011 23:18:06 +0000 (UTC)
> >>
> >>> Hello, I am configuring a network that'll have multiple DHCP servers
> >>> and I was wondering how Linux handles receiving multiple DHCP OFFERs?

Define "Linux":
The kernel?
- A given distribution?
- All distributions?
- The major ones?
- ISCs dhclient?
- RedHats "pump"?
- Other DHCP clients?

> >>> More specifically, how does it choose which one to prefer and how long
> >>> will it wait for a answer from a preferred server if the other server
> >>> answers first? Thanks.

IMHO it doesn't really work in general to have multiple (standalone)
DHCP servers in one network.
Perhaps/probably it works if there is no absolutely dynamical allocation
from pools but only static ones which are identical across all DHCP
servers (as some kind of high-availability).

> >> There are multiple userspace implementations of DHCP, and the kernel
> >> does not usually get involved at all. You'll therefore have to ask
> >> the folks who write and maintain the various DHCP implementations.
> >
> > What about netbooting? Or are you expecting people to use initramfs with
> > a userspace implementation?
> 
> Normally with PXE boot it's the PXE ROM that initially gets the IP 
> address. After the kernel boots up, userspace normally repeats the process.

I would assume that PXE ROMs also take the first received DHCPOFFER and
use it.

>From DHCPs point of view, it is the clients decision which DHCPOFFER it
honors or chooses to ignore (and the servers decision it it actually
sends an DHCPOFFER).

In reality (and e.g. for ISCs dhclient), usually the first received one
will be used (because it's the easiest to implement, it avoids the
problems with deciding how long to wait, takes less time on bootup
because there is no unnecessary timeout!) and last time I looked into it
(which was quite time ago ...), there was no feature to filter or
(securely) authenticate anything (which would actually make sense as the
client could detect invalid DCHP offers from rogue DHCP servers. Lots of
devices have such a beast on board nowadays and I wouldn't bet that all
of them are deactivated per default).

	Bernd
-- 
Bernd Petrovitsch                  Email : bernd@petrovitsch.priv.at
                     LUGA : http://www.luga.at

