Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755615Ab1IHGmL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 02:42:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32628 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752489Ab1IHGmJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 02:42:09 -0400
Subject: Re: [PATCH] random: add blocking facility to urandom
From: Tomas Mraz <tmraz@redhat.com>
To: Neil Horman <nhorman@redhat.com>
Cc: Steve Grubb <sgrubb@redhat.com>, Sasha Levin <levinsasha928@gmail.com>,
        "Ted Ts'o" <tytso@mit.edu>, Jarod Wilson <jarod@redhat.com>,
        linux-crypto@vger.kernel.org, Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert.xu@redhat.com>,
        Stephan Mueller <stephan.mueller@atsec.com>,
        lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <20110907235739.GA4706@hmsreliant.think-freely.org>
References: <1314974248-1511-1-git-send-email-jarod@redhat.com>
	 <201109071630.15261.sgrubb@redhat.com> <1315427877.3576.46.camel@lappy>
	 <201109071656.49758.sgrubb@redhat.com>
	 <20110907235739.GA4706@hmsreliant.think-freely.org>
Content-Type: text/plain; charset="ISO-8859-2"
Date: Thu, 08 Sep 2011 08:41:57 +0200
Message-ID: <1315464117.11199.51.camel@vespa.frost.loc>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-09-07 at 19:57 -0400, Neil Horman wrote: 
> On Wed, Sep 07, 2011 at 04:56:49PM -0400, Steve Grubb wrote:
> > On Wednesday, September 07, 2011 04:37:57 PM Sasha Levin wrote:
> > > Anyway, it won't happen fast enough to actually not block.
> > > 
> > > Writing 1TB of urandom into a disk won't generate 1TB (or anything close
> > > to that) of randomness to cover for itself.
> > 
> > We don't need a 1:1 mapping of RNG used to entropy acquired. Its more on the scale of 
> > 8,000,000:1 or higher.
> > 
> Where are you getting that number from?
> 
> You may not need it, but there are other people using this facility as well that
> you're not considering.  If you assume that in the example Sasha has given, if
> conservatively, you have a modern disk with 4k sectors, and you fill each 4k
> sector with the value obtained from a 4 byte read from /dev/urandom, You will:
> 
> 1) Generate an interrupt for every page you write, which in turn will add at
> most 12 bits to the entropy pool
> 
> 2) Extract 32 bits from the entropy pool
> 
> Thats just a loosing proposition.   Barring further entropy generation from
> another source, this is bound to stall with this feature enabled. 
Why so? In the case the blocking limit is on 8MBits of data read
from /dev/urandom per every 1 bit added to the entropy pool (this is not
the exact way how the patch behaves but we can approximate that) I do
not see the /dev/urandom can block if the bytes read from it are written
to disk device - of course only if the device adds entropy into the
primary pool when there are writes on the device.

Of course you can still easily make the /dev/urandom to occasionally
block with this patch, just read the data and drop it.

But you have to understand that the value that will be set with the
sysctl added by this patch will be large in the order of millions of
bits.

-- 
Tomas Mraz
No matter how far down the wrong road you've gone, turn back.
                                              Turkish proverb

