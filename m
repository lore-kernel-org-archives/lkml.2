Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754903Ab0DOQyW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 12:54:22 -0400
Received: from one.firstfloor.org ([213.235.205.2]:41695 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754115Ab0DOQyU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 12:54:20 -0400
Date: Thu, 15 Apr 2010 18:54:16 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Andi Kleen <andi@firstfloor.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Dave Chinner <david@fromorbit.com>,
       Chris Mason <chris.mason@oracle.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 1/4] vmscan: simplify shrink_inactive_list()
Message-ID: <20100415165416.GV18855@one.firstfloor.org>
References: <20100415085420.GT2493@dastard> <20100415185310.D1A1.A69D9226@jp.fujitsu.com> <20100415192140.D1A4.A69D9226@jp.fujitsu.com> <20100415131532.GD10966@csn.ul.ie> <87tyrc92un.fsf@basil.nowhere.org> <20100415154442.GG10966@csn.ul.ie>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100415154442.GG10966@csn.ul.ie>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> It's a buying-time venture, I'll agree but as both approaches are only
> about reducing stack stack they wouldn't be long-term solutions by your
> criteria. What do you suggest?

(from easy to more complicated):

- Disable direct reclaim with 4K stacks
- Do direct reclaim only on separate stacks
- Add interrupt stacks to any 8K stack architectures.
- Get rid of 4K stacks completely
- Think about any other stackings that could give large scale recursion
and find ways to run them on separate stacks too.
- Long term: maybe we need 16K stacks at some point, depending on how
good the VM gets. Alternative would be to stop making Linux more complicated,
but that's unlikely to happen.


-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
