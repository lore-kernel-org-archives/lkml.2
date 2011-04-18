Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754084Ab1DRJ0L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 05:26:11 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:45440 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752101Ab1DRJ0J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 05:26:09 -0400
Date: Mon, 18 Apr 2011 05:26:07 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: Shaohua Li <shaohua.li@intel.com>, lkml <linux-kernel@vger.kernel.org>,
        Tejun Heo <htejun@gmail.com>, "Shi, Alex" <alex.shi@intel.com>,
        "Chen, Tim C" <tim.c.chen@intel.com>
Subject: Re: [RFC]block: add flush request at head
Message-ID: <20110418092607.GA3837@infradead.org>
References: <1303112174.3981.187.camel@sli10-conroe>
 <4DABF194.4010603@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DABF194.4010603@fusionio.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 18, 2011 at 10:08:52AM +0200, Jens Axboe wrote:
> Might be worth adding something for this special case, seems like the
> NCQ restrictions will continue to be around forever (or a long time, at
> least).

I heared people are working on adding a queued FLUSH to the standard,
but it's going to take a long time for it to get into real life systems.

What would help now is allowing libata to actually use the FUA bit,
given that every common disk and controller supports it these days.

Shaohua, does adding a

	libata.fua = 1

to the kernel command line help your benchmark in any way?  It should
if you flushes are mostly from journal writes, but not from fsync
that didn't change any metadata.

