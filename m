Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758161Ab1BKVBK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 16:01:10 -0500
Received: from mailb.microsoft.com ([131.107.115.215]:6340 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758096Ab1BKVBI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 16:01:08 -0500
X-Greylist: delayed 311 seconds by postgrey-1.27 at vger.kernel.org; Fri, 11 Feb 2011 16:01:08 EST
From: KY Srinivasan <kys@microsoft.com>
To: Greg KH <gregkh@suse.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: RE: [PATCH 1/3]: Staging: hv: Use native page allocation/free
 functions
Thread-Topic: [PATCH 1/3]: Staging: hv: Use native page allocation/free
 functions
Thread-Index: AQHLyhREQLJs9mA8vUSybVGIJ0ascZP9JUiA//+KTxA=
Date: Fri, 11 Feb 2011 20:55:56 +0000
Message-ID: <FB42D5CCD7B5934EB1827DB5ED9B850E0B2653@tk5ex14mbxc106.redmond.corp.microsoft.com>
References: <1297447140-21777-1-git-send-email-kys@microsoft.com>
 <20110211182949.GA10751@suse.de>
In-Reply-To: <20110211182949.GA10751@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.123.12]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Greg KH [mailto:gregkh@suse.de]
> Sent: Friday, February 11, 2011 1:30 PM
> To: KY Srinivasan
> Cc: linux-kernel@vger.kernel.org; devel@linuxdriverproject.org;
> virtualization@lists.osdl.org; Hank Janssen
> Subject: Re: [PATCH 1/3]: Staging: hv: Use native page allocation/free functions
> 
> On Fri, Feb 11, 2011 at 09:59:00AM -0800, K. Y. Srinivasan wrote:
> > --- a/drivers/staging/hv/hv.c
> > +++ b/drivers/staging/hv/hv.c
> > @@ -230,7 +230,12 @@ int hv_init(void)
> >  	* Allocate the hypercall page memory
> >  	* virtaddr = osd_page_alloc(1);
> >  	*/
> > -	virtaddr = osd_virtual_alloc_exec(PAGE_SIZE);
> > +#ifdef __x86_64__
> > +	virtaddr = __vmalloc(PAGE_SIZE, GFP_KERNEL, PAGE_KERNEL_EXEC);
> #else
> > +	virtaddr =  __vmalloc(PAGE_SIZE, GFP_KERNEL,
> > +			__pgprot(__PAGE_KERNEL & (~_PAGE_NX))); #endif
> 
> I'm not saying this patch is wrong at all, but I still don't understand why this is
> different depending on the architecture of the machine.  Why is this necessary, it
> should be ok to do the same type of allocation no matter what the processor is,
> right?

You are right Greg; I don't think there is a need to specify different page
protection bits based on the architecture - PAGE_KERNEL_EXEC should be enough.
However, this is the code that is currently in the tree - refer to osd.c.
If it is ok with you, I could submit an additional patch to clean this up.  

Regards,

K. Y 
> 
> thanks,
> 
> greg k-h

