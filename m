Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753457Ab1I1HS4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 03:18:56 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:46908 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753281Ab1I1HSy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 03:18:54 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 28 Sep 2011 16:18:05 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Michel Lespinasse <walken@google.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <dave@linux.vnet.ibm.com>, Rik van Riel <riel@redhat.com>,
        Balbir Singh <bsingharora@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <jweiner@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>, Michael Wolf <mjwolf@us.ibm.com>
Subject: Re: [PATCH 3/9] kstaled: page_referenced_kstaled() and supporting
 infrastructure.
Message-Id: <20110928161805.8acb33c5.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1317170947-17074-4-git-send-email-walken@google.com>
References: <1317170947-17074-1-git-send-email-walken@google.com>
	<1317170947-17074-4-git-send-email-walken@google.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Sep 2011 17:49:01 -0700
Michel Lespinasse <walken@google.com> wrote:

> Add a new page_referenced_kstaled() interface. The desired behavior
> is that page_referenced() returns page references since the last
> page_referenced() call, and page_referenced_kstaled() returns page
> references since the last page_referenced_kstaled() call, but they
> are both independent of each other and do not influence each other.
> 
> The following events are counted as kstaled page references:
> - CPU data access to the page (as noticed through pte_young());
> - mark_page_accessed() calls;
> - page being freed / reallocated.
> 
> 
> Signed-off-by: Michel Lespinasse <walken@google.com>

Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

2 questions.

What happens at Transparent HugeTLB pages are splitted/collapsed ?
Does this feature can ignore page migration i.e. flags should not be copied ?

Thanks,
-Kame

