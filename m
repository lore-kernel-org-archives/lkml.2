Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757017Ab0ELRom (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 13:44:42 -0400
Received: from loki.ee.unimelb.edu.au ([128.250.76.73]:41311 "EHLO
	loki.ee.unimelb.edu.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756846Ab0ELRoj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 13:44:39 -0400
X-Greylist: delayed 3113 seconds by postgrey-1.27 at vger.kernel.org; Wed, 12 May 2010 13:44:31 EDT
Subject: Re: [RFC][PATCH 3/3] Try to convert non-trivial clocksources to clocksource_register_hz
Mime-Version: 1.0 (Apple Message framework v1078)
Content-Type: text/plain; charset=us-ascii
From: Julien Ridoux <jridoux@unimelb.edu.au>
In-Reply-To: <1273538261.3843.99.camel@localhost.localdomain>
Date: Wed, 12 May 2010 12:43:27 -0400
Cc: Jim Cromie <jim.cromie@gmail.com>, Darryl Veitch <dveitch@unimelb.edu.au>,
       lkml <linux-kernel@vger.kernel.org>, Ralf Baechle <ralf@linux-mips.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mundt <lethal@linux-sh.org>, Thomas Gleixner <tglx@linutronix.de>
Content-Transfer-Encoding: 8BIT
Message-Id: <525FE321-39F1-4EDB-AED2-E453FAD36F20@unimelb.edu.au>
References: <1272677785-23881-1-git-send-email-johnstul@us.ibm.com> <1272677785-23881-2-git-send-email-johnstul@us.ibm.com> <1272677785-23881-3-git-send-email-johnstul@us.ibm.com> <AANLkTik35lel9vGzepy10zshOnvY1_P7Vbr91Q_G0PkC@mail.gmail.com> <1273538261.3843.99.camel@localhost.localdomain>
To: john stultz <johnstul@us.ibm.com>
X-Mailer: Apple Mail (2.1078)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi John and all!

I put some comments inline.

On 10/05/2010, at 8:37 PM, john stultz wrote:

> On Mon, 2010-05-10 at 17:33 -0400, Jim Cromie wrote:
>> <OT - out of scope in this thread>
>> 
>> on 5/3, slashdot had a synopsis of this item:
>> http://queue.acm.org/detail.cfm?id=1773943
>> It proposes a different split of duty between kernel and NTP daemon,
>> but oddly doesnt mention PTP.

As a quick comment, IEEE 1588 essentially specifies the network protocol and does not say much about the synchronisation algorithm itself. Our work focuses mostly on the synchronisation algorithm. We should be able to adapt to any network protocol without too many problems (hopefully).

> Yea, I emailed with some the RADclocks folks last year. They have done
> quite a bit of very interesting work, but to my knowledge, they haven't
> been working with upstream very much to push the patches.
> 
> Julien/Darryl: Sorry for dragging you out here, but I was curious if you
> had any plans to push your patches to lkml in the near term? From the
> patches in the tarball, it looks like you're structurally fairly clean
> (and you're using git, so that's good!) so they're probably a good
> starting point.

We still really want to clean up our patches and push them upstream. We have been working at a fairly wide range of issues in the past months that have been keeping us really busy.

> However, I do still have some concerns about the new interfaces that
> expose the raw counter values. From your paper (its very nice btw,
> congrats!) you mentioned CLOCK_MONOTONIC_RAW as a possible C_c(t) clock,
> but from the patches it seems that you found it insufficient? It would
> be really interesting to hear more about that, as well as your thoughts
> about the dual-system in-kernel and out of kernel NTP adjustment loops. 

On the particular CLOCK_MONOTONIC_RAW issue, I believe we will be able to find a solution that makes use of it and avoid the need for extra interfaces. I haven't had the time to check all the possible consequences, but we will definitely bring possible issues up in the community.

We have however fairly strong feelings regarding the dual-system (kernel, NTPd adjustment loop) as you know. Some recent experiments with virtual system are giving us strong arguments to push our approach. Again, we hope to share this with the community soon.


> I'm curious if the RADclocks calculation of C_a(t) = Cd(t) - E(t) can
> actually be done in the kernel, assuming E(t) is provided by userland.
> Or is that missing something core to RADclocks design?

It can!  Our kernel patches do exactly that. The current mechanism could be improved for sure, but it is functional.

> 
>> Does this or PTP make any sense in Linux ?
> 
> Folks are working on using PTP with Linux. My understanding is that the
> interfaces don't really change except for the packet timestamping.
> Google up Patrick Ohly's work for some details (although I've not heard
> too much on this recently, so I'm not sure how active it is).

Completely agree and we hope the RADclock will be able to benefit from this low level timestamping.

I am not following the linux-kernel mailing list much at the moment. Please Cc: me on any comments or questions you guys may have.

Cheers,
Julien

> 
> thanks
> -john

