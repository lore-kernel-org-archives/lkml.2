Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754658Ab0DEMyB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 08:54:01 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:47876 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754571Ab0DEMxx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 08:53:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=Ks91d3pHS6VtRk4VJUfNNsh6VlCwZsXzpGLQIiCs1MVmjXymGAVWt3JAUSMSaegTLF
         IIAXW5M/I5NdHttYe3mFRSXauQMIh4kVBZlxJInRwEGsXwG7rEhu2T1kLi34pcgFf8Xm
         eEt0lrOfFbY32lx21vKWkqiscNGdXlEPmRP4w=
Date: Mon, 5 Apr 2010 15:53:30 +0300
From: Dan Carpenter <error27@gmail.com>
To: Joerg Roedel <joro@8bytes.org>
Cc: Joerg Roedel <joerg.roedel@amd.com>, Ingo Molnar <mingo@elte.hu>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Shaun Ruffell <sruffell@digium.com>, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [patch] dma-debug: off by one issue
Message-ID: <20100405125329.GA16197@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Joerg Roedel <joro@8bytes.org>, Joerg Roedel <joerg.roedel@amd.com>,
	Ingo Molnar <mingo@elte.hu>,
	FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
	Shaun Ruffell <sruffell@digium.com>, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
References: <20100402112843.GI5265@bicker> <20100403204717.GS24846@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100403204717.GS24846@8bytes.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 03, 2010 at 10:47:17PM +0200, Joerg Roedel wrote:
> On Fri, Apr 02, 2010 at 02:28:43PM +0300, Dan Carpenter wrote:
> > We need to reserve the last character for the NULL terminator.
> 
> The character is already reserved by the user-to-kernel copy earlier in
> the function.
> 
> 	Joerg
> 

Yes, but the original code requires more code reading to audit. Let's 
change the commit message to say that it's a clean up patch.

regards,
dan carpenter

> > 
> > Signed-off-by: Dan Carpenter <error27@gmail.com>
> > 
> > diff --git a/lib/dma-debug.c b/lib/dma-debug.c
> > index ba8b670..01e6427 100644
> > --- a/lib/dma-debug.c
> > +++ b/lib/dma-debug.c
> > @@ -570,7 +570,7 @@ static ssize_t filter_write(struct file *file, const char __user *userbuf,
> >  	 * Now parse out the first token and use it as the name for the
> >  	 * driver to filter for.
> >  	 */
> > -	for (i = 0; i < NAME_MAX_LEN; ++i) {
> > +	for (i = 0; i < NAME_MAX_LEN - 1; ++i) {
> >  		current_driver_name[i] = buf[i];
> >  		if (isspace(buf[i]) || buf[i] == ' ' || buf[i] == 0)
> >  			break;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
