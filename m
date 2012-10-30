Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752916Ab2J3E4Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 00:56:25 -0400
Received: from mga14.intel.com ([143.182.124.37]:5542 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752570Ab2J3E4Y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 00:56:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,677,1344236400"; 
   d="scan'208";a="211060907"
From: "Liu, Chuansheng" <chuansheng.liu@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Li, Fei" <fei.li@intel.com>,
        "yanmin_zhang@linux.intel.com" <yanmin_zhang@linux.intel.com>
Subject: RE: [PATCH] hrtimer: Printing timer info when hitting BUG_ON()
Thread-Topic: [PATCH] hrtimer: Printing timer info when hitting BUG_ON()
Thread-Index: AQHNtbSkZyEFUwNSw0Wf1N5nZD1s35fRMVVw
Date: Tue, 30 Oct 2012 04:55:59 +0000
Message-ID: <27240C0AC20F114CBF8149A2696CBE4A1B7C41@SHSMSX101.ccr.corp.intel.com>
References: <1351508551.15558.1428.camel@cliu38-desktop-build>
 <1351501541.24721.1.camel@twins>
In-Reply-To: <1351501541.24721.1.camel@twins>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Peter Zijlstra [mailto:a.p.zijlstra@chello.nl]
> Sent: Monday, October 29, 2012 5:06 PM
> To: Liu, Chuansheng
> Cc: tglx@linutronix.de; mingo@kernel.org; linux-kernel@vger.kernel.org; Li, Fei;
> yanmin_zhang@linux.intel.com
> Subject: Re: [PATCH] hrtimer: Printing timer info when hitting BUG_ON()
> 
> On Mon, 2012-10-29 at 19:02 +0800, Chuansheng Liu wrote:
> > +/*
> > + * dump_hrtimer_callinfo - print hrtimer information including:
> > + * state, callback function, pid and start_site.
> > +*/
> > +static void dump_hrtimer_callinfo(struct hrtimer *timer)
> > +{
> > +
> > +       char symname[KSYM_NAME_LEN];
> > +
> > +       if (lookup_symbol_name((unsigned long)(timer->function),
> symname) < 0) {
> > +               pr_err("timer info: state/%lx, func/%pK\n",
> > +                       timer->state, timer->function);
> > +       } else {
> > +               pr_err("timer info: state/%lx, func/%s",
> > +                       timer->state, symname);
> > +       }
> > +
> > +#ifdef CONFIG_TIMER_STATS
> > +       if (lookup_symbol_name((unsigned long)(timer->start_site),
> > +                                               symname) < 0) {
> > +               pr_err("timer stats: pid/%d(%s), site/%pK\n",
> > +                       timer->start_pid, timer->start_comm,
> timer->start_site);
> > +       } else {
> > +               pr_err("timer stats: pid/%d(%s), site/%s\n",
> > +                       timer->start_pid, timer->start_comm,
> symname);
> > +       }
> > +#endif
> > +}
> 
> What's wrong with %pf ?
Thanks Peter's help and pointing out, patch V2 has been sent.
This patch helps us to find out the root cause quickly.

