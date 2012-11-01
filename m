Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759905Ab2KADlu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 23:41:50 -0400
Received: from sting.hengli.com.au ([178.18.18.71]:35486 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756112Ab2KADlr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 23:41:47 -0400
Date: Thu, 1 Nov 2012 11:41:36 +0800
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Christoph Lameter <cl@linux.com>
Cc: Shan Wei <shanwei88@gmail.com>, steffen.klassert@secunet.com,
        David Miller <davem@davemloft.net>, NetDev <netdev@vger.kernel.org>,
        Kernel-Maillist <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/9] net: xfrm: use this_cpu_ptr per-cpu helper
Message-ID: <20121101034136.GA27343@gondor.apana.org.au>
References: <509109F9.3030904@gmail.com>
 <0000013ab7e4a640-60bd5b38-a1fc-4730-b918-4109211ffea0-000000@email.amazonses.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0000013ab7e4a640-60bd5b38-a1fc-4730-b918-4109211ffea0-000000@email.amazonses.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 31, 2012 at 05:35:46PM +0000, Christoph Lameter wrote:
> On Wed, 31 Oct 2012, Shan Wei wrote:
> 
> > -
> >  	list_for_each_entry(pos, &ipcomp_tfms_list, list) {
> >  		struct crypto_comp *tfm;
> >
> >  		tfms = pos->tfms;
> > -		tfm = *per_cpu_ptr(tfms, cpu);
> > +
> > +		/* This can be any valid CPU ID so we don't need locking. */
> > +		tfm = *this_cpu_ptr(tfms);
> 
> It would be better to use
> 
> 	this_cpu_read(tfms)
> 
> since that would also make it atomic vs interrupts. The above code (both
> original and modified) could determine a pointer to a per cpu structure
> and then take an interrupt which would move the task. On return we would
> be accessing the per cpu variable of another processor.

Please refer to the comment in the patch above.

But I think the patch is wrong anyway because it would introduce
a warning, no?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
