Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754363Ab1FOAsX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 20:48:23 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:48766 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753538Ab1FOAsN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 20:48:13 -0400
X-VirusChecked: Checked
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-10.tower-127.messagelabs.com!1308098892!8385994!1
X-StarScan-Version: 6.2.17; banners=-,-,-
X-Originating-IP: [216.166.12.180]
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        "yinghai@kernel.org" <yinghai@kernel.org>,
        "hpa@linux.intel.com" <hpa@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 14 Jun 2011 19:47:19 -0500
Subject: [Q] mm/memblock.c: cast truncates bits from RED_INACTIVE
Thread-Topic: [Q] mm/memblock.c: cast truncates bits from RED_INACTIVE
Thread-Index: Acwq9cgcVKSC4A1wQDqE/nar82cq3Q==
Message-ID: <ADE657CA350FB648AAC2C43247A983F001F382220E0F@AUSP01VMBX24.collaborationhost.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p5F0mfod016902

Hello all,

Sparse is reporting a couple warnings in mm/memblock.c:

	warning: cast truncates bits from constant value (9f911029d74e35b becomes 9d74e35b)

The warnings are due to the cast of RED_INACTIVE in memblock_analyze():

	/* Check marker in the unused last array entry */
	WARN_ON(memblock_memory_init_regions[INIT_MEMBLOCK_REGIONS].base
		!= (phys_addr_t)RED_INACTIVE);
	WARN_ON(memblock_reserved_init_regions[INIT_MEMBLOCK_REGIONS].base
		!= (phys_addr_t)RED_INACTIVE);

And in memblock_init():

	/* Write a marker in the unused last array entry */
	memblock.memory.regions[INIT_MEMBLOCK_REGIONS].base = (phys_addr_t)RED_INACTIVE;
	memblock.reserved.regions[INIT_MEMBLOCK_REGIONS].base = (phys_addr_t)RED_INACTIVE;

Could this cause any problems?  If not, is there anyway to quiet the sparse noise?

Regards,
Hartley
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
