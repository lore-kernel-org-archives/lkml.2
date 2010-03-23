Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755354Ab0CWAWN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 20:22:13 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:34726 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754841Ab0CWAWL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 20:22:11 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH 06/11] Export fragmentation index via /proc/extfrag_index
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
       Andrea Arcangeli <aarcange@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Adam Litke <agl@us.ibm.com>, Avi Kivity <avi@redhat.com>,
       David Rientjes <rientjes@google.com>, Rik van Riel <riel@redhat.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <20100317113326.GD12388@csn.ul.ie>
References: <20100317114321.4C9A.A69D9226@jp.fujitsu.com> <20100317113326.GD12388@csn.ul.ie>
Message-Id: <20100323050910.A473.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 23 Mar 2010 09:22:04 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > +	/*
> > > +	 * Index is between 0 and 1 so return within 3 decimal places
> > > +	 *
> > > +	 * 0 => allocation would fail due to lack of memory
> > > +	 * 1 => allocation would fail due to fragmentation
> > > +	 */
> > > +	return 1000 - ( (1000+(info->free_pages * 1000 / requested)) / info->free_blocks_total);
> > > +}
> > 
> > Dumb question.
> > your paper (http://portal.acm.org/citation.cfm?id=1375634.1375641) says
> > fragmentation_index = 1 - (TotalFree/SizeRequested)/BlocksFree
> > but your code have extra '1000+'. Why?
> 
> To get an approximation to three decimal places.

Do you mean this is poor man's round up logic?
Why don't you use DIV_ROUND_UP? likes following,

return 1000 - (DIV_ROUND_UP(info->free_pages * 1000 / requested) /  info->free_blocks_total);


