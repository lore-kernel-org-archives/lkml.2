Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757006Ab0GURcj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 13:32:39 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52588
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755613Ab0GURcd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 13:32:33 -0400
Date: Wed, 21 Jul 2010 10:32:49 -0700 (PDT)
Message-Id: <20100721.103249.107094774.davem@davemloft.net>
To: shemminger@vyatta.com
Cc: leedom@chelsio.com, andy@greyhouse.net, harald@redhat.com,
        bhutchings@solarflare.com, sassmann@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, gospo@redhat.com,
        gregory.v.rose@intel.com, alexander.h.duyck@intel.com
Subject: Re: [PATCH net-next] sysfs: add entry to indicate network
 interfaces with random MAC address
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100721102816.4bef5ada@nehalam>
References: <20100721150732.GR7497@gospo.rdu.redhat.com>
	<201007210934.27986.leedom@chelsio.com>
	<20100721102816.4bef5ada@nehalam>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Hemminger <shemminger@vyatta.com>
Date: Wed, 21 Jul 2010 10:28:16 -0700

> IMHO no local assigned address should be used by udev. The cxgb4 driver
> should be using random value.
> 
> Does anyone have an example of locally assigned address that has persistence
> so that udev could use it.

The cxgb4 vf addresses are not random because they are fetched from the
card's NVRAM/EEPROM/firmware/whatever and thus are persistent.

We definitely want udev to use persistent rules for them.

This whole issue only exists because of the Intel VF case, where it
lacks persistent addresses but somehow we want to assign persistent
names to it's VF interfaces.

One idea I've proposed in other discussions about this is that if the
address is not persistent (either via the MAC address bit or the sysfs
value we're thinking of providing here) we use the device's geographic
location ("device path") as the key for udev stuff.
