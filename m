Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754113Ab1DVJUH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 05:20:07 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:62669 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752897Ab1DVJUF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 05:20:05 -0400
X-Nat-Received: from [202.181.97.72]:49438 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1303463973.20763
Message-Id: <201104220919.p3M9JWfw029700@www262.sakura.ne.jp>
Subject: Re: [RFC][PATCH 0/7] lockdep: Support recurise-read locks
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
To: yong.zhang0@gmail.com
Cc: a.p.zijlstra@chello.nl, rostedt@goodmis.org, tglx@linutronix.de,
        mingo@elte.hu, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Fri, 22 Apr 2011 18:19:32 +0900
References: <20110417094505.865828233@chello.nl> <201104180341.p3I3fnxc000638@www262.sakura.ne.jp> <BANLkTikYwWe6E6mb3PLE3L7a3VHWdtEvfQ@mail.gmail.com> <201104220744.p3M7indA004922@www262.sakura.ne.jp> <BANLkTikXSz-AK6BFvnDGEr6Qhx-dekzOQg@mail.gmail.com> <201104220831.p3M8VgAO017323@www262.sakura.ne.jp> <BANLkTikaU-2g-p676+a6aMdk+CPdSBQE1g@mail.gmail.com>
In-Reply-To: <BANLkTikaU-2g-p676+a6aMdk+CPdSBQE1g@mail.gmail.com>
Content-Type: text/plain; charset="ISO-2022-JP"
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.44/RELEASE, bases: 22042011 #5326222, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yong Zhang wrote:
> 2011/4/22 Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>:
> >> But if you call locktest1/locktest2 firstly, the chain will not be established
> >> just because recursive read is not added to prev->after.
> >
> > This part is not OK. At least, I think lockdep should be able to establish the
> > chain when locktest1 is called AGAIN after locktest2 is called (i.e.
> > "cat /proc/locktest1 /proc/locktest2 /proc/locktest1" case).
> 
> I guess lockdep will warn on "cat /proc/locktest1 /proc/locktest2
> /proc/locktest1"

It should warn, but it doesn't warn.
You can confirm it using locktest.c in this thread.
