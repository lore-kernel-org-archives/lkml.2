Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932720Ab2GETAN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 15:00:13 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:51691 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754615Ab2GETAJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 15:00:09 -0400
Date: Thu, 5 Jul 2012 20:59:56 +0200 (CEST)
From: Eldad Zack <eldad@fogrefinery.com>
X-X-Sender: eldad@debianer
To: Joe Perches <joe@perches.com>
cc: Trond Myklebust <Trond.Myklebust@netapp.com>,
        "J. Bruce Fields" <bfields@fieldses.org>, linux-nfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] sunrpc/cache.h: replace simple_strtoul
In-Reply-To: <1341444227.2058.5.camel@joe2Laptop>
Message-ID: <alpine.DEB.2.02.1207052039080.6660@debianer>
References: <1341442827-21339-1-git-send-email-eldad@fogrefinery.com>  <1341442827-21339-2-git-send-email-eldad@fogrefinery.com> <1341444227.2058.5.camel@joe2Laptop>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 4 Jul 2012, Joe Perches wrote:
> On Thu, 2012-07-05 at 01:00 +0200, Eldad Zack wrote:
> > This patch replaces the usage of simple_strtoul with kstrtoint in
> > get_int().
> 
> >  	int len = qword_get(bpp, buf, 50);
> This would be nicer as
> 	int len = qword_get(bpp, buf, sizeof(buf));

I agree, thanks!

> > @@ -226,8 +226,8 @@ static inline int get_int(char **bpp, int *anint)
> > +	ret = kstrtoint(buf, 0, &rv);
> > +	if (ret)
> >  		return -EINVAL;
> >  
> >  	*anint = rv;
> ret and rv aren't useful anymore.
> 
> Perhaps:
> 
> 	if (kstrtoint(buf, 0, anint))
> 		return -EINVAL;
> 
> 	return 0;

Yes, that works better, since kstrtoint() will not write to anint 
unless it's successful, so the whole business with rv is 
indeed redundant.

Looks much neater now thanks to your comments - I will resend it 
a bit later. Should I add you as Signed-off-by?

Eldad
