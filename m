Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755433Ab0IGH33 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 03:29:29 -0400
Received: from one.firstfloor.org ([213.235.205.2]:45545 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755429Ab0IGH3X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 03:29:23 -0400
From: Andi Kleen <andi@firstfloor.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm\@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "minchan.kim\@gmail.com" <minchan.kim@gmail.com>,
        Mel Gorman <mel@csn.ul.ie>,
        "kosaki.motohiro\@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [RFC][PATCH] big continuous memory allocator v2
References: <20100907114505.fc40ea3d.kamezawa.hiroyu@jp.fujitsu.com>
Date: Tue, 07 Sep 2010 09:29:21 +0200
In-Reply-To: <20100907114505.fc40ea3d.kamezawa.hiroyu@jp.fujitsu.com>
	(KAMEZAWA Hiroyuki's message of "Tue, 7 Sep 2010 11:45:05 +0900")
Message-ID: <87occa9fla.fsf@basil.nowhere.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> writes:

> This is a page allcoator based on memory migration/hotplug code.
> passed some small tests, and maybe easier to read than previous one.

Maybe I'm missing context here, but what is the use case for this?

If this works well enough the 1GB page code for x86, which currently
only supports allocating at boot time due to the MAX_ORDER problem,
could be moved over to runtime allocation. This would make
GB pages a lot nicer to use.

I think it would still need declaring a large moveable
area at boot right? (but moveable area is better than
prereserved memory)

On the other hand I'm not sure the VM is really up to speed
in managing such large areas.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
