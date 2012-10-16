Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754960Ab2JPWLT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 18:11:19 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:38371 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752918Ab2JPWLS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 18:11:18 -0400
Date: Tue, 16 Oct 2012 15:11:08 -0700
From: Mukesh Rathor <mukesh.rathor@oracle.com>
To: Ian Campbell <Ian.Campbell@citrix.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "Xen-devel@lists.xensource.com" <Xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH V2 2/7]: PVH: use native irq, enable
 callback, use HVM ring ops, ...
Message-ID: <20121016151108.0d30e7cf@mantra.us.oracle.com>
In-Reply-To: <1350291497.18058.5.camel@zakaz.uk.xensource.com>
References: <20121011145711.0d9c27df@mantra.us.oracle.com>
	<1350031937.14806.49.camel@zakaz.uk.xensource.com>
	<20121012120619.6d8f3317@mantra.us.oracle.com>
	<1350291497.18058.5.camel@zakaz.uk.xensource.com>
Organization: Oracle Corporation
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Oct 2012 09:58:17 +0100
Ian Campbell <Ian.Campbell@citrix.com> wrote:

> On Fri, 2012-10-12 at 20:06 +0100, Mukesh Rathor wrote:
> > On Fri, 12 Oct 2012 09:52:17 +0100
> > Ian Campbell <Ian.Campbell@citrix.com> wrote:
> > 
> > > >  drivers/xen/cpu_hotplug.c            |    4 +++-
> > > >  drivers/xen/events.c                 |    9 ++++++++-
> > > >  drivers/xen/xenbus/xenbus_client.c   |    3 ++-
> > > >  7 files changed, 27 insertions(+), 8 deletions(-)
> > > > 
> > > union {
> > > 	struct {
> > > 		unsigned long gdt_frames[16], gdt_ents;
> > > 	} pv;
> > > 	struct {
> > > 		unsigned long gdtaddr, gdtsz;
> > > 	} pvh;
> > > } gdt;
> > > 
> > > (I've gone with naming the union gdt instead of u. You might want
> > > therefore to also drop the gdt prefix from the members?)
> > 
> > Is it worth it, I mean, making it a union. Would you be OK if I just
> > used gdt_frames[0] and gdt_ends for gdtaddr and size?
> 
> What's the problem with making it a union? Seems like you are 80% of
> the way there.

No problem. It resutls in a patch on xen side too. I'll send that too.

> units AFAICT and so can be combined.
> 
> How come you don't need the same stuff for ldt*?

Happens natively. Isn't PVH great!

thanks
mukesh
