Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755311Ab2DNSZc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 14:25:32 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:59276 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752253Ab2DNSZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 14:25:31 -0400
Date: Sat, 14 Apr 2012 14:24:13 -0400 (EDT)
Message-Id: <20120414.142413.168675709062216981.davem@davemloft.net>
To: bhutchings@solarflare.com
Cc: xiong@qca.qualcomm.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, qca-linux-team@qualcomm.com,
        nic-devel@qualcomm.com
Subject: Re: [PATCH 04/37] atl1c: remove VPD register
From: David Miller <davem@davemloft.net>
In-Reply-To: <1334413369.7150.422.camel@deadeye>
References: <20120413.204551.959091962456153270.davem@davemloft.net>
	<157393863283F442885425D2C454285623D486D9@nasanexd02a.na.qualcomm.com>
	<1334413369.7150.422.camel@deadeye>
X-Mailer: Mew version 6.4 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sat, 14 Apr 2012 11:24:53 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Hutchings <bhutchings@solarflare.com>
Date: Sat, 14 Apr 2012 15:22:49 +0100

> On Sat, 2012-04-14 at 09:12 +0000, Huang, Xiong wrote:
>> 
>> > -----Original Message-----
>> > From: David Miller [mailto:davem@davemloft.net]
>> > Sent: Saturday, April 14, 2012 8:46
>> > To: Huang, Xiong
>> > Cc: netdev@vger.kernel.org; linux-kernel@vger.kernel.org; qca-linux-team; nic-
>> > devel
>> > Subject: Re: [PATCH 04/37] atl1c: remove VPD register
>> > 
>> > From: xiong <xiong@qca.qualcomm.com>
>> > Date: Fri, 13 Apr 2012 08:14:29 +0800
>> > 
>> > > VPD register is only used for L1(devid=PCI_DEVICE_ID_ATTANSIC_L1) to
>> > > access external NV-memory.
>> > > l1c & later chip doesn't use it any more.
>> > >
>> > > Signed-off-by: xiong <xiong@qca.qualcomm.com>
>> > > Tested-by: Liu David <dwliu@qca.qualcomm.com>
>> > 
>> > You just broke ethtool register dumps with this change.
>> > 
>> > Now, all the initial registers are reported offset by one entry, yet the last two are
>> > still reported in their original spots.
>> > 
>> > This layout is exposed to userspace, and interpreted by tools, and you cannot
>> > change it.
>> > 
>> > If this register always reports some value, you should just keep it there in the
>> > dumps.
>> >
>> The VPD register doesn't report anything :(, just a dummy register now.
>> we don't have any special tools in userspace to explain the dumped registers.
>> Actually the purpose of dumping these registers via ethtool is just for debug.
> [...]
> 
> Of course, the whole purpose of the operation is for debugging.  But you
> should bump the dump version number (currently 0) every time you change
> the offsets of registers in the dump.

And also update the size, and not leave any holes between the actually
used register slots, etc.
