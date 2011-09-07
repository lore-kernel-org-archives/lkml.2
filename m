Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756289Ab1IGSRu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 14:17:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53583 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756113Ab1IGSRt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 14:17:49 -0400
Date: Wed, 7 Sep 2011 14:17:40 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: hch@infradead.org, Jeremy Fitzhardinge <jeremy@goop.org>,
        jbeulich@novell.com, linux-kernel@vger.kernel.org, JBeulich@suse.com
Subject: Re: Help with implementing some form of barriers in 3.0 kernels.
Message-ID: <20110907181740.GG31726@redhat.com>
References: <20110907174832.GN32190@dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110907174832.GN32190@dumpdata.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 07, 2011 at 01:48:32PM -0400, Konrad Rzeszutek Wilk wrote:
> Hey Christoph,
> 
> I was wondering what you think is the proper way of implementing a
> backend to support the 'barrier' type requests? We have this issue were
> there are 2.6.36 type guests that still use barriers and we would like
> to support them properly. But in 3.0 there are no barriers - hence
> the question whether WRITE_fLUSH_FUA would be equal to WRITE_BARRIER?

I think WRITE_FLUSH_FUA is not same as WRITE_BARRIER. Because it does
not ensure request ordering. A request rq2 which is issued after rq1 (with
WRITE_flush_FUA), can still finish before rq1. In the past WRITE_BARRIER
would not allow that.

So AFAIK, WRITE_flush_fua is not WRITE_BARRIER.

Thanks
Vivek
