Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754560Ab1IEPT3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 11:19:29 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58268 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754415Ab1IEPT2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 11:19:28 -0400
Date: Mon, 5 Sep 2011 08:19:24 -0700
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Regmap bulk read styles.
Message-ID: <20110905151917.GD3889@opensource.wolfsonmicro.com>
References: <4E64E16A.6060401@cam.ac.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E64E16A.6060401@cam.ac.uk>
X-Cookie: Advancement in position.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 05, 2011 at 03:49:14PM +0100, Jonathan Cameron wrote:

> The burst read is pretty much what you have covered by
> regmap_bulk_read. I assume an implementation for spi
> doing

> TX Addr1 XXXXX XXXXX XXXXX XXXXX
> RX XXXXX Data1 Data2 Data3 Data4 ...

> would be general enough to be worth providing? Any device
> that doesn't understand this should simply not use it.

Yes, that's the assumption the code is making for all buses.

> The second is more interesting.  It actually looks quite like
> your gather write.  We have a set of registers that we need
> to read.  A classic example is that a coherent set will only
> be received (e.g. valid at an instant in time) if we read
> all channels of an accelerometer in one go (between chip selects).

> Would you be in favour of an interface to handle this use case
> or is it better just to bypass regmap for this use case?
> (which would be a pity as it leads to duplication as all the
> configuration stuff fits nicely).

If you can come up with a tasteful interface for doing this I wouldn't
object but my suspicion is that it's going to be easier to reimplement.
It does seem useful, I'm just worried about how the interface would
look.

> As an aside, isn't your gather write more typically described
> as a scatter write?  (writes one coherent set to a number of
> disjoint locations?)

On the write side it's generally a gather (reading from different
locations and writing out a continuous stream) while on the read side
it's generally a scatter (reading a continuous data stream and writing
it to multiple locations).  The gather here refers to getting data from
more than one place and using it to transmit a single byte stream.
