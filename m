Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751124Ab0JYElb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 00:41:31 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:33202 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750742Ab0JYEla (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 00:41:30 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 25 Oct 2010 13:35:56 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Christoph Lameter <cl@linux.com>, Mel Gorman <mel@csn.ul.ie>,
        Rob Mueller <robm@fastmail.fm>, linux-kernel@vger.kernel.org,
        Bron Gondwana <brong@fastmail.fm>, linux-mm <linux-mm@kvack.org>,
        David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: [resend][PATCH] mm: increase RECLAIM_DISTANCE to 30
Message-Id: <20101025133556.64056c92.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20101025122343.9165.A69D9226@jp.fujitsu.com>
References: <20101025122343.9165.A69D9226@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Oct 2010 12:24:24 +0900 (JST)
KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> Recently, Robert Mueller reported zone_reclaim_mode doesn't work
> properly on his new NUMA server (Dual Xeon E5520 + Intel S5520UR MB).
> He is using Cyrus IMAPd and it's built on a very traditional
> single-process model.
> 
>   * a master process which reads config files and manages the other
>     process
>   * multiple imapd processes, one per connection
>   * multiple pop3d processes, one per connection
>   * multiple lmtpd processes, one per connection
>   * periodical "cleanup" processes.
> 
> Then, there are thousands of independent processes. The problem is,
> recent Intel motherboard turn on zone_reclaim_mode by default and
> traditional prefork model software don't work fine on it.
> Unfortunatelly, Such model is still typical one even though 21th
> century. We can't ignore them.
> 
> This patch raise zone_reclaim_mode threshold to 30. 30 don't have
> specific meaning. but 20 mean one-hop QPI/Hypertransport and such
> relatively cheap 2-4 socket machine are often used for tradiotional
> server as above. The intention is, their machine don't use
> zone_reclaim_mode.
> 
> Note: ia64 and Power have arch specific RECLAIM_DISTANCE definition.
> then this patch doesn't change such high-end NUMA machine behavior.
> 
> Cc: Mel Gorman <mel@csn.ul.ie>
> Cc: Bron Gondwana <brong@fastmail.fm>
> Cc: Robert Mueller <robm@fastmail.fm>
> Acked-by: Christoph Lameter <cl@linux.com>
> Acked-by: David Rientjes <rientjes@google.com>
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

