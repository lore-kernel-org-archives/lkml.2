Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758134Ab2JSOy3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 10:54:29 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57913 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757599Ab2JSOyZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 10:54:25 -0400
Message-ID: <5081699B.4020203@suse.cz>
Date: Fri, 19 Oct 2012 16:54:19 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: yann.morin.1998@free.fr, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpoirier@suse.de, yselkowitz@gmail.com
Subject: Re: [PATCH] kconfig/menuconfig: use TAILQ instead of CIRCLEQ
References: <1350581625-23153-1-git-send-email-yann.morin.1998@free.fr> <201210192110.CII57863.VOStFJQFMLHOFO@I-love.SAKURA.ne.jp>
In-Reply-To: <201210192110.CII57863.VOStFJQFMLHOFO@I-love.SAKURA.ne.jp>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19.10.2012 14:10, Tetsuo Handa wrote:
> Yann E. MORIN wrote:
>> So, switch to using TAILQ instead, which are more portable.
[...]
> Excuse me, but your patch does not solve my problem because kconfig started
> using macros which does not exist in "@(#)queue.h 8.3 (Berkeley) 12/13/93".
> Kconfig still fails after applying your patch:
> 
>   HOSTCC  scripts/kconfig/mconf.o
> scripts/kconfig/mconf.c: In function `update_text':
> scripts/kconfig/mconf.c:326: warning: implicit declaration of function `TAILQ_FOREACH'
[...]
> scripts/kconfig/mconf.c:378: warning: implicit declaration of function `TAILQ_HEAD_INITIALIZER'
> 
> So, would you add something which looks like "sed -e 's/CIRCLEQ/TAILQ/g'" upon
> https://lkml.org/lkml/2012/10/16/274 ?

Could you reduce that patch to not copy all of queue.h?
TAILQ_HEAD_INITIALIZER can be replaced by a TAILQ_INIT() call after
variable definitions, and we do not need stuff like
TAILQ_FOREACH_REVERSE. The other option is to reimplement the needed
operations under a different name, so that people don't accidentally use
other macros that are missing in old queue.h revisions.

Michal
