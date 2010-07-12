Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756625Ab0GLTEN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 15:04:13 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48527 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755973Ab0GLTEL convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 15:04:11 -0400
MIME-Version: 1.0
In-Reply-To: <20100712185029.GB14425@pengutronix.de>
References: <alpine.LFD.2.00.1006030725420.8175@i5.linux-foundation.org>
	<20100603181010.GA25779@flint.arm.linux.org.uk>
	<1275589230.23384.19.camel@c-dwalke-linux.qualcomm.com>
	<alpine.LFD.2.00.1006031119440.8175@i5.linux-foundation.org>
	<20100614083214.GA2104@pengutronix.de>
	<20100630104043.GG11746@pengutronix.de>
	<20100712155518.GA24144@pengutronix.de>
	<AANLkTilhI9O6YwnuAylo_jNgwR8VXmpSVJ1kylIYPCGT@mail.gmail.com>
	<20100712173228.GC9897@n2100.arm.linux.org.uk>
	<AANLkTinxUqzxClVDTyruJ6kzFTganXUGJJHJ5wRi9Iak@mail.gmail.com>
	<20100712185029.GB14425@pengutronix.de>
Date: Mon, 12 Jul 2010 12:04:03 -0700
Message-ID: <AANLkTinOuU-VVXaMwMp69CBp2Y4wxpoWybEQ34H5j0lJ@mail.gmail.com>
Subject: Re: ARM defconfig files
From: Linus Torvalds <torvalds@linux-foundation.org>
To: =?ISO-8859-1?Q?Uwe_Kleine=2DK=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Daniel Walker <dwalker@codeaurora.org>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Eric Miao <eric.miao@canonical.com>, linux-omap@vger.kernel.org,
        Nicolas Pitre <nico@fluxnic.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/7/12 Uwe Kleine-König <u.kleine-koenig@pengutronix.de>:
>
> I'm willing to try my solution, some others on the linux-arm-kernel
> lists considered it worth trying, too.  Feel free to pull my tree[1].
> Russell refused to take defconfig changes for a while now, so I don't
> expect merge problems if you do.

Well, I can hardly refuse a pull that removes almost 200k lines. So
I'd happily pull it. Just this single line in your email is a very
very powerful thing:

>  177 files changed, 652 insertions(+), 194157 deletions(-)

However, before I would pull, I'd definitely like to make sure we at
least have some way forward too, and clarify some issues. So I have a
couple of questions:

 - is this guaranteed to be a no-op as things stand now, and what are
the secondary effects of it?

   Put another way: I realize that fairly late in the -rc series is
actually a really good time to do this, rather than during the merge
window itself when things are in flux. However, while it would be a
good time to pull this for that reason, it's also a _horrible_ time to
pull if it then regresses the defconfig uses, or if it causes horrible
problems for linux-next merging etc.

 - what happens when somebody wants to update the defconfig files?

   This is a question that involves a number of people, because over
the last half year, we've had lots of people changing them. "git
shortlog -ns" on that ARM config directory gives 39 people in the last
half year, with the top looking roughly like

    26  Ben Dooks
    10  Tony Lindgren
     4  Haojian Zhuang
     4  Kukjin Kim
     3  Santosh Shilimkar
     3  Sriram
     2  Janusz Krzysztofik
    ....

and how are these people going to do their updates going forward
without re-introducing the noise?

IOW, I'd _love_ to get rid of almost 200k lines of noise and your
approach would seem to have the advantage that it's "invisible" to
users. But I would want to get some kind of assurance that it's
practical to do so.

                                  Linus
