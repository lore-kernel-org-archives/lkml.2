Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753841Ab3AJPPJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 10:15:09 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:52581 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753403Ab3AJPPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 10:15:08 -0500
X-Nat-Received: from [202.181.97.72]:52130 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1357830884.5974
To: eparis@redhat.com, linux-kernel@vger.kernel.org
Cc: dwalsh@redhat.com, dmalcolm@redhat.com, sds@tycho.nsa.gov,
        segoon@openwall.com, linux-security-module@vger.kernel.org
Subject: Re: Friendlier EPERM - Request for input
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <1357747463.2593.28.camel@localhost>
	<1357760637.2593.55.camel@localhost>
In-Reply-To: <1357760637.2593.55.camel@localhost>
Message-Id: <201301110014.CDB90164.MFtFHVSQOFOJLO@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Fri, 11 Jan 2013 00:14:42 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 10012013 #9020787, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Paris wrote:
> On systems with a strict security policy worried about such things this
> would quite reasonably need to be disabled.  But most of the reason
> people turn off LSMs is because it gets in the way and they get pissed
> getting an EPERM, checking rwx bits, having no idea WTF happened, and
> then being REALLY pissed at the LSM when they figure out that was the
> problem.  I want to put it right there, out front, here is what went
> wrong for the common case.

The reason I think is that people turn off LSMs because they are using LSMs
without understanding "what the current configuration is" and/or "how to change
configuration". People do not spend (or cannot afford spending) resources for
understanding LSM's configuration.

> We could if it was worth it make filling in the extended dial
> information an LSM hook where you can check on a per denial basis.  But
> I don't see the need.

Have you ever tried TOMOYO's interactive enforcing mode?

> The audit log is complete crap from a usability PoV.  If a web admin is

TOMOYO's audit log is very useful. TOMOYO is a security tool but is also useful
for education/training/debugging/development/profiling etc.

> trying to figure out why his web server isn't serving out web pages
> in /home he's going to look in the web server logs and see EPERM.

TOMOYO's interactive enforcing mode allows the administrator to judge whether
the web pages in /home should be served or not, before he gets EPERM.

> That's it.  Now he has to start blindly guessing which of the many
> possible reasons for EPERM is his problem.  Wouldn't it be better if the
> information was actually available?  Using the audit log in real time is
> a bloody nightmare.

TOMOYO's interactive enforcing mode utilizes TOMOYO's audit log in real time.
In other words, TOMOYO can interpose syscalls and expose the current syscall
which is about to be denied. Useful information is available in real time
and is used before getting an EPERM.

>                     As the audit maintainer I know how to use ausearch,
> but then again, as the SELinux maintainer I know how to figure out which
> of the many possibilities from EPERM are the cause.  But I want to make
> it easier for a normal admin to figure that out.

The problem I think is that people don't understand "what the current
configuration is" and/or "how to change configuration".

> 
> I know many people are worried about information leaks, so I'll right up
> front say lets add the sysctl to disable the interface for those who are
> concerned about the metadata information leak.  But for most of us I
> want that data right when it happens, where it happens, so It can be
> exposed, used, and acted upon by the admin trying to troubleshoot why
> the shit just hit the fan.

TOMOYO is exposing useful information in real time.
