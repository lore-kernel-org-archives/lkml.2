Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756508Ab2AJQKf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 11:10:35 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:61499 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756358Ab2AJQKe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 11:10:34 -0500
MIME-Version: 1.0
In-Reply-To: <CAGyNYUMGzoZ50hDgOMeUVZbTyFHBDOV43j1ppBbfpXnMwqSeLw@mail.gmail.com>
References: <1325856086.17441.27.camel@osiris>
	<CAGyNYUO0WGXgN50AXW08Hec97TM-PRm4iNQR5gZ+=wdRz1KUgQ@mail.gmail.com>
	<CAGyNYUMGzoZ50hDgOMeUVZbTyFHBDOV43j1ppBbfpXnMwqSeLw@mail.gmail.com>
Date: Wed, 11 Jan 2012 00:10:33 +0800
Message-ID: <CAF0htA4+dMFs_3y+XrSMUA6VBB9H-s369TN_AoyDG-paJ3TuSw@mail.gmail.com>
Subject: Re: [PATCH] score: fix off-by-one index into syscall table
From: Lennox Wu <lennox.wu@gmail.com>
To: Eugene Teo <eugeneteo@kernel.sg>
Cc: Dan Rosenberg <drosenberg@vsecurity.com>, liqin.chen@sunplusct.com,
        linux-kernel@vger.kernel.org, security@kernel.org, arnd@arndb.de,
        Liqin Chen <liqin.gnu@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear all,
I will look the issue and update the informaion  of  MAINTAINERS.
Best,
Lennox

2012/1/10 Eugene Teo <eugeneteo@kernel.sg>
>
> On Tue, Jan 10, 2012 at 2:40 PM, Eugene Teo <eugeneteo@kernel.sg> wrote:
> > Cc'ed arnd@arndb.de
> >
> > ping
>
> Liqin's work email bounced.  I'm not sure if he is working on these
> anymore. If not, the MAINTAINERS file needs to be updated.
>
> > On Fri, Jan 6, 2012 at 9:21 PM, Dan Rosenberg <drosenberg@vsecurity.com> wrote:
> >> If the provided system call number is equal to __NR_syscalls, the
> >> current check will pass and a function pointer just after the system
> >> call table may be called, since sys_call_table is an array with total
> >> size __NR_syscalls.  Whether or not this is a security bug depends on
> >> what the compiler puts immediately after the system call table.  It's
> >> likely that this won't do anything bad because there is an additional
> >> NULL check on the syscall entry, but if there happens to be a non-NULL
> >> value immediately after the system call table, this may result in local
> >> privilege escalation.
> >>
> >> Signed-off-by: Dan Rosenberg <drosenberg@vsecurity.com>
> >> Cc: stable@kernel.org
> >> Cc: security@kernel.org
> >> ---
> >>  arch/score/kernel/entry.S |    2 +-
> >>  1 files changed, 1 insertions(+), 1 deletions(-)
> >>
> >> diff --git a/arch/score/kernel/entry.S b/arch/score/kernel/entry.S
> >> index 577abba..83bb960 100644
> >> --- a/arch/score/kernel/entry.S
> >> +++ b/arch/score/kernel/entry.S
> >> @@ -408,7 +408,7 @@ ENTRY(handle_sys)
> >>        sw      r9, [r0, PT_EPC]
> >>
> >>        cmpi.c  r27, __NR_syscalls      # check syscall number
> >> -       bgtu    illegal_syscall
> >> +       bgeu    illegal_syscall
> >>
> >>        slli    r8, r27, 2              # get syscall routine
> >>        la      r11, sys_call_table
> >>
> >>
