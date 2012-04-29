Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753788Ab2D2MZy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2012 08:25:54 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:56406 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752524Ab2D2MZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2012 08:25:53 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6695"; a="183721608"
X-IronPort-AV: E=Sophos;i="4.75,498,1330934400"; 
   d="scan'208";a="206798681"
From: "Huang, Xiong" <xiong@qca.qualcomm.com>
To: Florian Fainelli <florian@openwrt.org>
CC: "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        qca-linux-team <qca-linux-team@qualcomm.com>,
        nic-devel <nic-devel@qualcomm.com>
Subject: =?big5?B?tarOYDogW1BBVENIIDAyLzEwXSBhdGwxYzogYWRkIFBIWSBsaW5rIGV2ZW50KHVw?=
 =?big5?Q?/down)_patch?=
Thread-Topic: [PATCH 02/10] atl1c: add PHY link event(up/down) patch
Thread-Index: AQHNJOKGtvutybYD2UOZf50PlMVq85aw8xEAgADIPvg=
Date: Sun, 29 Apr 2012 12:25:51 +0000
Message-ID: <157393863283F442885425D2C454285623D5FD3A@nasanexd02a.na.qualcomm.com>
References: <1335578325-21326-1-git-send-email-xiong@qca.qualcomm.com>
 <1335578325-21326-3-git-send-email-xiong@qca.qualcomm.com>,<201204281924.20714.florian@openwrt.org>
In-Reply-To: <201204281924.20714.florian@openwrt.org>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.45.230.6]
Content-Type: text/plain; charset="big5"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q3TCQ0XX001213


> +
> +struct atl1c_platform_patch {
> +     u16 pci_vid;
> +     u16 pci_did;
> +     u8  pci_revid;
> +     u16 subsystem_vid;
> +     u16 subsystem_did;
> +     u32 patch_flag;
> +#define ATL1C_LINK_PATCH     0x1
> +};
> +static struct atl1c_platform_patch plats[] = {

This should be static const.

> +{0x1969, 0x2060, 0xC1, 0x1019, 0x8152, 0x1},

-------------------------------------------------------------------------------------------------------
How about if I revise it as:

static const struct atl1c_platform_patch plats[] __devinitdata = {
....}

the array is only used by atl1c_probe function. is it appropriate to add '__devinitdata' here ?



Thanks
-Xiongÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
