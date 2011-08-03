Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753427Ab1HCGXN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 02:23:13 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:24473 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499Ab1HCGXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 02:23:07 -0400
Date: Wed, 3 Aug 2011 08:23:05 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Igor Mammedov <imammedo@redhat.com>
cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] xen: off by one error in xen/setup.c
In-Reply-To: <4E38DDAF.4070602@redhat.com>
Message-ID: <alpine.LNX.2.00.1108030821320.4521@swampdragon.chaosbits.net>
References: <1312278325-4246-1-git-send-email-imammedo@redhat.com> <1312278325-4246-2-git-send-email-imammedo@redhat.com> <20110802170710.GS11133@dumpdata.com> <4E38DDAF.4070602@redhat.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Aug 2011, Igor Mammedov wrote:

> On 08/02/2011 07:07 PM, Konrad Rzeszutek Wilk wrote:
> > On Tue, Aug 02, 2011 at 11:45:23AM +0200, Igor Mammedov wrote:
> > > Do not try to initialize pfn beyond of available address space.
> > > 
> > > Signed-off-by: Igor Mammedov<imammedo@redhat.com>
> > > ---
> > >   arch/x86/xen/setup.c |    2 +-
> > >   1 files changed, 1 insertions(+), 1 deletions(-)
> > > 
> > > diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
> > > index 60aeeb5..2221b05 100644
> > > --- a/arch/x86/xen/setup.c
> > > +++ b/arch/x86/xen/setup.c
> > > @@ -69,7 +69,7 @@ static void __init xen_add_extra_mem(unsigned long
> > > pages)
> > > 
> > >   	xen_max_p2m_pfn = PFN_DOWN(extra_start + size);
> > > 
> > > -	for (pfn = PFN_DOWN(extra_start); pfn<= xen_max_p2m_pfn; pfn++)
> > > +	for (pfn = PFN_DOWN(extra_start); pfn<  xen_max_p2m_pfn; ++pfn)
> > >   		__set_phys_to_machine(pfn, INVALID_P2M_ENTRY);
> > 
> > Did this actually break anything?
> 
> Not really, but for the sake of correctness and as cleanup it's good idea.
> 

Ok I'm really, really nitpicking here, but if it's supposed to "clean up", 
wouldn't this:

  for (pfn = PFN_DOWN(extra_start); pfn < xen_max_p2m_pfn; ++pfn)

be preferable (note the spacing around '<') ?

-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

