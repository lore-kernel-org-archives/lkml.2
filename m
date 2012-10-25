Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759474Ab2JYM5w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 08:57:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58697 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754050Ab2JYM5v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 08:57:51 -0400
Date: Thu, 25 Oct 2012 18:27:32 +0530 (IST)
From: P J P <ppandit@redhat.com>
X-X-Sender: pjp@javelin.pnq.redhat.com
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
cc: keescook@chromium.org, viro@zeniv.linux.org.uk,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        josh@joshtriplett.org, serge.hallyn@canonical.com,
        linux-fsdevel@vger.kernel.org, me@halfdog.net
Subject: Re: [PATCH] exec: do not leave bprm->interp on stack
In-Reply-To: <201210252103.BJG56875.OtHFLOOVSFFQMJ@I-love.SAKURA.ne.jp>
Message-ID: <alpine.LFD.2.02.1210251757200.24078@wniryva.cad.erqung.pbz>
References: <20121024232032.GA31129@www.outflux.net> <20121025041620.GH2616@ZenIV.linux.org.uk> <CAGXu5jLwvcpyMp8RcF8aFySKkkj+17ovNOvC_r88+D0fQW7CsQ@mail.gmail.com> <alpine.LFD.2.02.1210251636480.23155@wniryva.cad.erqung.pbz>
 <201210252103.BJG56875.OtHFLOOVSFFQMJ@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


   Hello Tetsuo,

+-- On Thu, 25 Oct 2012, Tetsuo Handa wrote --+
| Excuse me, but why do you change definition of printable(c) ?
| Looks like a regression.

#define printable(c) (((c)=='\t') || ((c)=='\n') || (0x20<=(c) && (c)<=0x7e))

 Earlier definition of printable() as above was used to - break; - out of the 
loop when (c) was either tab or new line or any printable character. Whereas, 
in the patch it is used to call the request_module routine if the (c) is 
printable character, and hence the change to - printable().


| Wouldn't your patch trigger call request_module() whenever a script
| starting with "#!/bin/sh" is executed?

 Yes, Petr(a colleague here) already pointed out about excessive call to 
request_module() routine, in case if the requested module is already loaded or 
is not required/available. I'm trying to find a possible fix for the same.

Is there a way to to see if the requested module 'binfmt-xxxx' is accessible 
or not? The call to - request_module - could be conditioned accordingly.

Thank you.
--
Prasad J Pandit / Red Hat Security Response Team
DB7A 84C5 D3F9 7CD1 B5EB  C939 D048 7860 3655 602B
