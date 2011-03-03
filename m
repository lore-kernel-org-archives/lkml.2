Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758878Ab1CCVQd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 16:16:33 -0500
Received: from mx1.vsecurity.com ([209.67.252.12]:51006 "EHLO
	mx1.vsecurity.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751805Ab1CCVQc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 16:16:32 -0500
Subject: Re: [PATCH] Make /proc/slabinfo 0400
From: Dan Rosenberg <drosenberg@vsecurity.com>
To: Matt Mackall <mpm@selenic.com>
Cc: cl@linux-foundation.org, penberg@kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <1299185882.3062.233.camel@calx>
References: <1299174652.2071.12.camel@dan>  <1299185882.3062.233.camel@calx>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 03 Mar 2011 16:16:26 -0500
Message-ID: <1299186986.2071.90.camel@dan>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> 
> Looking at a couple of these exploits, my suspicion is that looking at
> slabinfo simply improves the odds of success by a small factor (ie 10x
> or so) and doesn't present a real obstacle to attackers. All that
> appears to be required is to arrange that an overrunnable object be
> allocated next to one that is exploitable when overrun. And that can be
> arranged with fairly high probability on SLUB's merged caches.
> 

This is accurate, but the primary goal of exploit mitigation isn't
necessarily to completely prevent the possibility of exploitation (time
has shown that this is unlikely to be feasible), but rather to increase
the cost of investment required to develop a reliable exploit.  If
removing read access to /proc/slabinfo means that heap exploits are even
slightly more likely to fail, then that's a win as far as I'm concerned
and may be the thing that prevents some helpless end user from getting
compromised.

> On the other hand, I'm not convinced the contents of this file are of
> much use to people without admin access.
> 

Exactly.  We might as well do everything we can to make attackers' lives
more difficult, especially when the cost is so low.

-Dan

> -- 
> Mathematics is the supreme nostalgia of our time.


