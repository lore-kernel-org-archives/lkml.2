Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752448Ab0DMIop (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 04:44:45 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:38768 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752065Ab0DMIoo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 04:44:44 -0400
Content-Type: text/plain; charset=UTF-8
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
       benh <benh@kernel.crashing.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 1/2] perf: Move arch specific code into separate arch directory
From: Ian Munsie <imunsie@au1.ibm.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
In-reply-to: <4BC313EF.4040406@redhat.com>
References: <1271054596-26561-1-git-send-email-imunsie@au.ibm.com> <1271054596-26561-2-git-send-email-imunsie@au.ibm.com> <4BC313EF.4040406@redhat.com>
Date: Tue, 13 Apr 2010 18:44:14 +1000
Message-Id: <1271147886-sup-8960@au1.ibm.com>
User-Agent: Sup/0.10.2
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Masami,

Thanks for the feedback

Excerpts from Masami Hiramatsu's message of Mon Apr 12 22:37:03 +1000 2010:
> Could you add a check whether the get_arch_regstr() is defined
> (or dwarf-regs.h is exist) in Makefile?
> If it is not defined, we'd better drop dwarf support(so set NO_DWARF),
> because it means we haven't ported perf probe on that architecture yet. :)

I was a little reluctant to do that when I first read your message
because it felt like adding autoconf stuff into the Makefile and the
code should already fail gracefully on architectures without the
register mappings. But, since the Makefile already has some autoconf
like magic and it would make the code cleaner, I'll play with the idea a
bit more tomorrow.

> > diff --git a/tools/perf/arch/x86/include/arch_dwarf-regs.h b/tools/perf/arch/x86/include/arch_dwarf-regs.h
> > new file mode 100644
> > index 0000000..9e8da6a
> > --- /dev/null
> > +++ b/tools/perf/arch/x86/include/arch_dwarf-regs.h
> > @@ -0,0 +1,6 @@
> > +#ifndef _PREF_ARCH_PPC_DWARF_REGS_H
> > +#define _PREF_ARCH_PPC_DWARF_REGS_H
> 
> _PREF_ARCH_X86_DWARF_REGS_H ?

Nice catch (oops)


Cheers,
-Ian
