Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755916Ab0GHJvZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 05:51:25 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:44650 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752832Ab0GHJvX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 05:51:23 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Peter Zijlstra <peterz@infradead.org>
Subject: Re: FYI: mmap_sem OOM patch
Cc: kosaki.motohiro@jp.fujitsu.com, Michel Lespinasse <walken@google.com>,
       linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
       Divyesh Shah <dpshah@google.com>
In-Reply-To: <1278581717.1900.20.camel@laptop>
References: <20100708182134.CD3F.A69D9226@jp.fujitsu.com> <1278581717.1900.20.camel@laptop>
Message-Id: <20100708184341.CD42.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu,  8 Jul 2010 18:51:20 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, 2010-07-08 at 18:24 +0900, KOSAKI Motohiro wrote:
> > > On Wed, 2010-07-07 at 16:11 -0700, Michel Lespinasse wrote:
> > > 
> > > > diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
> > > > index f627779..4b3a1c7 100644
> > > > --- a/arch/x86/mm/fault.c
> > > > +++ b/arch/x86/mm/fault.c
> > > > @@ -1062,7 +1062,10 @@ do_page_fault(struct pt_regs *regs, unsigned long error_code)
> > > >  			bad_area_nosemaphore(regs, error_code, address);
> > > >  			return;
> > > >  		}
> > > > -		down_read(&mm->mmap_sem);
> > > > +		if (test_thread_flag(TIF_MEMDIE))
> > > > +			down_read_unfair(&mm->mmap_sem);
> > > > +		else
> > > > +			down_read(&mm->mmap_sem);
> > > >  	} else {
> > > >  		/*
> > > >  		 * The above down_read_trylock() might have succeeded in
> > > 
> > > I still think adding that _unfair interface is asking for trouble.
> > 
> > Can you please explain trouble that you worry? Why do we need to keep
> > thread fairness when OOM case?
> 
> Just the whole concept of the unfair thing offends me ;-) I didn't
> really look at the particular application in this case.

I see. 
Yup, I agree unfair thing concept is a bit ugly. If anyone have 
alternative idea, I agree to choose that thing.



