Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755559Ab0FXOiU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 10:38:20 -0400
Received: from verein.lst.de ([213.95.11.210]:47742 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754511Ab0FXOiT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 10:38:19 -0400
Date: Thu, 24 Jun 2010 16:37:17 +0200
From: Christoph Hellwig <hch@lst.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jason Baron <jbaron@redhat.com>, x86@kernel.org,
       linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
       linuxppc-dev@ozlabs.org, Ingo Molnar <mingo@redhat.com>,
       Paul Mackerras <paulus@samba.org>, Ian Munsie <imunsie@au1.ibm.com>,
       Greg Ungerer <gerg@uclinux.org>,
       Russell King <rmk+kernel@arm.linux.org.uk>,
       Thomas Gleixner <tglx@linutronix.de>, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 12/40] x86, compat: convert ia32 layer to use
Message-ID: <20100624143717.GA7565@lst.de>
References: <1277287401-28571-1-git-send-email-imunsie@au1.ibm.com> <1277287401-28571-13-git-send-email-imunsie@au1.ibm.com> <20100623101402.GA10564@lst.de> <20100623103619.GC5242@nowhere> <20100623104603.GB11845@lst.de> <20100623114116.GE5242@nowhere> <4C225F40.8000008@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C225F40.8000008@zytor.com>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 23, 2010 at 12:23:44PM -0700, H. Peter Anvin wrote:
> >> arch/s390/kernel/sys_s390.c:SYSCALL_DEFINE(s390_fallocate)(int fd, int mode, loff_t offset,
> >> arch/sparc/kernel/sys_sparc_64.c:SYSCALL_DEFINE1(sparc_pipe_real, struct pt_regs *, regs)
> > 
> > In fact we sort of wanted to standardize the name of arch overriden compat
> > syscalls, so that userspace programs playing with syscalls tracing won't have
> > to deal with arch naming differences.
> > 
> 
> That seems totally wrong in so many ways.
> 
> What userspace sees is the system call name, e.g. fallocate or pipe.  It
> should *not* be visible to userspace that there is an arch-specici
> implementation.

This is really just the in-kernel name.  With tracing we export it to
userspace, so agreed that we should stay consistent.  We need a good
way to override both native and compat system calls with arch version
to always export the sys_ / compat_sys names.

