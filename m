Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754753Ab2BXGOK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 01:14:10 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:32869 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753422Ab2BXGOI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 01:14:08 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of yong.zhang0@gmail.com designates 10.180.80.40 as permitted sender) smtp.mail=yong.zhang0@gmail.com; dkim=pass header.i=yong.zhang0@gmail.com
Date: Fri, 24 Feb 2012 14:13:50 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: Venki Pallipadi <venki@google.com>, Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Aaron Durbin <adurbin@google.com>, Paul Turner <pjt@google.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Extend mwait idle to optimize away CAL and RES
 interrupts to an idle CPU -v1
Message-ID: <20120224061350.GB17543@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <1329957415-15239-1-git-send-email-venki@google.com>
 <1329989454.24994.57.camel@twins>
 <CABeCy1a0U8Hk3Yfp54M-U80t2fbPrFQw=GnNQ_V082e9VxJQow@mail.gmail.com>
 <20120224054150.GA17543@zhy>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120224054150.GA17543@zhy>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 24, 2012 at 01:41:50PM +0800, Yong Zhang wrote:
> On Thu, Feb 23, 2012 at 11:34:11AM -0800, Venki Pallipadi wrote:
> > On Thu, Feb 23, 2012 at 1:30 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> > > Why not scheduler_ipi()?
> > 
> > Was trying to avoid irq_enter/exit. As the work here is done in idle
> > thread context, I though we could avoid enter/exit. 
> 
> It seems we could not.
> At least RCU need it, see commit c5d753a55, otherwise we will get
> warning like 'RCU used illegally from extended quiescent state!'

[Off topic]
This remind me that we should have moved the irq_enter()/irq_exit() to
each arch's related irq handler.
see: http://marc.info/?l=linux-kernel&m=130709505700821&w=2

So Peter, is there someone alread on it? or it still worth doing now?

Thanks,
Yong
