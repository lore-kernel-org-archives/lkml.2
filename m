Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752554Ab2AZLCH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 06:02:07 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:50769 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751275Ab2AZLCF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 06:02:05 -0500
MIME-Version: 1.0
In-Reply-To: <20120125.213609.1699401522361877843.davem@davemloft.net>
References: <30372884.681327480899559.JavaMail.root@5-MeO-DMT.ynet.sk>
 <26709175.701327480995351.JavaMail.root@5-MeO-DMT.ynet.sk> <20120125.213609.1699401522361877843.davem@davemloft.net>
From: =?ISO-8859-2?Q?=A9tefan_Gula?= <steweg@ynet.sk>
Date: Thu, 26 Jan 2012 12:01:44 +0100
X-Google-Sender-Auth: 67jSVMt6OWKpjYXbXrtjufWLE40
Message-ID: <CAGsizzLxWbCqKxMTc-_-7MDmWg_VgP63ZBmi7P2z_Y7YMtrehg@mail.gmail.com>
Subject: Re: [patch v1, kernel 3.2.1] RTNETLINK adjusting values of min_ifinfo_dump_size
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/1/26 David Miller <davem@davemloft.net>:
> From: Stefan Gula <steweg@ynet.sk>
> Date: Wed, 25 Jan 2012 09:43:15 +0100 (CET)
>
>> From: Stefan Gula <steweg@gmail.com>
>>
>> This patch extends the rtnetlink.c. The problem is that calcit, which
>> returns the value min_ifinfo_dump_size, is called without ability to
>> get device info as well (struct net_device *dev is not accessible from
>> it). This create a problem if required size of struct sk_buff *skb is
>> not enough big to comply with all data returned by fill_info function
0>> for the interface that required size can vary over time, e.g. some
>> dynamic structures will be putted to skb like hlists or lists. To do
>> this patch extends the do_setlink function with recalculating of
>> min_ifinfo_dump_size accordingly to device type and get_size
>> functions.
>>
>> Signed-off-by: Stefan Gula <steweg@gmail.com>
>
> This commit message is terrible, and the reason I know it's terrible
> is because even after reading it I still had to go read the code
> in order to understand what your change even does or why it's even
> necessary.
>
> How about this:
>
>        Setting link parameters on a netdevice changes the value
>        of if_nlmsg_size(), therefore it is necessary to recalculate
>        min_ifinfo_dump_size.
>
Sound good... do I have to resubmit the patch with the correct description?
