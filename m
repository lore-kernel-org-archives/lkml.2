Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754926Ab0KPRAS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 12:00:18 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:44023 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752552Ab0KPRAR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 12:00:17 -0500
From: "Aguirre, Sergio" <saaguirre@ti.com>
To: Darren Hart <dvhart@linux.intel.com>
CC: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@gmail.com>
Date: Tue, 16 Nov 2010 10:59:53 -0600
Subject: RE: [RFC][PATCH] futex: Hide false positive about uninit var usage
Thread-Topic: [RFC][PATCH] futex: Hide false positive about uninit var usage
Thread-Index: AcuFrWPoMi0rPGKtSGee271h6+oKWAAAfu0A
Message-ID: <A24693684029E5489D1D202277BE89447382A563@dlee02.ent.ti.com>
References: <1289925157-17054-1-git-send-email-saaguirre@ti.com>
 <4CE2B4AC.5080606@linux.intel.com>
In-Reply-To: <4CE2B4AC.5080606@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Darren,

> -----Original Message-----
> From: Darren Hart [mailto:dvhart@linux.intel.com]
> Sent: Tuesday, November 16, 2010 10:43 AM
> To: Aguirre, Sergio
> Cc: LKML; Thomas Gleixner; Peter Zijlstra; Ingo Molnar; Namhyung Kim
> Subject: Re: [RFC][PATCH] futex: Hide false positive about uninit var
> usage
> 
> On 11/16/2010 08:32 AM, Sergio Aguirre wrote:
> > In exit_robust_list, there was this warning shown:
> >
> > kernel/futex.c: In function 'exit_robust_list':
> > kernel/futex.c:2492: warning: 'next_pi' may be used uninitialized in
> this function
> >
> > Which is a false positive, since in the function, the only scenario
> > possible in which the var is read, is after a successful excecution of
> > fetch_robust_entry, which populates the variable.
> >
> > So there's no real possibility of it being used uninitialized.
> 
> Hi Sergio,
> 
> You are correct. Thomas has recently pulled my fix for this into tip, it
> should be queued for mainline already.

Oh ok. Sorry, I didn't know that. Please ignore this patch then.

Regards,
Sergio

> 
> Thanks,
> 
> Darren Hart
> 
> >
> > Signed-off-by: Sergio Aguirre<saaguirre@ti.com>
> > Cc: Thomas Gleixner<tglx@linutronix.de>
> > Cc: Peter Zijlstra<a.p.zijlstra@chello.nl>
> > Cc: Darren Hart<dvhart@linux.intel.com>
> > Cc: Ingo Molnar<mingo@elte.hu>
> > Cc: Namhyung Kim<namhyung@gmail.com>
> > ---
> >   kernel/futex.c |    3 ++-
> >   1 files changed, 2 insertions(+), 1 deletions(-)
> >
> > diff --git a/kernel/futex.c b/kernel/futex.c
> > index 6c683b3..3646157 100644
> > --- a/kernel/futex.c
> > +++ b/kernel/futex.c
> > @@ -2489,7 +2489,8 @@ void exit_robust_list(struct task_struct *curr)
> >   {
> >   	struct robust_list_head __user *head = curr->robust_list;
> >   	struct robust_list __user *entry, *next_entry, *pending;
> > -	unsigned int limit = ROBUST_LIST_LIMIT, pi, next_pi, pip;
> > +	unsigned int limit = ROBUST_LIST_LIMIT, pi;
> > +	unsigned int uninitialized_var(next_pi), pip;
> >   	unsigned long futex_offset;
> >   	int rc;
> >
> 
> 
> --
> Darren Hart
> Yocto Linux Kernel
