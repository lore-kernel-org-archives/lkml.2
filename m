Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753462Ab2KKSRK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2012 13:17:10 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:51737 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753006Ab2KKSRI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2012 13:17:08 -0500
MIME-Version: 1.0
In-Reply-To: <20121110115027.GC2777@rric.localhost>
References: <1352509298-7319-1-git-send-email-jacob.shin@amd.com>
	<20121110115027.GC2777@rric.localhost>
Date: Sun, 11 Nov 2012 19:17:07 +0100
Message-ID: <CABPqkBSdEsKwzni2VQcedV9tOFWWCVVV4WhmkWHRp6nFTo9wDA@mail.gmail.com>
Subject: Re: [PATCH 0/4] perf, amd: Enable AMD family 15h northbridge counters
From: Stephane Eranian <eranian@google.com>
To: Robert Richter <rric@kernel.org>
Cc: Jacob Shin <jacob.shin@amd.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        x86 <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 10, 2012 at 12:50 PM, Robert Richter <rric@kernel.org> wrote:
> On 09.11.12 19:01:34, Jacob Shin wrote:
>> The following patchset enables 4 additional performance counters in
>> AMD family 15h processors that counts northbridge events -- such as
>> DRAM accesses.
>>
>> This patchset is based on previous work done by Robert Richter
>> <rric@kernel.org> :
>>
>> https://lkml.org/lkml/2012/6/19/324
>
> The original patch set of this is here (a rebased version):
>
>  http://git.kernel.org/?p=linux/kernel/git/rric/oprofile.git;a=shortlog;h=refs/heads/perf-nb
>
> This code was tested in detail.
>
>> The main differences are:
>>
>> - The northbridge counters are indexed contiguously right above the
>>   core performance counters.
>>
>> - MSR address offset calculations are moved to architecture specific
>>   files.
>>
>> - Interrups are set up to be delivered only to a single core.
>
> So I rather suggest to make delta patches on top of my patches.
>
> Peter's main concerns were that my patch set is not in the
> Intel-uncore style. I started reworking this but was not able to
> finish my work. This concerns still exist.
>
That was my concern too. I don't recall exactly why it could not
be totally disconnected from the core PMU. I think hardware-wise,
it was possible. Could you refresh my memory?
