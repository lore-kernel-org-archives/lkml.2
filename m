Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758666Ab1JFQoL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 12:44:11 -0400
Received: from casper.infradead.org ([85.118.1.10]:43814 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753505Ab1JFQoK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 12:44:10 -0400
Subject: Re: [PATCH 07/12] perf_events: add LBR software filter support for
 Intel X86
From: Peter Zijlstra <peterz@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Stephane Eranian <eranian@google.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, acme@redhat.com, ming.m.lin@intel.com,
        robert.richter@amd.com, ravitillo@lbl.gov,
        "masami.hiramatsu.pt" <masami.hiramatsu.pt@hitachi.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Date: Thu, 06 Oct 2011 18:43:44 +0200
In-Reply-To: <20111006153229.GJ14482@one.firstfloor.org>
References: <1317912555-9559-1-git-send-email-eranian@google.com>
	 <1317912555-9559-8-git-send-email-eranian@google.com>
	 <20111006153229.GJ14482@one.firstfloor.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1317919424.29658.13.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-10-06 at 17:32 +0200, Andi Kleen wrote:
> > +	kernel_insn_init(&insn, kaddr);
> > +	insn_get_opcode(&insn);
> 
> This makes me uncomfortable. AFAIK that's the first use of the opcode
> decoder being used directly for user space. It has a quite large attack
> surface. Who says it cannot be exploited?

You mean:
arch/x86/kernel/cpu/perf_event_intel_ds.c:intel_pmu_pebs_fixup_ip()
doesn't use the opcode decoder on user space code?

ISTR Masami telling me they ran fuzzers on it, feeding it bad
instructions etc. But maybe he can tell more.
