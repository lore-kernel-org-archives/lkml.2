Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753211Ab0HQFWL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 01:22:11 -0400
Received: from stargate.chelsio.com ([67.207.112.58]:4499 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751952Ab0HQFWJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 01:22:09 -0400
Message-ID: <4C6A1C7C.7070004@chelsio.com>
Date: Mon, 16 Aug 2010 22:22:04 -0700
From: Dimitris Michailidis <dm@chelsio.com>
Organization: Chelsio Communications
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: linux-kernel@vger.kernel.org
Subject: Re: tasks getting stuck on mmap_sem?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> I just started seeing this with current GIT, is it related
> to the page table locking shuffle of a few days ago?
> 
> [21029.265646] INFO: task git:16643 blocked for more than 120 seconds.
> [21029.267054] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [21029.268412] git           D 000000000072f804     0 16643  16273 0x210001101000080
> [21029.269809] Call Trace:
> [21029.271062]  [000000000072f778] rwsem_down_failed_common+0x90/0xb8
> [21029.272390]  [000000000072f804] __down_read+0x30/0x40
> [21029.273689]  [0000000000731148] do_sparc64_fault+0x238/0x788
> [21029.274996]  [00000000004079e8] sparc64_realfault_common+0x10/0x20
> [21029.276347] INFO: task git:16644 blocked for more than 120 seconds.
> [21029.277655] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [21029.278993] git           D 000000000072f874     0 16644  16273 0x210041101000080
> [21029.280348] Call Trace:
> [21029.281542]  [000000000072f778] rwsem_down_failed_common+0x90/0xb8
> [21029.282818]  [000000000072f874] __down_write+0x34/0x44
> [21029.284057]  [00000000004d9c44] SyS_mmap_pgoff+0xc8/0x118
> [21029.285293]  [0000000000406154] linux_sparc_syscall32+0x34/0x40
>  ...
> 
> etc.  it's a set of git threads computing deltas for a remote pull
> request to the machine.

This may be similar to the problems IA-64 had last week as a result of the 
rwsem changes, eg see commit 01d69a82e1d3c938da16bf55aab000672243aa24.  I 
see arch/sparc/include/asm/atomic_64.h uses ints with atomic64_t, which was 
a problem for IA-64.  Just guessing.
