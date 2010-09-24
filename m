Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933300Ab0IXQq5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 12:46:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25417 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932952Ab0IXQfC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 12:35:02 -0400
Date: Fri, 24 Sep 2010 12:34:35 -0400
From: Jason Baron <jbaron@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org, rostedt@goodmis.org,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/core] jump label: x86 support
Message-ID: <20100924163435.GE2887@redhat.com>
References: <f838f49f40fbea0254036194be66dc48b598dcea.1284733808.git.jbaron@redhat.com> <tip-d9f5ab7b1c0a520867af389bab5d5fcdbd0e407e@git.kernel.org> <4C9CCF98.7000506@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C9CCF98.7000506@zytor.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 24, 2010 at 09:19:36AM -0700, H. Peter Anvin wrote:
> On 09/24/2010 02:01 AM, tip-bot for Jason Baron wrote:
> > Commit-ID:  d9f5ab7b1c0a520867af389bab5d5fcdbd0e407e
> > Gitweb:     http://git.kernel.org/tip/d9f5ab7b1c0a520867af389bab5d5fcdbd0e407e
> > Author:     Jason Baron <jbaron@redhat.com>
> > AuthorDate: Fri, 17 Sep 2010 11:09:22 -0400
> > Committer:  Steven Rostedt <rostedt@goodmis.org>
> > CommitDate: Wed, 22 Sep 2010 16:33:03 -0400
> > 
> > jump label: x86 support
> > 
> > add x86 support for jump label. I'm keeping this patch separate so its clear
> > to arch maintainers what was required for x86 support this new feature.
> > Hopefully, it wouldn't be too painful for other archs.
> > 
> > Signed-off-by: Jason Baron <jbaron@redhat.com>
> > LKML-Reference: <f838f49f40fbea0254036194be66dc48b598dcea.1284733808.git.jbaron@redhat.com>
> > 
> > [ cleaned up some formatting ]
> > 
> > Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> > ---
> >  arch/x86/Kconfig                  |    1 +
> >  arch/x86/include/asm/jump_label.h |   47 ++++++++++++++++++++++++++++++++++
> >  arch/x86/kernel/Makefile          |    2 +-
> >  arch/x86/kernel/jump_label.c      |   50 +++++++++++++++++++++++++++++++++++++
> >  arch/x86/kernel/module.c          |    3 ++
> >  5 files changed, 102 insertions(+), 1 deletions(-)
> > 
> > diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> > index cea0cd9..afcd663 100644
> > --- a/arch/x86/Kconfig
> > +++ b/arch/x86/Kconfig
> > @@ -59,6 +59,7 @@ config X86
> >  	select ANON_INODES
> >  	select HAVE_ARCH_KMEMCHECK
> >  	select HAVE_USER_RETURN_NOTIFIER
> > +	select HAVE_ARCH_JUMP_LABEL if !CC_OPTIMIZE_FOR_SIZE
> >  
> >  config INSTRUCTION_DECODER
> >  	def_bool (KPROBES || PERF_EVENTS)
> 
> What the heck?  I had NAKed at least this chunk already...
> 
> 	-hpa
> 

The !CC_OPTIMIZE_FOR_SIZE condition is subsequently removed by a
follow-on patch as part of the commit series.

thanks,

-Jason
