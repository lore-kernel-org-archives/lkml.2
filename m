Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758722Ab1JFROT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 13:14:19 -0400
Received: from one.firstfloor.org ([213.235.205.2]:35223 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758711Ab1JFROP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 13:14:15 -0400
Date: Thu, 6 Oct 2011 19:14:12 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>, Stephane Eranian <eranian@google.com>,
        linux-kernel@vger.kernel.org, mingo@elte.hu, acme@redhat.com,
        ming.m.lin@intel.com, robert.richter@amd.com, ravitillo@lbl.gov,
        "masami.hiramatsu.pt" <masami.hiramatsu.pt@hitachi.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: [PATCH 07/12] perf_events: add LBR software filter support for Intel X86
Message-ID: <20111006171412.GK14482@one.firstfloor.org>
References: <1317912555-9559-1-git-send-email-eranian@google.com> <1317912555-9559-8-git-send-email-eranian@google.com> <20111006153229.GJ14482@one.firstfloor.org> <1317919424.29658.13.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317919424.29658.13.camel@twins>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 06, 2011 at 06:43:44PM +0200, Peter Zijlstra wrote:
> On Thu, 2011-10-06 at 17:32 +0200, Andi Kleen wrote:
> > > +	kernel_insn_init(&insn, kaddr);
> > > +	insn_get_opcode(&insn);
> > 
> > This makes me uncomfortable. AFAIK that's the first use of the opcode
> > decoder being used directly for user space. It has a quite large attack
> > surface. Who says it cannot be exploited?
> 
> You mean:
> arch/x86/kernel/cpu/perf_event_intel_ds.c:intel_pmu_pebs_fixup_ip()
> doesn't use the opcode decoder on user space code?

True it does. Ok the second.
I know uprobes is planning it too, so the problem has to be handled
eventually.

Still it makes me uncomfortable.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
