Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933569Ab2C2PXB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 11:23:01 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:21174 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933530Ab2C2PWy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 11:22:54 -0400
Date: Thu, 29 Mar 2012 11:17:22 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: Konrad Rzeszutek Wilk <konrad@darnok.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Subject: Re: [Xen-devel] [PATCH] xen-blkfront: set pages are FOREIGN_FRAME
 when sharing them
Message-ID: <20120329151722.GK12008@phenom.dumpdata.com>
References: <1332856198-29770-1-git-send-email-stefano.stabellini@eu.citrix.com>
 <20120327175843.GA4299@andromeda.dapyr.net>
 <alpine.DEB.2.00.1203291449360.15151@kaball-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1203291449360.15151@kaball-desktop>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090202.4F747E13.0096,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 29, 2012 at 02:56:10PM +0100, Stefano Stabellini wrote:
> On Tue, 27 Mar 2012, Konrad Rzeszutek Wilk wrote:
> > On Tue, Mar 27, 2012 at 02:49:58PM +0100, Stefano Stabellini wrote:
> > > Set pages as FOREIGN_FRAME whenever blkfront shares them with another
> > > domain. Then when blkfront un-share them, also removes the
> > > FOREIGN_FRAME_BIT from the p2m.
> > > 
> > > We do it so that when the source and the destination domain are the same
> > > (blkfront connected to blkback in the same domain) we can more easily
> > > recognize which ones are the source pfns and which ones are the
> > > destination pfns (both are going to be pointing to the same mfns).
> > > 
> > > Without this patch enstablishing a connection between blkfront and QEMU
> > > qdisk in the same domain causes QEMU to hang and never return.
> > > Considering that it fixes a serious bug, it should be backported to
> > > previous releases.
> > 
> > 
> > ERROR: "set_phys_to_machine" [drivers/block/xen-blkfront.ko] undefined!
> 
> I cannot reproduce this error: set_phys_to_machine is defined in
> arch/x86/include/asm/xen/page.h, that is included by include/xen/page.h,
> that is included by blkfront).
> What CS did you apply this patch to? What is your config?

To upstream Linus's tree.
The culprit was that I try to compile everything as modules.
> 
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xen.org
> http://lists.xen.org/xen-devel
