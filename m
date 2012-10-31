Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932479Ab2JaGtf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 02:49:35 -0400
Received: from mga03.intel.com ([143.182.124.21]:47735 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932075Ab2JaGtd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 02:49:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,685,1344236400"; 
   d="scan'208";a="162729514"
Date: Wed, 31 Oct 2012 14:49:40 +0800
From: Yuanhan Liu <yuanhan.liu@linux.intel.com>
To: Stefani Seibold <stefani@seibold.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] kfifo: round up the fifo size power of 2
Message-ID: <20121031064940.GD29509@yliu-dev.sh.intel.com>
References: <1351238218-22648-1-git-send-email-yuanhan.liu@linux.intel.com>
 <20121029135935.bb8b0b2a.akpm@linux-foundation.org>
 <20121031055916.GC29509@yliu-dev.sh.intel.com>
 <1351665033.23165.6.camel@wall-e>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351665033.23165.6.camel@wall-e>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 31, 2012 at 07:30:33AM +0100, Stefani Seibold wrote:
> Am Mittwoch, den 31.10.2012, 13:59 +0800 schrieb Yuanhan Liu:
> > On Mon, Oct 29, 2012 at 01:59:35PM -0700, Andrew Morton wrote:
> > > On Fri, 26 Oct 2012 15:56:57 +0800
> > > Yuanhan Liu <yuanhan.liu@linux.intel.com> wrote:
> > > 
> > > > Say, if we want to allocate a filo with size of 6 bytes, it would be safer
> > > > to allocate 8 bytes instead of 4 bytes.
> > > >
> > > > ...
> > > >  	if (!is_power_of_2(size))
> > > > -		size = rounddown_pow_of_two(size);
> > > > +		size = roundup_pow_of_two(size);
> > > >  
> > > >  	fifo->in = 0;
> > > >  	fifo->out = 0;
> > > 
> > > hm, well, if the user asked for a 100-element fifo then it is a bit
> > > strange and unexpected to give them a 128-element one.
> > 
> > 
> > Yes, and I guess the same to give them a 64-element one.
> > 
> > > 
> > > If there's absolutely no prospect that the kfifo code will ever support
> > > 100-byte fifos then I guess we should rework the API so that the caller
> > > has to pass in log2 of the size, not the size itself.  That way there
> > > will be no surprises and no mistakes.
> > > 
> > > That being said, the power-of-2 limitation isn't at all intrinsic to a
> > > fifo, so we shouldn't do this.  Ideally, we'd change the kfifo
> > > implementation so it does what the caller asked it to do!
> > 
> > I'm fine with removing the power-of-2 limitation. Stefani, what's your
> > comment on that?
> > 
> 

> You can't remove the power-of-2-limitation, since this would result in a
> performance decrease (bit wise and vs. modulo operation).

Right.

> 
> Andrew is right, this is an API miss design.  So it would be good to
> rework the kfifo_init () and kfifo_alloc() to pass in log2 of the size,
> not the size itself.

Yes, this would make this issue gone completely. Would you mind to let
me do that?

	--yliu
