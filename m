Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756242Ab0DNQ7t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 12:59:49 -0400
Received: from mtagate1.de.ibm.com ([195.212.17.161]:50092 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756186Ab0DNQ7r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 12:59:47 -0400
Date: Wed, 14 Apr 2010 19:00:08 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ian Munsie <imunsie@au1.ibm.com>, linux-kernel@vger.kernel.org,
       linuxppc-dev@lists.ozlabs.org, benh@kernel.crashing.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH v2 1/2] perf: Move arch specific code into separate
 arch directory
Message-ID: <20100414170008.GA2359@osiris.boeblingen.de.ibm.com>
References: <1271221600-25533-1-git-send-email-imunsie@au.ibm.com>
 <1271221600-25533-2-git-send-email-imunsie@au.ibm.com>
 <4BC5D534.8010508@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BC5D534.8010508@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 14, 2010 at 07:46:12AM -0700, Masami Hiramatsu wrote:
> Ian Munsie wrote:
> > From: Ian Munsie <imunsie@au.ibm.com>
> > 
> > The perf userspace tool included some architecture specific code to map
> > registers from the DWARF register number into the names used by the regs
> > and stack access API.
> > 
> > This patch moves the architecture specific code out into a separate
> > arch/x86 directory along with the infrastructure required to use it.
> > 
> > Signed-off-by: Ian Munsie <imunsie@au.ibm.com>
> > ---
> > Changes since v1: From Masami Hiramatsu's suggestion, I added a check in the
> > Makefile for if the arch specific Makefile defines PERF_HAVE_DWARF_REGS,
> > printing a message during build if it has not. This simplifies the code
> > removing the odd macro from the previous version and the need for an arch
> > specific arch_dwarf-regs.h. I have not entirely disabled DWARF support for
> > architectures that don't implement the register mappings, so that they can
> > still add a probe based on a line number (they will be missing the ability to
> > capture the value of a variable from a register).
> 
> Hmm, sorry, I don't think it is a good way to go... IMHO, porting dwarf-regs.c
> is so easy (you can just refer systemtap/runtime/loc2c-runtime.h), easier
> than porting kprobe-tracer on another arch. And perf is a part of kernel tree.
> It means that someone who are porting kprobe-tracer, he should port
> dwarf-regs.c too. In that case, PERF_HAVE_DWARF_REGS flag will be used only
> between those two patches in same patchset. So, I suggested you to drop dwarf
> support if dwarf-regs mapping doesn't exist.
> 
> AFAIK, at this point, only s390 users are affected. I'd like to ask
> them to just port a register mapping on perf and test it too.

Hm, I'm a bit lost here. Probably due to lack of context. What would be missing
on s390 and what am I supposed to implement and how can I test it?
Any pointers to git commits?
