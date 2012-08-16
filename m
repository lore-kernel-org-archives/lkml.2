Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933441Ab2HPVsN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 17:48:13 -0400
Received: from incomingmail.riverbed.com ([208.70.196.45]:12395 "EHLO
	smtp1.riverbed.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756537Ab2HPVsM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 17:48:12 -0400
From: Jiang Wang <Jiang.Wang@riverbed.com>
To: Michael Chan <mchan@broadcom.com>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chaitanya Lala <Chaitanya.Lala@riverbed.com>,
        "Francis St. Amant" <Francis.St.Amant@riverbed.com>
Subject: RE: [PATCH] bnx2: turn off the network statck during initialization
Thread-Topic: [PATCH] bnx2: turn off the network statck during initialization
Thread-Index: AQHNe9wN/GY2GzvEwk20Q1fuXq+2eJddP4KA//+NcgCAAHtYAP//kWDwgACL2ID//48v0A==
Date: Thu, 16 Aug 2012 21:48:01 +0000
Message-ID: <CEE05A0D7856E14880AD5560634EBEA834DB2C2B@SFO1EXC-MBXP06.nbttech.com>
References: <1345141295-7589-1-git-send-email-Jiang.Wang@riverbed.com>
 <1345143431.6916.36.camel@LTIRV-MCHAN1.corp.ad.broadcom.com>
 <CEE05A0D7856E14880AD5560634EBEA834DB2ABC@SFO1EXC-MBXP06.nbttech.com>
 <1345145318.6916.42.camel@LTIRV-MCHAN1.corp.ad.broadcom.com>
 <CEE05A0D7856E14880AD5560634EBEA834DB2B40@SFO1EXC-MBXP06.nbttech.com>
 <1345151593.6916.62.camel@LTIRV-MCHAN1.corp.ad.broadcom.com>
In-Reply-To: <1345151593.6916.62.camel@LTIRV-MCHAN1.corp.ad.broadcom.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.16.205.254]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2012-08-16 at 20:28 +0000, Jiang Wang wrote:
> Also, I have another comment related to link state.
> 
> Right now, the bnx2 driver powers up the device in bnx2_init_board(), 
> regardless the netif_carrier is on or off.

We actually don't power up the device.  bnx2_init_board() just probes the device.  If link is already up, it will stay up.  If it is down, it will stay down.

---- I see. I was confused by the name of bnx2_set_power_state()  and I think the PHY is actually powered up by bnx2_reset_nic, right?

> This may introduce following inconsistent behaviors:
> 1) suppose the cable is plugged in to the NIC and the other end is 
> connected to a switch
> 2) user powers up the box

The link may already be up before or when you power up the box because of management firmware (iLO, etc) or WoL.

---- OK.

> 3) the Linux does not bring up the interface; i.e, ifconfig ethx shows 
> it is down
> 4) ethtool ethx will show no link
> 5) if the user goes to check the light on the physical NIC, he will 
> see the green link light is ON. That means the link is up, right?
> 
> I think it is better to power down the device until bnx2_open is 
> called. In this way, ethtool report and the physical link light will 
> be consistent.

We cannot power it down.  If link is up, it is up for a reason (e.g. it is an iLO port, etc).

---- OK. 


Thanks.


