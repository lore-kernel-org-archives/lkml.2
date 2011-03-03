Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932384Ab1CCU6L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 15:58:11 -0500
Received: from waste.org ([173.11.57.241]:50064 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932281Ab1CCU6K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 15:58:10 -0500
Subject: Re: [PATCH] Make /proc/slabinfo 0400
From: Matt Mackall <mpm@selenic.com>
To: Dan Rosenberg <drosenberg@vsecurity.com>
Cc: cl@linux-foundation.org, penberg@kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <1299174652.2071.12.camel@dan>
References: <1299174652.2071.12.camel@dan>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 03 Mar 2011 14:58:02 -0600
Message-ID: <1299185882.3062.233.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-03-03 at 12:50 -0500, Dan Rosenberg wrote:
> Allowing unprivileged users to read /proc/slabinfo represents a security
> risk, since revealing details of slab allocations can expose information
> that is useful when exploiting kernel heap corruption issues.  This is
> evidenced by observing that nearly all recent public exploits for heap
> issues rely on feedback from /proc/slabinfo to manipulate heap layout
> into an exploitable state.

Looking at a couple of these exploits, my suspicion is that looking at
slabinfo simply improves the odds of success by a small factor (ie 10x
or so) and doesn't present a real obstacle to attackers. All that
appears to be required is to arrange that an overrunnable object be
allocated next to one that is exploitable when overrun. And that can be
arranged with fairly high probability on SLUB's merged caches.

On the other hand, I'm not convinced the contents of this file are of
much use to people without admin access.

-- 
Mathematics is the supreme nostalgia of our time.


