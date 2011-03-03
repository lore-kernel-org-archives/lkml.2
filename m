Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757253Ab1CCBu5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 20:50:57 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:54897 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756162Ab1CCBu4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 20:50:56 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: noname noname <namei.unix@gmail.com>
Subject: Re: [RFC PATCH 0/5] Add accountings for Page Cache
Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, jaxboe@fusionio.com, akpm@linux-foundation.org,
        fengguang.wu@intel.com
In-Reply-To: <AANLkTik7MA6YcrWVbjFhQsN0arR72xmH9g1M2Yi-E_B-@mail.gmail.com>
References: <AANLkTik7MA6YcrWVbjFhQsN0arR72xmH9g1M2Yi-E_B-@mail.gmail.com>
Message-Id: <20110303104430.B93F.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu,  3 Mar 2011 10:50:52 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> [Summery]
> 
> In order to evaluate page cache efficiency, system admins are happy to
> know whether a block of data is cached for subsequent use, or whether
> the page is read-in but seldom used. This patch extends an effort to
> provide such kind of information. We adds three counters, which are
> exported to the user space, for the Page Cache that is almost
> transparent to the applications. This would benifit some heavy page
> cache users that might try to tune the performance in hybrid storage
> situation.

I think you need to explain exact and concrete use-case. Typically, 
cache-hit ratio doesn't help administrator at all. because merely backup
operation (eg. cp, dd, et al) makes prenty cache-miss. But it is no sign
of memory shortage. Usually, vmscan stastics may help memroy utilization
obzavation.

Plus, as ingo said, you have to consider to use trancepoint framework
at first. Because, it is zero cost if an admin don't enable such tracepoint.

At last, I don't think disk_stats have to have page cache stastics. It seems
slightly layer violation.

Thanks.


