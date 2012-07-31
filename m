Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754630Ab2GaOtM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 10:49:12 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:35676 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753959Ab2GaOtK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 10:49:10 -0400
Date: Tue, 31 Jul 2012 10:39:15 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Konrad Rzeszutek Wilk <konrad@darnok.org>
Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH 4/7] xen/mmu: Recycle the Xen provided L4,
 L3, and L2 pages
Message-ID: <20120731143915.GJ4789@phenom.dumpdata.com>
References: <1343335652-5659-1-git-send-email-konrad.wilk@oracle.com>
 <1343335652-5659-5-git-send-email-konrad.wilk@oracle.com>
 <alpine.DEB.2.02.1207271241580.26163@kaball.uk.xensource.com>
 <20120727173824.GD17427@andromeda.dapyr.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120727173824.GD17427@andromeda.dapyr.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > +	for (i = 0; i < ARRAY_SIZE(addr); i++) {
> > > +		unsigned j;
> > > +		/* No idea about the order the addr are in, so just do them twice. */
> > > +		for (j = 0; j < ARRAY_SIZE(addr); j++) {
> > 
> > I don't think I understand this double loop.
> 
> So with Xen toolstack, the order is L4, L3, L2, L1s.. and with
> the hypervisor it is L4, L1,... but in the future the order might
> be L1, L1 ..., L1, L2, L3, L4 (potentially?) so this double loop
> will loop around the addresses twice to catch this in case we get
> it like this.

Which we would get in case the toolstack ever decided to put those
pages in L4, L2, L3 order. Since the toolstack puts them in L4, L3, L2
and hypervisor puts it in L4, L1, L3, L2 we might as well just
simplify this and not do the extra loop. Posting patches shortly with
this.
