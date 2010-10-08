Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758367Ab0JHQL7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 12:11:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36938 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758925Ab0JHQL5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 12:11:57 -0400
Date: Fri, 8 Oct 2010 13:07:49 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Gleb Natapov <gleb@redhat.com>
Cc: kvm@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        avi@redhat.com, mingo@elte.hu, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, hpa@zytor.com, riel@redhat.com,
        cl@linux-foundation.org
Subject: Re: [PATCH v6 03/12] Retry fault before vmentry
Message-ID: <20101008160749.GA31315@amt.cnet>
References: <1286207794-16120-1-git-send-email-gleb@redhat.com>
 <1286207794-16120-4-git-send-email-gleb@redhat.com>
 <20101005155409.GB28955@amt.cnet>
 <20101006110704.GW11145@redhat.com>
 <20101006142050.GA31423@amt.cnet>
 <20101007184457.GA8354@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101007184457.GA8354@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 07, 2010 at 08:44:57PM +0200, Gleb Natapov wrote:
> On Wed, Oct 06, 2010 at 11:20:50AM -0300, Marcelo Tosatti wrote:
> > On Wed, Oct 06, 2010 at 01:07:04PM +0200, Gleb Natapov wrote:
> > > > Can't you set a bit in vcpu->requests instead, and handle it in "out:"
> > > > at the end of vcpu_enter_guest? 
> > > > 
> > > > To have a single entry point for pagefaults, after vmexit handling.
> > > Jumping to "out:" will skip vmexit handling anyway, so we will not reuse
> > > same call site anyway. I don't see yet why the way you propose will have
> > > an advantage.
> > 
> > What i meant was to call pagefault handler after vmexit handling.
> > 
> > Because the way it is in your patch now, with pre pagefault on entry,
> > one has to make an effort to verify ordering wrt other events on entry
> > processing.
> > 
> What events do you have in mind?

TLB flushing, event injection, etc.

> > With pre pagefault after vmexit, its more natural.
> > 
> I do not see non-ugly way to pass information that is needed to perform
> the prefault to the place you want me to put it. We can skip guest entry
> in case prefault was done which will have the same effect as your
> proposal, but I want to have a good reason to do so since otherwise we
> will just do more work for nothing on guest entry.

The reason is that it becomes similar to normal pagefault handling. I
don't have a specific bug to give you as example.

> 
> > Does that make sense?
> 
> --
> 			Gleb.
