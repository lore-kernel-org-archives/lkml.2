Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751253Ab2GJSJ5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 14:09:57 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:39868 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751058Ab2GJSJ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 14:09:56 -0400
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+zrwiavkK6tmQaLfmwtM48/lr387qFmLE
X-RZG-CLASS-ID: mo00
Date: Tue, 10 Jul 2012 20:09:53 +0200
From: Olaf Hering <olaf@aepfle.de>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Daniel Kiper <dkiper@net-space.pl>, xen-devel@lists.xensource.com,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        Jan Beulich <JBeulich@suse.com>
Subject: Re: [Xen-devel] incorrect layout of globals from head_64.S during
 kexec boot
Message-ID: <20120710180953.GB20075@aepfle.de>
References: <20120706120750.GA8970@aepfle.de>
 <4FF6FCA9020000780008E0BB@nat28.tlf.novell.com>
 <20120706133105.GA20600@aepfle.de>
 <20120706141419.GA21951@aepfle.de>
 <4FF7174C020000780008E1FF@nat28.tlf.novell.com>
 <20120706172918.GA15222@aepfle.de>
 <20120710093327.GA13864@aepfle.de>
 <20120710141411.GB1791@phenom.dumpdata.com>
 <20120710152308.GA31819@aepfle.de>
 <20120710172626.GA6868@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120710172626.GA6868@phenom.dumpdata.com>
User-Agent: Mutt/1.5.21.rev5543 (2011-12-20)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 10, Konrad Rzeszutek Wilk wrote:

> On Tue, Jul 10, 2012 at 05:23:08PM +0200, Olaf Hering wrote:
> > I was not thinking of statically allocated pages but some new concept of
> > allocating such shared pages. Shouldnt there be some dedicated area in
> > the E820 table which has to be used during the whole life time of the
> > guest?
> 
> Not that I can see. But I don't see why that could not be added? Perhaps
> the HVM loader can make it happen? But then how would it tell the kernel
> that this E820_RESERVED is the shared_info one. Not the other ones..

Maybe just use a new E820 type for this sort of thing? Its just the
question wether some other OS can cope with an unknown type. From my
reading of the e820 related code a region with an unknown type is just
ignored.

> > Are there more shared areas or is it just the shared info page?
> > 
> > > And I am kind of worried that moving it to the .data section won't
> > > be completly safe - as the decompressor might blow away that part too.
> > 
> > The decompressor may just clear the area, but since there is no way to
> > tell where the shared pages are its always a risk to allocate them at
> > compile time.
> 
> Yeah, and with the hypervisor potentially still updating the "old"
> MFN before the new kernel has registered the new MFN, we can end up
> corrupting the new kernel. Ouch.
> 
> Would all of these issues disappear if the hypervisor had a hypercall
> that would stop updating the shared info? or just deregister the MFN?
> What if you ripped the GMFN out using 'decrease_reservation' hypercall?
> Would that eliminate the pesky GMFN?

I'm not sure, most likely the gfn will just disappear from the guest,
like a ballooned page disappears. Accessing it will likely cause a
crash.

Olaf
