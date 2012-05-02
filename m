Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753256Ab2EBNE6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 09:04:58 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:42716 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752313Ab2EBNE5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 09:04:57 -0400
MIME-Version: 1.0
In-Reply-To: <4FA11CC7.5040302@intel.com>
References: <1335603099-2624-1-git-send-email-alex.shi@intel.com>
	<1335603099-2624-3-git-send-email-alex.shi@intel.com>
	<20120430105440.GC9303@aftab.osrc.amd.com>
	<4FA0FD39.9060908@intel.com>
	<20120502093815.GB12914@aftab.osrc.amd.com>
	<4FA11CC7.5040302@intel.com>
Date: Wed, 2 May 2012 23:04:51 +1000
Message-ID: <CAPa8GCDhGfuYEemdsnUZwh=O6Nco1PH1JgiruvWw3400yz9S8w@mail.gmail.com>
Subject: Re: [PATCH 2/3] x86/flush_tlb: try flush_tlb_single one by one in flush_tlb_range
From: Nick Piggin <npiggin@gmail.com>
To: Alex Shi <alex.shi@intel.com>
Cc: Borislav Petkov <bp@amd64.org>, andi.kleen@intel.com,
        tim.c.chen@linux.intel.com, jeremy@goop.org, chrisw@sous-sol.org,
        akataria@vmware.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, rostedt@goodmis.org, fweisbec@gmail.com,
        riel@redhat.com, luto@mit.edu, avi@redhat.com, len.brown@intel.com,
        paul.gortmaker@windriver.com, dhowells@redhat.com,
        fenghua.yu@intel.com, yinghai@kernel.org, cpw@sgi.com, steiner@sgi.com,
        linux-kernel@vger.kernel.org, yongjie.ren@intel.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2 May 2012 21:38, Alex Shi <alex.shi@intel.com> wrote:
> On 05/02/2012 05:38 PM, Borislav Petkov wrote:
>
>> On Wed, May 02, 2012 at 05:24:09PM +0800, Alex Shi wrote:
>>> For some of scenario, above equation can be modified as:
>>> (512 - X) * 100ns(assumed TLB refill cost) = X * 140ns(assumed invlpg cost)

It should not be that optimistic, because that equation assumes every
unflushed entry saves a TLB refill too.

I think it is always a good idea to make such fundamental primitives
cheaper though.


>> Also, have you run your patches with other benchmarks beside your
>> microbenchmark, say kernbench, SPEC<something>, i.e. some other
>> multithreaded benchmark touching shared memory? Are you seeing any
>> improvement there?
>
>
> I tested oltp reading and specjbb2005 with openjdk. They should not much
> flush_tlb_range calling. So, no clear improvement.
> Do you know benchmarks which cause enough flush_tlb_range?

x86 does not do such invlpg flushing for munmap either, as far as I
can see?

It would be a little more work to make this happen, but it might show
more benefit, provided glibc does not free too huge chunks at once,
it should apply far more often.
