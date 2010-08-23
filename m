Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752896Ab0HWMpc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 08:45:32 -0400
Received: from smtp105.prem.mail.ac4.yahoo.com ([76.13.13.44]:21491 "HELO
	smtp105.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751674Ab0HWMpa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 08:45:30 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: m3_mKnMVM1nECzzkOU1uAqm_NDQQmaV5Z58O8Od7WDbaa1x
 rdmAhL0EQ4LYBoza_rX6smbuJJuMfkP0.Ofi2yxNwT8xKa3RXXEHZUe.IGcW
 3o8LlHXSv4byNxnXfeMJgUwrLTIQUbfpuGcSs5NhuRlSS7Tm4moNUDtSQRtr
 31P0kcXmVDtkOdD0NH.0H7OuoqVFl8mYIezYViZRNvndQPtq5XdZDXk7gVXc
 3
X-Yahoo-Newman-Property: ymail-3
Date: Mon, 23 Aug 2010 07:45:25 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Mel Gorman <mel@csn.ul.ie>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel List <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH 0/3] Reduce watermark-related problems with the per-cpu
 allocator V2
In-Reply-To: <1282550442-15193-1-git-send-email-mel@csn.ul.ie>
Message-ID: <alpine.DEB.2.00.1008230742300.4094@router.home>
References: <1282550442-15193-1-git-send-email-mel@csn.ul.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Aug 2010, Mel Gorman wrote:

> Internal IBM test teams beta testing distribution kernels have reported
> problems on machines with a large number of CPUs whereby page allocator
> failure messages show huge differences between the nr_free_pages vmstat
> counter and what is available on the buddy lists. In an extreme example,
> nr_free_pages was above the min watermark but zero pages were on the buddy
> lists allowing the system to potentially livelock unable to make forward
> progress unless an allocation succeeds. There is no reason why the problems
> would not affect mainline so the following series mitigates the problems
> in the page allocator related to to per-cpu counter drift and lists.

The maximum time for which the livelock can exists is the vm stat
interval. By default the counters are brought up to date at least once per
second or if a certain delta was violated. Drifts are controlled by the
delta configuration.

