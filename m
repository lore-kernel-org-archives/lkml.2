Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756622Ab2HUP2S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 11:28:18 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:61387 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755020Ab2HUP2Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 11:28:16 -0400
X-IronPort-AV: E=Sophos;i="4.77,802,1336348800"; 
   d="scan'208";a="14110072"
Date: Tue, 21 Aug 2012 16:27:53 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Subject: Re: [Xen-devel] [PATCH 11/11] xen/mmu: Release just the MFN list,
 not MFN list and part of pagetables.
In-Reply-To: <20120821145713.GG20289@phenom.dumpdata.com>
Message-ID: <alpine.DEB.2.02.1208211626470.15568@kaball.uk.xensource.com>
References: <1345133009-21941-1-git-send-email-konrad.wilk@oracle.com> <1345133009-21941-12-git-send-email-konrad.wilk@oracle.com> <alpine.DEB.2.02.1208211514130.15568@kaball.uk.xensource.com> <20120821145713.GG20289@phenom.dumpdata.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Aug 2012, Konrad Rzeszutek Wilk wrote:
> On Tue, Aug 21, 2012 at 03:18:26PM +0100, Stefano Stabellini wrote:
> > On Thu, 16 Aug 2012, Konrad Rzeszutek Wilk wrote:
> > > We call memblock_reserve for [start of mfn list] -> [PMD aligned end
> > > of mfn list] instead of <start of mfn list> -> <page aligned end of mfn list].
> > > 
> > > This has the disastrous effect that if at bootup the end of mfn_list is
> > > not PMD aligned we end up returning to memblock parts of the region
> > > past the mfn_list array. And those parts are the PTE tables with
> > > the disastrous effect of seeing this at bootup:
> > 
> > This patch looks wrong to me.
> 
> Its easier to see if you stick the patch in the code. The size = part
> was actually also done earlier.

Yes, you are right, I see that know.
