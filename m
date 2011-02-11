Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932408Ab1BKV0H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 16:26:07 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41560 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932175Ab1BKV0F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 16:26:05 -0500
Date: Fri, 11 Feb 2011 13:23:52 -0800
From: Greg KH <gregkh@suse.de>
To: KY Srinivasan <kys@microsoft.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: Re: [PATCH 1/3]: Staging: hv: Use native page allocation/free
 functions
Message-ID: <20110211212352.GA10845@suse.de>
References: <1297447140-21777-1-git-send-email-kys@microsoft.com>
 <20110211182949.GA10751@suse.de>
 <FB42D5CCD7B5934EB1827DB5ED9B850E0B2653@tk5ex14mbxc106.redmond.corp.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <FB42D5CCD7B5934EB1827DB5ED9B850E0B2653@tk5ex14mbxc106.redmond.corp.microsoft.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 11, 2011 at 08:55:56PM +0000, KY Srinivasan wrote:
> 
> 
> > -----Original Message-----
> > From: Greg KH [mailto:gregkh@suse.de]
> > Sent: Friday, February 11, 2011 1:30 PM
> > To: KY Srinivasan
> > Cc: linux-kernel@vger.kernel.org; devel@linuxdriverproject.org;
> > virtualization@lists.osdl.org; Hank Janssen
> > Subject: Re: [PATCH 1/3]: Staging: hv: Use native page allocation/free functions
> > 
> > On Fri, Feb 11, 2011 at 09:59:00AM -0800, K. Y. Srinivasan wrote:
> > > --- a/drivers/staging/hv/hv.c
> > > +++ b/drivers/staging/hv/hv.c
> > > @@ -230,7 +230,12 @@ int hv_init(void)
> > >  	* Allocate the hypercall page memory
> > >  	* virtaddr = osd_page_alloc(1);
> > >  	*/
> > > -	virtaddr = osd_virtual_alloc_exec(PAGE_SIZE);
> > > +#ifdef __x86_64__
> > > +	virtaddr = __vmalloc(PAGE_SIZE, GFP_KERNEL, PAGE_KERNEL_EXEC);
> > #else
> > > +	virtaddr =  __vmalloc(PAGE_SIZE, GFP_KERNEL,
> > > +			__pgprot(__PAGE_KERNEL & (~_PAGE_NX))); #endif
> > 
> > I'm not saying this patch is wrong at all, but I still don't understand why this is
> > different depending on the architecture of the machine.  Why is this necessary, it
> > should be ok to do the same type of allocation no matter what the processor is,
> > right?
> 
> You are right Greg; I don't think there is a need to specify different page
> protection bits based on the architecture - PAGE_KERNEL_EXEC should be enough.

I thought so, but for some reason Hank said there this was needed.
Hank, is it still true?

> However, this is the code that is currently in the tree - refer to osd.c.

Oh, I remember, it's not a critique of this patch, it just reminded me
of this question I always had for this code.

> If it is ok with you, I could submit an additional patch to clean this up.  

If Hank says it is ok, and you all test it to verify nothing breaks,
please send it on.

thanks,

greg k-h
