Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752448Ab2HCJh7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 05:37:59 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:46901 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751463Ab2HCJh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 05:37:57 -0400
Message-ID: <501B9BF1.2050006@suse.cz>
Date: Fri, 03 Aug 2012 11:37:53 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120718 Thunderbird/15.0
MIME-Version: 1.0
To: Fengguang Wu <fengguang.wu@intel.com>
CC: Alan Cox <alan@linux.intel.com>, Al Viro <viro@zeniv.linux.org.uk>,
        LKML <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: Re: uart_startup: GFP_KERNEL allocation with IRQs disabled
References: <20120803014600.GA7886@localhost>
In-Reply-To: <20120803014600.GA7886@localhost>
X-Enigmail-Version: 1.5a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/03/2012 03:46 AM, Fengguang Wu wrote:
> Hi all,

Hi,

> The IRQ should be disabled somewhere in the path walk, which makes
> the GFP_KERNEL allocation in uart_startup() no longer valid..
> 
> [    0.499537] kworker/u:1 (29) used greatest stack depth: 7156 bytes left
> [    0.500947] ------------[ cut here ]------------
> [    0.501445] WARNING: at /c/kernel-tests/src/stable/kernel/lockdep.c:2739 lockdep_trace_alloc+0x86/0xb2()
> [    0.502413] Modules linked in:
> [    0.502766] Pid: 1, comm: init Not tainted 3.5.0-01258-g1ade992 #182
> [    0.503419] Call Trace:
...
> [    0.504381]  [<c1079e7d>] get_zeroed_page+0xd/0xf
> [    0.504381]  [<c10f976f>] uart_startup.part.8+0x46/0x152
> [    0.504381]  [<c10f745f>] ? tty_port_tty_set+0x37/0x3c
> [    0.504381]  [<c10fa175>] uart_open+0xc9/0x10b
> [    0.504381]  [<c10fa0ac>] ? uart_suspend_port+0x229/0x229
> [    0.504381]  [<c10f1bc2>] tty_open+0x26b/0x3d3
> [    0.504381]  [<c109872a>] chrdev_open+0xf7/0x117

This does not make sense to me. I would not blame TTY/serial for this.
There is somebody who forgot to enable interrupts somewhere. Could you
enable DEBUG_ATOMIC_SLEEP? It might trigger earlier revealing us the
culprit.

thanks,
-- 
js
suse labs
