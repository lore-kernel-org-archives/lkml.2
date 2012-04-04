Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932409Ab2DDQYL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 12:24:11 -0400
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:16465 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932286Ab2DDQYH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 12:24:07 -0400
Date: Wed, 4 Apr 2012 18:23:48 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Chris Wilson <chris@chris-wilson.co.uk>,
        Knut Petersen <Knut_Petersen@t-online.de>, airlied@linux.ie,
        eric@anholt.net, jesse.barnes@intel.com, linux-kernel@vger.kernel.org,
        intel-gfx <intel-gfx@lists.freedesktop.org>, gregkh@suse.de
Subject: Re: [PATCH] Fix i915 drm regression on AOpen i915GMm-HFS
 motherboard
Message-ID: <20120404182348.10baa7f6@endymion.delvare>
In-Reply-To: <AANLkTi=JGSL5=cXRJgv857AXx64OvWzz8TAS4XJNHtW8@mail.gmail.com>
References: <4D21DC41.8070408@t-online.de>
	<b7da2f$q1ffv6@fmsmga001.fm.intel.com>
	<4D22119B.9050007@t-online.de>
	<AANLkTikffkQJnVKzcGhEZjPqg_iQPQ+P2Bbqz7A9Unq_@mail.gmail.com>
	<849307$b0clt4@azsmga001.ch.intel.com>
	<AANLkTi=JGSL5=cXRJgv857AXx64OvWzz8TAS4XJNHtW8@mail.gmail.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Jan 2011 12:26:07 -0800, Linus Torvalds wrote:
> [ related, but independent, issue ]
> 
> On Mon, Jan 3, 2011 at 11:59 AM, Chris Wilson <chris@chris-wilson.co.uk> wrote:
> >
> >                            That function currently requires
> > GMBUS to differentiate between a NAK and an IO error (bitbanging just
> > returns EREMOTEIO regardless, iirc).
> 
> Hmm. That sounds like something that would be worth fixing regardless
> and independently of this. I'd expect that a lot of users would care
> whether there was an actual protocol error or whether the command got
> a NAK. There's a big difference between "those lines don't seem to
> even be connected to anything" and "the other end didn't like us".
> 
> Even the comments in the bitbanging code seem to say that it should be
> returning ETIMEDOUT etc for when there is no answer (and the low-level
> "i2c_outb()" seems to do that), but then the code does seem to ignore
> all that information and turn all errors into EREMOTEIO.
> 
> Which sounds bogus.
> 
> Added Jean to the cc in case he has some input (or knows who we should
> bug about algo-bit.c). Also David Brownell, because he touched an
> error code in that file two and a half years ago, so he now owns it
> forever ;)

For the records, I did fix the bogus error codes in i2c-algo-bit in:

>From abc01b2718ee1d26e83c4c62c4b79806b3240ac7
From: Jean Delvare <khali@linux-fr.org>
Date: Sun, 30 Oct 2011 13:47:25 +0100
Subject: [PATCH] i2c-algo-bit: Return standard fault codes

Adjust i2c-algo-bit to return fault codes compliant with
Documentation/i2c/fault-codes, rather than the undocumented and
vague -EREMOTEIO.



R.I.P David...

-- 
Jean Delvare
