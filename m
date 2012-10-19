Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945982Ab2JSWw7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 18:52:59 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:49349 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945931Ab2JSWw5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 18:52:57 -0400
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
Organization: BZH lan
To: linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] kconfig/menuconfig: use TAILQ instead of CIRCLEQ
Date: Sat, 20 Oct 2012 00:52:53 +0200
User-Agent: KMail/1.13.5 (Linux/3.6.2-treguer; KDE/4.4.5; x86_64; ; )
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        linux-kernel@vger.kernel.org, mmarek@suse.cz, bpoirier@suse.de,
        yselkowitz@gmail.com
References: <1350581625-23153-1-git-send-email-yann.morin.1998@free.fr> <201210192110.CII57863.VOStFJQFMLHOFO@I-love.SAKURA.ne.jp>
In-Reply-To: <201210192110.CII57863.VOStFJQFMLHOFO@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201210200052.53599.yann.morin.1998@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tetsuo, Michal, All,

On Friday 19 October 2012 Tetsuo Handa wrote:
> Yann E. MORIN wrote:
> > Some systems (eg. Cygwin, FreeBSD) are missing the CIRCLEQ macros.
[--SNIP--]
> > So, switch to using TAILQ instead, which are more portable.
[--SNIP--]
> Excuse me, but your patch does not solve my problem because kconfig started
> using macros which does not exist in "@(#)queue.h 8.3 (Berkeley) 12/13/93".

Whoa. That's old... :-/

Currently, kconfig uses (CIRCLEQ or TAILQ)

> Kconfig still fails after applying your patch:
[--SNIP--]
> So, would you add something which looks like "sed -e 's/CIRCLEQ/TAILQ/g'" upon
> https://lkml.org/lkml/2012/10/16/274 ?

Sorry, I did not see you had posted a patch.

Basically, I don't care what solution we choose. Using TAILQ looks like
being not the solution. So, here are the known options:
1-  Michal pointed to tools/firewire/list.h, but those are different from
    the CIRCLEQ/TAILQ, and switching is not easy (at least for me after a
    quick glance);

1b- note also that drivers/scsi/aic7xxx/queue.h has all of both the CIRCLEQ
    and TAILQ macros we're interested in, too, and it looks like it can be
    used out of the kernel (eg. for userland);

2-  carry the parts of CIRCLEQ (or TAILQ) that we need, and use them if
    the system's sys/queue.h does not provide them, as Tetsuo proposed;

3-  carry the parts of CIRCLEQ (or TAILQ) that we need, and do not rely
    on the system's sys/queue.h to provide them at all.


Michal, what do you think would be the best route to go, to:
1- get a fix in 3.7 ?
2- if the fix for 3.7 is just a workaround, a proper fix for 3.8 ?

Regards,
Yann E. MORIN.

-- 
.-----------------.--------------------.------------------.--------------------.
|  Yann E. MORIN  | Real-Time Embedded | /"\ ASCII RIBBON | Erics' conspiracy: |
| +33 662 376 056 | Software  Designer | \ / CAMPAIGN     |  ___               |
| +33 223 225 172 `------------.-------:  X  AGAINST      |  \e/  There is no  |
| http://ymorin.is-a-geek.org/ | _/*\_ | / \ HTML MAIL    |   v   conspiracy.  |
'------------------------------^-------^------------------^--------------------'
