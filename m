Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759135Ab2JKS3L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 14:29:11 -0400
Received: from 1wt.eu ([62.212.114.60]:32804 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758141Ab2JKS3J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 14:29:09 -0400
Date: Thu, 11 Oct 2012 20:29:05 +0200
From: Willy Tarreau <w@1wt.eu>
To: Romain Francoise <romain@orebokech.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org, hpa@zytor.com
Subject: Re: Linux 2.6.32.60
Message-ID: <20121011182905.GB12041@1wt.eu>
References: <20121009094453.GA4289@1wt.eu> <87y5jeqv6b.fsf@silenus.orebokech.com> <20121011062916.GG8938@1wt.eu> <87vcegq3sz.fsf@silenus.orebokech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87vcegq3sz.fsf@silenus.orebokech.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 11, 2012 at 08:09:00PM +0200, Romain Francoise wrote:
> Hi Willy,
> 
> Willy Tarreau <w@1wt.eu> writes:
> 
> > RDRAND certainly qualifies as a source of entropy and I judged it was
> > appropriate for a backport for this reason. Nobody has objected about
> > this during the review, but maybe you have a different opinion and valid
> > reasons for these patches to be reverted ?
> > [...]
> > If you think these patches constitute a regression, I can revert them.
> > However I'd like convincing arguments since they're here to help address
> > a real issue.
> 
> I have no evidence of any problems caused by including these patches. It's
> just that they don't match what I expect to find in a longterm release,
> and *if* there are issues they will only show up on a limited set of
> machines (Ivy Bridge or newer), so they will be more difficult to track
> down.

I agree but the situation with random right now is not much better.

> But if you think that including the feature is worth the risk I'm totally
> fine with it, it's your call to make anyway. :)

To be clear, I don't think we need "features" but we need to address
risks. Risks of having your servers generate a private key that someone
else on the net also uses is high right now as it has been proven (my
reverse proxy's public key at home was found on 83 other hosts on the
net before I changed it). The work done by several maintainers to provide
entropy was quick and efficient. However there are still areas where we
know that entropy is limited (eg: similarly equiped servers or appliances
connected to nothing and automatically installed by booting off a CD
would only differ by a MAC address and maybe a few other bytes). So I
think it makes sense to be able to use what the hardware provides when
it is available. My opinion indeed was that these patches seem to come
with a very low risk, and their authors were very quick to react to the
random issues so I'm sure we could count on them if we even encounter
any issue.

So in the end, my overall opinion is that the risk of having them merged
is much lower than the risk of not having them. But I could be wrong.

My concern at the moment is more that the patches are in 2.6.32 and not
in 3.0, which is something we need to sort out quickly. *that* would be
a valid reason for reverting them.

> Thanks for maintaining the 2.6.32 series!

You're welcome, and thanks to you for double-checking :-)

Willy

