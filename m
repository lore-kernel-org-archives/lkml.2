Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932604Ab2JWMjy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 08:39:54 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:33197 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756796Ab2JWMjx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 08:39:53 -0400
MIME-Version: 1.0
In-Reply-To: <1350995474.13456.12.camel@twins>
References: <1350602382-12771-1-git-send-email-andi@firstfloor.org>
	<1350602382-12771-6-git-send-email-andi@firstfloor.org>
	<1350995474.13456.12.camel@twins>
Date: Tue, 23 Oct 2012 14:39:52 +0200
Message-ID: <CABPqkBQ4WkVb8cUdrACG8sFH7PDe96devv5_FiRSfDrxFMB8Zg@mail.gmail.com>
Subject: Re: [PATCH 05/34] perf, x86: Report PEBS event in a raw format
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andi Kleen <andi@firstfloor.org>, x86 <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andi Kleen <ak@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2012 at 2:31 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Thu, 2012-10-18 at 16:19 -0700, Andi Kleen wrote:
>> +       if (event->attr.sample_type & PERF_SAMPLE_RAW) {
>> +               raw.size = x86_pmu.pebs_record_size;
>> +               raw.data = __pebs;
>> +               data.raw = &raw;
>> +       }
>
> The Changelog babbles about registers, yet you export the entire record.
>
> There's the PERF_SAMPLE_REGS thing which has been pointed out to you,
> but you fail to include this in your arguments.
>
I believe we can use a similar approach to PERF_SAMPLE_REGS to expose
the PEBS machine state. We need to add PERF_SAMPLE_IREGS and then
return interrupt machine registers with regular sampling and the PEBS machine
registers in precise mode. A while back I wrote a patch to do just this. Once my
PEBS-LL patch is out, I will get back to it.

> Also, there's an alignment issue there, the raw.data is 32bit offset,
> the record is u64 aligned, leaving the output stream offset, wrecking
> things.
>
> And as with any ABI extension, it should come with useful userspace to
> make use of it.
>
> I'll hold off on this one for now.
