Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752612Ab2BZCd1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Feb 2012 21:33:27 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:49127 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966Ab2BZCd0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Feb 2012 21:33:26 -0500
Date: Sat, 25 Feb 2012 21:28:05 -0500 (EST)
Message-Id: <20120225.212805.1394065389987976077.davem@davemloft.net>
To: baruch@tkos.co.il
Cc: stigge@antcom.de, jeffrey.t.kirsher@intel.com, alexander.h.duyck@intel.com,
        eilong@broadcom.com, ian.campbell@citrix.com, netdev@vger.kernel.org,
        w.sang@pengutronix.de, linux-kernel@vger.kernel.org,
        kevin.wells@nxp.com, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2] ARM: LPC32xx: Ethernet driver
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120226015217.GA3257@tarshish>
References: <1330201304-24037-1-git-send-email-stigge@antcom.de>
	<20120226015217.GA3257@tarshish>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sat, 25 Feb 2012 18:28:32 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Baruch Siach <baruch@tkos.co.il>
Date: Sun, 26 Feb 2012 03:52:18 +0200

> Hi Roland,
> 
> On Sat, Feb 25, 2012 at 09:21:44PM +0100, Roland Stigge wrote:
>> This patch adds an ethernet driver for the LPC32xx ARM SoC.
>> 
>> Signed-off-by: Roland Stigge <stigge@antcom.de>
> 
> [snip]
> 
>> +static int __init ethaddr(char *s)
>> +{
>> +	int i;
>> +	unsigned int r[6];
>> +
>> +	sscanf(s, "%x:%x:%x:%x:%x:%x",
>> +			&r[0], &r[1], &r[2], &r[3], &r[4], &r[5]);
>> +	for (i = 0; i < 6; i++)
>> +		mac_address[i] = (u8)r[i];
>> +
>> +	return 1;
>> +}
>> +__setup("ethaddr=", ethaddr);
> 
> Please use a module_param() instead of a top level kernel parameter.

Actually, remove this entirely, we don't add module parameters
to force the ethernet address.  That should be done in userland
in some fashion.

We've had many discussions about this recently, and this is the
consistent policy we want to enforce in all drivers from now on.
