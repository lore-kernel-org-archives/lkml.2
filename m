Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752431Ab2AYR6T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 12:58:19 -0500
Received: from mga14.intel.com ([143.182.124.37]:45129 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751449Ab2AYR6R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 12:58:17 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="59937102"
From: "Yu, Fenghua" <fenghua.yu@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Brian Gerst <brgerst@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Mallick, Asit K" <asit.k.mallick@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "Van De Ven, Arjan" <arjan.van.de.ven@intel.com>,
        "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        Randy Dunlap <rdunlap@xenotime.net>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Chen Gong <gong.chen@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-pm <linux-pm@vger.kernel.org>, x86 <x86@kernel.org>
Subject: RE: [PATCH v5 10/12] x86/mtrr/main.c: Ask the first online CPU to
 save mtrr
Thread-Topic: [PATCH v5 10/12] x86/mtrr/main.c: Ask the first online CPU to
 save mtrr
Thread-Index: AQHM0IXtchbg6t0dpEylW7Itt3XhjJYJMbWAgAV5GACADsipEA==
Date: Wed, 25 Jan 2012 17:58:11 +0000
Message-ID: <3E5A0FA7E9CA944F9D5414FEC6C712200349AE@ORSMSX105.amr.corp.intel.com>
References: <1326301493-28760-1-git-send-email-fenghua.yu@intel.com>
 <1326301493-28760-11-git-send-email-fenghua.yu@intel.com>
 <CAMzpN2hfCCarbn+CDGrQuUaXYT29HpRd+9n0EKWvZdgLdqdAhA@mail.gmail.com>
 <4F136A50.80203@zytor.com>
In-Reply-To: <4F136A50.80203@zytor.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.138]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q0PHwWCa005383

> From: H. Peter Anvin [mailto:hpa@zytor.com]
> Sent: Sunday, January 15, 2012 4:08 PM
> On 01/12/2012 04:33 AM, Brian Gerst wrote:
> > On Wed, Jan 11, 2012 at 12:04 PM, Fenghua Yu <fenghua.yu@intel.com>
> wrote:
> >> From: Fenghua Yu <fenghua.yu@intel.com>
> >>
> >> Ask the first online CPU to save mtrr instead of asking BSP. BSP
> could be
> >> offline when mtrr_save_state() is called.
> >
> > If you can use any non-boot cpu to save the MTRRs why not just use
> the
> > current cpu?  They should all be in sync anyways.
> >
> 
> A much bigger question: why do we ever bother saving the MTRR state per
> se?  We examine the MTRR state -- we have to -- during boot, and it
> should never diverge from the state set by the OS from that point on --
> we'll need to set it back to that.  So we should just keep track of
> what
> the correct MTRR state is at all times.

The fixed MTRR state is saved when each CPU is up:
        /*
         * Save current MTRR state in case it was changed since early boot
         * (e.g. by the ACPI SMI) to initialize new CPUs with MTRRs in sync:
         */
        mtrr_save_state();
It's saved because MTRR state could be changed since early boot according to the above comment. I haven't found other info source except the comment. If that's true, we may need to save the state, right?

Thanks.

-Fenghua

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
