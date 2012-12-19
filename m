Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755798Ab2LSRxv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 12:53:51 -0500
Received: from mail-lb0-f178.google.com ([209.85.217.178]:49354 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753072Ab2LSRxp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 12:53:45 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFx71aA5_eX1=DjKG-Wd0u9YeryD6FeAk9HJ1DnxRTwPoA@mail.gmail.com>
References: <50CF89EB.2030109@kernel.dk>
	<20121218092554.GA3823@gmail.com>
	<50D056A5.3040501@kernel.dk>
	<CA+55aFzhfknCd-JERhrDfkOhdm_eytoVBYA42ex2K+BghBaBKQ@mail.gmail.com>
	<50D1D373.5060301@kernel.dk>
	<CA+55aFx71aA5_eX1=DjKG-Wd0u9YeryD6FeAk9HJ1DnxRTwPoA@mail.gmail.com>
Date: Wed, 19 Dec 2012 09:53:39 -0800
Message-ID: <CAD=FV=XC5CnWLDG=+faGTzx7J3x6f1eCkNMcBGKtsWHg8vXbOg@mail.gmail.com>
Subject: Re: [boot crash] Re: [GIT PULL[ block drivers bits for 3.8
From: Doug Anderson <dianders@chromium.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jens Axboe <axboe@kernel.dk>, Shaohua Li <shli@fusionio.com>,
        Neil Brown <neilb@suse.de>, Ingo Molnar <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 19, 2012 at 8:29 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> I presumably happens on pretty much anything that doesn't have
> discard. Of course, I've personally gotten rid of any rotating devices
> I have, but it still sounds like there's a big testing hole somewhere.

For what it's worth, I have tested Linus's patch on my ARM Chromebook
(which was reproducing the divide by 0 yesterday).  With the patch the
system has no divide by 0 and still boots fine.

Interestingly enough the divide by 0 appeared to happen at probe time
once for each partition of both the internal eMMC and the external SD
card.  Later in the boot sequence the code runs with a non-zero
discard.  I'm not familiar enough with this part of the kernel to
speculate why this system behaves differently than the systems that
Jens tested on.
