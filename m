Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755555Ab2F1Q1K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 12:27:10 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:43002 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128Ab2F1Q1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 12:27:08 -0400
MIME-Version: 1.0
In-Reply-To: <1340900356.28750.72.camel@twins>
References: <1340899250-26803-1-git-send-email-feng.tang@intel.com>
	<1340899974.28750.66.camel@twins>
	<CABPqkBSKQ1r_XvKZX5d59Jx3CJ8WoXsO1JJ4KfSiMng4EbH3tA@mail.gmail.com>
	<1340900356.28750.72.camel@twins>
Date: Thu, 28 Jun 2012 18:27:06 +0200
Message-ID: <CABPqkBQ6Ot8fQLtMCbAiPFWPhajaGB-HEsYmLYRY8_Xee8sBNg@mail.gmail.com>
Subject: Re: [PATCH] perf, x86: Enabled PEBS event to be exported in a raw format
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Feng Tang <feng.tang@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        x86@kernel.org, Andi Kleen <ak@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My patchset does not cover the general PEBS case (not LL). However, I
think we can leverage
the machine state captured by PEBS by adding a simple patch on top of
Jiri's sample regs
patchset. I have experimented with that last week. One interesting
measurement you can make
on SNB once you have that is : value profiling. That means sampling
the values of function
arguments. I think we can fit this into perf report.

My problem with the script approach is that you may end up
re-inventing a lot of the infrastructure
already in perf in terms of histograming and sorting. I think scripts
are good for dumping
the raw data or very simply analysis. Now I recognize that they are
handy to implement
mahcine specific decoding of the samples.

On Thu, Jun 28, 2012 at 6:19 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Thu, 2012-06-28 at 18:15 +0200, Stephane Eranian wrote:
>> I will cover some useful use cases with my PEBS-LL patchset + perf
>> support.
>>
> OK, I'll wait for those then.
