Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751772Ab2FFLre (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 07:47:34 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:36812 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751801Ab2FFLrd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 07:47:33 -0400
Date: Wed, 6 Jun 2012 17:14:23 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>, linuxppc-dev@lists.ozlabs.org,
        lkml <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
        benh@kernel.crashing.org, Anton Blanchard <anton@samba.org>,
        Ingo Molnar <mingo@elte.hu>, oleg@redhat.com
Subject: Re: [PATCH 1/2] uprobes: Pass probed vaddr to
 arch_uprobe_analyze_insn()
Message-ID: <20120606114423.GA32094@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20120606091950.GB6745@in.ibm.com>
 <1338974632.2749.87.camel@twins>
 <20120606093744.GB29580@in.ibm.com>
 <20120606094014.GD9495@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20120606094014.GD9495@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12060611-6078-0000-0000-00000BCC80CE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar <mingo@kernel.org> [2012-06-06 11:40:15]:

> 
> * Ananth N Mavinakayanahalli <ananth@in.ibm.com> wrote:
> 
> > On Wed, Jun 06, 2012 at 11:23:52AM +0200, Peter Zijlstra wrote:
> > > On Wed, 2012-06-06 at 14:49 +0530, Ananth N Mavinakayanahalli wrote:
> > > > +int arch_uprobe_analyze_insn(struct arch_uprobe *auprobe, struct mm_struct *mm, loff_t vaddr)
> > > 
> > > Don't we traditionally use unsigned long to pass vaddrs?
> > 
> > Right. But the vaddr we pass here is vma_info->vaddr which is loff_t.
> > I guess I should've made that clear in the patch description.
> 
> Why not fix struct vma_info's vaddr type?
> 

Calculating and comparing vaddr results either uses variables of type loff_t. 
To avoid typecasting and avoid overflow at each of these places, we used
loff_t. 

Ananth, install_breakpoint() already has a variable of type addr of type
unsigned long.  Why dont you use addr instead of vaddr. 

-- 
Thanks and regards
Srikar

