Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751591Ab3AJJRK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 04:17:10 -0500
Received: from smtp-fw-33001.amazon.com ([207.171.189.228]:63456 "EHLO
	smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750949Ab3AJJRH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 04:17:07 -0500
X-IronPort-AV: E=Sophos;i="4.84,444,1355097600"; 
   d="scan'208";a="437961895"
Date: Thu, 10 Jan 2013 10:16:53 +0100
From: Matt Wilson <msw@amazon.com>
To: Ian Campbell <Ian.Campbell@citrix.com>
CC: ANNIE LI <annie.li@oracle.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>
Subject: Re: [Xen-devel] [PATCH v2] xen/grant-table: correctly initialize
 grant table version 1
Message-ID: <20130110091652.GB6316@u109add4315675089e695.ant.amazon.com>
References: <1355997710.26722.12.camel@zakaz.uk.xensource.com>
 <1357470882-17345-1-git-send-email-msw@amazon.com>
 <50ECD89A.50100@oracle.com>
 <1357732929.7989.250.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1357732929.7989.250.camel@zakaz.uk.xensource.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 09, 2013 at 12:02:09PM +0000, Ian Campbell wrote:
> On Wed, 2013-01-09 at 02:40 +0000, ANNIE LI wrote:
> > > @@ -1080,18 +1081,18 @@ static void gnttab_request_version(void)
> > >   		panic("we need grant tables version 2, but only version 1 is available");
> > >   	} else {
> > >   		grant_table_version = 1;
> > > +		grefs_per_grant_frame = PAGE_SIZE / sizeof(struct grant_entry_v1);
> > >   		gnttab_interface =&gnttab_v1_ops;
> > >   	}
> > > -	printk(KERN_INFO "Grant tables using version %d layout.\n",
> > > -		grant_table_version);
> > >   }
> > >   
> > 
> > Is it better to keep printk here? In your last patch, you removed it 
> > because gnttab_request_version and gnttab_resume are all called in 
> > gnttab_init. and gnttab_resume also contains calling of 
> > gnttab_request_version. But in this patch, gnttab_setup is used, and 
> > does not have this issue now.
> 
> Yes, I think we want to print this at both start of day and resume?
> 
> Either by adding a print to gnttab_resume() or by keeping the existing
> one here in preference to moving it to gnttab_setup(). I'd prefer the
> latter to avoid the duplication, unless I'm mistaken and request_version
> is called in more than those two locations.

In this version the printk() is in gnttab_setup(), which is called
both at start of day (gnttab_init()) and resume (gnttab_resume()). I
can move it back to gnttab_request_version() if you'd like, but this
patch should be behaving as expected already.

Matt
