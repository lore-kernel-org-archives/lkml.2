Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751357Ab1GUOKr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 10:10:47 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:47817 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750843Ab1GUOKq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 10:10:46 -0400
Date: Thu, 21 Jul 2011 15:10:27 +0100
From: Will Deacon <will.deacon@arm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: "mingo@redhat.com" <mingo@redhat.com>,
        "dengcheng.zhu@gmail.com" <dengcheng.zhu@gmail.com>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "heiko.carstens@de.ibm.com" <heiko.carstens@de.ibm.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "dzickus@redhat.com" <dzickus@redhat.com>,
        "hpa@zytor.com" <hpa@zytor.com>, "anton@samba.org" <anton@samba.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jason.wessel@windriver.com" <jason.wessel@windriver.com>,
        "lethal@linux-sh.org" <lethal@linux-sh.org>,
        "emunson@mgebm.net" <emunson@mgebm.net>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "mcree@orcon.net.nz" <mcree@orcon.net.nz>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Subject: Re: [tip:perf/core] perf: Remove the nmi parameter from the
 swevent and overflow interface
Message-ID: <20110721141027.GA8446@e102144-lin.cambridge.arm.com>
References: <tip-agjev8eu666tvknpb3iaj0fg@git.kernel.org>
 <20110708173442.GB31972@e102144-lin.cambridge.arm.com>
 <1310146876.3282.711.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1310146876.3282.711.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

On Fri, Jul 08, 2011 at 06:41:16PM +0100, Peter Zijlstra wrote:
> On Fri, 2011-07-08 at 18:34 +0100, Will Deacon wrote:
> > On Fri, Jul 01, 2011 at 04:21:25PM +0100, tip-bot for Peter Zijlstra wrote:
> > > Commit-ID:  a8b0ca17b80e92faab46ee7179ba9e99ccb61233
> > > Gitweb:     http://git.kernel.org/tip/a8b0ca17b80e92faab46ee7179ba9e99ccb61233
> > > Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
> > > AuthorDate: Mon, 27 Jun 2011 14:41:57 +0200
> > > Committer:  Ingo Molnar <mingo@elte.hu>
> > > CommitDate: Fri, 1 Jul 2011 11:06:35 +0200
> > > 
> > > perf: Remove the nmi parameter from the swevent and overflow interface

[...]

> > 
> > Whilst you updated the arch code in this series, you forgot to update the
> > oprofile perf backend. 
> 
> Bah, I bet it skillfully hid from my grep-foo.
> 
> > I think you want something as simple as:
> > 
> > 
> > diff --git a/drivers/oprofile/oprofile_perf.c b/drivers/oprofile/oprofile_perf.c
> > index 59acf9e..94796f3 100644
> > --- a/drivers/oprofile/oprofile_perf.c
> > +++ b/drivers/oprofile/oprofile_perf.c
> > @@ -31,7 +31,7 @@ static int num_counters;
> >  /*
> >   * Overflow callback for oprofile.
> >   */
> > -static void op_overflow_handler(struct perf_event *event, int unused,
> > +static void op_overflow_handler(struct perf_event *event,
> >                         struct perf_sample_data *data, struct pt_regs *regs)
> >  {
> >         int id;
> > 
> 
> Yes, that is sufficient. Thanks!

I can't see this in next. Are you happy taking this or do you want me to
post it to the list as a standalone patch?

Cheers,

Will
