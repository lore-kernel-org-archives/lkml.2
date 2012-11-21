Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756801Ab2KVVK7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 16:10:59 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:50895 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751706Ab2KVVKz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 16:10:55 -0500
Date: Wed, 21 Nov 2012 15:00:57 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Sachin Kamat <sachin.kamat@linaro.org>, linux-kernel@vger.kernel.org,
        patches@linaro.org
Subject: Re: [PATCH 1/1] tty: vt: Remove redundant null check before kfree.
Message-ID: <20121121230057.GA29095@kroah.com>
References: <1353475147-28308-1-git-send-email-sachin.kamat@linaro.org>
 <20121121144624.GA21766@kroah.com>
 <50AD5916.3030604@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50AD5916.3030604@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 21, 2012 at 11:43:34PM +0100, Jiri Slaby wrote:
> On 11/21/2012 03:46 PM, Greg KH wrote:
> > On Wed, Nov 21, 2012 at 10:49:07AM +0530, Sachin Kamat wrote:
> >> --- a/drivers/tty/vt/consolemap.c
> >> +++ b/drivers/tty/vt/consolemap.c
> >> @@ -410,10 +410,8 @@ static void con_release_unimap(struct uni_pagedir *p)
> >>  		kfree(p->inverse_translations[i]);
> >>  		p->inverse_translations[i] = NULL;
> >>  	}
> >> -	if (p->inverse_trans_unicode) {
> >> -		kfree(p->inverse_trans_unicode);
> >> -		p->inverse_trans_unicode = NULL;
> >> -	}
> >> +	kfree(p->inverse_trans_unicode);
> >> +	p->inverse_trans_unicode = NULL;
> > 
> > kfree with NULL is a no-op, but the line after that just caused a kernel
> > crash if it was NULL, so I can't accept this type of thing.
> 
> Greg, I'm not sure -- what do you mean here? The change actually looks
> fine to me... We do not dereference p->inverse_trans_unicode there.

If we never dereference it, why is it being set to NULL?

greg k-h
