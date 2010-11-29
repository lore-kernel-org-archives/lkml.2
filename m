Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754296Ab0K2OEd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 09:04:33 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:57059 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1754041Ab0K2OEc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 09:04:32 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/uPLBlJXLuZEHgTejF0W10hubqQN5pxSHLwHyNe7
	5GO2eOHTsqSVlW
Subject: Re: [PATCH v4] sched: automated per session task groups
From: Mike Galbraith <efault@gmx.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Paul Turner <pjt@google.com>
In-Reply-To: <20101129134744.GA30787@elte.hu>
References: <20101121133744.GA10765@elte.hu>
	 <1290700829.4759.16.camel@maggy.simson.net>
	 <1290954299.30515.15.camel@marge.simson.net>
	 <AANLkTin5Z_WdAPDfcS3V3DCcN40HLDfpzK-o0XeSMiQh@mail.gmail.com>
	 <20101128201851.GA20555@elte.hu> <1291031593.32004.19.camel@laptop>
	 <20101129123042.GA26112@elte.hu>
	 <1291038310.17004.7.camel@marge.simson.net>
	 <20101129134744.GA30787@elte.hu>
Content-Type: text/plain
Date: Mon, 29 Nov 2010 15:04:27 +0100
Message-Id: <1291039467.19125.3.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-11-29 at 14:47 +0100, Ingo Molnar wrote:
> * Mike Galbraith <efault@gmx.de> wrote:

> > The good news is that the 37.git kernel was mislabeled in grub, was also
> > booting the _tip_ kernel, and is actually just fine.  It's only tip, and
> > tip 92fd4d4d67b9 is still bad.  I'll try a quick bisect before getting
> > back to backlog.
> 
> Just curious, what's the freshest still good -tip sha1?

I don't have a good tip yet.  My bisection started with a merge, which
tested bad, so it spat out...

marge:..git/linux-2.6 # git bisect bad
The merge base e53beacd23d9cb47590da6a7a7f6d417b941a994 is bad.
This means the bug has been fixed between e53beacd23d9cb47590da6a7a7f6d417b941a994 and [19650e8580987c0ffabc2fe2cbc16b944789df8b].

marge:..git/linux-2.6 # git bisect log
git bisect start
# good: [19650e8580987c0ffabc2fe2cbc16b944789df8b] Merge branch 'bugfixes' of git://git.linux-nfs.org/projects/trondmy/nfs-2.6
git bisect good 19650e8580987c0ffabc2fe2cbc16b944789df8b
# bad: [92fd4d4d67b945c0766416284d4ab236b31542c4] Merge commit 'v2.6.37-rc2' into sched/core
git bisect bad 92fd4d4d67b945c0766416284d4ab236b31542c4
# bad: [e53beacd23d9cb47590da6a7a7f6d417b941a994] Linux 2.6.37-rc2
git bisect bad e53beacd23d9cb47590da6a7a7f6d417b941a994
marge:..git/linux-2.6 #

