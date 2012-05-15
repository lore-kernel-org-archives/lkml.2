Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932747Ab2EOM66 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 08:58:58 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:35817 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932154Ab2EOM64 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 08:58:56 -0400
MIME-Version: 1.0
In-Reply-To: <CAPa8GCADw7cn+cGukfy6=gEJAqV2Ef3=YFcPriuPmhpE-xvX7A@mail.gmail.com>
References: <1337072138-8323-1-git-send-email-alex.shi@intel.com>
	<1337072138-8323-7-git-send-email-alex.shi@intel.com>
	<CAPa8GCDsSOrzQwX2qRJyocYAZdGbwjD4t4fjxmWXV6=EoXjXZw@mail.gmail.com>
	<CAPa8GCADw7cn+cGukfy6=gEJAqV2Ef3=YFcPriuPmhpE-xvX7A@mail.gmail.com>
Date: Tue, 15 May 2012 20:58:54 +0800
Message-ID: <CAJRGBZy0S_fg3GY4S5CG-2SWv5AG1jMrcMMqCiTg=7xyD1mrzQ@mail.gmail.com>
Subject: Re: [PATCH v5 6/7] x86/tlb: optimizing flush_tlb_mm
From: Luming Yu <luming.yu@gmail.com>
To: Nick Piggin <npiggin@gmail.com>
Cc: Alex Shi <alex.shi@intel.com>, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, arnd@arndb.de, rostedt@goodmis.org, fweisbec@gmail.com,
        jeremy@goop.org, riel@redhat.com, luto@mit.edu, avi@redhat.com,
        len.brown@intel.com, dhowells@redhat.com, fenghua.yu@intel.com,
        borislav.petkov@amd.com, yinghai@kernel.org, ak@linux.intel.com,
        cpw@sgi.com, steiner@sgi.com, akpm@linux-foundation.org,
        penberg@kernel.org, hughd@google.com, rientjes@google.com,
        kosaki.motohiro@jp.fujitsu.com, n-horiguchi@ah.jp.nec.com,
        tj@kernel.org, oleg@redhat.com, axboe@kernel.dk, jmorris@namei.org,
        a.p.zijlstra@chello.nl, kamezawa.hiroyu@jp.fujitsu.com,
        viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org,
        yongjie.ren@intel.com, linux-arch@vger.kernel.org, jcm@jonmasters.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 15, 2012 at 5:17 PM, Nick Piggin <npiggin@gmail.com> wrote:
> On 15 May 2012 19:15, Nick Piggin <npiggin@gmail.com> wrote:
>> So this should go to linux-arch...
>>
>> On 15 May 2012 18:55, Alex Shi <alex.shi@intel.com> wrote:
>>> Not every flush_tlb_mm execution moment is really need to evacuate all
>>> TLB entries, like in munmap, just few 'invlpg' is better for whole
>>> process performance, since it leaves most of TLB entries for later
>>> accessing.
>
> Did you have microbenchmarks for this like your mprotect numbers,
> by the way? Test munmap numbers and see how that looks. Also,

Might be off topic, but I just spent few minutes to test out the difference
between write CR3 vs. invlpg on a pretty old but still reliable P4 desktop
with my simple hardware latency and bandwidth test tool I posted for
RFC several weeks ago on LKML.

Both __native_flush_tlb() and __native_flush_tlb_single(...)
introduced roughly 1 ns  latency to tsc sampling executed in
stop_machine_context in two logical CPUs

Just to fuel the discussion. :-)

Cheers,
/l
