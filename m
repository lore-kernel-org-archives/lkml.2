Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751823Ab2FNFY4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 01:24:56 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:37473 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006Ab2FNFYz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 01:24:55 -0400
Date: Thu, 14 Jun 2012 10:54:30 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Anton Arapov <anton@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/6] uprobes: don't use loff_t for the valid virtual
	address
Message-ID: <20120614052430.GA9089@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <20120613184933.GA13870@redhat.com> <20120613185106.GE13878@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120613185106.GE13878@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12061405-1780-0000-0000-0000066C99B0
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000281; HX=3.00000190; KW=3.00000007;
 PH=3.00000001; SC=3.00000002; SDB=6.00147885; UDB=6.00033736; UTC=2012-06-14
 05:24:50
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 13, 2012 at 08:51:06PM +0200, Oleg Nesterov wrote:
> loff_t looks confusing when it is used for the virtual address.
> Change map_info and install_breakpoint/remove_breakpoint paths
> to use "unsigned long".
> 
> The patch doesn't change vma_address(), it can't return "long"
> because it is used to verify the mapping. But probably this
> needs some cleanups too.

Oleg,

As you mentioned in another email, this conflicts with my [1/2]
preparatory patch for the powerpc port. Do you think it just makes sense
to make the arch_uprobe_analyze_insn() prototype change to take vaddr as
part of this set itself?

I will then rebase the powerpc port when this goes into an upstream
tree.

Ananth

