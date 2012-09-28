Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756922Ab2I1Iyu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 04:54:50 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:37048 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752352Ab2I1Iyr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 04:54:47 -0400
MIME-Version: 1.0
In-Reply-To: <1348821784.3292.50.camel@twins>
References: <1348806696-31170-1-git-send-email-andi@firstfloor.org>
	<1348806696-31170-2-git-send-email-andi@firstfloor.org>
	<1348821784.3292.50.camel@twins>
Date: Fri, 28 Sep 2012 10:54:45 +0200
Message-ID: <CABPqkBS1Crg7yHbzrvF7S2YUjrPZNSYRpE7tuax+OcEu4xrHMA@mail.gmail.com>
Subject: Re: [PATCH 01/31] perf, x86: Add PEBSv2 record support
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
        x86 <x86@kernel.org>, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andi Kleen <ak@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 28, 2012 at 10:43 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Thu, 2012-09-27 at 21:31 -0700, Andi Kleen wrote:
>> +               if (event->attr.precise_ip > 1 && x86_pmu.intel_cap.pebs_format < 2) {
>
> Shouldn't that be: && x86_pmu.intel_cap.pebs_trap, like most other sites
> instead? Or didn't they flip the trap capability on Haswell?

On Haswell, you get the event_ip which points to the sampled
instruction, i.e., the off-by-one
error can be avoided by using that value instead of pebs.rip. The nice
side effect is that you
free the LBR and minimize the overhead (no fixups). Therfore the LBR
filter can have any
setting when combined with PEBS, thus we do not need to check for
compatibility nor force
any setting for the LBR filter.
