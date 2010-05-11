Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757086Ab0EKAhy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 20:37:54 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:60069 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754496Ab0EKAhw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 20:37:52 -0400
Subject: Re: [RFC][PATCH 3/3] Try to convert non-trivial clocksources to
 clocksource_register_hz
From: john stultz <johnstul@us.ibm.com>
To: Jim Cromie <jim.cromie@gmail.com>, Darryl Veitch <dveitch@unimelb.edu.au>,
       Julien Ridoux <jridoux@unimelb.edu.au>
Cc: lkml <linux-kernel@vger.kernel.org>, Ralf Baechle <ralf@linux-mips.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mundt <lethal@linux-sh.org>, Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <AANLkTik35lel9vGzepy10zshOnvY1_P7Vbr91Q_G0PkC@mail.gmail.com>
References: <1272677785-23881-1-git-send-email-johnstul@us.ibm.com>
	 <1272677785-23881-2-git-send-email-johnstul@us.ibm.com>
	 <1272677785-23881-3-git-send-email-johnstul@us.ibm.com>
	 <AANLkTik35lel9vGzepy10zshOnvY1_P7Vbr91Q_G0PkC@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 10 May 2010 17:37:41 -0700
Message-ID: <1273538261.3843.99.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-05-10 at 17:33 -0400, Jim Cromie wrote:
> <OT - out of scope in this thread>
> 
> on 5/3, slashdot had a synopsis of this item:
> http://queue.acm.org/detail.cfm?id=1773943
> It proposes a different split of duty between kernel and NTP daemon,
> but oddly doesnt mention PTP.

Yea, I emailed with some the RADclocks folks last year. They have done
quite a bit of very interesting work, but to my knowledge, they haven't
been working with upstream very much to push the patches.

Julien/Darryl: Sorry for dragging you out here, but I was curious if you
had any plans to push your patches to lkml in the near term? From the
patches in the tarball, it looks like you're structurally fairly clean
(and you're using git, so that's good!) so they're probably a good
starting point.

However, I do still have some concerns about the new interfaces that
expose the raw counter values. From your paper (its very nice btw,
congrats!) you mentioned CLOCK_MONOTONIC_RAW as a possible C_c(t) clock,
but from the patches it seems that you found it insufficient? It would
be really interesting to hear more about that, as well as your thoughts
about the dual-system in-kernel and out of kernel NTP adjustment loops. 

I'm curious if the RADclocks calculation of C_a(t) = Cd(t) - E(t) can
actually be done in the kernel, assuming E(t) is provided by userland.
Or is that missing something core to RADclocks design?

> Does this or PTP make any sense in Linux ?

Folks are working on using PTP with Linux. My understanding is that the
interfaces don't really change except for the packet timestamping.
Google up Patrick Ohly's work for some details (although I've not heard
too much on this recently, so I'm not sure how active it is).

thanks
-john

