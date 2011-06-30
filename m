Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754823Ab1F3JZg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 05:25:36 -0400
Received: from server109-228-6-236.live-servers.net ([109.228.6.236]:63278
	"EHLO fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750988Ab1F3JZ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 05:25:29 -0400
X-Greylist: delayed 1762 seconds by postgrey-1.27 at vger.kernel.org; Thu, 30 Jun 2011 05:25:29 EDT
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.66.37;
Date: Thu, 30 Jun 2011 09:55:55 +0100
To: Keith Packard <keithp@keithp.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, airlied@linux.ie,
        dri-devel@lists.freedesktop.org
Subject: Re: [PATCH] i915: slab shrinker have to return -1 if it cant shrink any objects
Cc: kosaki.motohiro@jp.fujitsu.com
References: <4E0444CA.3080407@jp.fujitsu.com> <yuny60kt1nx.fsf@aiko.keithp.com>
From: Chris Wilson <chris@chris-wilson.co.uk>
In-Reply-To: <yuny60kt1nx.fsf@aiko.keithp.com>
X-Originating-IP: 78.156.66.37
Message-ID: <1309424153_44559@CP5-2952>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Jun 2011 20:53:54 -0700, Keith Packard <keithp@keithp.com> wrote:
> On Fri, 24 Jun 2011 17:03:22 +0900, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
> 
> > Now, i915_gem_inactive_shrink() should return -1 instead of 0 if it
> > can't take a lock. Otherwise, vmscan is getting a lot of confusing
> > because vmscan can't distinguish "can't take a lock temporary" and
> > "we've shrank all of i915 objects".
> 
> This doesn't look like the cleanest change possible. I think it would be
> better if the shrink function could uniformly return an error
> indication so that we wouldn't need the weird looking conditional return.

Unless I am mistaken, and there are more patches in flight, the return
code from i915_gem_inactive_shrink() is promoted to unsigned long and then
used in the calculation of how may objects to evict...
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
