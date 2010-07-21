Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754186Ab0GUSaz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 14:30:55 -0400
Received: from stargate.chelsio.com ([67.207.112.58]:12757 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131Ab0GUSax (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 14:30:53 -0400
From: Casey Leedom <leedom@chelsio.com>
Organization: Chelsio Communications, Inc.
To: David Miller <davem@davemloft.net>
Subject: Re: [PATCH net-next] sysfs: add entry to indicate network interfaces with random MAC address
Date: Wed, 21 Jul 2010 11:29:47 -0700
User-Agent: KMail/1.13.2 (Linux/2.6.32-23-generic; KDE/4.4.2; x86_64; ; )
Cc: shemminger@vyatta.com, andy@greyhouse.net, harald@redhat.com,
        bhutchings@solarflare.com, sassmann@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, gospo@redhat.com,
        gregory.v.rose@intel.com, alexander.h.duyck@intel.com
References: <20100721150732.GR7497@gospo.rdu.redhat.com> <20100721102816.4bef5ada@nehalam> <20100721.103249.107094774.davem@davemloft.net>
In-Reply-To: <20100721.103249.107094774.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201007211129.48288.leedom@chelsio.com>
X-OriginalArrivalTime: 21 Jul 2010 18:29:49.0315 (UTC) FILETIME=[B3C8DD30:01CB2902]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

| From: David Miller <davem@davemloft.net>
| Date: Wednesday, July 21, 2010 10:32 am
| 
| From: Stephen Hemminger <shemminger@vyatta.com>
| Date: Wed, 21 Jul 2010 10:28:16 -0700
| 
| > IMHO no local assigned address should be used by udev. The cxgb4 driver
| > should be using random value.
| > 
| > Does anyone have an example of locally assigned address that has
| > persistence so that udev could use it.
| 
| The cxgb4 vf addresses are not random because they are fetched from the
| card's NVRAM/EEPROM/firmware/whatever and thus are persistent.
| 
| We definitely want udev to use persistent rules for them.
|
| This whole issue only exists because of the Intel VF case, where it
| lacks persistent addresses but somehow we want to assign persistent
| names to it's VF interfaces.

  Yes, we _explicitly_ wanted to have persistent MAC Addresses for our PCI-E SR-
IOV Virtual Functions for a whole raft of reasons.  The two most important were:

 1. Linux' model for persistent device naming today seems to be
    oriented around persistent network device addresses.

 2. Lots of data centers use MAC addresses for things like DHCP/BOOTP,
    security/filtering, etc.

Our design goal was to look as much like a normal Ethernet MAC as possible in 
order to reduce the need for software/behavior changes.

| One idea I've proposed in other discussions about this is that if the
| address is not persistent (either via the MAC address bit or the sysfs
| value we're thinking of providing here) we use the device's geographic
| location ("device path") as the key for udev stuff.

  Another option might be to have a new Net Device Operations call to ask the 
adapter for a Unique Key.  This could be formed for most devices via a tuple of 
the {PCI Vendor ID, PCI Device ID, Adapter Serial Number, Port Number, [and if 
applicable] Adapter Function ID}.  Of course this could be a fairly long string 
... :-)

Casey
