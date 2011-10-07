Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759808Ab1JGKkw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 06:40:52 -0400
Received: from smtp-out.google.com ([216.239.44.51]:7651 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759651Ab1JGKkv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 06:40:51 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:date:
	message-id:subject:from:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=QZWF6/TxDA+suAB3Jp+Rsk8sRwLJoa0LsxaDQFdN3DYGJLAooPd0al762sBhZu81w
	naTxyxGwaBj6cfkn0+0jg==
MIME-Version: 1.0
In-Reply-To: <CABPqkBSNejhZ_ciyLTUFAybBqqGB-8QzVrPj8OTbAhQ_+mj4aw@mail.gmail.com>
References: <1317912555-9559-1-git-send-email-eranian@google.com>
	<1317912555-9559-8-git-send-email-eranian@google.com>
	<20111006153229.GJ14482@one.firstfloor.org>
	<CABPqkBSNejhZ_ciyLTUFAybBqqGB-8QzVrPj8OTbAhQ_+mj4aw@mail.gmail.com>
Date: Fri, 7 Oct 2011 12:40:48 +0200
Message-ID: <CABPqkBReqBhFFKsLPfbzFHL7hs2hXSJ8tTZuP9D-2N2MGiB9Mw@mail.gmail.com>
Subject: Re: [PATCH 07/12] perf_events: add LBR software filter support for
 Intel X86
From: Stephane Eranian <eranian@google.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        acme@redhat.com, ming.m.lin@intel.com, robert.richter@amd.com,
        ravitillo@lbl.gov
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 7, 2011 at 12:38 PM, Stephane Eranian <eranian@google.com> wrote:
> On Thu, Oct 6, 2011 at 5:32 PM, Andi Kleen <andi@firstfloor.org> wrote:
>>> +     kernel_insn_init(&insn, kaddr);
>>> +     insn_get_opcode(&insn);
>>
>> This makes me uncomfortable. AFAIK that's the first use of the opcode
>> decoder being used directly for user space. It has a quite large attack
>> surface. Who says it cannot be exploited?
>>
> This is not new, it's already used for the PEBS fixups and that includes
> user level fixups, if possible.
>
> We are not executing the instruction here, just decoding it to filter it out
> from a buffer if necessary.
>
I would add that in this particular usage, the source address is coming
straight from LBR, it's not made up my SW. That means it corresponds
to a point where there was a control flow change. But it can certainly
be any x86 opcode (not just branches). LBR captures control flow changes
due to traps, faults, interrupts.
