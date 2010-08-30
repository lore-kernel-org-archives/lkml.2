Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756413Ab0H3RuZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 13:50:25 -0400
Received: from he.sipsolutions.net ([78.46.109.217]:60206 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756394Ab0H3RuX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 13:50:23 -0400
Subject: Re: [PATCH] wireless: fix 64K kernel heap content leak via ioctl
From: Johannes Berg <johannes@sipsolutions.net>
To: jt@hpl.hp.com
Cc: Kees Cook <kees.cook@canonical.com>, linux-kernel@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>, Joe Perches <joe@perches.com>,
        Tejun Heo <tj@kernel.org>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
In-Reply-To: <20100830174018.GA3639@bougret.hpl.hp.com>
References: <20100827210240.GC4703@outflux.net>
	 <20100827212254.GB32275@bougret.hpl.hp.com>
	 <1283158058.3691.10.camel@jlt3.sipsolutions.net>
	 <1283158704.3691.11.camel@jlt3.sipsolutions.net>
	 <1283162341.3691.45.camel@jlt3.sipsolutions.net>
	 <20100830174018.GA3639@bougret.hpl.hp.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 30 Aug 2010 19:50:02 +0200
Message-ID: <1283190602.3694.3.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-08-30 at 10:40 -0700, Jean Tourrilhes wrote:

>         Ha ! I see. It would be for regular iwpoint queries, not for
> extended NOMAX queries (scan is a extended NOMAX query).

Yeah, that took a while to sink in here too ..

> 	I actually like your patch better than mine, it's closer to
> the original intent of the API. Go for it ;-)

> 	Thanks a lot for the second pair of eyes.

And thank you for looking over my patch. I guess the real bug is still
in cfg80211 there.

Initially I considered setting iwp->length to zero, rather than
max_tokens. What do you think about doing that? The reason I decided to
use max_tokens was that somebody might look at the length value to know
how much to copy (which is OK only in NOMAX queries); but that would be
a more severe driver bug ... can't really make up my mind. We just copy
back zeroes anyway.

johannes

