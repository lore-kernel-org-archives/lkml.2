Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756482Ab1IGS3b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 14:29:31 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:25776 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751450Ab1IGS3a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 14:29:30 -0400
Date: Wed, 7 Sep 2011 14:27:49 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: hch@infradead.org, Jeremy Fitzhardinge <jeremy@goop.org>,
        jbeulich@novell.com, linux-kernel@vger.kernel.org, JBeulich@suse.com
Subject: Re: Help with implementing some form of barriers in 3.0 kernels.
Message-ID: <20110907182748.GC5888@dumpdata.com>
References: <20110907174832.GN32190@dumpdata.com>
 <20110907181740.GG31726@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110907181740.GG31726@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: rtcsinet22.oracle.com [66.248.204.30]
X-CT-RefId: str=0001.0A090207.4E67B7BF.00B3,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 07, 2011 at 02:17:40PM -0400, Vivek Goyal wrote:
> On Wed, Sep 07, 2011 at 01:48:32PM -0400, Konrad Rzeszutek Wilk wrote:
> > Hey Christoph,
> > 
> > I was wondering what you think is the proper way of implementing a
> > backend to support the 'barrier' type requests? We have this issue were
> > there are 2.6.36 type guests that still use barriers and we would like
> > to support them properly. But in 3.0 there are no barriers - hence
> > the question whether WRITE_fLUSH_FUA would be equal to WRITE_BARRIER?
> 
> I think WRITE_FLUSH_FUA is not same as WRITE_BARRIER. Because it does
> not ensure request ordering. A request rq2 which is issued after rq1 (with
> WRITE_flush_FUA), can still finish before rq1. In the past WRITE_BARRIER
> would not allow that.
> 
> So AFAIK, WRITE_flush_fua is not WRITE_BARRIER.

Ok, any thoughts on how to emulate it then perhaps? Mark each request after
rq1 with WRITE_FUA? .. But then how long should the _FUA bit be set - perhaps
until the rq1 has completed?

> 
> Thanks
> Vivek
