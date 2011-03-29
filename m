Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755407Ab1C2Cqi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 22:46:38 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:50443 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752909Ab1C2Cqh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 22:46:37 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 2/5] Revert "oom: give the dying task a higher priority"
Cc: kosaki.motohiro@jp.fujitsu.com,
        "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
        Minchan Kim <minchan.kim@gmail.com>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        linux-mm <linux-mm@kvack.org>, Andrey Vagin <avagin@openvz.org>,
        Hugh Dickins <hughd@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1301318293.4859.19.camel@twins>
References: <20110328131029.GN19007@uudg.org> <1301318293.4859.19.camel@twins>
Message-Id: <20110329114703.C088.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Mailer: Becky! ver. 2.56.05 [ja]
Date: Tue, 29 Mar 2011 11:46:33 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

> > I mean, in the context of SCHED_OTHER tasks would it really help the dying
> > task to be scheduled sooner to release its resources? 
> 
> That very much depends on how all this stuff works, I guess if everybody
> serializes on OOM and only the first will actually kill a task and all
> the waiting tasks will try to allocate a page again before also doing
> the OOM thing, and the pending tasks are woken after the OOM target task
> has completed dying.. then I don't see much point in boosting things,
> since everybody interested in memory will block and eventually only the
> dying task will be left running.

Probably I can answer this question. When OOM occur, kernel has very a
few pages (typically 10 - 100). but not 0. therefore bloody page-in vs
page-out battle (aka allocation vs free battle) is running.

IOW, While we have multiple cpu or per-cpu page queue, we don't see
page cache become completely 0.

Therefore, not killed task doesn't sleep completely. page-out may have
very small allocation successful chance. (but almostly it's fail. pages
are stealed by another task)

Before Luis's patch, kernel livelock on oom may be solved within 30min,
but after his patch, it's solved within 1 second. that's big different
for human response time. That's the test result.

Thanks.


