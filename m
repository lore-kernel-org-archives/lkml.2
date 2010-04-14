Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755832Ab0DNOnT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 10:43:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55617 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755493Ab0DNOnR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 10:43:17 -0400
Message-ID: <4BC5D534.8010508@redhat.com>
Date: Wed, 14 Apr 2010 07:46:12 -0700
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc11 Thunderbird/3.0.1
MIME-Version: 1.0
To: Ian Munsie <imunsie@au1.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>
CC: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
       benh@kernel.crashing.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH v2 1/2] perf: Move arch specific code into separate arch
 directory
References: <1271221600-25533-1-git-send-email-imunsie@au.ibm.com> <1271221600-25533-2-git-send-email-imunsie@au.ibm.com>
In-Reply-To: <1271221600-25533-2-git-send-email-imunsie@au.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ian Munsie wrote:
> From: Ian Munsie <imunsie@au.ibm.com>
> 
> The perf userspace tool included some architecture specific code to map
> registers from the DWARF register number into the names used by the regs
> and stack access API.
> 
> This patch moves the architecture specific code out into a separate
> arch/x86 directory along with the infrastructure required to use it.
> 
> Signed-off-by: Ian Munsie <imunsie@au.ibm.com>
> ---
> Changes since v1: From Masami Hiramatsu's suggestion, I added a check in the
> Makefile for if the arch specific Makefile defines PERF_HAVE_DWARF_REGS,
> printing a message during build if it has not. This simplifies the code
> removing the odd macro from the previous version and the need for an arch
> specific arch_dwarf-regs.h. I have not entirely disabled DWARF support for
> architectures that don't implement the register mappings, so that they can
> still add a probe based on a line number (they will be missing the ability to
> capture the value of a variable from a register).

Hmm, sorry, I don't think it is a good way to go... IMHO, porting dwarf-regs.c
is so easy (you can just refer systemtap/runtime/loc2c-runtime.h), easier
than porting kprobe-tracer on another arch. And perf is a part of kernel tree.
It means that someone who are porting kprobe-tracer, he should port
dwarf-regs.c too. In that case, PERF_HAVE_DWARF_REGS flag will be used only
between those two patches in same patchset. So, I suggested you to drop dwarf
support if dwarf-regs mapping doesn't exist.

AFAIK, at this point, only s390 users are affected. I'd like to ask
them to just port a register mapping on perf and test it too.

Thank you,

-- 
Masami Hiramatsu
e-mail: mhiramat@redhat.com
