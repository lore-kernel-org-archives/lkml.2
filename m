Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752938Ab1IUSqi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 14:46:38 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:38590 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750751Ab1IUSqh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 14:46:37 -0400
Date: Wed, 21 Sep 2011 14:46:30 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Matthew Wilcox <matthew@wil.cx>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: xen_biovec_phys_mergeable not exported
Message-ID: <20110921184630.GI17357@phenom.oracle.com>
References: <20110920202553.GB16740@parisc-linux.org>
 <4E79D404.7000805@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E79D404.7000805@kernel.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4E7A310A.010A:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 21, 2011 at 02:09:40PM +0200, Jens Axboe wrote:
> On 2011-09-20 22:25, Matthew Wilcox wrote:
> > 
> > In my NVMe driver, I call BIOVEC_PHYS_MERGEABLE().  If CONFIG_XEN
> > is defined, it references xen_biovec_phys_mergeable() which is not
> > EXPORT_SYMBOL.  I think BIOVEC_PHYS_MERGABLE is a perfectly kosher thing
> > to be calling from a module that implements a bio-based block driver,
> > so I think the right thing to do is to add an EXPORT_SYMBOL(_GPL?) to
> > the Xen code when I submit the driver.

I am OK with that.
> > 
> > Does anyone have a different opinion on this?
> 
> Yep, lets just export it for now. Long term, that functionality will be
> moving back into the block layer when we unify the queuing models.
> 
> -- 
> Jens Axboe
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
