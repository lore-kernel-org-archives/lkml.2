Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752051Ab1ACU06 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 15:26:58 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34456 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750995Ab1ACU05 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 15:26:57 -0500
MIME-Version: 1.0
In-Reply-To: <849307$b0clt4@azsmga001.ch.intel.com>
References: <4D21DC41.8070408@t-online.de> <b7da2f$q1ffv6@fmsmga001.fm.intel.com>
 <4D22119B.9050007@t-online.de> <AANLkTikffkQJnVKzcGhEZjPqg_iQPQ+P2Bbqz7A9Unq_@mail.gmail.com>
 <849307$b0clt4@azsmga001.ch.intel.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 3 Jan 2011 12:26:07 -0800
Message-ID: <AANLkTi=JGSL5=cXRJgv857AXx64OvWzz8TAS4XJNHtW8@mail.gmail.com>
Subject: Re: [PATCH] Fix i915 drm regression on AOpen i915GMm-HFS motherboard
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Knut Petersen <Knut_Petersen@t-online.de>, airlied@linux.ie,
        eric@anholt.net, jesse.barnes@intel.com, linux-kernel@vger.kernel.org,
        intel-gfx <intel-gfx@lists.freedesktop.org>, gregkh@suse.de,
        Jean Delvare <khali@linux-fr.org>,
        David Brownell <david-b@pacbell.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ related, but independent, issue ]

On Mon, Jan 3, 2011 at 11:59 AM, Chris Wilson <chris@chris-wilson.co.uk> wrote:
>
>                            That function currently requires
> GMBUS to differentiate between a NAK and an IO error (bitbanging just
> returns EREMOTEIO regardless, iirc).

Hmm. That sounds like something that would be worth fixing regardless
and independently of this. I'd expect that a lot of users would care
whether there was an actual protocol error or whether the command got
a NAK. There's a big difference between "those lines don't seem to
even be connected to anything" and "the other end didn't like us".

Even the comments in the bitbanging code seem to say that it should be
returning ETIMEDOUT etc for when there is no answer (and the low-level
"i2c_outb()" seems to do that), but then the code does seem to ignore
all that information and turn all errors into EREMOTEIO.

Which sounds bogus.

Added Jean to the cc in case he has some input (or knows who we should
bug about algo-bit.c). Also David Brownell, because he touched an
error code in that file two and a half years ago, so he now owns it
forever ;)

                         Linus
