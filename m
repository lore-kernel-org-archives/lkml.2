Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752551Ab0DOEJJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 00:09:09 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:39710 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891Ab0DOEJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 00:09:07 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] mm: disallow direct reclaim page writeback
Cc: kosaki.motohiro@jp.fujitsu.com, Mel Gorman <mel@csn.ul.ie>,
       Chris Mason <chris.mason@oracle.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
In-Reply-To: <20100415013436.GO2493@dastard>
References: <20100414085132.GJ25756@csn.ul.ie> <20100415013436.GO2493@dastard>
Message-Id: <20100415130212.D16E.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu, 15 Apr 2010 13:09:01 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

> How about this? For now, we stop direct reclaim from doing writeback
> only on order zero allocations, but allow it for higher order
> allocations. That will prevent the majority of situations where
> direct reclaim blows the stack and interferes with background
> writeout, but won't cause lumpy reclaim to change behaviour.
> This reduces the scope of impact and hence testing and validation
> the needs to be done.

Tend to agree. but I would proposed slightly different algorithm for
avoind incorrect oom.

for high order allocation
	allow to use lumpy reclaim and pageout() for both kswapd and direct reclaim

for low order allocation
	- kswapd:          always delegate io to flusher thread
	- direct reclaim:  delegate io to flusher thread only if vm pressure is low

This seems more safely. I mean Who want see incorrect oom regression?
I've made some pathes for this. I'll post it as another mail.

> Then we can work towards allowing lumpy reclaim to use background
> threads as Chris suggested for doing specific writeback operations
> to solve the remaining problems being seen. Does this seem like a
> reasonable compromise and approach to dealing with the problem?

Tend to agree. probably now we are discussing right approach. but
this is definitely needed deep thinking. then, I can't take exactly
answer yet.




