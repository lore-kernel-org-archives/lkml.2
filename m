Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752298Ab3AJKcK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 05:32:10 -0500
Received: from smtp.eu.citrix.com ([46.33.159.39]:36518 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751331Ab3AJKcI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 05:32:08 -0500
X-IronPort-AV: E=Sophos;i="4.84,443,1355097600"; 
   d="scan'208";a="570352"
Message-ID: <1357813925.7989.326.camel@zakaz.uk.xensource.com>
Subject: Re: [Xen-devel] [PATCH v2] xen/grant-table: correctly initialize
 grant table version 1
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Matt Wilson <msw@amazon.com>
CC: ANNIE LI <annie.li@oracle.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>
Date: Thu, 10 Jan 2013 10:32:05 +0000
In-Reply-To: <20130110091652.GB6316@u109add4315675089e695.ant.amazon.com>
References: <1355997710.26722.12.camel@zakaz.uk.xensource.com>
	 <1357470882-17345-1-git-send-email-msw@amazon.com>
	 <50ECD89A.50100@oracle.com>
	 <1357732929.7989.250.camel@zakaz.uk.xensource.com>
	 <20130110091652.GB6316@u109add4315675089e695.ant.amazon.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-01-10 at 09:16 +0000, Matt Wilson wrote:
> On Wed, Jan 09, 2013 at 12:02:09PM +0000, Ian Campbell wrote:
> > On Wed, 2013-01-09 at 02:40 +0000, ANNIE LI wrote:
> > > > @@ -1080,18 +1081,18 @@ static void gnttab_request_version(void)
> > > >   		panic("we need grant tables version 2, but only version 1 is available");
> > > >   	} else {
> > > >   		grant_table_version = 1;
> > > > +		grefs_per_grant_frame = PAGE_SIZE / sizeof(struct grant_entry_v1);
> > > >   		gnttab_interface =&gnttab_v1_ops;
> > > >   	}
> > > > -	printk(KERN_INFO "Grant tables using version %d layout.\n",
> > > > -		grant_table_version);
> > > >   }
> > > >   
> > > 
> > > Is it better to keep printk here? In your last patch, you removed it 
> > > because gnttab_request_version and gnttab_resume are all called in 
> > > gnttab_init. and gnttab_resume also contains calling of 
> > > gnttab_request_version. But in this patch, gnttab_setup is used, and 
> > > does not have this issue now.
> > 
> > Yes, I think we want to print this at both start of day and resume?
> > 
> > Either by adding a print to gnttab_resume() or by keeping the existing
> > one here in preference to moving it to gnttab_setup(). I'd prefer the
> > latter to avoid the duplication, unless I'm mistaken and request_version
> > is called in more than those two locations.
> 
> In this version the printk() is in gnttab_setup(), which is called
> both at start of day (gnttab_init()) and resume (gnttab_resume()). I
> can move it back to gnttab_request_version() if you'd like, but this
> patch should be behaving as expected already.

I misread the patch, you are absolutely right.

Acked-by: Ian Campbell <ian.campbell@citrix.com>


