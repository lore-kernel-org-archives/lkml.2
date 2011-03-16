Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753907Ab1CPTzR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 15:55:17 -0400
Received: from waste.org ([173.11.57.241]:36467 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753528Ab1CPTzN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 15:55:13 -0400
Subject: Re: [PATCH 1/8] drivers/random: Cache align ip_random better
From: Matt Mackall <mpm@selenic.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Hugh Dickins <hughd@google.com>, George Spelvin <linux@horizon.com>,
        penberg@cs.helsinki.fi, herbert@gondor.hengli.com.au,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
In-Reply-To: <1300303593.3202.30.camel@edumazet-laptop>
References: <20110316022804.27679.qmail@science.horizon.com>
	 <alpine.LSU.2.00.1103161011370.13407@sister.anvils>
	 <1300299787.3128.495.camel@calx> <1300303593.3202.30.camel@edumazet-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 16 Mar 2011 14:55:07 -0500
Message-ID: <1300305307.3128.528.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-03-16 at 20:26 +0100, Eric Dumazet wrote:
> > I think this alignment exists to minimize the number of cacheline
> > bounces on SMP as this can be a pretty hot structure in the network
> > stack. It could probably benefit from a per-cpu treatment.
> > 
> 
> Well, this is a mostly read area of memory, dirtied every 5 minutes.
> 
> Compare this to 'jiffies' for example ;)
> 
> What could be done is to embed 'ip_cnt' inside ip_keydata[0] for
> example, to avoid wasting a cache line for one bit ;)
> 
> 
> c1606c40 b ip_cnt
> <hole>
> c1606c80 b ip_keydata

Yeah. I actually think we're due for rethinking this entire process. It
dates back to when we introduced syncookies in the 90s and it shows. The
fact that we've started abusing it for other things doesn't help.

-- 
Mathematics is the supreme nostalgia of our time.


