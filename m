Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755386Ab1CVXpf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 19:45:35 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:34804 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752951Ab1CVXpe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 19:45:34 -0400
Date: Tue, 22 Mar 2011 23:45:45 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: David Collins <collinsd@codeaurora.org>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Deadlock scenario in regulator core
Message-ID: <20110322234544.GA2529@opensource.wolfsonmicro.com>
References: <4D891C59.1030009@codeaurora.org>
 <20110322223156.GA10782@opensource.wolfsonmicro.com>
 <4D893125.3030703@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D893125.3030703@codeaurora.org>
X-Cookie: Your aim is high and to the right.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 22, 2011 at 04:30:45PM -0700, David Collins wrote:
> On 03/22/2011 03:31 PM, Mark Brown wrote:

> > +	int disret;
> > +
> > +	if (rdev->supply) {
> > +		ret = regulator_enable(rdev->supply);

> This should be _regulator_enable instead of regulator_enable.  There will

Oh, feh.  The supply stuff would generally be easier if it were
consumers as you'd expect, the special casing just makes things more
fragile.  It's not clear to me that the best approach here isn't just to
make the supplies have regular consumer structs so we can do things like
this.

> also need to be a mutex lock and unlock around it for rdev->supply->mutex.

Unless we implement the above change - you're assuming that the change
to the unlocked enable is the best one.

>  I think that it needs to iterate through all supplies in the chain
> similar to how it is done in regulator_disable.

The current code (if it had compiled) would deal with that through
recursion.

> This should be _regulator_disable instead of regulator_disable.  There
> will also need to be a mutex lock and unlock around it for
> rdev->supply->mutex.  Additionally, a while loop is needed to disable all
> supplies in the chain (same as in regulator_disable).

Again, no loop needed with the code as written as it's recursive.
