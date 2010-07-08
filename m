Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755483Ab0GHJf2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 05:35:28 -0400
Received: from casper.infradead.org ([85.118.1.10]:59252 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753807Ab0GHJf1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 05:35:27 -0400
Subject: Re: FYI: mmap_sem OOM patch
From: Peter Zijlstra <peterz@infradead.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Michel Lespinasse <walken@google.com>, linux-mm <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>, Divyesh Shah <dpshah@google.com>
In-Reply-To: <20100708182134.CD3F.A69D9226@jp.fujitsu.com>
References: <20100707231134.GA26555@google.com>
	 <1278579768.1900.14.camel@laptop>
	 <20100708182134.CD3F.A69D9226@jp.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 08 Jul 2010 11:35:17 +0200
Message-ID: <1278581717.1900.20.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-07-08 at 18:24 +0900, KOSAKI Motohiro wrote:
> > On Wed, 2010-07-07 at 16:11 -0700, Michel Lespinasse wrote:
> > 
> > > diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
> > > index f627779..4b3a1c7 100644
> > > --- a/arch/x86/mm/fault.c
> > > +++ b/arch/x86/mm/fault.c
> > > @@ -1062,7 +1062,10 @@ do_page_fault(struct pt_regs *regs, unsigned long error_code)
> > >  			bad_area_nosemaphore(regs, error_code, address);
> > >  			return;
> > >  		}
> > > -		down_read(&mm->mmap_sem);
> > > +		if (test_thread_flag(TIF_MEMDIE))
> > > +			down_read_unfair(&mm->mmap_sem);
> > > +		else
> > > +			down_read(&mm->mmap_sem);
> > >  	} else {
> > >  		/*
> > >  		 * The above down_read_trylock() might have succeeded in
> > 
> > I still think adding that _unfair interface is asking for trouble.
> 
> Can you please explain trouble that you worry? Why do we need to keep
> thread fairness when OOM case?

Just the whole concept of the unfair thing offends me ;-) I didn't
really look at the particular application in this case.


