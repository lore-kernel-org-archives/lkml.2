Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752991Ab0KNFHe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Nov 2010 00:07:34 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:49652 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751678Ab0KNFHP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Nov 2010 00:07:15 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: 7eggert@gmx.de
Subject: Re: [PATCH] oom: create a resource limit for oom_adj
Cc: kosaki.motohiro@jp.fujitsu.com, David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>, Ying Han <yinghan@google.com>,
        linux-kernel@vger.kernel.org, gspencer@chromium.org,
        piman@chromium.org, wad@chromium.org, olofj@chromium.org,
        Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <E1PGgMk-0001AW-OD@be1.7eggert.dyndns.org>
References: <fNMps-1S1-21@gated-at.bofh.it> <E1PGgMk-0001AW-OD@be1.7eggert.dyndns.org>
Message-Id: <20101114140237.E010.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Sun, 14 Nov 2010 14:07:12 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Hmm, at first glance that seems potentially dangerous if the current tab
> > generates a burt of memory allocations and it ends up killing all other
> > tabs before finally targeting the culprit whereas currently the heuristic
> > should do a good job of finding this problematic tab and killing it
> > instantly.
> 
> The original oom_adj design would e.g. adjust all background tabs to seem
> twice as bad as the current tab, so a ever-growing current tab would
> only be able to get one or two tabs killed in the worst case:
> 
> System is near OOM while the current tab starts using a normal amount of
> mem and grows beyond limits. After it easily killed the first bg tab by
> allocating one byte, it needs to grow to twice the normal tab memsize to
> start the OOM killer again. By then, it's score will be equal to normal
> background tabs (half size, double score), and killing the second tab will
> be luck. Killing the third tab should be impossible.
> 
> (If you adjust the bg tabs to be four times as killable, you'll get what
>  you asked for.)

Sorry for the delay. 

I've sent revert patch to linus. We DON'T want to break any userland seriously. 
So, we reconsider about this area. personally I hope to reintroduce oom_score_adj
later, but It must don't break current userland.



