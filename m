Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754099Ab0DOPBk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 11:01:40 -0400
Received: from one.firstfloor.org ([213.235.205.2]:52608 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753574Ab0DOPBi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 11:01:38 -0400
To: Mel Gorman <mel@csn.ul.ie>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Dave Chinner <david@fromorbit.com>,
       Chris Mason <chris.mason@oracle.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 1/4] vmscan: simplify shrink_inactive_list()
From: Andi Kleen <andi@firstfloor.org>
References: <20100415085420.GT2493@dastard>
	<20100415185310.D1A1.A69D9226@jp.fujitsu.com>
	<20100415192140.D1A4.A69D9226@jp.fujitsu.com>
	<20100415131532.GD10966@csn.ul.ie>
Date: Thu, 15 Apr 2010 17:01:36 +0200
In-Reply-To: <20100415131532.GD10966@csn.ul.ie> (Mel Gorman's message of "Thu, 15 Apr 2010 14:15:33 +0100")
Message-ID: <87tyrc92un.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mel Gorman <mel@csn.ul.ie> writes:
>
> $ stack-o-meter vmlinux-vanilla vmlinux-2-simplfy-shrink 
> add/remove: 0/0 grow/shrink: 0/2 up/down: 0/-144 (-144)
> function                                     old     new   delta
> shrink_zone                                 1232    1160     -72
> kswapd                                       748     676     -72

And the next time someone adds a new feature to these code paths or
the compiler inlines differently these 72 bytes are easily there
again. It's not really a long term solution. Code is tending to get
more complicated all the time. I consider it unlikely this trend will
stop any time soon.

So just doing some stack micro optimizations doesn't really help 
all that much.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
