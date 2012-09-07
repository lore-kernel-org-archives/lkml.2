Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758958Ab2IGW7p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 18:59:45 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:49416 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758782Ab2IGW7k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 18:59:40 -0400
Message-ID: <504A7C5C.1000706@jp.fujitsu.com>
Date: Fri, 07 Sep 2012 18:59:40 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: mgorman@suse.de
CC: akpm@linux-foundation.org, kosaki.motohiro@jp.fujitsu.com,
        davej@redhat.com, cl@linux.com, ben@decadent.org.uk,
        ak@linux.intel.com, hughd@google.com, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH 3/5] mempolicy: fix a race in shared_policy_replace()
References: <1345480594-27032-1-git-send-email-mgorman@suse.de> <1345480594-27032-4-git-send-email-mgorman@suse.de>
In-Reply-To: <1345480594-27032-4-git-send-email-mgorman@suse.de>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

First off, thank you very much for reworking this for me. I haven't got a chance
to get a test machine for this.

> shared_policy_replace() use of sp_alloc() is unsafe. 1) sp_node cannot
> be dereferenced if sp->lock is not held and 2) another thread can modify
> sp_node between spin_unlock for allocating a new sp node and next spin_lock.
> The bug was introduced before 2.6.12-rc2.
> 
> Kosaki's original patch for this problem was to allocate an sp node and policy
> within shared_policy_replace and initialise it when the lock is reacquired. I
> was not keen on this approach because it partially duplicates sp_alloc(). As
> the paths were sp->lock is taken are not that performance critical this
> patch converts sp->lock to sp->mutex so it can sleep when calling sp_alloc().

Looks make sense.

Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>


