Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757578Ab1I3Voa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 17:44:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55014 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751083Ab1I3VoW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 17:44:22 -0400
Date: Fri, 30 Sep 2011 23:43:41 +0200
From: Johannes Weiner <jweiner@redhat.com>
To: Rik van Riel <riel@redhat.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Satoru Moriya <smoriya@redhat.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, lwoodman@redhat.com,
        Seiji Aguchi <saguchi@redhat.com>, akpm@linux-foundation.org,
        hughd@google.com, hannes@cmpxchg.org
Subject: Re: [PATCH -v2 -mm] add extra free kbytes tunable
Message-ID: <20110930214341.GB5096@redhat.com>
References: <20110901105208.3849a8ff@annuminas.surriel.com>
 <20110901100650.6d884589.rdunlap@xenotime.net>
 <20110901152650.7a63cb8b@annuminas.surriel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110901152650.7a63cb8b@annuminas.surriel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 01, 2011 at 03:26:50PM -0400, Rik van Riel wrote:
> Add a userspace visible knob to tell the VM to keep an extra amount
> of memory free, by increasing the gap between each zone's min and
> low watermarks.
> 
> This is useful for realtime applications that call system
> calls and have a bound on the number of allocations that happen
> in any short time period.  In this application, extra_free_kbytes
> would be left at an amount equal to or larger than than the
> maximum number of allocations that happen in any burst.
> 
> It may also be useful to reduce the memory use of virtual
> machines (temporarily?), in a way that does not cause memory
> fragmentation like ballooning does.
> 
> Signed-off-by: Rik van Riel<riel@redhat.com>

Acked-by: Johannes Weiner <jweiner@redhat.com>

Btw, I wonder if there should be a waking of the kswapds in
setup_per_zone_wmarks() in general to make sure the new watermarks are
met.  But that applies to min_free_kbytes as well, so not a
requirement for this patch.
