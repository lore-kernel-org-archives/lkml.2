Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933073Ab0J2VWG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 17:22:06 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:58503 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751200Ab0J2VWD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 17:22:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=gFE4gm66H9hlZyGCrwC6d1OqpjnKfT6fKDya0pJlDvFh1xLilgzAdBHX2xcmaMY01s
         PlOWNiKxJAfh4XngCmtoTKt37+IoyJ9GMdeBCVsJM+hcLcRWd60krS9cmtafVgK9vD0I
         ++5su/tH1cZm6ckb1U6rDD+XBoBb9L0L5RCFQ=
Date: Sat, 30 Oct 2010 01:21:59 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, mingo@redhat.com, hpa@zytor.com,
        linux-kernel@vger.kernel.org, brgerst@gmail.com, tglx@linutronix.de,
        mingo@elte.hu, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86-32: Restore irq stacks NUMA-aware
	allocations
Message-ID: <20101029212159.GD6130@lenovo>
References: <1288276854.2649.607.camel@edumazet-laptop> <tip-5c1eb08936693cd78c71164c8bea0b086ae72c67@git.kernel.org> <1288377146.1988.0.camel@laptop> <20101029202809.GB6130@lenovo> <1288385883.2680.17.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1288385883.2680.17.camel@edumazet-laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 29, 2010 at 10:58:03PM +0200, Eric Dumazet wrote:
> Le samedi 30 octobre 2010 à 00:28 +0400, Cyrill Gorcunov a écrit :
> > On Fri, Oct 29, 2010 at 08:32:26PM +0200, Peter Zijlstra wrote:
> > > On Fri, 2010-10-29 at 06:43 +0000, tip-bot for Eric Dumazet wrote:
> > > > +       irqctx = page_address(alloc_pages_node(cpu_to_node(cpu),
> > > > +                                              THREAD_FLAGS,
> > > > +                                              THREAD_ORDER)); 
> > > 
> > > Shouldn't we be checking for a NULL return from alloc_pages_node()
> > > before calling page_address() on it?
> > > --
> > 
> >  Something like below I guess, but probably we could try to allocate
> > on appropriate NUMA node first and if it fails -- via old alloc_pages
> > and if it fail in turn -- then we panic.
> 
> Maybe my commit message was not clear : 
> 
> There is no need to test return from alloc_pages_node() and do the
> fallback. It already done properly.
>

Yes Eric, somehow managed to miss that, my bad.
 
  Cyrill
