Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758280Ab1F1OnO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 10:43:14 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:48048 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757357Ab1F1OmH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 10:42:07 -0400
Date: Tue, 28 Jun 2011 10:42:06 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: Sandy Harris <sandyinchina@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: random(4) driver questions
Message-ID: <20110628144206.GJ2729@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Sandy Harris <sandyinchina@gmail.com>,
	LKML <linux-kernel@vger.kernel.org>
References: <BANLkTinC7vfaRWf5TK9gJuQVtVwDkEQFcQ@mail.gmail.com>
 <20110627145442.GA2729@thunk.org>
 <BANLkTin1cABBLn0yPxk6oyTbw4miN7TEPw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTin1cABBLn0yPxk6oyTbw4miN7TEPw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 28, 2011 at 02:02:58PM +0800, Sandy Harris wrote:
> However, for the secondary pools, a block cipher seems to
> me to be the obvious thing to use because there is plenty
> of analysis, in the Yarrow paper and follow-ups, of that
> technique. Also, I think it might be faster.

Well, there hasn't actually been any analysis of the use of a block
cipher.  The Yarrow paper and all follow-ons that I'm aware simply
assume that the block cipher is secure.  Most of the Yarrow analysis
has been on what I consider to be largely pointless, academic
considerations about "what if you're able to get the internal state".
(Whereas I'm of the opinion, if you can get access to the internal
state of the kernel, you probably can do a lot of other things that
are much bigger deal --- such as, dropping in a root exploit and then
start tapping your keyboard, network, etc.)

> An AES-128 context, 11 128-bit round keys, is roughly the
> same size as one of the current secondary pools, 32 32-bit
> chunks. What would maintainers think of a patch along
> those lines?

But if you're ditching the AES key scheduling step, it's no longer
AES, which means all of the analysis for AES not necessarily
applicable....  So if you're going for a cryptographic conservative
design, it's not at all clear to me that a bastardized AES is an
improvement.

Also, note that faster is *not* a feature for a random number
generator...

> Another question is whether and when we might replace
> SHA-1 with a more modern hash. Jeff Garzik has a patch
> to add Skein to the crypto API. That would be faster
> than SHA-1 and perhaps more easily analyzed since
> the compression function is a block cipher. Of course
> the SHA-3 Advanced Hash Standard process is not
> scheduled to finish for another year and there's a
> good argument that we should wait for that.

Waiting for SHA-3 (and then giving a bit more time for the
cryptographers to spend more time trying to attack it) seems like a
better approach to me....

						- Ted
