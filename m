Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932363Ab2EWNTY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 09:19:24 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:43240 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750747Ab2EWNTX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 09:19:23 -0400
Date: Wed, 23 May 2012 09:12:42 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Simon Graham <simon.graham@citrix.com>
Cc: Ian Campbell <Ian.Campbell@citrix.com>,
        Ben Hutchings <bhutchings@solarflare.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Adnan Misherfi <adnan.misherfi@oracle.com>
Subject: Re: [PATCH] xen/netback: calculate correctly the SKB slots.
Message-ID: <20120523131242.GA15406@phenom.dumpdata.com>
References: <1337621793-12486-1-git-send-email-konrad.wilk@oracle.com>
 <1337627640.2979.33.camel@bwh-desktop.uk.solarflarecom.com>
 <1337678512.10118.40.camel@zakaz.uk.xensource.com>
 <20120522180901.GC22488@phenom.dumpdata.com>
 <F02ED76F3FCF8C468AD22A7618C05BBBB18DBFFE61@FTLPMAILBOX01.citrite.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <F02ED76F3FCF8C468AD22A7618C05BBBB18DBFFE61@FTLPMAILBOX01.citrite.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 22, 2012 at 03:01:55PM -0400, Simon Graham wrote:
> > >
> > > > >  	int i, copy_off;
> > > > >
> > > > >  	count = DIV_ROUND_UP(
> > > > > -			offset_in_page(skb->data)+skb_headlen(skb),
> > PAGE_SIZE);
> > > > > +			offset_in_page(skb->data + skb_headlen(skb)),
> > PAGE_SIZE);
> > > >
> > > > The new version would be equivalent to:
> > > > 	count = offset_in_page(skb->data + skb_headlen(skb)) != 0;
> > > > which is not right, as netbk_gop_skb() will use one slot per page.
> > >
> > > Just outside the context of this patch we separately count the frag
> > > pages.
> > >
> > > However I think you are right if skb->data covers > 1 page, since the
> > > new version can only ever return 0 or 1. I expect this patch papers
> > over
> > > the underlying issue by not stopping often enough, rather than
> > actually
> > > fixing the underlying issue.
> > 
> > Ah, any thoughts? Have you guys seen this behavior as well?
> 
> We ran into this same problem and the fix we've been running with for a while now (been meaning to submit it!) is:

Where is the patchqueue of the patches? Is it only on the src.rpm or
is it in some nice mercurial tree? Asking b/c if we run into other trouble
it would be also time-saving for us (and I presume other companies
too) to check that. Thanks!
