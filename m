Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753367Ab1JUHNP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Oct 2011 03:13:15 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:62130 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347Ab1JUHNO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Oct 2011 03:13:14 -0400
MIME-Version: 1.0
In-Reply-To: <1319153279.2918.16.camel@deadeye>
References: <1319144425-15547-1-git-send-email-Kyle.D.Moffett@boeing.com>
 <1319144425-15547-16-git-send-email-Kyle.D.Moffett@boeing.com> <1319153279.2918.16.camel@deadeye>
From: Kyle Moffett <kyle@moffetthome.net>
Date: Fri, 21 Oct 2011 03:12:53 -0400
Message-ID: <CAGZ=bqKMGnf1SaPHrgaNYTaaq-axA-1bbOWeZfThwZgWUy8weA@mail.gmail.com>
Subject: Re: [RFC PATCH 15/17] phy_device: Add "port" and "transciever" fields
To: Ben Hutchings <bhutchings@solarflare.com>
Cc: Kyle Moffett <Kyle.D.Moffett@boeing.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        David Decotigny <decot@google.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Mike Frysinger <vapier@gentoo.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 20, 2011 at 19:27, Ben Hutchings <bhutchings@solarflare.com> wrote:
> On Thu, 2011-10-20 at 17:00 -0400, Kyle Moffett wrote:
>> Some PHYs have multiple software-selectable inputs and outputs,
>> including RGMII, SGMII, SerDes, etc.  New fields are added to the
>> "struct phy_device" for "port" and "transciever" to allow "ethtool" to
>> switch outputs at runtime.  The defaults for the new fields are
>> identical to the hardcoded values used previously.
>>
>> This should make no functional changes to the PHY layer behavior, but
>> it will allow later PHY/ethernet drivers to override those fields.
>>
>> Signed-off-by: Kyle Moffett <Kyle.D.Moffett@boeing.com>
>> ---
>>  drivers/net/phy/phy.c        |    4 ++--
>>  drivers/net/phy/phy_device.c |    2 ++
>>  include/linux/phy.h          |    4 ++++
>>  3 files changed, 8 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
>> index c378f91..5f72055 100644
>> --- a/drivers/net/phy/phy.c
>> +++ b/drivers/net/phy/phy.c
>> @@ -290,9 +290,9 @@ int phy_ethtool_gset(struct phy_device *phydev, struct ethtool_cmd *cmd)
>>
>>       ethtool_cmd_speed_set(cmd, phydev->speed);
>>       cmd->duplex = phydev->duplex;
>> -     cmd->port = PORT_MII;
>> +     cmd->port = phydev->port;
>>       cmd->phy_address = phydev->addr;
>> -     cmd->transceiver = XCVR_EXTERNAL;
>> +     cmd->transceiver = phydev->transciever;
>
> 'transceiver' is spelt thus.

Oh shoot!

That's what I get for trying to do a last-minute patch edit before
sending the email; thanks for pointing it out!

Cheers,
Kyle Moffett

-- 
Curious about my work on the Debian powerpcspe port?
I'm keeping a blog here: http://pureperl.blogspot.com/
