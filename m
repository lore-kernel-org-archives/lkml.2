Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752269Ab2LSSKo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 13:10:44 -0500
Received: from merlin.infradead.org ([205.233.59.134]:43981 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751180Ab2LSSKg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 13:10:36 -0500
Message-ID: <50D20316.7020205@kernel.dk>
Date: Wed, 19 Dec 2012 19:10:30 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Shaohua Li <shli@fusionio.com>, Neil Brown <neilb@suse.de>,
        Ingo Molnar <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [boot crash] Re: [GIT PULL[ block drivers bits for 3.8
References: <50CF89EB.2030109@kernel.dk> <20121218092554.GA3823@gmail.com> <50D056A5.3040501@kernel.dk> <CA+55aFzhfknCd-JERhrDfkOhdm_eytoVBYA42ex2K+BghBaBKQ@mail.gmail.com> <50D1D373.5060301@kernel.dk> <CA+55aFx71aA5_eX1=DjKG-Wd0u9YeryD6FeAk9HJ1DnxRTwPoA@mail.gmail.com>
In-Reply-To: <CA+55aFx71aA5_eX1=DjKG-Wd0u9YeryD6FeAk9HJ1DnxRTwPoA@mail.gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-12-19 17:29, Linus Torvalds wrote:
>> Of course it's been tested. Granted it got moved over too late (as 1 of
>> 2 that did), but I've run the branch on a multitude of systems.
>> Apparently none of them hit the case of having a zero granularity
>> reported, so never hit the bug.
> 
> I presumably happens on pretty much anything that doesn't have
> discard. Of course, I've personally gotten rid of any rotating devices
> I have, but it still sounds like there's a big testing hole somewhere.

It doesn't, though it seems so. Otherwise I definitely would have seen
it. It only happens if discard max sectors is set, but alignment isn't.
I suspect because that first divide is ordered after the
!max_discard_sectors check. At least here.

And I suspect we would have seen a lot more reports if it DID trigger
on anything that didn't have discard :-)

-- 
Jens Axboe

