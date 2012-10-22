Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756233Ab2JVUjn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 16:39:43 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:28273 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754195Ab2JVUjm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 16:39:42 -0400
Date: Mon, 22 Oct 2012 13:39:31 -0700
From: Mukesh Rathor <mukesh.rathor@oracle.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Ian Campbell <Ian.Campbell@citrix.com>
Subject: Re: [PATCH 2/6] xen/pvh: Extend vcpu_guest_context, p2m, event, and
 xenbus to support PVH.
Message-ID: <20121022133931.1d4750a1@mantra.us.oracle.com>
In-Reply-To: <20121022201451.GJ25200@phenom.dumpdata.com>
References: <1350695882-12820-1-git-send-email-konrad.wilk@oracle.com>
	<1350695882-12820-3-git-send-email-konrad.wilk@oracle.com>
	<alpine.DEB.2.02.1210221439530.2689@kaball.uk.xensource.com>
	<20121022113154.0e28ff1d@mantra.us.oracle.com>
	<20121022201451.GJ25200@phenom.dumpdata.com>
Organization: Oracle Corporation
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Oct 2012 16:14:51 -0400
Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:

> On Mon, Oct 22, 2012 at 11:31:54AM -0700, Mukesh Rathor wrote:
> > On Mon, 22 Oct 2012 14:44:40 +0100
> > Stefano Stabellini <stefano.stabellini@eu.citrix.com> wrote:
> > 
> > > On Sat, 20 Oct 2012, Konrad Rzeszutek Wilk wrote:
> > > > From: Mukesh Rathor <mukesh.rathor@oracle.com>
> > > > 
> > > > make gdt_frames[]/gdt_ents into a union with {gdtaddr, gdtsz},
> > > > as PVH only needs to send down gdtaddr and gdtsz.
> > > > 
> > > > For interrupts, PVH uses native_irq_ops.
> > > > vcpu hotplug is currently not available for PVH.
> > > > 
> > > > For events we follow what PVHVM does - to use callback vector.
> > > > Lastly, also use HVM path to setup XenBus.
> > > > 
> > > > Signed-off-by: Mukesh Rathor <mukesh.rathor@oracle.com>
> > > > Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> > > > ---
> > > >  		return true;
> > > >  	}
> > > > -	xen_copy_trap_info(ctxt->trap_ctxt);
> > > > +	/* check for autoxlated to get it right for 32bit
> > > > kernel */
> > > 
> > > I am not sure what this comment means, considering that in another
> > > comment below you say that we don't support 32bit PVH kernels.
> > 
> > Function is common to both 32bit and 64bit kernels. We need to
> > check for auto xlated also in the if statement in addition to
> > supervisor mode kernel, so 32 bit doesn't go down the wrong path.
> 
> Can one just make it #ifdef CONFIG_X86_64 for the whole thing?
> You are either way during bootup doing a 'BUG' when booting as 32-bit?

32bit pure pv, ie, pv mmu, path. BUG() is for 32bit PVH. 
Sure we could ifdef whole thing, but then we'd have to add more ifdef's
around else, closing else, etc.. I"m ok with whatever works for you.

thanks
mukesh



