Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756630Ab1FIWD2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 18:03:28 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:53552 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755444Ab1FIWD1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 18:03:27 -0400
Date: Thu, 09 Jun 2011 15:03:19 -0700 (PDT)
Message-Id: <20110609.150319.1816839671339957224.davem@davemloft.net>
To: fubar@us.ibm.com
Cc: panweiping3@gmail.com, andy@greyhouse.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 net-next 0/5] bonding:use latest lacp_rate and
 ad_select and delete unused ad_timer and arp_mon_pt
From: David Miller <davem@davemloft.net>
In-Reply-To: <31665.1307656691@death>
References: <cover.1307603621.git.panweiping3@gmail.com>
	<31665.1307656691@death>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 09 Jun 2011 15:03:20 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jay Vosburgh <fubar@us.ibm.com>
Date: Thu, 09 Jun 2011 14:58:11 -0700

> Weiping Pan <panweiping3@gmail.com> wrote:
> 
>>There is bug that when you modify lacp_rate via sysfs,
>>802.3ad won't use the new value of lacp_rate to transmit packets.
>>This is because port->actor_oper_port_state isn't changed.
>>
>>As for ad_select, it can work,
>>but both struct bond_params and ad_bond_info have lacp_fast and ad_select,
>>they are duplicate and need extra synchronization.
>>802.3ad can get them from bond_params directly every time.
>>
>>And ad_timer and arp_mon_pt aren't used any more, just delete them.
>>
>>changelog:
>>v2:
>>add bond_3ad_update_lacp_rate() as a helper function,
>>and hold bond->lock when iterates slave list.
>>
>>v3:
>>delete duplicate lacp_fast and agg_select_mode from struct ad_bond_info.
>>
>>v4:
>>delete unused ad_timer and arp_mon_pt.
> 
> 	All patches in the series look reasonable.
> 
> Signed-off-by: Jay Vosburgh <fubar@us.ibm.com>

All applied, thanks everyone.
