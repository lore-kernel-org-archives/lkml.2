Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754174Ab2DSHBu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 03:01:50 -0400
Received: from [124.207.24.138] ([124.207.24.138]:36128 "EHLO
	mail.ss.pku.edu.cn" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752248Ab2DSHBr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 03:01:47 -0400
MIME-Version: 1.0
In-Reply-To: <20120419064751.GA6268@asmodeus.uplinklabs.net>
References: <CAF1ivSZqe54_gAQNZW_teiApObkXsC5iu04Siy1OEnm9M9AcUA@mail.gmail.com>
	<20120419064751.GA6268@asmodeus.uplinklabs.net>
Date: Thu, 19 Apr 2012 15:00:59 +0800
Message-ID: <CAF1ivSYtRi-3PpF2TeQwOFSBSWp+Cnz2B6ds6Py1T5uZ6U70Nw@mail.gmail.com>
Subject: Re: [PATCH 0/2] fix "perf top" soft lockups under Xen
From: Lin Ming <mlin@ss.pku.edu.cn>
To: Steven Noonan <steven@uplinklabs.net>
Cc: linux-kernel@vger.kernel.org, Jeremy Fitzhardinge <jeremy@goop.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Marcus Granado <marcus.granado@citrix.com>, xen-devel@lists.xen.org,
        Ben Guthro <ben@guthro.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 19, 2012 at 2:47 PM, Steven Noonan <steven@uplinklabs.net> wrote:

[snip]

>
> OK, finally got around to testing this. Sorry about the delay, been
> rather busy at work.
>
> These two patches definitely fix the lockups, but 'perf test' doesn't
> pass every test:

Thanks for the test!

>
>         1: vmlinux symtab matches kallsyms:
>        --- start ---
>        Looking at the vmlinux_path (6 entries long)
>        dso__load_sym: cannot get elf header.
>        Using /lib/modules/3.3.2-00002-gf57130d/build/vmlinux for symbols
>        Maps only in vmlinux:
>         ffffffff81ae61b1-ffffffff81b9d7b7 0 [kernel].init.text
>         ffffffff81b9d7b8-ffffffff9fffffff 0 [kernel].exit.text
>        Maps in vmlinux with a different name in kallsyms:
>        Maps only in kallsyms:
>        ---- end ----
>        vmlinux symtab matches kallsyms: Ok
>         2: detect open syscall event:
>        --- start ---
>        ---- end ----
>        detect open syscall event: Ok
>         3: detect open syscall event on all cpus:
>        --- start ---
>        ---- end ----
>        detect open syscall event on all cpus: Ok
>         4: read samples using the mmap interface:
>        --- start ---
>        ---- end ----
>        read samples using the mmap interface: Ok
>         5: parse events tests:
>        --- start ---
>        ---- end ----
>        parse events tests: Ok
>         6: Validate PERF_RECORD_* events & perf_sample fields:
>        --- start ---
>        perf_evlist__open: Bad file descriptor
>        ---- end ----
>        Validate PERF_RECORD_* events & perf_sample fields: FAILED!

This should be another unrelated issue.
Let me try to see if I can reproduce it.

>
> I couldn't figure out what exactly was failing in that test with a
> quick inspection... Someone else want to take a stab at it? If someone
> wants to give me patches that add extra output, I could run those too.
>
> Anyway:
>
> Tested-by: Steven Noonan <steven@uplinklabs.net>

Thanks.

Lin Ming

>
> - Steven
