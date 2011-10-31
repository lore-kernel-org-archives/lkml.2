Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933270Ab1JaVZR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 17:25:17 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:60997 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752225Ab1JaVZP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 17:25:15 -0400
From: Jay Vosburgh <fubar@us.ibm.com>
To: Ben Hutchings <bhutchings@solarflare.com>
cc: Weiping Pan <wpan@redhat.com>, netdev@vger.kernel.org, andy@greyhouse.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] bonding:update speed/duplex for NETDEV_CHANGE
In-reply-to: <1320094108.2735.15.camel@bwh-desktop>
References: <4EAE0D9A.9060408@gmail.com> <e00468a2cbb8a25d7a89028e876769449454309f.1320070684.git.wpan@redhat.com> <1320084906.2735.9.camel@bwh-desktop> <14973.1320093129@death> <1320094108.2735.15.camel@bwh-desktop>
Comments: In-reply-to Ben Hutchings <bhutchings@solarflare.com>
   message dated "Mon, 31 Oct 2011 20:48:28 -0000."
X-Mailer: MH-E 8.2; nmh 1.3; GNU Emacs 23.2.1
Date: Mon, 31 Oct 2011 14:23:08 -0700
Message-ID: <16441.1320096188@death>
x-cbid: 11103121-8974-0000-0000-000001487469
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ben Hutchings <bhutchings@solarflare.com> wrote:

>On Mon, 2011-10-31 at 13:32 -0700, Jay Vosburgh wrote:
>[...]
>> 	This particular case arises only during enslavement.  The call
>> to bond_update_speed_duplex call has failed, but the device is marked by
>> bonding to be up.  Bonding complains that the device isn't down, but it
>> cannot get speed and duplex, and therefore is assuming them to be
>> 100/Full.
>> 
>> 	The catch is that this happens only for the ARP monitor, because
>> it initially presumes a slave to be up regardless of actual carrier
>> state (for historical reasons related to very old 10 or 10/100 drivers,
>> prior to the introduction of netif_carrier_*).
>
>Right, I gathered that.  Is there any reason to use the ARP monitor when
>all slaves support link state notification?  Maybe the bonding
>documentation should recommend miimon in section 7, not just in section
>2.

	The ARP monitor can validate that traffic actually flows from
the slave to some destination in the switch domain (and back), so, for
example, it's useful in cases that multiple switch hops exist between
the host and the local router.  A link failure in the middle of the path
won't affect carrier on the local device, but still may cause a
communications break.

	-J

---
	-Jay Vosburgh, IBM Linux Technology Center, fubar@us.ibm.com

