Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754969Ab2HOTbU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 15:31:20 -0400
Received: from waste.org ([173.11.57.241]:56948 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751785Ab2HOTbS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 15:31:18 -0400
Message-ID: <1345059051.32116.32.camel@calx>
Subject: Re: [PATCH RFC] random: Account for entropy loss due to overwrites
From: Matt Mackall <mpm@selenic.com>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: "Ted Ts'o" <tytso@mit.edu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        greg@kroah.com, w@1wt.eu, ewust@umich.edu, zakir@umich.edu,
        nadiah@cs.ucsd.edu, jhalderm@umich.edu, tglx@linutronix.de,
        davem@davemloft.net, mingo@kernel.org, hpa@zytor.com,
        DJ Johnston <dj.johnston@intel.com>, stable@vger.kernel.org
Date: Wed, 15 Aug 2012 14:30:51 -0500
In-Reply-To: <1344878779-10700-1-git-send-email-hpa@linux.intel.com>
References: <1344878779-10700-1-git-send-email-hpa@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-08-13 at 10:26 -0700, H. Peter Anvin wrote:
> From: "H. Peter Anvin" <hpa@linux.intel.com>
> 
> When we write entropy into a non-empty pool, we currently don't
> account at all for the fact that we will probabilistically overwrite
> some of the entropy in that pool.

Technically, no, nothing is overwritten. The key fact is that the mixing
function is -reversible-. Thus, even if you mix in known data, you can't
learn anything about the state and thus can't destroy any of the
existing entropy.

But you are correct, mixing new actual entropy is not purely additive
(with saturation). For that to happen, we'd need an input mixing
function with perfect maximal cascading. Instead we effectively cascade
across somewhere between 6 and 64 bits. So the truth lies somewhere
between linear and your exponential estimate (which would be the case
for mixing a single bit into the pool with XOR), but much closer to
linear due to combinatoric expansion.

On the other hand, I don't think this sort of thing matters at all.
There is so much more fundamentally wrong with even trying to do entropy
accounting in the first place that these sorts of details don't even
matter. Instead we should stop fooling ourselves and just drop the
pretense of accounting entirely. Now that we've got a much richer set of
inputs, I think the time is ripe... but of course, I'm no longer the
maintainer.

-- 
Mathematics is the supreme nostalgia of our time.


