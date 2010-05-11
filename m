Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756794Ab0EKKt0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 06:49:26 -0400
Received: from gate.crashing.org ([63.228.1.57]:41646 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751545Ab0EKKtY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 06:49:24 -0400
Subject: Re: Rampant ext3/4 corruption on 2.6.34-rc7 with VIVT ARM (Marvell
 88f5182)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Jamie Lokier <jamie@shareable.org>
Cc: linux-kernel@vger.kernel.org, Nicolas Pitre <nico@marvell.com>,
       Saeed Bishara <saeed@marvell.com>,
       "James E.J. Bottomley" <jejb@parisc-linux.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-ext4@vger.kernel.org,
       linux-arm-kernel@lists.infradead.org
In-Reply-To: <20100511101620.GA18654@shareable.org>
References: <1273569821.21352.19.camel@pasglop>
	 <20100511101620.GA18654@shareable.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 11 May 2010 20:47:58 +1000
Message-ID: <1273574878.21352.25.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-05-11 at 11:16 +0100, Jamie Lokier wrote:
> 
> I've seen similar ext3 corruption errors with an IDE on a Sigma
> Designs EM8620 with ARM core.  It's completely unrelated :-) But the
> fault was in the IDE driver doing cache flushes too late after
> starting to set up DMA.  To diagnose it, we luckily found a
> reproducible test case, then sprinkled full cache flushes at various
> places to narrow it down, and eventually found that one full cache
> flush in the driver itself sorted it out, which told us where the
> fault was.  From there it was easy. 

Ok, well, that's -a- possibility... we'll see. I'm doing some more tests
to try to characterize the problem a bit better, then we can play with
the driver. I think it's also worth trying with earlier kernels in case
it's some kind of regression, though that means I'll have to backport my
board support for that little box :-)

Cheers,
Ben.


