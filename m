Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934685Ab1JaWlp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 18:41:45 -0400
Received: from mail.solarflare.com ([216.237.3.220]:36239 "EHLO
	exchange.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934441Ab1JaWln (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 18:41:43 -0400
Subject: Re: [PATCH] bonding:update speed/duplex for NETDEV_CHANGE
From: Ben Hutchings <bhutchings@solarflare.com>
To: Jay Vosburgh <fubar@us.ibm.com>
CC: Weiping Pan <wpan@redhat.com>, <netdev@vger.kernel.org>,
        <andy@greyhouse.net>, <linux-kernel@vger.kernel.org>
In-Reply-To: <16441.1320096188@death>
References: <4EAE0D9A.9060408@gmail.com>
	 <e00468a2cbb8a25d7a89028e876769449454309f.1320070684.git.wpan@redhat.com>
	 <1320084906.2735.9.camel@bwh-desktop> <14973.1320093129@death>
	 <1320094108.2735.15.camel@bwh-desktop>  <16441.1320096188@death>
Content-Type: text/plain; charset="UTF-8"
Organization: Solarflare Communications
Date: Mon, 31 Oct 2011 22:41:39 +0000
Message-ID: <1320100899.2735.19.camel@bwh-desktop>
MIME-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.137]
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-6.500.1024-18482.005
X-TM-AS-Result: No--27.914400-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-OriginalArrivalTime: 31 Oct 2011 22:41:43.0392 (UTC) FILETIME=[43633E00:01CC981E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-10-31 at 14:23 -0700, Jay Vosburgh wrote:
> Ben Hutchings <bhutchings@solarflare.com> wrote:
> 
> >On Mon, 2011-10-31 at 13:32 -0700, Jay Vosburgh wrote:
> >[...]
> >> 	This particular case arises only during enslavement.  The call
> >> to bond_update_speed_duplex call has failed, but the device is marked by
> >> bonding to be up.  Bonding complains that the device isn't down, but it
> >> cannot get speed and duplex, and therefore is assuming them to be
> >> 100/Full.
> >> 
> >> 	The catch is that this happens only for the ARP monitor, because
> >> it initially presumes a slave to be up regardless of actual carrier
> >> state (for historical reasons related to very old 10 or 10/100 drivers,
> >> prior to the introduction of netif_carrier_*).
> >
> >Right, I gathered that.  Is there any reason to use the ARP monitor when
> >all slaves support link state notification?  Maybe the bonding
> >documentation should recommend miimon in section 7, not just in section
> >2.
> 
> 	The ARP monitor can validate that traffic actually flows from
> the slave to some destination in the switch domain (and back), so, for
> example, it's useful in cases that multiple switch hops exist between
> the host and the local router.  A link failure in the middle of the path
> won't affect carrier on the local device, but still may cause a
> communications break.

Then the ARP monitor should gracefully handle the case where a new slave
has link down, as proposed.

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

