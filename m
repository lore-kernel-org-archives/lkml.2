Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755467Ab1FIHMg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 03:12:36 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:60129 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752569Ab1FIHMe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 03:12:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=wbPqqjUR7DEkJECTv0ggWMlsdhY9usDmx2UZzyi3YZliBJPpJqKs1MWuUdXpIpITF2
         SJ+/UpomZGy4OdYjKgAEfraDF7uVT9TrnBTEqp1elblKU6Whlg3MnFfCM8NXiPGn4sgC
         TaPOWwkzudU/v5CQsA0Ggr5alaiaC98f5J9Hs=
Message-ID: <4DF0728A.9010702@gmail.com>
Date: Thu, 09 Jun 2011 15:13:14 +0800
From: WeipingPan <panweiping3@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: Weiping Pan <panweiping3@gmail.com>
CC: fubar@us.ibm.com, andy@greyhouse.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 net-next 0/5] bonding:use latest lacp_rate and ad_select,
References: <cover.1307601948.git.panweiping3@gmail.com>
In-Reply-To: <cover.1307601948.git.panweiping3@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/09/2011 03:03 PM, Weiping Pan wrote:
> There is bug that when you modify lacp_rate via sysfs,
> 802.3ad won't use the new value of lacp_rate to transmit packets.
> This is because port->actor_oper_port_state isn't changed.
>
> As for ad_select, it can work,
> but both struct bond_params and ad_bond_info have lacp_fast and ad_select,
> they are duplicate and need extra synchronization.
> 802.3ad can get them from bond_params directly every time.
>
> And ad_timer and arp_mon_pt aren't used any more, just delete them.
>
> changelog:
> v2:
> add bond_3ad_update_lacp_rate() as a helper function,
> and hold bond->lock when iterates slave list.
>
> v3:
> delete duplicate lacp_fast and agg_select_mode from struct ad_bond_info.
>
> v4:
> delete unused ad_timer and arp_mon_pt.
>
> Weiping Pan (5):
>    bonding: make 802.3ad use latest lacp_rate
>    bonding:delete lacp_fast from ad_bond_info
>    bonding:delete agg_select_mode from ad_bond_info
>    bonding: delete unused ad_timer
>    bonding: delete unused arp_mon_pt
>
>   drivers/net/bonding/bond_3ad.c   |   41 ++++++++++++++++++++++++++++++++-----
>   drivers/net/bonding/bond_3ad.h   |    8 +-----
>   drivers/net/bonding/bond_main.c  |    3 +-
>   drivers/net/bonding/bond_sysfs.c |    1 +
>   drivers/net/bonding/bonding.h    |    1 -
>   5 files changed, 39 insertions(+), 15 deletions(-)
>
Oh, my god, it's messy, I will resend the patch set.
sorry

Weiping Pan
