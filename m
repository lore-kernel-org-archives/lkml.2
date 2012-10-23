Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932945Ab2JWN6I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 09:58:08 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:60630 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932291Ab2JWN6G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 09:58:06 -0400
MIME-Version: 1.0
In-Reply-To: <20121023134505.GD16230@one.firstfloor.org>
References: <1350602382-12771-1-git-send-email-andi@firstfloor.org>
	<1350602382-12771-6-git-send-email-andi@firstfloor.org>
	<1350995474.13456.12.camel@twins>
	<CABPqkBQ4WkVb8cUdrACG8sFH7PDe96devv5_FiRSfDrxFMB8Zg@mail.gmail.com>
	<20121023134505.GD16230@one.firstfloor.org>
Date: Tue, 23 Oct 2012 15:58:03 +0200
Message-ID: <CABPqkBQiF7OG_rZKkafRuk700ryHi_h_yM7jHh1RLu4k23gW8A@mail.gmail.com>
Subject: Re: [PATCH 05/34] perf, x86: Report PEBS event in a raw format
From: Stephane Eranian <eranian@google.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, x86 <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andi Kleen <ak@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2012 at 3:45 PM, Andi Kleen <andi@firstfloor.org> wrote:
>> I believe we can use a similar approach to PERF_SAMPLE_REGS to expose
>> the PEBS machine state. We need to add PERF_SAMPLE_IREGS and then
>> return interrupt machine registers with regular sampling and the PEBS machine
>> registers in precise mode. A while back I wrote a patch to do just this. Once my
>> PEBS-LL patch is out, I will get back to it.
>
> But why not just use raw? That's far simpler and works fine and is
> already supported by perf script.
>
I have not looked at the scripts. But I am guessing they dump the content of the
PEBS records for further postprocessing by other scripts or programs.

If you do this inside perf, you have access to more infrastructure
code, e.g., dwarf.
For instance, I am interested in getting a value profiling mode. That
means sampling
the values of function arguments. That needs some dwarf support and the PEBS
machine state. With that you can produce a per function histogram of
the 6 integer
register args. You can certainly build anything in Python, but I don't
see the point
of this. Especially given that there is already some infrastructure
(and abstraction)
provided by Jiri's patch for PERF_SAMPLE_REGS.
