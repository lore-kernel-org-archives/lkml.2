Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932327Ab2EOJPN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 05:15:13 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:36015 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932120Ab2EOJPK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 05:15:10 -0400
MIME-Version: 1.0
In-Reply-To: <1337072138-8323-7-git-send-email-alex.shi@intel.com>
References: <1337072138-8323-1-git-send-email-alex.shi@intel.com>
	<1337072138-8323-7-git-send-email-alex.shi@intel.com>
Date: Tue, 15 May 2012 19:15:09 +1000
Message-ID: <CAPa8GCDsSOrzQwX2qRJyocYAZdGbwjD4t4fjxmWXV6=EoXjXZw@mail.gmail.com>
Subject: Re: [PATCH v5 6/7] x86/tlb: optimizing flush_tlb_mm
From: Nick Piggin <npiggin@gmail.com>
To: Alex Shi <alex.shi@intel.com>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, arnd@arndb.de,
        rostedt@goodmis.org, fweisbec@gmail.com, jeremy@goop.org,
        riel@redhat.com, luto@mit.edu, avi@redhat.com, len.brown@intel.com,
        dhowells@redhat.com, fenghua.yu@intel.com, borislav.petkov@amd.com,
        yinghai@kernel.org, ak@linux.intel.com, cpw@sgi.com, steiner@sgi.com,
        akpm@linux-foundation.org, penberg@kernel.org, hughd@google.com,
        rientjes@google.com, kosaki.motohiro@jp.fujitsu.com,
        n-horiguchi@ah.jp.nec.com, tj@kernel.org, oleg@redhat.com,
        axboe@kernel.dk, jmorris@namei.org, a.p.zijlstra@chello.nl,
        kamezawa.hiroyu@jp.fujitsu.com, viro@zeniv.linux.org.uk,
        linux-kernel@vger.kernel.org, yongjie.ren@intel.com,
        linux-arch@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So this should go to linux-arch...

On 15 May 2012 18:55, Alex Shi <alex.shi@intel.com> wrote:
> Not every flush_tlb_mm execution moment is really need to evacuate all
> TLB entries, like in munmap, just few 'invlpg' is better for whole
> process performance, since it leaves most of TLB entries for later
> accessing.
>
> This patch is changing flush_tlb_mm(mm) to flush_tlb_mm(mm, start, end)
> in cases.

What happened with Peter's comment about using flush_tlb_range for this?

flush_tlb_mm() API should just stay unchanged AFAIKS.

Then you need to work out the best way to give range info to the tlb/mmu gather
API. Possibly passing in the rage for that guy is OK, which x86 can
then implement
as flush range.
