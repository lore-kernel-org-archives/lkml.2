Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755209Ab1IFQLG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 12:11:06 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:56308 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755191Ab1IFQK6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 12:10:58 -0400
X-IronPort-AV: E=Sophos;i="4.68,339,1312156800"; 
   d="scan'208";a="7632134"
Date: Tue, 6 Sep 2011 17:19:01 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ian Campbell <Ian.Campbell@eu.citrix.com>
Subject: Re: [PATCH] xen: modify kernel mappings corresponding to granted
 pages
In-Reply-To: <20110809023407.GA13905@dumpdata.com>
Message-ID: <alpine.DEB.2.00.1109051657550.12963@kaball-desktop>
References: <1311699345-32579-1-git-send-email-stefano.stabellini@eu.citrix.com> <20110809023407.GA13905@dumpdata.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Aug 2011, Konrad Rzeszutek Wilk wrote:
> On Tue, Jul 26, 2011 at 05:55:45PM +0100, stefano.stabellini@eu.citrix.com wrote:
> > From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> >
> > If we want to use granted pages for AIO, changing the mappings of a user
> > vma and the corresponding p2m is not enough, we also need to update the
> > kernel mappings accordingly.
> > On x86_64 it is easy, we can issue another HYPERVISOR_grant_table_op
> > right away in m2p_add_override. We can remove the mappings using another
> > HYPERVISOR_grant_table_op in m2p_remove_override.
> > On x86_32 it is more difficult because the pages are highmem pages and
> > therefore we need to catch the set_pte that tries to map a granted page
> > and issue an HYPERVISOR_grant_table_op instead.
> > Same thing for unmapping them: we need to catch the pte clear or the
> > set_pte that try to unmap a granted page and issue an
> > HYPERVISOR_grant_table_op.
> 
> So I hadn't looked at this in detail, but I wonder if we can use the
> MULTIcall for this? It looks like we need to do two hypercalls so why
> not batch it?

It wasn't easy but I managed to use multicalls in both m2p override and
the highmem counterparts in xen/mmu.c.
I'll send the multicall changes as a separate patch because I think
is going to be easier to read.
