Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755313Ab1FBXGL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 19:06:11 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:60987 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755131Ab1FBXGJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 19:06:09 -0400
From: Richard Weinberger <richard@nod.at>
To: Tony Luck <tony.luck@intel.com>
Subject: Re: [PATCH] Audit: push audit success and retcode into arch ptrace.h
Date: Fri, 3 Jun 2011 01:03:46 +0200
User-Agent: KMail/1.13.7 (Linux/2.6.37.6-0.5-desktop; KDE/4.6.3; x86_64; ; )
Cc: Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
        fenghua.yu@intel.com, monstr@monstr.eu, ralf@linux-mips.org,
        benh@kernel.crashing.org, paulus@samba.org, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, linux390@de.ibm.com, lethal@linux-sh.org,
        davem@davemloft.net, jdike@addtoit.com, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        viro@zeniv.linux.org.uk, oleg@redhat.com, akpm@linux-foundation.org,
        linux-ia64@vger.kernel.org, microblaze-uclinux@itee.uq.edu.au,
        linux-mips@linux-mips.org, linuxppc-dev@lists.ozlabs.org,
        linux-s390@vger.kernel.org, linux-sh@vger.kernel.org,
        sparclinux@vger.kernel.org,
        user-mode-linux-devel@lists.sourceforge.net
References: <20110602210458.23613.24076.stgit@paris.rdu.redhat.com> <201106030032.17398.richard@nod.at> <BANLkTik9kCs_06=7HKo44cWqpS0zB9fr+A@mail.gmail.com>
In-Reply-To: <BANLkTik9kCs_06=7HKo44cWqpS0zB9fr+A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="windows-1252"
Content-Transfer-Encoding: 8BIT
Message-Id: <201106030103.46742.richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag 03 Juni 2011, 01:00:51 schrieb Tony Luck:
> > But there seems to be another problem.
> > Why is pt_regs of type void *?
> > 
> > gcc complains:
> > In file included from include/linux/fsnotify.h:15:0,
> >                 from include/linux/security.h:26,
> >                 from init/main.c:32:
> > include/linux/audit.h: In function ‘audit_syscall_exit’:
> > include/linux/audit.h:440:17: warning: dereferencing ‘void *’ pointer
> > include/linux/audit.h:440:3: error: invalid use of void expression
> > include/linux/audit.h:441:21: warning: dereferencing ‘void *’ pointer
> > include/linux/audit.h:441:21: error: void value not ignored as it ought
> > to be
> 
> Perhaps same issue on ia64 - but symptoms are different:

The void * pointer is the problem.
On UML it builds fine when I cast it:
#define regs_return_value(r) UPT_SYSCALL_RET((struct uml_pt_regs *)r)

I'll test it tomorrow in detail, for now I'm too sleepy.

Thanks,
//richard
