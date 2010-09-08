Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756854Ab0IHDiM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 23:38:12 -0400
Received: from kroah.org ([198.145.64.141]:51277 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751175Ab0IHDiL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 23:38:11 -0400
Date: Tue, 7 Sep 2010 19:38:05 -0700
From: Greg KH <greg@kroah.com>
To: "Prashant P. Shah" <pshah.mumbai@gmail.com>
Cc: Joe Perches <joe@perches.com>, gregkh@suse.de, devel@driverdev.osuosl.org,
        daniele.boncompagni@gmail.com, linux-kernel@vger.kernel.org,
        julia@diku.dk
Subject: Re: [PATCH 2/3] Staging: otus: added valid KERN_ loglevels to
	printk in wwrap.c
Message-ID: <20100908023805.GA1040@kroah.com>
References: <3f9402c47b6c1e56310bc43ea624bae01dce826f.1283865137.git.pshah.mumbai@gmail.com> <7e1ccc28be954d553b6daddf54dbc149f27c709f.1283865137.git.pshah.mumbai@gmail.com> <1283872193.23280.123.camel@Joe-Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1283872193.23280.123.camel@Joe-Laptop>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 07, 2010 at 08:09:53AM -0700, Joe Perches wrote:
> On Tue, 2010-09-07 at 18:44 +0530, Prashant P. Shah wrote:
> > This is a patch to the wwrap.c file that adds valid KERN_ loglevels
> > to printk() statements
> > 
> > Signed-off-by: Prashant P. Shah <pshah.mumbai@gmail.com>
> > ---
> >  drivers/staging/otus/wwrap.c |   33 ++++++++++++++++-----------------
> >  1 files changed, 16 insertions(+), 17 deletions(-)
> > 
> > diff --git a/drivers/staging/otus/wwrap.c b/drivers/staging/otus/wwrap.c
> []
> > @@ -358,13 +357,13 @@ void zfLnxUsbDataIn_callback(urb_t *urb)
> >  #if 0
> >  			/* Dump data */
> >  			for (ii = index; ii < pkt_len+4;) {
> > -				printk("%02x ", (buf->data[ii] & 0xff));
> > +				printk(KERN_INFO "%02x ", (buf->data[ii] & 0xff));
> >  
> >  				if ((++ii % 16) == 0)
> > -					printk("\n");
> > +					printk(KERN_INFO "\n");
> >  			}
> >  
> > -			printk("\n");
> > +			printk(KERN_INFO "\n");
> >  #endif
> >  
> >  			pad_len = 4 - (pkt_len & 0x3);
> 
> and
> 
> > @@ -636,11 +635,11 @@ u32_t zfLnxUsbSubmitTxData(zdev_t *dev)
> >  	if (TxData->hdrlen != 0) {
> >  		puTxBuf = macp->txUsbBuf[freeTxUrb];
> >  		for (i = 0; i < len; i++) {
> > -			printk("%02x ", puTxBuf[i]);
> > +			printk(KERN_INFO "%02x ", puTxBuf[i]);
> >  			if (i % 16 == 15)
> > -				printk("\n");
> > +				printk(KERN_INFO "\n");
> >  		}
> > -		printk("\n");
> > +		printk(KERN_INFO "\n");
> 
> These should use KERN_CONT.
> 
> It'd be better to use print_hex_dump() instead.

Yes, I can't accept this patch, it is incorrect.

thanks,

greg k-h
