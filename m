Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757549Ab0ERWDh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 18:03:37 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:57486 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755287Ab0ERWDf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 18:03:35 -0400
Date: Wed, 19 May 2010 07:02:38 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
Cc: Magnus Damm <magnus.damm@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org,
       Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: [GIT PULL] sh updates for 2.6.35-rc1
Message-ID: <20100518220237.GA5933@linux-sh.org>
References: <20100518092532.GA3050@linux-sh.org> <AANLkTim6t8oG-vdLKE918Sd2TFKJpSf5Bw2PTtSsD_Fh@mail.gmail.com> <20100518101500.GA3156@linux-sh.org> <AANLkTinIVjwrQ9gza2FIvZN5w4nm8ZjSUe836oRmWYG7@mail.gmail.com> <AANLkTindMQ3Clk_qVnwUNYbbWcXjsUyyy4fQsjdDflFt@mail.gmail.com> <AANLkTilNQwo1YYT2pNJN5X0ae98iMKCdsBkcogjKZm-f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTilNQwo1YYT2pNJN5X0ae98iMKCdsBkcogjKZm-f@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 18, 2010 at 04:46:12PM +0530, Jaswinder Singh Rajput wrote:
> I am looking at the future, where multiple architecture will use each
> other files.
> 
> I am just worried about the file count. Currently :
> 
> $ ls include/linux/ | wc -l
> 1029
> 
> If other architecture will also start adding the files in
> include/linux like you did then ?
> 
> So better make another directory in include.
> 
I think you're still missing the point here, this "future" case you speak
of has been commonplace for years already now, and it's certainly not
going to change (we've had mixed architecture multi-cores under Linux for
almost 10 years now, so your future case has been going on for some time
now). All of this started out with the header for the serial block being
moved over, which is now used by 3 in-tree architectures and a 4th
architecture under development.

Things like interrupt and clock controllers are not the first things that
come to mind when people think of architecture independent drivers, but
that's really what it has come down to at this point. The driver model
and so on have helped a lot in this regard, and between that and the
early platform extensions we implemented for the platform bus it's been
possible to do things like move all of our clocksources/clockevents out
in to the driver model and permit different architectures to tie in to
them as necessary. There has been a lot of behind the scenes prep work
that we've been doing to make as much of this stuff completely
architecture independent as possible, so it's not like we've simply been
lazily shuffling headers around based on some idea of what might possible
pop up in the future. Each one of these headers has been explicitly
placed for a reason and has (or will have in a subsequent merge) multiple
architecture users.

While we could try to encapsulate some of this in some sort of pseudo
architecture abstraction, that really doesn't accomplish anything, and it
also suggests an architectural relationship where there simply isn't one.
Sure, most of these drivers and IP blocks began life inside an SH core,
but given that we now use them across a wide range of architectures, this
continued relationship simply doesn't make any sense.

Having said that, I do realize that include/linux is rather cluttered
with hardware-related stuff these days, and that at least is perhaps
something that we may wish to change some day. Having some sort of hw/
abstraction for that stuff would make it easier to see what's hardware
related and what isn't, but that's an entirely different discussion and
one that needs a lot of thinking and consensus. asm/ certainly isn't the
place for these things however, given that at the end of the day they
really have nothing to do with any specific architecture.
