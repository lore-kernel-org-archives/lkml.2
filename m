Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752284Ab0FSDUg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 23:20:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39690 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751165Ab0FSDUe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 23:20:34 -0400
To: Kees Cook <kees.cook@canonical.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Randy Dunlap <rdunlap@xenotime.net>,
       James Morris <jmorris@namei.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Jiri Kosina <jkosina@suse.cz>, Dave Young <hidave.darkstar@gmail.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, David Howells <dhowells@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Eric W. Biederman" <ebiederm@xmission.com>, linux-doc@vger.kernel.org,
       Stephen Smalley <sds@tycho.nsa.gov>, Daniel J Walsh <dwalsh@redhat.com>,
       linux-security-module@vger.kernel.org, systemtap@sourceware.org
Subject: Re: [PATCH] ptrace: allow restriction of ptrace scope
References: <20100616221833.GM24749@outflux.net>
	<20100617000120.13071be8@lxorguk.ukuu.org.uk>
	<20100616232230.GP24749@outflux.net>
	<alpine.LRH.2.00.1006172336390.17282@tundra.namei.org>
	<20100617170453.GV24749@outflux.net>
	<20100617215349.2fac02f5@lxorguk.ukuu.org.uk>
	<20100617140630.c6ced27a.rdunlap@xenotime.net>
	<20100617221815.68ce30c5@lxorguk.ukuu.org.uk>
	<20100617215105.GB24749@outflux.net>
From: fche@redhat.com (Frank Ch. Eigler)
Date: Fri, 18 Jun 2010 23:19:53 -0400
In-Reply-To: <20100617215105.GB24749@outflux.net> (Kees Cook's message of "Thu, 17 Jun 2010 14:51:05 -0700")
Message-ID: <y0mk4pvvhd2.fsf@fche.csb>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kees Cook <kees.cook@canonical.com> writes:

> [...]  At present, I'm aware of global PTRACE control being possible
> in SELinux, AppArmor, grsecurity, and as a patch in Ubuntu's kernel.
> I don't know about TOMOYO or Smack, but configuring the default
> scope of PTRACE in at least 4 different ways so far (or not being
> able to change it at all) just seems crazy. [...]

For the curious, below is a demonstration an interactive systemtap
script that can implement this sort of local policy, independently of
the other security APIs.

http://sourceware.org/systemtap/examples/keyword-index.html#SECURITY

just a user         sammy sysadmin
===========         ==============

8232% echo $$
8232

                    root# noptrace.stp -x 8232 &

8232% do-stuff &
[1] 8888
                    root# cat /proc/systemtap/stap_*/blocked
                    8232 /bin/bash
                    8888 /usr/local/bin/do-stuff

8232% strace ls
strace: ptrace(PTRACE_TRACEME, ...): No such process
8232% gdb do-stuff 8888
Attaching to program: /usr/local/bin/do-stuff, process 8888
ptrace: No such process.

                    root# echo 8232 > /proc/systemtap/stap_*/unblock

8232% strace ls
[...working again...]


- FChE
