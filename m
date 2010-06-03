Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753601Ab0FCGwu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 02:52:50 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:55950 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751608Ab0FCGwt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 02:52:49 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH 02/12] oom: introduce find_lock_task_mm() to fix !mm false  positives
Cc: kosaki.motohiro@jp.fujitsu.com,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Oleg Nesterov <oleg@redhat.com>, David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>
In-Reply-To: <AANLkTikF0EAmKsBx28-paTg7DUdOiHLz5KHJbzLW_OBS@mail.gmail.com>
References: <20100603144948.724D.A69D9226@jp.fujitsu.com> <AANLkTikF0EAmKsBx28-paTg7DUdOiHLz5KHJbzLW_OBS@mail.gmail.com>
Message-Id: <20100603152842.726E.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu,  3 Jun 2010 15:52:46 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> > Cc: David Rientjes <rientjes@google.com>
> > Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> 
> Could you see my previous comment?
> http://lkml.org/lkml/2010/6/2/325
> Anyway, I added my review sign
> 
> Reviewed-by: Minchan Kim <minchan.kim@gmail.com>

Sorry, I had lost your comment ;)

But personally I don't like find_alive_subthread() because 
such function actually does,
  1) iterate threads in the same thread group
  2) find alive (a.k.a have ->mm) thread
  3) lock the task
and, I think (3) is most important role of this function.
So, I prefer to contain "lock" word.

Otherwise, people easily forget to cann task_unlock().
But I'm ok to rename any give me better name.

Thanks.

