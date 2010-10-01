Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756808Ab0JAOgb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 10:36:31 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:40616 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756087Ab0JAOga (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 10:36:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=lat941g4XvvZkChbhpIFL/uhqN6uteRthI+9YA03RUPFxnQHTxhUcXGLUlBBDVxllb
         fGwmfj6yo5SVmIa0Cs+NE8K1yItrOPTqseZFoToCoR7o+U6S89M+JGB/aTMwCTdAPtYS
         YEB9YMfuve1sZtwxJ0sZ9iDXipGxW3mSAAhqY=
Date: Fri, 1 Oct 2010 16:36:10 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Van De Ven, Arjan" <arjan.van.de.ven@intel.com>
Cc: Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
        "Wu, Xia" <xia.wu@intel.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Zhu, Daniel" <daniel.zhu@intel.com>,
        "Wang, Yong Y" <yong.y.wang@intel.com>
Subject: Re: unnecessary timer interrupt of slab.c and bdi tasks when the
	system is in sleep state
Message-ID: <20101001143546.GA6194@nowhere>
References: <A24AE1FFE7AEC5489F83450EE98351BF221878E0FB@shsmsx502.ccr.corp.intel.com> <alpine.DEB.2.00.1009300908050.27201@router.home> <20101001141932.GA5467@nowhere> <26E9B811E137AB4B95200FD4C950886BA64E0E96@orsmsx507.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <26E9B811E137AB4B95200FD4C950886BA64E0E96@orsmsx507.amr.corp.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 01, 2010 at 07:22:10AM -0700, Van De Ven, Arjan wrote:
> > > > I found some unnecessary timer interrupts when the system enter
> > sleep state.
> > > > (1)     /mm/slab.c
> > > > cache_reap() clean up on allocated memory every 2s. If the system
> > is in sleep state, the system is waked-up when this timer expires. In
> > fact,
> > > > there isn't more slabs to been cleaned up in sleep state.
> > >
> > > Right. We could switch off the timer when idle without much of an
> > issue.
> > > The expiration of the caches wont occur and so we will have stale
> > objects
> > > on the queues when we exit sleep state. You could flush the queues
> > before
> > > switching off the timers?
> > 
> > 
> > May be flushing the queue everytime we enter nohz is too much, as that
> > can
> > happen very often?
> > 
> 
> 
> the slab timer is already deferable... which means it won't hit while the system is completely idle.


I'm not sure what you mean exactly. The slab work seems to be scheduled strictly
periodically, unless the cpu goes offline. But I can't find any nohz-wise adaptation.



> I think this part of the original report is a red herring found on an older kernel.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

