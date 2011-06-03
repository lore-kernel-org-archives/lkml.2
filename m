Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752126Ab1FCKZU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 06:25:20 -0400
Received: from mail.codesourcery.com ([38.113.113.100]:40146 "EHLO
	mail.codesourcery.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751401Ab1FCKZT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 06:25:19 -0400
From: Pedro Alves <pedro@codesourcery.com>
Organization: CodeSourcery
To: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCHSET ptrace] ptrace: implement PTRACE_SEIZE/INTERRUPT and group stop notification, take#4
Date: Fri, 3 Jun 2011 11:25:15 +0100
User-Agent: KMail/1.13.6 (Linux/2.6.38-8-generic; KDE/4.6.2; x86_64; ; )
Cc: Denys Vlasenko <vda.linux@googlemail.com>, Oleg Nesterov <oleg@redhat.com>,
        jan.kratochvil@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org, indan@nul.nu,
        bdonlan@gmail.com
References: <1306710760-16440-1-git-send-email-tj@kernel.org> <BANLkTik5hV8dnyspyGz8YAAdtoQNQDyOSw@mail.gmail.com> <20110603012445.GA14872@mtj.dyndns.org>
In-Reply-To: <20110603012445.GA14872@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106031125.16071.pedro@codesourcery.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 03 June 2011 02:24:45, Tejun Heo wrote:
> > > * What to do about events which are reported by genuine SIGTRAP
> > >  generation?
> > 
> > I don't understand what you meant here. Example(s)?
> 
> The syscall, breakpoint, single step SIGTRAPs which can't be
> distinguished from userland generated SIGTRAPs and may be mixed and/or
> lost.  Maybe it's best to leave them alone or maybe we can add some
> way to distinguish them which is mostly backward compatible (which is
> enabled w/ SEIZE and hopefully doesn't require noticeable userland
> changes).

Some archs started encoding some of that stuff on SIGTRAPs si_code.
E.g., on a ppc box I got here, I see:

/* `si_code' values for SIGTRAP signal.  */
enum
{
  TRAP_BRKPT = 1,               /* Process breakpoint.  */
# define TRAP_BRKPT     TRAP_BRKPT
  TRAP_TRACE                    /* Process trace trap.  */
# define TRAP_TRACE     TRAP_TRACE
};

It'd be _very_ useful for x86 (and others) to have
something like TRAP_BRKPT for int3.  Both for ptracers
and in-process self debuggers.

I'd be super happy to be told we have that already
in recent kernels and I missed it.  :-)

-- 
Pedro Alves
