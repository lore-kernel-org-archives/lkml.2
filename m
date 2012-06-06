Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757161Ab2FFQeR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 12:34:17 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:60406 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756811Ab2FFQeQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 12:34:16 -0400
Date: Wed, 6 Jun 2012 22:00:50 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        linuxppc-dev@lists.ozlabs.org, lkml <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>, benh@kernel.crashing.org,
        Anton Blanchard <anton@samba.org>, Ingo Molnar <mingo@elte.hu>,
        peterz@infradead.org
Subject: Re: [PATCH 1/2] uprobes: Pass probed vaddr to
 arch_uprobe_analyze_insn()
Message-ID: <20120606163050.GB32094@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20120606091950.GB6745@in.ibm.com>
 <20120606150848.GA24641@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20120606150848.GA24641@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12060616-6148-0000-0000-000006790647
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Oleg Nesterov <oleg@redhat.com> [2012-06-06 17:08:48]:

> On 06/06, Ananth N Mavinakayanahalli wrote:
> >
> > From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
> >
> > On RISC architectures like powerpc, instructions are fixed size.
> > Instruction analysis on such platforms is just a matter of (insn % 4).
> > Pass the vaddr at which the uprobe is to be inserted so that
> > arch_uprobe_analyze_insn() can flag misaligned registration requests.
> 
> And the next patch checks "vaddr & 0x03".
> 
> But why do you need this new arg? arch_uprobe_analyze_insn() could
> check "container_of(auprobe, struct uprobe, arch)->offset & 0x3" with
> the same effect, no? vm_start/vm_pgoff are obviously page-aligned.
> 

We cant use container_of because we moved the definition for struct
uprobe to kernel/events/uprobe.c. This was possible before when struct
uprobe definition was in include/uprobes.h 

-- 
Thanks and Regards
Srikar

