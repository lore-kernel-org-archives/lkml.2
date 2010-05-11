Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932755Ab0EKGVI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 02:21:08 -0400
Received: from mtagate2.de.ibm.com ([195.212.17.162]:44049 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932722Ab0EKGVD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 02:21:03 -0400
Date: Tue, 11 May 2010 08:20:50 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: john stultz <johnstul@us.ibm.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Ralf Baechle <ralf@linux-mips.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mundt <lethal@linux-sh.org>, Jim Cromie <jim.cromie@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC][PATCH 3/3] Try to convert non-trivial clocksources to
 clocksource_register_hz
Message-ID: <20100511082050.4b11e5f3@mschwide.boeblingen.de.ibm.com>
In-Reply-To: <1273519150.3843.4.camel@localhost.localdomain>
References: <1272677785-23881-1-git-send-email-johnstul@us.ibm.com>
	<1272677785-23881-2-git-send-email-johnstul@us.ibm.com>
	<1272677785-23881-3-git-send-email-johnstul@us.ibm.com>
	<20100510175338.05ef5db8@mschwide.boeblingen.de.ibm.com>
	<1273519150.3843.4.camel@localhost.localdomain>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 May 2010 12:19:10 -0700
john stultz <johnstul@us.ibm.com> wrote:

> On Mon, 2010-05-10 at 17:53 +0200, Martin Schwidefsky wrote:
> > On Fri, 30 Apr 2010 18:36:25 -0700 John Stultz <johnstul@us.ibm.com> wrote:
> > The s390 conversion to clocksource_register_khz looks good - at least
> > the kilo hertz value is correct. Bit 2^12 of the TOD value are
> > microseconds, which makes one millisecond (1000<<12). 
> 
> Thanks for the review!
> 
> However, is there a more straightforward frequency value that we could
> use? Is 4096000000 hz really the correct value or is there something
> more precise?

>From the principles of operation manual 4-37:
The TOD clock nominally is incremented by adding a one in bit position
51 every microsecond. In models having a higher or lower resolution, a
different bit position is incremented at such a frequency that the rate
of advancing the clock is the same as if a one were added in bit
position 51 every microsecond. The resolution of the TOD clock is such
that the incrementing rate is comparable to the instruction-execution
rate of the model.

Remember that the bit numbering in IBM manuals starts with 0 for the
most significant bit (bit 51 == 2^12 for a 64 bit value). The quality
of the TOD clock is very good, with ETR or STP it will be drifted to an
external time source with a precision in the range of microseconds
(you could think of it as NTP in hardware / microcode).
If there is a clocksource register function that takes a microsecond
value we could improve the precision.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

