Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755165Ab0FCRXI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 13:23:08 -0400
Received: from smtp-out.google.com ([74.125.121.35]:23372 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751960Ab0FCRXG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 13:23:06 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:date:message-id:subject:from:to:cc:
	content-type:x-system-of-record;
	b=Ak8bMquedK2bb0Bvy56VILZz9+ueyl2zSB1jmzATitOGMzFBX5EedyCZTBF96bth6
	06SX7yI1VQ5HzbwDX6mPQ==
MIME-Version: 1.0
Date: Thu, 3 Jun 2010 19:23:02 +0200
Message-ID: <AANLkTik2yNxwCHl7FZAyOG4Vt56RlLi59oZR5Jo6o9ox@mail.gmail.com>
Subject: how to use perf annotate on the kernel
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, paulus@samba.org, davem@davemloft.net,
       fweisbec@gmail.com, acme@infradead.org, perfmon2-devel@lists.sf.net,
       eranian@gmail.com, eranian@google.com, tzanussi@gmail.com
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnaldo,

I am trying to understand how one is supposed
to use perf annotate to get sample correlations
with kernel symbols.

I do:

# perf record -a -e cycles:k dd if=/dev/zero of=/dev/null count=1000000
# perf report

# Events: 14K cycles
#
# Overhead          Command        Shared Object  Symbol
# ........  ...............  ...................  ......
#
     8.76%               dd  [kernel.kallsyms]    [k] __lock_acquire
     7.49%               dd  [kernel.kallsyms]    [k] sched_clock
     6.41%               dd  [kernel.kallsyms]    [k] __clear_user
     5.50%               dd  [kernel.kallsyms]    [k] sched_clock_local
     3.86%               dd  [kernel.kallsyms]    [k] cpu_clock
     3.82%               dd  [kernel.kallsyms]    [k] trace_hardirqs_off_caller
     3.50%               dd  [kernel.kallsyms]    [k] lock_release
     3.27%               dd  [kernel.kallsyms]    [k] system_call_after_swapgs
     3.15%               dd  [kernel.kallsyms]    [k] system_call

# perf annotate (or annotate -d '[kernel.kallsyms]'?)
Can't annotate __lock_acquire: No vmlinux file was found in the path

# perf annotate -k vmlinux
objdump: '[kernel.kallsyms]': No such file
objdump: '[kernel.kallsyms]': No such file
objdump: '[kernel.kallsyms]': No such file
objdump: '[kernel.kallsyms]': No such file
objdump: '[kernel.kallsyms]': No such file
objdump: '[kernel.kallsyms]': No such file
objdump: '[kernel.kallsyms]': No such file
objdump: '[kernel.kallsyms]': No such file
objdump: '[kernel.kallsyms]': No such file
objdump: '[kernel.kallsyms]': No such file

Am I missing something here?
Thanks.
