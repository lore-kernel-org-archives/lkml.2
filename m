Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752486Ab0LQLoe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 06:44:34 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46565 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751795Ab0LQLod (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 06:44:33 -0500
Date: Fri, 17 Dec 2010 11:44:30 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Saravana Kannan <skannan@codeaurora.org>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH 2/2] regulator: Optimise out noop voltage changes
Message-ID: <20101217114430.GB31453@rakim.wolfsonmicro.main>
References: <3bf69fb1c4f33c8a1f405b4f05ba1a59.squirrel@www.codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3bf69fb1c4f33c8a1f405b4f05ba1a59.squirrel@www.codeaurora.org>
X-Cookie: I just had a NOSE JOB!!
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 16, 2010 at 05:46:07PM -0800, Saravana Kannan wrote:
> 
> 1. With support for multiple consumers, we can further optimize and call
> the producer's set voltage only if the final voltage range changes. So if
> consumer A asks for (2.0 - 5.0) and consumer B keeps changing between (1.0
> - 5.0) and (1.5 - 5.0), then we can completely no-op all of consumer B's
> calls.

Yes, that could be done as a further optimisation - we'd be able to bale
out after the 

> 2. When I was trying to do the above this Sunday, I also noticed what
> looks like a bug or at least an unpleasant behavior. A consumer's min_uV
> and max_uV were being updated (for-next around Dec 12th) before calling
> the producer's set voltage. So, in the above example, if consumer C comes
> in and asks for (10 - 15), it will prevent the producer voltage from ever
> changing again. All of consumer A and B's future requests will result in a
> failure since min_uV > max_uV when you do the consumer aggregation.

I'm sorry I can't parse this at all.  What is a producer?

If the consumers are all asking for incompatible things there's a system
integration issue and the consumers need to be sorted out; it's
difficult for the regulator API to do anything safely while everything
wants incompatible configurations.
