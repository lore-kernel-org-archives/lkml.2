Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755510Ab2DQIgp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 04:36:45 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:56688 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755347Ab2DQIgn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 04:36:43 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6683"; a="182318475"
X-IronPort-AV: E=Sophos;i="4.75,432,1330934400"; 
   d="scan'208";a="303085805"
From: "Huang, Xiong" <xiong@qca.qualcomm.com>
To: Ben Hutchings <bhutchings@solarflare.com>
CC: David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        qca-linux-team <qca-linux-team@qualcomm.com>,
        nic-devel <nic-devel@qualcomm.com>
Subject: RE: [PATCH 04/37] atl1c: remove VPD register
Thread-Topic: [PATCH 04/37] atl1c: remove VPD register
Thread-Index: AQHNGQqSFrw7Qq1rE0KxsIfaXt7JDZaZ8ySAgAAUkECAAM+ygIAD4NZV
Date: Tue, 17 Apr 2012 08:36:41 +0000
Message-ID: <157393863283F442885425D2C454285623D576A2@nasanexd02a.na.qualcomm.com>
References: <1334276102-15866-1-git-send-email-xiong@qca.qualcomm.com>
	 <1334276102-15866-5-git-send-email-xiong@qca.qualcomm.com>
	 <20120413.204551.959091962456153270.davem@davemloft.net>
	 <157393863283F442885425D2C454285623D486D9@nasanexd02a.na.qualcomm.com>,<1334413369.7150.422.camel@deadeye>
In-Reply-To: <1334413369.7150.422.camel@deadeye>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [199.106.114.10]
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q3H8aw4Y008762

Ok, I will update it. thanks a lot

-Xiong
________________________________________
·¢¼şÈË: Ben Hutchings [bhutchings@solarflare.com]
·¢ËÍÊ±¼ä: 2012Äê4ÔÂ14ÈÕ 22:22
ÊÕ¼şÈË: Huang, Xiong
Cc: David Miller; netdev@vger.kernel.org; linux-kernel@vger.kernel.org; qca-linux-team; nic-devel
Ö÷Ìâ: RE: [PATCH 04/37] atl1c: remove VPD register

On Sat, 2012-04-14 at 09:12 +0000, Huang, Xiong wrote:
>
> > -----Original Message-----
> > From: David Miller [mailto:davem@davemloft.net]
> > Sent: Saturday, April 14, 2012 8:46
> > To: Huang, Xiong
> > Cc: netdev@vger.kernel.org; linux-kernel@vger.kernel.org; qca-linux-team; nic-
> > devel
> > Subject: Re: [PATCH 04/37] atl1c: remove VPD register
> >
> > From: xiong <xiong@qca.qualcomm.com>
> > Date: Fri, 13 Apr 2012 08:14:29 +0800
> >
> > > VPD register is only used for L1(devid=PCI_DEVICE_ID_ATTANSIC_L1) to
> > > access external NV-memory.
> > > l1c & later chip doesn't use it any more.
> > >
> > > Signed-off-by: xiong <xiong@qca.qualcomm.com>
> > > Tested-by: Liu David <dwliu@qca.qualcomm.com>
> >
> > You just broke ethtool register dumps with this change.
> >
> > Now, all the initial registers are reported offset by one entry, yet the last two are
> > still reported in their original spots.
> >
> > This layout is exposed to userspace, and interpreted by tools, and you cannot
> > change it.
> >
> > If this register always reports some value, you should just keep it there in the
> > dumps.
> >
> The VPD register doesn't report anything :(, just a dummy register now.
> we don't have any special tools in userspace to explain the dumped registers.
> Actually the purpose of dumping these registers via ethtool is just for debug.
[...]

Of course, the whole purpose of the operation is for debugging.  But you
should bump the dump version number (currently 0) every time you change
the offsets of registers in the dump.

Ben.

--
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
