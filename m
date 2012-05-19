Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759419Ab2ESPp6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2012 11:45:58 -0400
Received: from manchmal.in-ulm.de ([217.10.9.201]:34021 "EHLO
	manchmal.in-ulm.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758974Ab2ESPp4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2012 11:45:56 -0400
Date: Sat, 19 May 2012 17:45:51 +0200
From: Christoph Biedl <linux-kernel.bfrz@manchmal.in-ulm.de>
To: Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Sami Liedes <sami.liedes@iki.fi>, Tejun Heo <tj@kernel.org>,
        Christoph Lameter <cl@linux-foundation.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [ 31/54] kmemleak: Fix the kmemleak tracking of the percpu
 areas with !SMP
Message-ID: <1337442045@msgid.manchmal.in-ulm.de>
References: <20120518212656.GA4992@kroah.com>
 <20120518211602.287791770@linuxfoundation.org>
 <1337433313@msgid.manchmal.in-ulm.de>
 <20120519144652.GA2067@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120519144652.GA2067@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote...

> On Sat, May 19, 2012 at 03:27:33PM +0200, Christoph Biedl wrote:
> > Greg KH wrote...
> > 
> > > 3.0-stable review patch.  If anyone has any objections, please let me know.
> > 
> > > From: Catalin Marinas <catalin.marinas@arm.com>
> > > 
> > > commit 100d13c3b5b9410f604b86f5e0a34da64b8cf659 upstream.
> > 
> > > +	/* kmemleak tracks the percpu allocations separately */
> > > +	kmemleak_free(fc);
> > 
> > That one causes:
> > 
> >     mm/percpu.c: In function ‘setup_per_cpu_areas’:
> >     mm/percpu.c:1877: error: implicit declaration of function ‘kmemleak_free’
> >     make[1]: *** [mm/percpu.o] Error 1
> >     make: *** [mm] Error 2
> 
> Odd, it doesn't cause that problem here for me, what ARCH are you
> building for?  I'm on x86-64.

x86-64 and ARM, not x86-32 for whatever reason, parisc not tested yet.

But, if I read the nested #ifdef right, CONFIG_CMP must be disabled to
hit that code.

> Actually, I don't think this is needed at all for 3.0 as percpu memleak
> handling went in with the patch you reference above, so this would cause
> problems on 3.0.  So I'll go delete that patch from the queue, thanks
> for letting me know.

I'm fine with that descision.

    Christoph
