Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932723Ab0GTVSa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 17:18:30 -0400
Received: from mail.vyatta.com ([76.74.103.46]:38754 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932695Ab0GTVS2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 17:18:28 -0400
Date: Tue, 20 Jul 2010 14:18:16 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: David Miller <davem@davemloft.net>
Cc: bhutchings@solarflare.com, sassmann@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, gospo@redhat.com,
        gregory.v.rose@intel.com, alexander.h.duyck@intel.com,
        leedom@chelsio.com, harald@redhat.com
Subject: Re: [PATCH net-next] sysfs: add entry to indicate network
 interfaces with random MAC address
Message-ID: <20100720141816.16f0a939@nehalam>
In-Reply-To: <20100720.131748.51255156.davem@davemloft.net>
References: <1279627656.2110.13.camel@achroite.uk.solarflarecom.com>
	<4C45996B.3000003@redhat.com>
	<1279636194.2110.45.camel@achroite.uk.solarflarecom.com>
	<20100720.131748.51255156.davem@davemloft.net>
Organization: Vyatta
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Jul 2010 13:17:48 -0700 (PDT)
David Miller <davem@davemloft.net> wrote:

> From: Ben Hutchings <bhutchings@solarflare.com>
> Date: Tue, 20 Jul 2010 15:29:54 +0100
> 
> > On Tue, 2010-07-20 at 14:41 +0200, Stefan Assmann wrote:
> >> Btw, the driver itself could also alter the flag. Then we'd have a well
> >> defined way of setting a stable address.
> > 
> > The driver can't know whether an address assigned by the user is stable.
> 
> If userspace can somehow obtain a persistent address, it can kick
> udev too.
> 
> I really don't see any real value provided by letting userspace mess
> with this.  Because the permanence communicated in this value is from
> the perspective of the kernel driver, it's really therefore about the
> thing that's in ->perm_addr[] not what happens to be in ->addr[] right
> now.

No one mentioned that the first octet of an Ethernet address already
indicates "software generated" Ethernet address. Per the standard,
if bit 1 is set it means address is locally assigned.

static inline bool is_locally_assigned_ether(const u8 *addr)
{
	return (addr[0] & 0x2) != 0;
}
