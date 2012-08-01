Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752787Ab2HAQFU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 12:05:20 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:16046 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241Ab2HAQFS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 12:05:18 -0400
X-IronPort-AV: E=Sophos;i="4.77,694,1336348800"; 
   d="scan'208";a="13807715"
Date: Wed, 1 Aug 2012 17:04:45 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Ian Campbell <Ian.Campbell@citrix.com>, "Tim (Xen.org)" <tim@xen.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "arnd@arndb.de" <arnd@arndb.de>
Subject: Re: [PATCH 23/24] hvc_xen: allow dom0_write_console for HVM guests
In-Reply-To: <20120801145413.GR7227@phenom.dumpdata.com>
Message-ID: <alpine.DEB.2.02.1208011704000.4645@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1207251741470.26163@kaball.uk.xensource.com> <1343316846-25860-23-git-send-email-stefano.stabellini@eu.citrix.com> <20120801145413.GR7227@phenom.dumpdata.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Aug 2012, Konrad Rzeszutek Wilk wrote:
> On Thu, Jul 26, 2012 at 04:34:05PM +0100, Stefano Stabellini wrote:
> > On ARM all guests are HVM guests, including Dom0.
> > Allow dom0_write_console to be called by an HVM domain.
> 
> Um, but xen_hvm_domain() != xen_pv_domain() so won't this return without
> printing anything?

Nope, it would call dom0_write_console that issues a console hypercall.
However I am going to remove this patch and rely on the simple serial
emulator we have in Xen for early_printk stuff

> > 
> > Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> > ---
> >  drivers/tty/hvc/hvc_xen.c |    5 +----
> >  1 files changed, 1 insertions(+), 4 deletions(-)
> > 
> > diff --git a/drivers/tty/hvc/hvc_xen.c b/drivers/tty/hvc/hvc_xen.c
> > index 3c04fb8..949edc2 100644
> > --- a/drivers/tty/hvc/hvc_xen.c
> > +++ b/drivers/tty/hvc/hvc_xen.c
> > @@ -616,12 +616,9 @@ static void xenboot_write_console(struct console *console, const char *string,
> >  	unsigned int linelen, off = 0;
> >  	const char *pos;
> >  
> > -	if (!xen_pv_domain())
> > -		return;
> > -
> >  	dom0_write_console(0, string, len);
> >  
> > -	if (xen_initial_domain())
> > +	if (!xen_pv_domain())
> >  		return;
> >  
> >  	domU_write_console(0, "(early) ", 8);
> > -- 
> > 1.7.2.5
> 
