Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756367Ab2JTQ6m (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2012 12:58:42 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:34716 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755223Ab2JTQ6k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2012 12:58:40 -0400
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
Organization: BZH lan
To: linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] kconfig/menuconfig: use TAILQ instead of CIRCLEQ
Date: Sat, 20 Oct 2012 18:58:36 +0200
User-Agent: KMail/1.13.5 (Linux/3.6.2-treguer; KDE/4.4.5; x86_64; ; )
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, mmarek@suse.cz,
        linux-kernel@vger.kernel.org, bpoirier@suse.de, yselkowitz@gmail.com
References: <1350581625-23153-1-git-send-email-yann.morin.1998@free.fr> <5081699B.4020203@suse.cz> <201210202343.IED90702.SFHOJFOVMtQFLO@I-love.SAKURA.ne.jp>
In-Reply-To: <201210202343.IED90702.SFHOJFOVMtQFLO@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201210201858.37169.yann.morin.1998@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tetuso, All,

On Saturday 20 October 2012 Tetsuo Handa wrote:
> Michal Marek wrote:
> > On 19.10.2012 14:10, Tetsuo Handa wrote:
> > > Yann E. MORIN wrote:
> > >> So, switch to using TAILQ instead, which are more portable.
> > [...]
> > > Excuse me, but your patch does not solve my problem because kconfig started
> > > using macros which does not exist in "@(#)queue.h 8.3 (Berkeley) 12/13/93".
> > > Kconfig still fails after applying your patch:
> > > 
> > >   HOSTCC  scripts/kconfig/mconf.o
> > > scripts/kconfig/mconf.c: In function `update_text':
> > > scripts/kconfig/mconf.c:326: warning: implicit declaration of function `TAILQ_FOREACH'
> > [...]
> > > scripts/kconfig/mconf.c:378: warning: implicit declaration of function `TAILQ_HEAD_INITIALIZER'
> > > 
> > > So, would you add something which looks like "sed -e 's/CIRCLEQ/TAILQ/g'" upon
> > > https://lkml.org/lkml/2012/10/16/274 ?
> > 
> > Could you reduce that patch to not copy all of queue.h?
> > TAILQ_HEAD_INITIALIZER can be replaced by a TAILQ_INIT() call after
> > variable definitions, and we do not need stuff like
> > TAILQ_FOREACH_REVERSE. The other option is to reimplement the needed
> > operations under a different name, so that people don't accidentally use
> > other macros that are missing in old queue.h revisions.
> > 
> > Michal
> > 
> 
> I'm fine to manually add missing macros to /usr/include/sys/queue.h of
> "@(#)queue.h 8.3 (Berkeley) 12/13/93" in my environment instead of adding
> define-as-needed lines to scripts/kconfig/expr.h, for missing macros are
> available with that of "@(#)queue.h 8.5 (Berkeley) 8/20/94".

Are you OK with this s/CIRCLEQ/TAILQ/ patch, then?
    http://marc.info/?l=linux-kbuild&m=135058165015518&w=2

Regards,
Yann E. MORIN.

-- 
.-----------------.--------------------.------------------.--------------------.
|  Yann E. MORIN  | Real-Time Embedded | /"\ ASCII RIBBON | Erics' conspiracy: |
| +33 662 376 056 | Software  Designer | \ / CAMPAIGN     |  ___               |
| +33 223 225 172 `------------.-------:  X  AGAINST      |  \e/  There is no  |
| http://ymorin.is-a-geek.org/ | _/*\_ | / \ HTML MAIL    |   v   conspiracy.  |
'------------------------------^-------^------------------^--------------------'
