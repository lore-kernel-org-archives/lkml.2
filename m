Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753393Ab2AZSar (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 13:30:47 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:33309 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660Ab2AZSap convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 13:30:45 -0500
Date: Thu, 26 Jan 2012 13:30:43 -0500 (EST)
Message-Id: <20120126.133043.1328427160816607242.davem@davemloft.net>
To: steweg@ynet.sk
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch v1, kernel 3.2.1] RTNETLINK adjusting values of
 min_ifinfo_dump_size
From: David Miller <davem@davemloft.net>
In-Reply-To: <CAGsizzLxWbCqKxMTc-_-7MDmWg_VgP63ZBmi7P2z_Y7YMtrehg@mail.gmail.com>
References: <26709175.701327480995351.JavaMail.root@5-MeO-DMT.ynet.sk>
	<20120125.213609.1699401522361877843.davem@davemloft.net>
	<CAGsizzLxWbCqKxMTc-_-7MDmWg_VgP63ZBmi7P2z_Y7YMtrehg@mail.gmail.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-15
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 26 Jan 2012 10:30:45 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: ¦tefan Gula <steweg@ynet.sk>
Date: Thu, 26 Jan 2012 12:01:44 +0100

> 2012/1/26 David Miller <davem@davemloft.net>:
>> From: Stefan Gula <steweg@ynet.sk>
>> Date: Wed, 25 Jan 2012 09:43:15 +0100 (CET)
>>
>>> From: Stefan Gula <steweg@gmail.com>
>>>
>>> This patch extends the rtnetlink.c. The problem is that calcit, which
>>> returns the value min_ifinfo_dump_size, is called without ability to
>>> get device info as well (struct net_device *dev is not accessible from
>>> it). This create a problem if required size of struct sk_buff *skb is
>>> not enough big to comply with all data returned by fill_info function
> 0>> for the interface that required size can vary over time, e.g. some
>>> dynamic structures will be putted to skb like hlists or lists. To do
>>> this patch extends the do_setlink function with recalculating of
>>> min_ifinfo_dump_size accordingly to device type and get_size
>>> functions.
>>>
>>> Signed-off-by: Stefan Gula <steweg@gmail.com>
>>
>> This commit message is terrible, and the reason I know it's terrible
>> is because even after reading it I still had to go read the code
>> in order to understand what your change even does or why it's even
>> necessary.
>>
>> How about this:
>>
>>        Setting link parameters on a netdevice changes the value
>>        of if_nlmsg_size(), therefore it is necessary to recalculate
>>        min_ifinfo_dump_size.
>>
> Sound good... do I have to resubmit the patch with the correct description?

Yes.
