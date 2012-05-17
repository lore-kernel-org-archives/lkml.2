Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966622Ab2EQOwV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 10:52:21 -0400
Received: from merlin.infradead.org ([205.233.59.134]:40018 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966562Ab2EQOwH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 10:52:07 -0400
Message-ID: <1337266310.4281.30.camel@twins>
Subject: Re: [PATCH v2 3/3] x86: Support local_flush_tlb_kernel_range
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Minchan Kim <minchan@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nitin Gupta <ngupta@vflare.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Tejun Heo <tj@kernel.org>, David Howells <dhowells@redhat.com>,
        x86@kernel.org, Nick Piggin <npiggin@gmail.com>
Date: Thu, 17 May 2012 16:51:50 +0200
In-Reply-To: <4FB4B29C.4010908@kernel.org>
References: <1337133919-4182-1-git-send-email-minchan@kernel.org>
	 <1337133919-4182-3-git-send-email-minchan@kernel.org>
	 <4FB4B29C.4010908@kernel.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-17 at 17:11 +0900, Minchan Kim wrote:
> > +++ b/arch/x86/include/asm/tlbflush.h
> > @@ -172,4 +172,16 @@ static inline void flush_tlb_kernel_range(unsigned long start,
> >       flush_tlb_all();
> >  }
> >  
> > +static inline void local_flush_tlb_kernel_range(unsigned long start,
> > +             unsigned long end)
> > +{
> > +     if (cpu_has_invlpg) {
> > +             while (start < end) {
> > +                     __flush_tlb_single(start);
> > +                     start += PAGE_SIZE;
> > +             }
> > +     } else
> > +             local_flush_tlb();
> > +}


It would be much better if you wait for Alex Shi's patch to mature.
doing the invlpg thing for ranges is not an unconditional win.

Also, does it even work if the range happens to be backed by huge pages?
IIRC we try and do the identity map with large pages wherever possible.
