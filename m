Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756575Ab2FFPLT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 11:11:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8119 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753018Ab2FFPLS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 11:11:18 -0400
Date: Wed, 6 Jun 2012 17:08:48 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org, lkml <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>, benh@kernel.crashing.org,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Anton Blanchard <anton@samba.org>, Ingo Molnar <mingo@elte.hu>,
        peterz@infradead.org
Subject: Re: [PATCH 1/2] uprobes: Pass probed vaddr to
	arch_uprobe_analyze_insn()
Message-ID: <20120606150848.GA24641@redhat.com>
References: <20120606091950.GB6745@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120606091950.GB6745@in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/06, Ananth N Mavinakayanahalli wrote:
>
> From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
>
> On RISC architectures like powerpc, instructions are fixed size.
> Instruction analysis on such platforms is just a matter of (insn % 4).
> Pass the vaddr at which the uprobe is to be inserted so that
> arch_uprobe_analyze_insn() can flag misaligned registration requests.

And the next patch checks "vaddr & 0x03".

But why do you need this new arg? arch_uprobe_analyze_insn() could
check "container_of(auprobe, struct uprobe, arch)->offset & 0x3" with
the same effect, no? vm_start/vm_pgoff are obviously page-aligned.

Oleg.

