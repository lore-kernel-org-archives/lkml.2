Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751944Ab1JYQc2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 12:32:28 -0400
Received: from slb-smtpout-01.boeing.com ([130.76.64.48]:48863 "EHLO
	slb-smtpout-01.boeing.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751375Ab1JYQc1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 12:32:27 -0400
X-Greylist: delayed 1860 seconds by postgrey-1.27 at vger.kernel.org; Tue, 25 Oct 2011 12:32:26 EDT
From: "Moffett, Kyle D" <Kyle.D.Moffett@boeing.com>
To: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>,
        Kuninori Morimoto <morimoto.kuninori@renesas.com>
Date: Tue, 25 Oct 2011 11:00:31 -0500
Subject: Re: [RFC PATCH 11/17] sh_eth: Don't unnecessarily reset the PHY
Thread-Topic: [RFC PATCH 11/17] sh_eth: Don't unnecessarily reset the PHY
Thread-Index: AcyTLzrTTT7Jh6JuTSin8uil1x4POg==
Message-ID: <47C02D56-BA6A-4568-8676-E979A13CBD0B@boeing.com>
References: <1319144425-15547-1-git-send-email-Kyle.D.Moffett@boeing.com>
 <1319144425-15547-12-git-send-email-Kyle.D.Moffett@boeing.com>
 <4EA69972.4090004@renesas.com>
In-Reply-To: <4EA69972.4090004@renesas.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Oct 25, 2011, at 07:11, Yoshihiro Shimoda wrote:
> 2011/10/21 6:00, Kyle Moffett wrote:
>> Signed-off-by: Kyle Moffett <Kyle.D.Moffett@boeing.com>
>> ---
>> drivers/net/sh_eth.c |   19 +------------------
>> 1 files changed, 1 insertions(+), 18 deletions(-)
>> 
>> diff --git a/drivers/net/sh_eth.c b/drivers/net/sh_eth.c
>> index 1c1666e..7ef4378 100644
>> --- a/drivers/net/sh_eth.c
>> +++ b/drivers/net/sh_eth.c
>> @@ -1235,23 +1235,6 @@ static int sh_eth_phy_init(struct net_device *ndev)
>> 	return 0;
>> }
>> 
>> -/* PHY control start function */
>> -static int sh_eth_phy_start(struct net_device *ndev)
>> -{
>> -	struct sh_eth_private *mdp = netdev_priv(ndev);
>> -	int ret;
>> -
>> -	ret = sh_eth_phy_init(ndev);
>> -	if (ret)
>> -		return ret;
>> -
>> -	/* reset phy - this also wakes it from PDOWN */
>> -	phy_write(mdp->phydev, MII_BMCR, BMCR_RESET);
>> -	phy_start(mdp->phydev);
> 
> I think that the driver needs the phy_start().
> So, I removed the phy_write() only. Then, the driver could work correctly.
> 
> Therefore, I would to remove the following code only.
> Do you think about this?
> 
>> -	/* reset phy - this also wakes it from PDOWN */
>> -	phy_write(mdp->phydev, MII_BMCR, BMCR_RESET);

You're right, sorry about that.  I think I mis-merged this when I rebased
from a much earlier commit.  The simple removal of the BMCR_RESET write
should achieve what I was intending.

Cheers,
Kyle Moffett

--
Curious about my work on the Debian powerpcspe port?
I'm keeping a blog here: http://pureperl.blogspot.com/

