Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757094Ab0GIOaP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 10:30:15 -0400
Received: from casper.infradead.org ([85.118.1.10]:42644 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756749Ab0GIOaN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 10:30:13 -0400
Subject: Re: periods and deadlines in SCHED_DEADLINE
From: Peter Zijlstra <peterz@infradead.org>
To: Raistlin <raistlin@linux.it>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Song Yuan <song.yuan@ericsson.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Nicola Manica <nicola.manica@disi.unitn.it>,
       Luca Abeni <lucabe72@email.it>,
       Claudio Scordino <claudio@evidence.eu.com>,
       Harald Gustafsson <harald.gustafsson@ericsson.com>,
       Bjoern Brandenburg <bbb@email.unc.edu>, bastoni@cs.unc.edu,
       Giuseppe Lipari <lipari@retis.sssup.it>
In-Reply-To: <1278682707.6083.227.camel@Palantir>
References: <1278682707.6083.227.camel@Palantir>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 09 Jul 2010 16:30:00 +0200
Message-ID: <1278685800.1900.212.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-07-09 at 15:38 +0200, Raistlin wrote:
> 
> Therefore, here it is my proposal:
>  - if the programmer specify both period and deadline, I act as above,
>    running the _only_necessary_ test in the kernel, assuming that
>    userspace performed some other kind of (correct!) admission test by
>    its own, or that it is cool with missing some deadlines... What do
>    you think?

It would be good to provide room in the interface to improve upon this
situation.

One thing we could do, although this would make the proposed scheduler a
wee bit more complex, is split between hard and soft realtime. Only
accept P==rel_D for hard, and schedule the soft tasks in the hard slack
or something like that.

That way we can later extend the hard admission tests to accept more.

