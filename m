Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753779Ab1LFTRv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 14:17:51 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:55667 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752989Ab1LFTRt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 14:17:49 -0500
MIME-Version: 1.0
In-Reply-To: <1323169412.32012.69.camel@twins>
References: <1318595833-29984-1-git-send-email-eranian@google.com>
	<1323124766.32012.49.camel@twins>
	<20111206094927.GA25782@mudshark.cambridge.arm.com>
	<1323169412.32012.69.camel@twins>
Date: Tue, 6 Dec 2011 11:14:14 -0800
Message-ID: <CABPqkBQq=ra+-O==qT+8DtFZ5T7=M4yJrnPJ_bb+UmUTGGQepQ@mail.gmail.com>
Subject: Re: [PATCH 00/12] perf_events: add support for sampling taken
 branches (v2)
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Will Deacon <will.deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@elte.hu" <mingo@elte.hu>, "acme@redhat.com" <acme@redhat.com>,
        "ming.m.lin@intel.com" <ming.m.lin@intel.com>,
        "andi@firstfloor.org" <andi@firstfloor.org>,
        "robert.richter@amd.com" <robert.richter@amd.com>,
        "ravitillo@lbl.gov" <ravitillo@lbl.gov>,
        "paulus@samba.org" <paulus@samba.org>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        "rth@twiddle.net" <rth@twiddle.net>,
        "ralf@linux-mips.org" <ralf@linux-mips.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "lethal@linux-sh.org" <lethal@linux-sh.org>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 6, 2011 at 3:03 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, 2011-12-06 at 09:49 +0000, Will Deacon wrote:
>> On Mon, Dec 05, 2011 at 10:39:26PM +0000, Peter Zijlstra wrote:
>> > On Fri, 2011-10-14 at 14:37 +0200, Stephane Eranian wrote:
>> > > This patchset adds an important and useful new feature to
>> > > perf_events: branch stack sampling. In other words, the
>> > > ability to capture taken branches into each sample.
>> > >
>> > Other than the few comments given it all looks good. My main worry is
>> > the Intel only aspect, I'd really love for there to be another platform
>> > that could implement at least part of this.
>>
>> I discussed this with Stephane in Prague and, although it would be lovely to
>> have this on ARM, we simply don't have the hardware to do it. So the nature
>> of series does seem to be x86-centric unless there's way to do a watered
>> down version in software.
>
> The only way to do this in software would be like
> CONFIG_PROFILE_ALL_BRANCHES and that's horrid (and kernel only).
>
> But there's more than Intel & ARM, but it looks like PPC doesn't have
> this either and I suspect MIPS and SPARC don't either, which doesn't
> leave us with much else.
>
There is a hardware branch buffer on all Itanium processors.
You can find the description for the McKinley implementation
 (Itanium2) branch buffer in section 10.3.9 from:
http://download.intel.com/design/Itanium2/manuals/25111003.pdf

> So I guess we should just go ahead and merge this and hope more hardware
> grows this feature in a compatible enough manner.
