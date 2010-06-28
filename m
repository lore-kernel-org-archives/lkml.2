Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754755Ab0F1NPS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 09:15:18 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:62993 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751755Ab0F1NPO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 09:15:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=rOWcAXsBcG2F5sX/fjcC2hMhi4fvzm5rGB+xloWP16lN0FxxVq4vZrFqRjzavQo+Yc
         M85uRhnpn5C0p4J+iVmo1Ha4dMh0p/dBuyMnJr4ni2byTtclixmjHxRi8ZbP4UsXvqMP
         xe3EJF1L1Cix2zQ7MaoE05CKQi9U6CD5n5qjs=
Date: Mon, 28 Jun 2010 17:15:11 +0400
From: Kulikov Vasiliy <segooon@gmail.com>
To: Dan Carpenter <error27@gmail.com>, trivial@kernel.org,
       Kernel Janitors <kernel-janitors@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Henk de Groot <pe1dnn@amsat.org>,
       Joe Perches <joe@perches.com>, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 15/16] trivial: use ARRAY_SIZE
Message-ID: <20100628131511.GA26416@shinshilla>
References: <1277726143-24899-1-git-send-email-segooon@gmail.com>
 <20100628125224.GJ19184@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100628125224.GJ19184@bicker>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 28, 2010 at 14:52 +0200, Dan Carpenter wrote:
> On Mon, Jun 28, 2010 at 03:55:41PM +0400, Kulikov Vasiliy wrote:
> > Change sizeof(x) / sizeof(*x) to ARRAY_SIZE(x).
> > 
> > Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
> > ---
> >  drivers/staging/wlags49_h2/hcf.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/staging/wlags49_h2/hcf.c b/drivers/staging/wlags49_h2/hcf.c
> > index 390628c..c4fe0ec 100644
> > --- a/drivers/staging/wlags49_h2/hcf.c
> > +++ b/drivers/staging/wlags49_h2/hcf.c
> > @@ -502,7 +502,7 @@ HCF_STATIC hcf_16* BASED xxxx[ ] = {
> >  #endif // MSF_COMPONENT_ID
> >  	NULL									//endsentinel
> >    };
> > -#define xxxx_PRI_IDENTITY_OFFSET	(sizeof(xxxx)/sizeof(xxxx[0]) - 3)
> > +#define xxxx_PRI_IDENTITY_OFFSET	(ARRAY_SIZE(xxxx) - 3)
> >  
> 
> I would say the more critical problem with this macro is that it doesn't
> work unless you name all your arrays "xxxx[]" so it encourages sub par
> variable names.
> 
> You could do:
> #define PRI_IDENTITY_OFFSET(x) (ARRAY_SIZE(x) - 3)

Look at the patch:

> > @@ -502,7 +502,7 @@ HCF_STATIC hcf_16* BASED xxxx[ ] = {
There is an array called 'xxxx' and macro xxxx_PRI_IDENTITY_OFFSET is defined
after array definition. This magic macroconstant is used in the code to get
elements of xxxx.
