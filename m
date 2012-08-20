Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754655Ab2HTL7B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 07:59:01 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:8537 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754378Ab2HTL66 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 07:58:58 -0400
X-IronPort-AV: E=Sophos;i="4.77,796,1336348800"; 
   d="scan'208";a="14083372"
Date: Mon, 20 Aug 2012 12:58:37 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Ian Campbell <Ian.Campbell@citrix.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH 06/11] xen/mmu: For 64-bit do not call
 xen_map_identity_early
In-Reply-To: <1345463624.28762.67.camel@zakaz.uk.xensource.com>
Message-ID: <alpine.DEB.2.02.1208201257420.15568@kaball.uk.xensource.com>
References: <1345133009-21941-1-git-send-email-konrad.wilk@oracle.com>  <1345133009-21941-7-git-send-email-konrad.wilk@oracle.com>  <alpine.DEB.2.02.1208171839590.15568@kaball.uk.xensource.com>  <20120817174549.GA14257@phenom.dumpdata.com> 
 <alpine.DEB.2.02.1208201243180.15568@kaball.uk.xensource.com> <1345463624.28762.67.camel@zakaz.uk.xensource.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Aug 2012, Ian Campbell wrote:
> On Mon, 2012-08-20 at 12:45 +0100, Stefano Stabellini wrote:
> > On Fri, 17 Aug 2012, Konrad Rzeszutek Wilk wrote:
> > > On Fri, Aug 17, 2012 at 06:41:23PM +0100, Stefano Stabellini wrote:
> > > > On Thu, 16 Aug 2012, Konrad Rzeszutek Wilk wrote:
> > > > > B/c we do not need it. During the startup the Xen provides
> > > > > us with all the memory mapped that we need to function.
> > > > 
> > > > Shouldn't we check to make sure that is actually true (I am thinking at
> > > > nr_pt_frames)?
> > > 
> > > I was looking at the source code (hypervisor) to figure it out and
> > > that is certainly true.
> > > 
> > > 
> > > > Or is it actually stated somewhere in the Xen headers?
> > > 
> > > Couldn't find it, but after looking so long at the source code
> > > I didn't even bother looking for it.
> > > 
> > > Thought to be honest - I only looked at how the 64-bit pagetables
> > > were set up, so I didn't dare to touch the 32-bit. Hence the #ifdef
> > 
> > I think that we need to involve some Xen maintainers and get this
> > written down somewhere in the public headers, otherwise we have no
> > guarantees that it is going to stay as it is in the next Xen versions.
> > 
> > Maybe we just need to add a couple of lines of comment to
> > xen/include/public/xen.h.
> 
> The start of day memory layout for PV guests is written down in the
> comment just before struct start_info at
> http://xenbits.xen.org/docs/unstable/hypercall/include,public,xen.h.html#Struct_start_info
> 
> (I haven't read this thread to determine if what is documented matches
> what you guys are talking about relying on)

but it is not written down how much physical memory is going to be
mapped in the bootstrap page tables.
