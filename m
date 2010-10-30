Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752549Ab0J3DsM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 23:48:12 -0400
Received: from relay3.sgi.com ([192.48.152.1]:40143 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751281Ab0J3DsK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 23:48:10 -0400
Date: Fri, 29 Oct 2010 22:48:04 -0500
From: Russ Anderson <rja@sgi.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        David Woodhouse <dwmw2@infradead.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>, rja@americas.sgi.com
Subject: Re: [BUG] intr_remap: Simplify the code further
Message-ID: <20101030034804.GC9557@sgi.com>
Reply-To: Russ Anderson <rja@sgi.com>
References: <20101029222227.GJ32456@sgi.com> <1288399062.2690.169.camel@sbsiddha-MOBL3.sc.intel.com> <20101030015050.GA9557@sgi.com> <AANLkTi=Ct+NXV_pvPNbn+j-j=hHXmUxaqa=XEaga=+Pq@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTi=Ct+NXV_pvPNbn+j-j=hHXmUxaqa=XEaga=+Pq@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 29, 2010 at 07:55:49PM -0700, Yinghai Lu wrote:
> On Fri, Oct 29, 2010 at 6:50 PM, Russ Anderson <rja@sgi.com> wrote:
> > On Fri, Oct 29, 2010 at 05:37:42PM -0700, Suresh Siddha wrote:
> >> On Fri, 2010-10-29 at 15:22 -0700, Russ Anderson wrote:
> >> > There is a regression that is causing a NULL pointer dereference
> >> > in free_irte when shutting down xpc.  git bisect narrowed it down
> >> > to git commit d585d060b42bd36f6f0b23ff327d3b91f80c7139, which
> >> > changed free_irte().  Reverse applying the patch fixes the problem.
> >> >
> >>
> >> Russ, Is this with !CONFIG_SPARSE_IRQ?
> >
> >
> > CONFIG_SPARSE_IRQ=y
> >
> 
> can you try attached patch?

That fixes it.

> Yinghai

Thanks!

-- 
Russ Anderson, OS RAS/Partitioning Project Lead  
SGI - Silicon Graphics Inc          rja@sgi.com
