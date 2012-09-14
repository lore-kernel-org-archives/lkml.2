Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758776Ab2INPe5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 11:34:57 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:18075 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758665Ab2INPez (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 11:34:55 -0400
X-IronPort-AV: E=Sophos;i="4.80,423,1344211200"; 
   d="scan'208";a="14550853"
Message-ID: <1347636860.24226.236.camel@zakaz.uk.xensource.com>
Subject: Re: [PATCH v4 14/24] xen/arm: initialize grant_table on ARM
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "Tim (Xen.org)" <tim@xen.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 14 Sep 2012 16:34:20 +0100
In-Reply-To: <alpine.DEB.2.02.1209141624570.29232@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1209141145150.29232@kaball.uk.xensource.com>
	 <1347621207-11294-14-git-send-email-stefano.stabellini@eu.citrix.com>
	 <20120914131033.GM25249@phenom.dumpdata.com>
	 <alpine.DEB.2.02.1209141550080.29232@kaball.uk.xensource.com>
	 <1347635324.24226.229.camel@zakaz.uk.xensource.com>
	 <alpine.DEB.2.02.1209141624570.29232@kaball.uk.xensource.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.3-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-09-14 at 16:29 +0100, Stefano Stabellini wrote:
> On Fri, 14 Sep 2012, Ian Campbell wrote:
> > On Fri, 2012-09-14 at 15:56 +0100, Stefano Stabellini wrote:
> > > On Fri, 14 Sep 2012, Konrad Rzeszutek Wilk wrote:
> > > > On Fri, Sep 14, 2012 at 12:13:16PM +0100, Stefano Stabellini wrote:
> > > > > Initialize the grant table mapping at the address specified at index 0
> > > > > in the DT under the /xen node.
> > > > > After the grant table is initialized, call xenbus_probe (if not dom0).
> > > > 
> > > > So we don't really care about the grant's size then? The DT xen.txt
> > > > talks about it..
> > > 
> > > I am assuming that the size of the memory region specified in the device
> > > tree is sufficiently large to map the entire grant table, given that both
> > > the device tree hypervisor entry and the grant table size comes from Xen.
> > 
> > Actually, the grant table can grow dynamically under the control of the
> > guest, I think you just pass GNTTABOP_setup_table with some more frames.
> > See drivers/xen/grant_table.c:gnttab_expand().
> 
> gnttab_expand can return error if the new size exceeds
> gnttab_max_grant_frames(), that is implemented using
> GNTTABOP_query_size.

I hadn't spotted / wasn't aware that this gives you the max too.

> > > The grant table size is currently queried to Xen directly via an
> > > hypercall (GNTTABOP_query_size). Basically the size in the device tree
> > > is redundant information.
> > 
> > This size is the size of the physical address space where the guest
> > could chose map grant table frames. It could be either larger or smaller
> > than the actual grant table. (smaller because the guest could use
> > physical addresses not within this region, if it wanted to for some
> > reason).
> 
> Right.
> 
> What I am saying is that I assume that the memory region specified in
> the device tree is greater or equal than gnttab_max_grant_frames().

Makes sense.

(note that gnttab_max_grant_frames can be set on the hypervisor command
line though)

> Maybe I should add this to the device tree doc.

No harm in being explicit. 

