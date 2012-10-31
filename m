Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932208Ab2JaGbZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 02:31:25 -0400
Received: from www84.your-server.de ([213.133.104.84]:60428 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751786Ab2JaGbU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 02:31:20 -0400
Message-ID: <1351665033.23165.6.camel@wall-e>
Subject: Re: [PATCH 1/2] kfifo: round up the fifo size power of 2
From: Stefani Seibold <stefani@seibold.net>
To: Yuanhan Liu <yuanhan.liu@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Date: Wed, 31 Oct 2012 07:30:33 +0100
In-Reply-To: <20121031055916.GC29509@yliu-dev.sh.intel.com>
References: <1351238218-22648-1-git-send-email-yuanhan.liu@linux.intel.com>
	 <20121029135935.bb8b0b2a.akpm@linux-foundation.org>
	 <20121031055916.GC29509@yliu-dev.sh.intel.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, den 31.10.2012, 13:59 +0800 schrieb Yuanhan Liu:
> On Mon, Oct 29, 2012 at 01:59:35PM -0700, Andrew Morton wrote:
> > On Fri, 26 Oct 2012 15:56:57 +0800
> > Yuanhan Liu <yuanhan.liu@linux.intel.com> wrote:
> > 
> > > Say, if we want to allocate a filo with size of 6 bytes, it would be safer
> > > to allocate 8 bytes instead of 4 bytes.
> > >
> > > ...
> > >  	if (!is_power_of_2(size))
> > > -		size = rounddown_pow_of_two(size);
> > > +		size = roundup_pow_of_two(size);
> > >  
> > >  	fifo->in = 0;
> > >  	fifo->out = 0;
> > 
> > hm, well, if the user asked for a 100-element fifo then it is a bit
> > strange and unexpected to give them a 128-element one.
> 
> 
> Yes, and I guess the same to give them a 64-element one.
> 
> > 
> > If there's absolutely no prospect that the kfifo code will ever support
> > 100-byte fifos then I guess we should rework the API so that the caller
> > has to pass in log2 of the size, not the size itself.  That way there
> > will be no surprises and no mistakes.
> > 
> > That being said, the power-of-2 limitation isn't at all intrinsic to a
> > fifo, so we shouldn't do this.  Ideally, we'd change the kfifo
> > implementation so it does what the caller asked it to do!
> 
> I'm fine with removing the power-of-2 limitation. Stefani, what's your
> comment on that?
> 

You can't remove the power-of-2-limitation, since this would result in a
performance decrease (bit wise and vs. modulo operation).

Andrew is right, this is an API miss design.  So it would be good to
rework the kfifo_init () and kfifo_alloc() to pass in log2 of the size,
not the size itself.

Stefani


