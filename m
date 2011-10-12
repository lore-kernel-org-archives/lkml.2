Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751914Ab1JLAfb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 20:35:31 -0400
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:36492 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750991Ab1JLAfa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 20:35:30 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAHfflE55LabZ/2dsb2JhbABDqC2BBoFTAQEFOhwzCAMOCi4UJQMhARKtNJMGDoc+BKVb
Date: Wed, 12 Oct 2011 11:35:26 +1100
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
        aradford@gmail.com, xfs@oss.sgi.com
Subject: Re: 2.6.38.8 kernel bug in XFS or megaraid driver with heavy I/O load
Message-ID: <20111012003526.GI3159@dastard>
References: <20111011091757.GA32589@otto.nzcorp.net>
 <20111011133448.GA10692@infradead.org>
 <20111011141338.GA11808@otto.nzcorp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111011141338.GA11808@otto.nzcorp.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 11, 2011 at 04:13:38PM +0200, Anders Ossowicki wrote:
> On Tue, Oct 11, 2011 at 03:34:48PM +0200, Christoph Hellwig wrote:
> > This is core VM code, and operates purely on on-stack variables except
> > for the page cache radix tree nodes / pages.  So this either could be a
> > core VM bug that no one has noticed yet, or memory corruption.  Can you
> > run memtest86 on the box?
> 
> Unfortunately not, as it is a production server. Pulling it out to memtest 256G
> properly would take too long. But it seems unlikely to me that it should be
> memory corruption.  The machine has been running with the same (ecc) memory for
> more than a year and neither the service processor nor the kernel (according to
> dmesg) has caught anything before this. It would be a rare (though I admit not
> impossible) coincidence if we got catastrophic, undetected memory corruption a
> week after attaching a new raid controller with a new disk array.

Memory corruption can be caused by more than just a bad memory
stick. You've got a brand new driver running your brand new
controller and it may still have bugs - it might be scribbling over
memory it doesn't own because of off-by-one index errors, etc. It's
much more likely that that new hardware or driver code is the cause
of your problem than an undetected ECC memory error or core VM
problem.

FWIW, if it's a repeatable problem, you might want to update the
driver and controller firmware to something more recent and see if
that solves the problem....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
