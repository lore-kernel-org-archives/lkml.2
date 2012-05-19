Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757312Ab2ESVqc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2012 17:46:32 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:46107 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753779Ab2ESVqa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2012 17:46:30 -0400
Date: Sat, 19 May 2012 22:45:45 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Christoph Biedl <linux-kernel.bfrz@manchmal.in-ulm.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
        Sami Liedes <sami.liedes@iki.fi>, Tejun Heo <tj@kernel.org>,
        Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [ 31/54] kmemleak: Fix the kmemleak tracking of the percpu
 areas with !SMP
Message-ID: <20120519214545.GA26721@arm.com>
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

On Sat, May 19, 2012 at 03:46:52PM +0100, Greg KH wrote:
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

This patch propagated to far in the past. Support for per-cpu areas in
kmemleak was added with commit f528f0b8e5 (kmemleak: Handle percpu
memory allocation) in 3.3-rc1. That patch introduced the correct
#include for kmemleak.h.

Commit 100d13c should only be applied to stable 3.3 and not earlier.

Thanks.

-- 
Catalin
