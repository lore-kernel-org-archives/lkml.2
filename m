Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758767Ab2JSMLQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 08:11:16 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:63690 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754051Ab2JSMLP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 08:11:15 -0400
X-Nat-Received: from [202.181.97.72]:63527 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1350648660.13887
To: yann.morin.1998@free.fr, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: mmarek@suse.cz, bpoirier@suse.de, yselkowitz@gmail.com
Subject: Re: [PATCH] kconfig/menuconfig: use TAILQ instead of CIRCLEQ
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <1350581625-23153-1-git-send-email-yann.morin.1998@free.fr>
In-Reply-To: <1350581625-23153-1-git-send-email-yann.morin.1998@free.fr>
Message-Id: <201210192110.CII57863.VOStFJQFMLHOFO@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Fri, 19 Oct 2012 21:10:53 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 19102012 #8151499, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yann E. MORIN wrote:
> Some systems (eg. Cygwin, FreeBSD) are missing the CIRCLEQ macros.
> They were removed in Y2000 from FreeBSD:
>     http://svnweb.freebsd.org/base?view=revision&revision=70469
> 
> The reason was that TAILQ are perfectly capable of doing the exact
> same things:
>     http://www.mavetju.org/mail/view_thread.php?list=freebsd-arch&id=915145&thread=yes
> 
> (Thank Yaakov for the pointers!)
> 
> So, switch to using TAILQ instead, which are more portable.
> 
> Reported-by: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
> Reported-by: Benjamin Poirier <bpoirier@suse.de>
> Signed-off-by: "Yann E. MORIN" <yann.morin.1998@free.fr>
> Cc: Yaakov Selkowitz <yselkowitz@gmail.com>
> ---
>  scripts/kconfig/expr.h  |    4 ++--
>  scripts/kconfig/mconf.c |    4 ++--
>  scripts/kconfig/menu.c  |    6 +++---
>  3 files changed, 7 insertions(+), 7 deletions(-)
> 
Excuse me, but your patch does not solve my problem because kconfig started
using macros which does not exist in "@(#)queue.h 8.3 (Berkeley) 12/13/93".
Kconfig still fails after applying your patch:

  HOSTCC  scripts/kconfig/mconf.o
scripts/kconfig/mconf.c: In function `update_text':
scripts/kconfig/mconf.c:326: warning: implicit declaration of function `TAILQ_FOREACH'
scripts/kconfig/mconf.c:326: error: `entries' undeclared (first use in this function)
scripts/kconfig/mconf.c:326: error: (Each undeclared identifier is reported only once
scripts/kconfig/mconf.c:326: error: for each function it appears in.)
scripts/kconfig/mconf.c:326: error: syntax error before '{' token
scripts/kconfig/mconf.c:333: error: `header' undeclared (first use in this function)
scripts/kconfig/mconf.c: At top level:
scripts/kconfig/mconf.c:343: error: syntax error before '}' token
scripts/kconfig/mconf.c: In function `search_conf':
scripts/kconfig/mconf.c:378: warning: implicit declaration of function `TAILQ_HEAD_INITIALIZER'
scripts/kconfig/mconf.c:378: error: invalid initializer
make[1]: *** [scripts/kconfig/mconf.o] Error 1
make: *** [menuconfig] Error 2

So, would you add something which looks like "sed -e 's/CIRCLEQ/TAILQ/g'" upon
https://lkml.org/lkml/2012/10/16/274 ?
