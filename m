Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752572Ab1HVN0D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 09:26:03 -0400
Received: from router-fw.net-space.pl ([89.174.63.77]:53458 "EHLO
	router-fw.net-space.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752175Ab1HVN0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 09:26:00 -0400
Date: Mon, 22 Aug 2011 15:25:25 +0200
From: Daniel Kiper <dkiper@net-space.pl>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Daniel Kiper <dkiper@net-space.pl>, olaf@aepfle.de,
        xen-devel@lists.xensource.com, ian.campbell@citrix.com,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        horms@verge.net.au, vgoyal@redhat.com
Subject: Re: [PATCH 1/4] xen: Take into account Xen control interface changes since Xen Ver. 4.1
Message-ID: <20110822132525.GB27902@router-fw-old.local.net-space.pl>
References: <20110821135139.GB17323@router-fw-old.local.net-space.pl> <201108212356.50589.konrad.wilk@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201108212356.50589.konrad.wilk@oracle.com>
User-Agent: Mutt/1.3.28i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 21, 2011 at 11:56:50PM -0400, Konrad Rzeszutek Wilk wrote:
> > xc_interface_open() receive three arguments instead of void and returns
> > pointer to xc_interface type instead of int since Xen Ver. 4.1. Take into
> > account that and allow kexec-tools compilation with all versions of Xen.
> >
> > Signed-off-by: Daniel Kiper <dkiper@net-space.pl>
> > ---
> >  kexec/crashdump-xen.c |   15 ++++++++++++++-
> >  1 files changed, 14 insertions(+), 1 deletions(-)
> >
> > diff --git a/kexec/crashdump-xen.c b/kexec/crashdump-xen.c
> > index b347764..9dfabf8 100644
> > --- a/kexec/crashdump-xen.c
> > +++ b/kexec/crashdump-xen.c
> > @@ -126,19 +126,32 @@ unsigned long xen_architecture(struct crash_elf_info
> *elf_info)
> >  {
> >  	unsigned long machine = elf_info->machine;
> >  #ifdef HAVE_LIBXENCTRL
> > -	int xc, rc;
> > +	int rc;
> >  	xen_capabilities_info_t capabilities;
> > +#ifdef XENCTRL_HAS_XC_INTERFACE
> > +	xc_interface *xc;
> > +#else
> > +	int xc;
> > +#endif
>
> Where is the #endif for HAVE_LIBXENCTRL?

At the end of this function. It is not included in this patch.

Daniel
