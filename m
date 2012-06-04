Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760902Ab2FDVTJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 17:19:09 -0400
Received: from mga03.intel.com ([143.182.124.21]:2918 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753316Ab2FDVTH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 17:19:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="107679591"
From: "Yu, Fenghua" <fenghua.yu@intel.com>
To: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        H Peter Anvin <hpa@zytor.com>, "Luck, Tony" <tony.luck@intel.com>,
        "Mallick, Asit K" <asit.k.mallick@intel.com>,
        Arjan Dan De Ven <arjan@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>,
        linux-pm <linux-pm@vger.kernel.org>
Subject: RE: [PATCH 3/6] x86/smpboot.c: Wake up offline CPU via mwait or nmi
Thread-Topic: [PATCH 3/6] x86/smpboot.c: Wake up offline CPU via mwait or nmi
Thread-Index: AQHNQoAQHIHlKMct6Ee2Fsgil0bax5bq+HsA//+Tu0A=
Date: Mon, 4 Jun 2012 19:35:22 +0000
Message-ID: <3E5A0FA7E9CA944F9D5414FEC6C712200771C22F@ORSMSX105.amr.corp.intel.com>
References: <1338833876-29721-1-git-send-email-fenghua.yu@intel.com>
	 <1338833876-29721-4-git-send-email-fenghua.yu@intel.com>
 <1338836326.28766.3.camel@sbsiddha-desk.sc.intel.com>
In-Reply-To: <1338836326.28766.3.camel@sbsiddha-desk.sc.intel.com>
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
X-MIME-Autoconverted: from base64 to 8bit by nfs id q54LJKb2031133

> From: Siddha, Suresh B
> Sent: Monday, June 04, 2012 11:59 AM
> To: Yu, Fenghua
> Cc: Ingo Molnar; Thomas Gleixner; H Peter Anvin; Luck, Tony; Mallick,
> Asit K; Arjan Dan De Ven; linux-kernel; x86; linux-pm
> Subject: Re: [PATCH 3/6] x86/smpboot.c: Wake up offline CPU via mwait
> or nmi
> 
> On Mon, 2012-06-04 at 11:17 -0700, Fenghua Yu wrote:
> > From: Fenghua Yu <fenghua.yu@intel.com>
> >
> > wakeup_secondary_cpu_via_soft() is defined to wake up offline CPU via
> mwait if
> > the CPU is in mwait or via nmi if the CPU is in hlt.
> >
> > A CPU boots up by INIT, INIT, STARTUP sequence when it boots up for
> the first
> > time during boot time or hot plug.
> 
> I think this breaks suspend/resume as the cpu state gets lost.
> 
> Have you tried suspend/resume?

Good catch! Suspend/resume is broken.

A pm callback can be installed to clear cpu_dead state in suspend preparation. So when resume, INIT sequence is used to wakeup CPU's just like the boot time case.

I have a quick fix and will put it in the next version of the patchset.

Thanks.

-Fenghua
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
