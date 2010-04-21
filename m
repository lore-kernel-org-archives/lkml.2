Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756177Ab0DUSka (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 14:40:30 -0400
Received: from smtp-out.google.com ([216.239.44.51]:25942 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756149Ab0DUSk3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 14:40:29 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:x-system-of-record;
	b=fH8iofjjkxk76PNyStdC1xlx8Pd/3OuXKVHTbamNzkl6sVyEW54/4B4ZIIU2kR8Cm
	znM+6Oza5n4CVpV58Dd9g==
MIME-Version: 1.0
In-Reply-To: <20100421182629.GE6450@erda.amd.com>
References: <1271190201-25705-1-git-send-email-robert.richter@amd.com>
	 <1271317461.32749.67.camel@laptop>
	 <20100415151633.GN11907@erda.amd.com>
	 <1271851865.4807.10284.camel@twins>
	 <u2kbd4cb8901004210621gd8b453cg6b41f1ee3effaa99@mail.gmail.com>
	 <20100421182629.GE6450@erda.amd.com>
Date: Wed, 21 Apr 2010 20:40:07 +0200
Message-ID: <k2vbd4cb8901004211140g7cace261laf6d690211787a79@mail.gmail.com>
Subject: Re: [PATCH 00/12] perf: introduce model specific events and AMD IBS
From: Stephane Eranian <eranian@google.com>
To: Robert Richter <robert.richter@amd.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 21, 2010 at 8:26 PM, Robert Richter <robert.richter@amd.com> wrote:
> On 21.04.10 15:21:35, Stephane Eranian wrote:
>> Okay, so you're suggesting everything is exposed via PERF_SAMPLE_REGS.
>> PEBS does capture machine state which is easily mapped onto PERF_SAMPLE_REGS.
>> Well, that's until you look at PEB-LL on Nehalem where is captures
>> latencies and data
>> addresses.
>>
>> Those could be funneled through PERF_SAMPLE_REGS
>> as well, I believe. But that means, PERF_SAMPLE_REGS would need some
>> configuration
>> bitmask to name the registers of interest, e.g. EAX, EDX, IBSOP_DATA,
>> IBSOP_PHYSAD,
>> and so on.
>
> What is the idea of PERF_SAMPLE_REGS? A git grep PERF_SAMPLE_REGS only
> returns a single line in -tip. I know nothing about it.
>
You may want to collect some of the general purpose registers
(interrupted state) in each
sample. This is what you get today in a signal handler (ucontext) for
instance. That may
also be a way to export PEBS samples.
