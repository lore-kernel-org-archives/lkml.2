Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752569Ab2G1VnU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2012 17:43:20 -0400
Received: from mga01.intel.com ([192.55.52.88]:54068 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751632Ab2G1VnT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2012 17:43:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="188838627"
From: "Luck, Tony" <tony.luck@intel.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>,
        "linux-parisc@vger.kernel.org" <linux-parisc@vger.kernel.org>,
        "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
        "Wu, Fengguang" <fengguang.wu@intel.com>
Subject: RE: [PATCH] debug: Do not permit CONFIG_DEBUG_STACK_USAGE=y on IA64
 or PARISC
Thread-Topic: [PATCH] debug: Do not permit CONFIG_DEBUG_STACK_USAGE=y on
 IA64 or PARISC
Thread-Index: AQHNbJi8cu1EraYsb06urUq7jiT5f5c/N9/Q
Date: Sat, 28 Jul 2012 21:43:07 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F193720CE@ORSMSX104.amr.corp.intel.com>
References: <4a613b26cc402fb3ed8130cd07a37e76f4c133ef.1342634029.git.tony.luck@intel.com>
 <1343463151.3328.4.camel@dabdike.int.hansenpartnership.com>
In-Reply-To: <1343463151.3328.4.camel@dabdike.int.hansenpartnership.com>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q6SLhXQ4031600

> I agree with this.  Most of it looks easily fixable, but how would I
> enable the fix for ia64?  For PA it's simple: I'll just use
> CONFIG_STACK_GROWSUP, but that won't work for you.

ia64 has an ugly chicken vs. egg build dependency. When trying to build our asm-offsets.h
file (to get #define constants for various structure sizes and offsets in a format that is
usable in assembly code) we get:

include/linux/sched.h:2539: error: 'IA64_TASK_SIZE' undeclared (first use in this function)

Which is sad because IA64_TASK_SIZE is one of the #defines that asm-offsets.h is trying
to produce.

Which is why I just threw up my hands in despair and said "!IA64" for this option.

-Tony
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
