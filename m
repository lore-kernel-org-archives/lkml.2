Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933425Ab2EYQJg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 12:09:36 -0400
Received: from mga09.intel.com ([134.134.136.24]:35828 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932849Ab2EYQJe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 12:09:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="148450101"
From: "Luck, Tony" <tony.luck@intel.com>
To: "Liu, ShuoX" <shuox.liu@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Yanmin Zhang <yanmin_zhang@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>,
        "andi@firstfloor.org" <andi@firstfloor.org>,
        Ingo Molnar <mingo@elte.hu>
Subject: RE: [PATCH 1/2] printk: add interface for disabling recursion check
Thread-Topic: [PATCH 1/2] printk: add interface for disabling recursion check
Thread-Index: AQHNOkb6b4mcbkxM3k29tm7eYyKnSJbaq+Lw
Date: Fri, 25 May 2012 16:09:18 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F192F4D39@ORSMSX104.amr.corp.intel.com>
References: <4FBC444A.6060500@intel.com>
  <20120523100138.GA13506@x1.osrc.amd.com> <4FBDCE4A.7050900@intel.com>
  <20120524061145.GA18284@liondog.tnic>
  <20120524155611.b7aeff4d.akpm@linux-foundation.org>
 <1337905811.14538.206.camel@ymzhang.sh.intel.com>
 <4FBF3295.7090608@intel.com>
In-Reply-To: <4FBF3295.7090608@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.139]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q4PG9f73007281

+void printk_recursion_check_enable(void)
+{
+	atomic_dec(&recursion_check_disabled);
+}


Is it worth a BUG_ON() in here to check that recursion_check_disabled
is >=1 before blindly decrementing it? Or is this interface so simple
that nobody would ever get this wrong?

-Tony
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
