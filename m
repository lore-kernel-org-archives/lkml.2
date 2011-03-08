Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932462Ab1CHCHp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 21:07:45 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:34325 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756817Ab1CHCHm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 21:07:42 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: David Rientjes <rientjes@google.com>
Subject: Re: [PATCH] mm: skip zombie in OOM-killer
Cc: kosaki.motohiro@jp.fujitsu.com, Andrey Vagin <avagin@openvz.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <alpine.DEB.2.00.1103061400170.23737@chino.kir.corp.google.com>
References: <20110306193519.49DD.A69D9226@jp.fujitsu.com> <alpine.DEB.2.00.1103061400170.23737@chino.kir.corp.google.com>
Message-Id: <20110308105458.7EA2.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue,  8 Mar 2011 11:07:38 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Sun, 6 Mar 2011, KOSAKI Motohiro wrote:
> 
> > > When we check that task has flag TIF_MEMDIE, we forgot check that
> > > it has mm. A task may be zombie and a parent may wait a memor.
> > > 
> > > v2: Check that task doesn't have mm one time and skip it immediately
> > > 
> > > Signed-off-by: Andrey Vagin <avagin@openvz.org>
> > 
> > This seems incorrect. Do you have a reprodusable testcasae?
> > Your patch only care thread group leader state, but current code
> > care all thread in the process. Please look at oom_badness() and 
> > find_lock_task_mm(). 
> > 
> 
> That's all irrelevant, the test for TIF_MEMDIE specifically makes the oom 
> killer a complete no-op when an eligible task is found to have been oom 
> killed to prevent needlessly killing additional tasks.  oom_badness() and 
> find_lock_task_mm() have nothing to do with that check to return 
> ERR_PTR(-1UL) from select_bad_process().

I don't understand you think which task is eligible and unnecessary.
But, Look! Andrey is not talking about zombie process case. But, this v2
patch have factored out other tasks too. This IS the problem. No need
unrelated talk.

> 
> Andrey is patching the case where an eligible TIF_MEMDIE process is found 
> but it has already detached its ->mm.  In combination with the patch 
> posted to linux-mm, oom: prevent unnecessary oom kills or kernel panics, 
> which makes select_bad_process() iterate over all threads, it is an 
> effective solution.

Guys, It was alread NAKed. I've already talk kind explanation. Why do
you bother to look actual code. Why do you continue to talk funny your
dream?



