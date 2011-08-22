Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754559Ab1HVX25 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 19:28:57 -0400
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:52682 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751589Ab1HVX2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 19:28:55 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAILlUk55LIxD/2dsb2JhbABBqCF4gUABAQU6HCMQCAMOCi4UJQMhE70jDoY6BKQh
Date: Tue, 23 Aug 2011 09:28:34 +1000
From: Dave Chinner <david@fromorbit.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Konstantin Khlebnikov <khlebnikov@openvz.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] vmscan: fix initial shrinker size handling
Message-ID: <20110822232834.GV3162@dastard>
References: <20110822101721.19462.63082.stgit@zurg>
 <20110822143006.60f4b560.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110822143006.60f4b560.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 22, 2011 at 02:30:06PM -0700, Andrew Morton wrote:
> On Mon, 22 Aug 2011 14:17:21 +0300
> Konstantin Khlebnikov <khlebnikov@openvz.org> wrote:
> 
> > Shrinker function can returns -1, it means it cannot do anything without a risk of deadlock.
> > For example prune_super() do this if it cannot grab superblock refrence, even if nr_to_scan=0.
> > Currenly we interpret this like ULONG_MAX size shrinker, evaluate total_scan according this,
> > and next time this shrinker can get really big pressure. Let's skip such shrinkers instead.
> 
> Yes, that looks like a significant oversight.
> 
> > Also make total_scan signed, otherwise check (total_scan < 0) below never works.
> 
> Hopefully a smaller oversight.

Yeah, it was, but is harmless because it is caught by the next check
of total_scanned. I've made similar "make everything signed" changes
as well.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
