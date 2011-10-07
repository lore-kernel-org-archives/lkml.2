Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965366Ab1JGKmO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 06:42:14 -0400
Received: from casper.infradead.org ([85.118.1.10]:53496 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759812Ab1JGKmN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 06:42:13 -0400
Subject: Re: [PATCH 07/12] perf_events: add LBR software filter support for
 Intel X86
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, acme@redhat.com, ming.m.lin@intel.com,
        robert.richter@amd.com, ravitillo@lbl.gov
Date: Fri, 07 Oct 2011 12:42:02 +0200
In-Reply-To: <CABPqkBReqBhFFKsLPfbzFHL7hs2hXSJ8tTZuP9D-2N2MGiB9Mw@mail.gmail.com>
References: <1317912555-9559-1-git-send-email-eranian@google.com>
	 <1317912555-9559-8-git-send-email-eranian@google.com>
	 <20111006153229.GJ14482@one.firstfloor.org>
	 <CABPqkBSNejhZ_ciyLTUFAybBqqGB-8QzVrPj8OTbAhQ_+mj4aw@mail.gmail.com>
	 <CABPqkBReqBhFFKsLPfbzFHL7hs2hXSJ8tTZuP9D-2N2MGiB9Mw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1317984122.31132.6.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-10-07 at 12:40 +0200, Stephane Eranian wrote:
> On Fri, Oct 7, 2011 at 12:38 PM, Stephane Eranian <eranian@google.com> wrote:
> > On Thu, Oct 6, 2011 at 5:32 PM, Andi Kleen <andi@firstfloor.org> wrote:
> >>> +     kernel_insn_init(&insn, kaddr);
> >>> +     insn_get_opcode(&insn);
> >>
> >> This makes me uncomfortable. AFAIK that's the first use of the opcode
> >> decoder being used directly for user space. It has a quite large attack
> >> surface. Who says it cannot be exploited?
> >>
> > This is not new, it's already used for the PEBS fixups and that includes
> > user level fixups, if possible.
> >
> > We are not executing the instruction here, just decoding it to filter it out
> > from a buffer if necessary.
> >
> I would add that in this particular usage, the source address is coming
> straight from LBR, it's not made up my SW. That means it corresponds
> to a point where there was a control flow change. But it can certainly
> be any x86 opcode (not just branches). LBR captures control flow changes
> due to traps, faults, interrupts.

You could still fuzz it after the cpu passed through and before the
kernel reads the LBR. Its a narrow window, but quite feasible.
