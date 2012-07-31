Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754769Ab2GaOrf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 10:47:35 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:27735 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754022Ab2GaOrb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 10:47:31 -0400
Date: Tue, 31 Jul 2012 10:37:33 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Konrad Rzeszutek Wilk <konrad@darnok.org>
Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH 7/7] xen/mmu: Remove from __ka space PMD
 entries for pagetables.
Message-ID: <20120731143732.GI4789@phenom.dumpdata.com>
References: <1343335652-5659-1-git-send-email-konrad.wilk@oracle.com>
 <1343335652-5659-8-git-send-email-konrad.wilk@oracle.com>
 <alpine.DEB.2.02.1207271230150.26163@kaball.uk.xensource.com>
 <20120727174214.GE17427@andromeda.dapyr.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120727174214.GE17427@andromeda.dapyr.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > +	/* This is superflous and shouldn't be neccessary, but you know what
> > > +	 * lets do it. The MODULES_VADDR -> MODULES_END should be clear of
> > > +	 * anything at this stage. */
> > > +	xen_cleanhighmap(MODULES_VADDR, roundup(MODULES_VADDR, PUD_SIZE) - 1);
> > 
> > I would stick an #ifdef CONFIG_DEBUG of some kind around it
> 
> I am not really sure why, but we seem to have PMDs filed after the Xen
> pagetables. I thought it was the bootstack, but it just looked like we
> were filling up to the next PMD (so the 'roundup' right above this code
> should take care of that). But let me double check that - to reproduce
> this module loading problem I hacked the hypervisor to create a huge P2M

I am not seeing this anymore, so #ifdef DEBUG it is!
