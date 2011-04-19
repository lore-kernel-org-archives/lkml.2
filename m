Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753718Ab1DSBHK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 21:07:10 -0400
Received: from mga03.intel.com ([143.182.124.21]:24253 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752884Ab1DSBHH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 21:07:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,236,1301900400"; 
   d="scan'208";a="421584524"
Subject: Re: [RFC]block: add flush request at head
From: Shaohua Li <shaohua.li@intel.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <jaxboe@fusionio.com>, lkml <linux-kernel@vger.kernel.org>,
        Tejun Heo <htejun@gmail.com>, "Shi, Alex" <alex.shi@intel.com>,
        "Chen, Tim C" <tim.c.chen@intel.com>
In-Reply-To: <20110418092607.GA3837@infradead.org>
References: <1303112174.3981.187.camel@sli10-conroe>
	 <4DABF194.4010603@fusionio.com>  <20110418092607.GA3837@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 19 Apr 2011 09:07:04 +0800
Message-ID: <1303175224.3981.202.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-04-18 at 17:26 +0800, Christoph Hellwig wrote:
> On Mon, Apr 18, 2011 at 10:08:52AM +0200, Jens Axboe wrote:
> > Might be worth adding something for this special case, seems like the
> > NCQ restrictions will continue to be around forever (or a long time, at
> > least).
> 
> I heared people are working on adding a queued FLUSH to the standard,
> but it's going to take a long time for it to get into real life systems.
> 
> What would help now is allowing libata to actually use the FUA bit,
> given that every common disk and controller supports it these days.
> 
> Shaohua, does adding a
> 
> 	libata.fua = 1
> 
> to the kernel command line help your benchmark in any way?  It should
> if you flushes are mostly from journal writes, but not from fsync
> that didn't change any metadata.
This is a workload with fsync. I tested libata.fua=1, but nothing changed.

I also hacked the code when we proceed queue running flush list, also
proceed queue pending flush list, which doesn't change correctness for
sata. This improved a little, around 5%, but doesn't recover the whole
regression. so I still need add the flush request at queue head.

Thanks,
Shaohua


