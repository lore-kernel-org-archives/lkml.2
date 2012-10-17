Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756507Ab2JQJcN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 05:32:13 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:9760 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756478Ab2JQJcK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 05:32:10 -0400
X-IronPort-AV: E=Sophos;i="4.80,599,1344211200"; 
   d="scan'208";a="15220995"
Message-ID: <1350466326.2460.40.camel@zakaz.uk.xensource.com>
Subject: Re: [Xen-devel] [PATCH V2 6/7]: PVH: balloon and grant changes
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Mukesh Rathor <mukesh.rathor@oracle.com>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "Xen-devel@lists.xensource.com" <Xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 17 Oct 2012 10:32:06 +0100
In-Reply-To: <20121016170900.665acf55@mantra.us.oracle.com>
References: <20121011150113.4d525407@mantra.us.oracle.com>
	 <1350032817.14806.58.camel@zakaz.uk.xensource.com>
	 <20121016170900.665acf55@mantra.us.oracle.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.3-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-10-17 at 01:09 +0100, Mukesh Rathor wrote:
> > >  		gsv.version = 1;
> > >  	else
> > >  		gsv.version = 2;
> > > @@ -1083,12 +1088,24 @@ static void gnttab_request_version(void)
> > >  int gnttab_resume(void)
> > >  {
> > >  	unsigned int max_nr_gframes;
> > > +	char *kmsg = "Failed to kmalloc pages for pv in hvm grant
> > > frames\n"; 
> > >  	gnttab_request_version();
> > >  	max_nr_gframes = gnttab_max_grant_frames();
> > >  	if (max_nr_gframes < nr_grant_frames)
> > >  		return -ENOSYS;
> > >  
> > > +	/* PVH note: xen will free existing kmalloc'd mfn in
> > > +	 * XENMEM_add_to_physmap */
> > 
> > It doesn't leak it?
> > We should consider using xenballoon_alloc_pages here.
> 
> Well, it's a one time allocation of a dozen (iirc) pages, that are 
> returned back to dom heap.

>  We could use xenballoon, but for that we
> need to create vma first so we get the contigous VA,
>  then map each pte
> since xenballoon_ doesn't return contigous pages, and then populate
> physmap. I'm gonna punt it to phase II.  Lets get some working baseline
> in asap.

That's fair enough.


