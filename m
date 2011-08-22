Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754373Ab1HVXXD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 19:23:03 -0400
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:33035 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753950Ab1HVXXB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 19:23:01 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAC/iUk55LIxD/2dsb2JhbABBqB54gUABAQU6HCMQCAMYLhQlAyETvUAOhjoEpB0
Date: Tue, 23 Aug 2011 09:22:57 +1000
From: Dave Chinner <david@fromorbit.com>
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] vmscan: fix initial shrinker size handling
Message-ID: <20110822232257.GT3162@dastard>
References: <20110822101721.19462.63082.stgit@zurg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110822101721.19462.63082.stgit@zurg>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 22, 2011 at 02:17:21PM +0300, Konstantin Khlebnikov wrote:
> Shrinker function can returns -1, it means it cannot do anything without a risk of deadlock.
> For example prune_super() do this if it cannot grab superblock refrence, even if nr_to_scan=0.
> Currenly we interpret this like ULONG_MAX size shrinker, evaluate total_scan according this,
> and next time this shrinker can get really big pressure. Let's skip such shrinkers instead.
> 
> Also make total_scan signed, otherwise check (total_scan < 0) below never works.

I've got a patch set I am going to post out today that makes this
irrelevant.

The patch set splits the shrinker api into 2 callbacks - a "count
objects" callback and an "scan objects" callback, getting rid of
this messy "pass nr-to_scan == 0 to count objects" wart altogether.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
