Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757431Ab1KRJ4t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 04:56:49 -0500
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:51258 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751930Ab1KRJ4s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 04:56:48 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EANsoxk55Lbtu/2dsb2JhbABCqiSBBoFyAQEFOhwjEAgDGBUZFCUDIRO+axKGZIMhBJQ4iQKJFA
Date: Fri, 18 Nov 2011 20:56:44 +1100
From: Dave Chinner <david@fromorbit.com>
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: remove struct reclaim_state
Message-ID: <20111118095644.GJ7046@dastard>
References: <20111118092806.21688.8662.stgit@zurg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111118092806.21688.8662.stgit@zurg>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 18, 2011 at 01:28:06PM +0300, Konstantin Khlebnikov wrote:
> Memory reclaimer want to know how much pages was reclaimed during shrinking slabs.
> Currently there is special struct reclaim_state with single counter and pointer from
> task-struct. Let's store counter direcly on task struct and account freed pages
> unconditionally. This will reduce stack usage and simplify code in reclaimer and slab.
> 
> Logic in do_try_to_free_pages() is slightly changed, but this is ok.
> Nobody calls shrink_slab() explicitly before do_try_to_free_pages(),

Except for drop_slab() and shake_page()....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
