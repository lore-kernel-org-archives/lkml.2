Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751777Ab0LUQea (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 11:34:30 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60380 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750857Ab0LUQe3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 11:34:29 -0500
Date: Tue, 21 Dec 2010 16:34:41 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Saravana Kannan <skannan@codeaurora.org>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: Update consumer state only after set
 voltage succeeds.
Message-ID: <20101221163441.GC21871@opensource.wolfsonmicro.com>
References: <1292625868-26862-1-git-send-email-skannan@codeaurora.org>
 <20101220123903.GE26706@rakim.wolfsonmicro.main>
 <4D0FD85C.1020307@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D0FD85C.1020307@codeaurora.org>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 20, 2010 at 02:27:40PM -0800, Saravana Kannan wrote:

> I agree it looks a bit odd and I'm willing to do the code reorg if
> there is a better way. But I definitely wouldn't call this as

See the suggestion I made in the previous mail - try doing it by making
the change, then backing it out again if the attempt fails.

> randomly ignoring a consumer. We are just avoiding the consumer
> that's changing the range from "voting twice". We already send the
> new request thru min/max params.

It's a code clarity issue rather than a correctness issue.  When you're
in the code doing the check it's not terribly obvious why you're
ignoring it, and if you make any changes to the structure here or check
from other places you need to worry about which consumer to ignore.  If
we ever end up wanting to ignore two it'd be fun also...

> Do you have any suggestions for a better way to compute the min/max
> while leaving out a single consumer? I'm very much open to do that.

It seems better to arrange things so we don't ignore a consumer so the
check function doesn't need to worry about what it's checking, it just
goes and does it.
