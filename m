Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754651Ab1LXHEJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Dec 2011 02:04:09 -0500
Received: from mga11.intel.com ([192.55.52.93]:42277 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753539Ab1LXHEH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Dec 2011 02:04:07 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="105652967"
From: "Shi, Alex" <alex.shi@intel.com>
To: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
CC: Peter Zijlstra <peterz@infradead.org>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "efault@gmx.de" <efault@gmx.de>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>,
        "Li, Shaohua" <shaohua.li@intel.com>,
        "Chen, Tim C" <tim.c.chen@intel.com>,
        "Huang, Ying" <ying.huang@intel.com>
Subject: RE: [tip:sched/urgent] sched: Fix select_idle_sibling() regression
 in selecting an idle SMT sibling
Thread-Topic: [tip:sched/urgent] sched: Fix select_idle_sibling() regression
 in selecting an idle SMT sibling
Thread-Index: AQHMwaLGFzinl1zQT8iGfhsRZ1ce85Xqjwfg
Date: Sat, 24 Dec 2011 07:04:00 +0000
Message-ID: <B8BF297AD5A53A4BAEDA7B4D54BB80C9B0DC@SHSMSX101.ccr.corp.intel.com>
References: <1323978421.1984.244.camel@sbsiddha-desk.sc.intel.com>
	 <tip-ab2789213d224202237292d78aaa0c386c7b28b2@git.kernel.org>
	 <CAGjg+kEOkkjnQQJJyGQzGApV5asM5oqvRwEr2VkJy9G5gg1rxw@mail.gmail.com>
	 <1324471944.10752.8.camel@twins>
	 <1324496556.21294.11.camel@sbsiddha-desk.sc.intel.com>
	 <1324517502.17054.174.camel@debian>
	 <1324519393.21294.20.camel@sbsiddha-desk.sc.intel.com>
	 <1324520161.17054.190.camel@debian>
 <1324665814.4167.32.camel@sbsiddha-desk.sc.intel.com>
In-Reply-To: <1324665814.4167.32.camel@sbsiddha-desk.sc.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id pBO74H5G028948

> >
> > A little complex for the whole thing.
> > on 4 sockets EX machine, 3~5% hackbench thread regression due to 4dcfe
> > can be recovered by ab2789.
> >
> > But on 2 sockets SNB machine, 1024 clients loop netperf TCP-RR has about
> > 9% regression. and your patch seem recover 2~3%.
> >
> > And on a 2 sockets nhm, one of our private benchmark was impact much 20
> > +% regression. that benchmark just run 4 process, each of process open a
> > thread, and the thread tasks is to locate randomly pages and than read
> > from 4 times/write 1 time data into a page.  The ab2789 commit seems no
> > help our benchmark.

In fact, since L1 cache, D-TLB is shared between SMT siblings, it is not every application can benefit from wakeup on different Cores. 
> 
> Ok. Can you please try couple of experiments with two kernels? Two
> kernels being the base kernel (prior to 4dcfe1025b513c2c) and the second
> kernel with the commit ab2789213d224202237292d78aaa0c386c7b28b2.

Testing started on impacted NHM and SND machines for benchmark netperf hackbench thread and our small case. 
> 
> One experiment with p-states turned off and the second experiment with
> c-states turned off.
> 
> I suspect mostly deeper core c-states might be contributing to the
> behavior that you are seeing.

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
