Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758887Ab2EON1P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 09:27:15 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:38768 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752409Ab2EON1M convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 09:27:12 -0400
MIME-Version: 1.0
In-Reply-To: <1337087170.27020.166.camel@laptop>
References: <1337072138-8323-1-git-send-email-alex.shi@intel.com>
	<1337072138-8323-7-git-send-email-alex.shi@intel.com>
	<CAPa8GCDsSOrzQwX2qRJyocYAZdGbwjD4t4fjxmWXV6=EoXjXZw@mail.gmail.com>
	<CAPa8GCADw7cn+cGukfy6=gEJAqV2Ef3=YFcPriuPmhpE-xvX7A@mail.gmail.com>
	<CAJRGBZy0S_fg3GY4S5CG-2SWv5AG1jMrcMMqCiTg=7xyD1mrzQ@mail.gmail.com>
	<1337087170.27020.166.camel@laptop>
Date: Tue, 15 May 2012 21:27:10 +0800
Message-ID: <CAJRGBZyJy416yeyTgrcBR6b-7Y+cBXiz91f_gscRSado1wQVhg@mail.gmail.com>
Subject: Re: [PATCH v5 6/7] x86/tlb: optimizing flush_tlb_mm
From: Luming Yu <luming.yu@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Nick Piggin <npiggin@gmail.com>, Alex Shi <alex.shi@intel.com>,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, arnd@arndb.de,
        rostedt@goodmis.org, fweisbec@gmail.com, jeremy@goop.org,
        riel@redhat.com, luto@mit.edu, avi@redhat.com, len.brown@intel.com,
        dhowells@redhat.com, fenghua.yu@intel.com, borislav.petkov@amd.com,
        yinghai@kernel.org, ak@linux.intel.com, cpw@sgi.com, steiner@sgi.com,
        akpm@linux-foundation.org, penberg@kernel.org, hughd@google.com,
        rientjes@google.com, kosaki.motohiro@jp.fujitsu.com,
        n-horiguchi@ah.jp.nec.com, tj@kernel.org, oleg@redhat.com,
        axboe@kernel.dk, jmorris@namei.org, kamezawa.hiroyu@jp.fujitsu.com,
        viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org,
        yongjie.ren@intel.com, linux-arch@vger.kernel.org, jcm@jonmasters.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 15, 2012 at 9:06 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Tue, 2012-05-15 at 20:58 +0800, Luming Yu wrote:
>>
>>
>> Both __native_flush_tlb() and __native_flush_tlb_single(...)
>> introduced roughly 1 ns  latency to tsc sampling executed in

Fix typo, I just observed 1us with current tool, I would check if I
can push the accuracy to nanoseconds level.

>> stop_machine_context in two logical CPUs
>
> But you have to weight that against the cost of re-population, and

Right, it's hard to detect, but I will try if I can get measurement
done in a simple test tool to help people measure
this kind of stuff in few minutes.

> that's the difficult bit, since we have no clue how many tlb entries are
> in use by the current cr3.
>
> It might be possible for intel to give us this information, I've asked
> for something similar for cachelines.

This is the official document
http://www.intel.com/content/dam/doc/manual/64-ia-32-architectures-optimization-manual.pdf

Let me know if it can answer your question.

>
