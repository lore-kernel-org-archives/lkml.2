Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756047Ab0HYAix (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 20:38:53 -0400
Received: from mga09.intel.com ([134.134.136.24]:26314 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751444Ab0HYAiu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 20:38:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,265,1280732400"; 
   d="scan'208";a="650932424"
Subject: Re: [RFC -v2] kfifo writer side lock-less support
From: Huang Ying <ying.huang@intel.com>
To: Stefani Seibold <stefani@seibold.net>
Cc: "huang.ying.caritas@gmail.com" <huang.ying.caritas@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <1282677230.10219.22.camel@wall-e.seibold.net>
References: <1282614146.2708.13.camel@yhuang-dev>
	 <1282636558.7357.28.camel@wall-e.seibold.net>
	 <1282639425.2708.40.camel@yhuang-dev>
	 <1282640663.7896.17.camel@wall-e.seibold.net>
	 <1282654207.11483.32.camel@caritas-mobile.ml.org>
	 <1282677230.10219.22.camel@wall-e.seibold.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 25 Aug 2010 08:38:47 +0800
Message-ID: <1282696727.2708.73.camel@yhuang-dev>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-08-25 at 03:13 +0800, Stefani Seibold wrote:
> > > > The patch adds only 1 field (unsigned int) to struct __kfifo. I think
> > > > that should be acceptable. Because sizeof(struct __kfifo) should be much
> > > > smaller that __kfifo->mask + 1 in most cases.
> > > 
> > > I don't know what you mean with "because sizeof(struct __kfifo) should
> > > be much smaller that __kfifo->mask + 1 in most cases". I am convinced
> > > that you did not really understand the kfifo code. sizeof(struct
> > > __kfifo) is constant and __kfifo->mask + 1 is the fifo size in elements,
> > > which is not constant. Before you answering study the code first!
> > > 
> > > And is not acceptable to bload the struct __kfifo, because it will never
> > > need by the most users.
> > 
> > I mean, for most user, __kfifo->mask + 1 > sizeof(struct __kfifo), so
> > another 4 bytes for each user is relatively small.
> > 
> 
> You have no idea. As i wrote you should study the code before answering!
> 
> sizeof(struct __kfifo) is always 20 bytes on a 32 bit cpu, and
> kfifo->mask +1 depends on the size of the number of fifo elements and it
> is an initialization parameter. 

After my changing, sizeof(struct __kfifo) should be 24 on 32 bit CPU,
that is 4 bytes more. But I think for most users, kfifo->mask + 1 should
be hundreds or thousands. If the average(kfifo->mask + 1) = 256, the
increment percentage for each user is about:

4 / (256 + 20) = 1.45%

So I think the changes to the size of struct __kfifo should be
acceptable.

Best Regards,
Huang Ying


