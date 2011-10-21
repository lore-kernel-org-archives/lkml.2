Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932560Ab1JXNHq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 09:07:46 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:63166 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932340Ab1JXNHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 09:07:44 -0400
Date: Thu, 20 Oct 2011 20:06:24 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Jan Beulich <JBeulich@suse.com>
Cc: Ian Campbell <Ian.Campbell@citrix.com>,
        "hch@infradead.org" <hch@infradead.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Dong Yang Li <lidongyang@suse.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH 3/3] xen/blk[front|back]: Enhance discard
 support with secure erasing support.
Message-ID: <20111021000624.GA23358@phenom.dumpdata.com>
References: <1318260494-27985-1-git-send-email-konrad.wilk@oracle.com>
 <1318260494-27985-4-git-send-email-konrad.wilk@oracle.com>
 <1318263187.21903.464.camel@zakaz.uk.xensource.com>
 <20111010164250.GG28646@phenom.oracle.com>
 <1318274402.27397.13.camel@dagon.hellion.org.uk>
 <20111010195749.GA5755@phenom.oracle.com>
 <4E940E21020000780005AA29@nat28.tlf.novell.com>
 <20111011155133.GC29349@phenom.oracle.com>
 <20111011205729.GB22668@phenom.oracle.com>
 <4E9C4855020000780005BA73@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E9C4855020000780005BA73@nat28.tlf.novell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090209.4EA56316.0010,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 17, 2011 at 02:23:01PM +0100, Jan Beulich wrote:
> >>> On 11.10.11 at 22:57, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
> > --- a/drivers/block/xen-blkfront.c
> > +++ b/drivers/block/xen-blkfront.c
> >...
> > @@ -705,7 +711,7 @@ static void blkif_free(struct blkfront_info *info, int suspend)
> >  static void blkif_completion(struct blk_shadow *s)
> >  {
> >  	int i;
> 
> This function gets called for all types of requests, and hence must filter
> discard ones now that what would be nr_segments can be non-zero,


Oooh, nice catch.

> e.g.
> 
> 	if (s->req.operation == BLKIF_OP_DISCARD)
> 		return;
> 
> Jan
> 
> > -	for (i = 0; i < s->req.nr_segments; i++)
> > +	for (i = 0; i < s->req.u1.nr_segments; i++)
> >  		gnttab_end_foreign_access(s->req.u.rw.seg[i].gref, 0, 0UL);
> >  }
> >  
> 
