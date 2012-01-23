Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754701Ab2AWXAf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 18:00:35 -0500
Received: from mga02.intel.com ([134.134.136.20]:36155 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754144Ab2AWXAe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 18:00:34 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="99778081"
From: "Luck, Tony" <tony.luck@intel.com>
To: "Huang, Ying" <ying.huang@intel.com>, Tejun Heo <tj@kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Borislav Petkov <bp@amd64.org>,
        Chen Gong <gong.chen@linux.intel.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Subject: RE: x86, mce, Use user return notifier in mce
Thread-Topic: x86, mce, Use user return notifier in mce
Thread-Index: AQHM0+0jS2KpC3Me8EiY/3XJq6Sm5ZYWEcWAgACZj4CAADWrAIAABocAgAO0COA=
Date: Mon, 23 Jan 2012 23:00:16 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F0283A2@ORSMSX104.amr.corp.intel.com>
References: <1326415001-2145-1-git-send-email-ying.huang@intel.com>
	 <CA+8MBbJHsOHb-COG_y36VYDA9EeTs3KpLc86kw1OhVF9Z_p7Jw@mail.gmail.com>
	 <1326436352.8294.22.camel@yhuang-dev>
	 <CA+8MBb+oqJZDYvmh8E6RB2MRp5fDj298Qjc4zs-rmyGkA4F3cw@mail.gmail.com>
	 <1326676875.8294.30.camel@yhuang-dev>
	 <20120120173427.GC3336@dhcp-172-17-108-109.mtv.corp.google.com>
	 <1327113843.7922.27.camel@yhuang-dev>
	 <CAOS58YP-4=Tf61mDNBTgvnhpYbisTjDVjAVmDdxyrFDXwVN1cg@mail.gmail.com>
 <1327126770.7922.34.camel@yhuang-dev>
In-Reply-To: <1327126770.7922.34.camel@yhuang-dev>
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
X-MIME-Autoconverted: from base64 to 8bit by nfs id q0NN0kkU022553

> This is a performance issue.  So maybe we need to measure the actual
> latency firstly.  The first step can be using WQ_HIGHPRI as you
> suggested.

To clarify "performance issue" a bit.  The situation is that h/w has
found some error in a piece of memory that is not currently being
accessed by any processor - we don't have to take any action right
away - but we'd like to run the work queue that will hunt down which
processes are using this page sooner, rather than later. If some
process does access the memory, it will be a fatal error on some
systems - but if we get there first, we can mark the page, kill the
process(es) and keep the system running.

So we are looking for a solution where there isn't an unbounded time
before the work queue gets run.

-Tony
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
