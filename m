Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757971Ab0KRNki (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 08:40:38 -0500
Received: from casper.infradead.org ([85.118.1.10]:37794 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757936Ab0KRNkg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 08:40:36 -0500
Subject: Re: [PATCH 01/13] writeback: IO-less balance_dirty_pages()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Chris Mason <chris.mason@oracle.com>,
        Dave Chinner <david@fromorbit.com>, Jens Axboe <axboe@kernel.dk>,
        Christoph Hellwig <hch@lst.de>, "Theodore Ts'o" <tytso@mit.edu>,
        Mel Gorman <mel@csn.ul.ie>, Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-mm <linux-mm@kvack.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, tglx <tglx@linutronix.de>
In-Reply-To: <20101118132617.GA9307@localhost>
References: <20101117042720.033773013@intel.com>
	 <20101117042849.410279291@intel.com> <1290085474.2109.1480.camel@laptop>
	 <20101118132617.GA9307@localhost>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 18 Nov 2010 14:40:06 +0100
Message-ID: <1290087606.2109.1518.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-11-18 at 21:26 +0800, Wu Fengguang wrote:
> On Thu, Nov 18, 2010 at 09:04:34PM +0800, Peter Zijlstra wrote:
> > On Wed, 2010-11-17 at 12:27 +0800, Wu Fengguang wrote:
> > > - avoid useless (eg. zero pause time) balance_dirty_pages() calls
> > > - avoid too small pause time (less than  10ms, which burns CPU power)
> > > - avoid too large pause time (more than 100ms, which hurts responsiveness)
> > > - avoid big fluctuations of pause times 
> > 
> > If you feel like playing with sub-jiffies timeouts (a way to avoid that
> > HZ=>100 assumption), the below (totally untested) patch might be of
> > help..
> 
> Assuming there are HZ=10 users.
> 
> - when choosing such a coarse granularity, do they really care about
>   responsiveness? :)

No of course not, they usually care about booting their system,.. I've
been told booting Linux on a 10Mhz FPGA is 'fun' :-)

> - will the use of hrtimer add a little code size and/or runtime
>   overheads, and hence hurt the majority HZ=100 users?

Yes it will add code and runtime overhead, but it would allow you to
have 1ms timeouts even on a HZ=100 system, as opposed to a 10ms minimum.

Anyway, I'm not saying you should do it, I just wondered if we had the
API, saw we didn't and thought it might be nice to offer it if desired.


