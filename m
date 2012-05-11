Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932750Ab2EKRmN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 13:42:13 -0400
Received: from mga11.intel.com ([192.55.52.93]:61777 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757972Ab2EKRmM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 13:42:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="165046725"
From: "Luck, Tony" <tony.luck@intel.com>
To: Chen Gong <gong.chen@linux.intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Borislav Petkov <bp@amd64.org>,
        "Huang, Ying" <ying.huang@intel.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Subject: RE: [PATCH 2/2] x86/mce: Add instruction recovery signatures to
 mce-severity table
Thread-Topic: [PATCH 2/2] x86/mce: Add instruction recovery signatures to
 mce-severity table
Thread-Index: AQHNL0lNX6PGPdBkbUOeJPxXhK/15JbE0YwA
Date: Fri, 11 May 2012 17:42:09 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F192ED617@ORSMSX104.amr.corp.intel.com>
References: <cover.1336674796.git.tony.luck@intel.com>
 <0e89440bf6444635bde0b876eedd26e5c51f9ca3.1336674796.git.tony.luck@intel.com>
 <4FACC25B.80305@linux.intel.com>
In-Reply-To: <4FACC25B.80305@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.140]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q4BHgNVr020686

> For IFU, on affected logical processors, RIPV and EIPV both are 0,
> since now new IFU entries are added into severity table, the old
> entry as below should be removed:
>
> /* Neither return not error IP -- no chance to recover -> PANIC */
>        MCESEV(
>                PANIC, "Neither restart nor error IP",
>                MCGMASK(MCG_STATUS_RIPV|MCG_STATUS_EIPV, 0)
>                ),

We need to keep this. If EIPV is not set, then CS and IP on the
stack are not guaranteed ... so we can't tell whether the error
happened in user or kernel mode. This makes recovery "challenging".

I'm trying to figure out a quirk for processors that do generate
EIPV=RIPV=0 signature for IFU errors. There are some case where
we can work around the lack of EIPV.

-Tony

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
