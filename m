Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752308Ab0KWHRS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 02:17:18 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:37377 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752175Ab0KWHRC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 02:17:02 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] Revert oom rewrite series
Cc: kosaki.motohiro@jp.fujitsu.com, David Rientjes <rientjes@google.com>,
        "Figo.zhang" <zhangtianfei@leadcoretech.com>,
        "Figo.zhang" <figo1802@gmail.com>, lkml <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@osdl.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <20101115105735.0f9c1a22@lxorguk.ukuu.org.uk>
References: <alpine.DEB.2.00.1011150204060.2986@chino.kir.corp.google.com> <20101115105735.0f9c1a22@lxorguk.ukuu.org.uk>
Message-Id: <20101123160020.7B99.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 23 Nov 2010 16:16:57 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


sorry for the delay.

> > The goal was to make the oom killer heuristic as predictable as possible 
> > and to kill the most memory-hogging task to avoid having to recall it and 
> > needlessly kill several tasks.
> 
> Meta question - why is that a good thing. In a desktop environment it's
> frequently wrong, in a server environment it is often wrong. We had this
> before where people spend months fiddling with the vm and make it work
> slightly differently and it suits their workload, then other workloads go
> downhill. Then the cycle repeats.
> 
> > You have full control over disabling a task from being considered with 
> > oom_score_adj just like you did with oom_adj.  Since oom_adj is 
> > deprecated for two years, you can even use the old interface until then.
> 
> Which changeset added it to the Documentation directory as deprecated ?

It's insufficient.
a63d83f427fbce97a6cea0db2e64b0eb8435cd10 (oom: badness heuristic rewrite)
introduced a lot of incompatibility to oom_adj and oom_score.
Theresore I would sugestted full revert and resubmit some patches which
cherry pick no pain piece.


