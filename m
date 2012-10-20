Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755662Ab2JTOoH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2012 10:44:07 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:65015 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753681Ab2JTOoF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2012 10:44:05 -0400
X-Nat-Received: from [202.181.97.72]:63934 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1350744227.3729
To: mmarek@suse.cz
Cc: yann.morin.1998@free.fr, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpoirier@suse.de, yselkowitz@gmail.com
Subject: Re: [PATCH] kconfig/menuconfig: use TAILQ instead of CIRCLEQ
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <1350581625-23153-1-git-send-email-yann.morin.1998@free.fr>
	<201210192110.CII57863.VOStFJQFMLHOFO@I-love.SAKURA.ne.jp>
	<5081699B.4020203@suse.cz>
In-Reply-To: <5081699B.4020203@suse.cz>
Message-Id: <201210202343.IED90702.SFHOJFOVMtQFLO@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Sat, 20 Oct 2012 23:43:40 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 20102012 #8157510, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michal Marek wrote:
> On 19.10.2012 14:10, Tetsuo Handa wrote:
> > Yann E. MORIN wrote:
> >> So, switch to using TAILQ instead, which are more portable.
> [...]
> > Excuse me, but your patch does not solve my problem because kconfig started
> > using macros which does not exist in "@(#)queue.h 8.3 (Berkeley) 12/13/93".
> > Kconfig still fails after applying your patch:
> > 
> >   HOSTCC  scripts/kconfig/mconf.o
> > scripts/kconfig/mconf.c: In function `update_text':
> > scripts/kconfig/mconf.c:326: warning: implicit declaration of function `TAILQ_FOREACH'
> [...]
> > scripts/kconfig/mconf.c:378: warning: implicit declaration of function `TAILQ_HEAD_INITIALIZER'
> > 
> > So, would you add something which looks like "sed -e 's/CIRCLEQ/TAILQ/g'" upon
> > https://lkml.org/lkml/2012/10/16/274 ?
> 
> Could you reduce that patch to not copy all of queue.h?
> TAILQ_HEAD_INITIALIZER can be replaced by a TAILQ_INIT() call after
> variable definitions, and we do not need stuff like
> TAILQ_FOREACH_REVERSE. The other option is to reimplement the needed
> operations under a different name, so that people don't accidentally use
> other macros that are missing in old queue.h revisions.
> 
> Michal
> 

I'm fine to manually add missing macros to /usr/include/sys/queue.h of
"@(#)queue.h 8.3 (Berkeley) 12/13/93" in my environment instead of adding
define-as-needed lines to scripts/kconfig/expr.h, for missing macros are
available with that of "@(#)queue.h 8.5 (Berkeley) 8/20/94".
