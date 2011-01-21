Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753263Ab1AUO3z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 09:29:55 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:46371 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752721Ab1AUO3y (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Fri, 21 Jan 2011 09:29:54 -0500
Date: Fri, 21 Jan 2011 09:28:02 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefan Bader <stefan.bader@canonical.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build warning safter merge of the swiotlb-xen tree
Message-ID: <20110121142802.GB27319@dumpdata.com>
References: <20110121124159.135c7f5f.sfr@canb.auug.org.au>
 <4D3949E4.9010407@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D3949E4.9010407@canonical.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 21, 2011 at 09:55:00AM +0100, Stefan Bader wrote:
> On 01/21/2011 02:41 AM, Stephen Rothwell wrote:
> > Hi Konrad,
> > 
> > After merging the swiotlb-xen tree, today's linux-next build (x86_64
> > allmodconfig) produced these warnings:
> > 
> > arch/x86/xen/p2m.c: In function 'xen_build_dynamic_phys_to_machine':
> > arch/x86/xen/p2m.c:251: warning: passing argument 1 of 'p2m_init' from incompatible pointer type
> > arch/x86/xen/p2m.c:121: note: expected 'long unsigned int *' but argument is of type 'long unsigned int **'
> > arch/x86/xen/p2m.c:254: warning: assignment makes pointer from integer without a cast
> > arch/x86/xen/p2m.c:256: warning: assignment from incompatible pointer type
> > 
> > Introduced by commit fc0976e2c086e6e518e32dcafedb5a2ba3ea297d ("xen: p2m:
> > correctly initialize partial p2m leave").
> > 
> Sorry about that. For some reason I was blinded to the fact that p2m holds longs
> not pointers. And "unfortunately" it works either way. The following update
> would remove the warnings. Not sure it can still be folded into the original patch.

No trouble. Folded it in the original patch you submitted and fixed the tree up.

Thank you for being diligent about this.
