Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759747Ab1IJQoU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Sep 2011 12:44:20 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:39965 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759461Ab1IJQoT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Sep 2011 12:44:19 -0400
MIME-Version: 1.0
In-Reply-To: <4E6B6624.1000406@christianhoffmann.info>
References: <4E6B6624.1000406@christianhoffmann.info>
Date: Sat, 10 Sep 2011 12:44:17 -0400
Message-ID: <CA+5PVA4nRVN0cia9R49=T5xy1inxQLSjDcv1yn4+UFppufRiYA@mail.gmail.com>
Subject: Re: scheduling while atomic: swapper/0/0x10000002
From: Josh Boyer <jwboyer@gmail.com>
To: Christian Hoffmann <email@christianhoffmann.info>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 10, 2011 at 9:29 AM, Christian Hoffmann
<email@christianhoffmann.info> wrote:
> Hi,
>
> I can see the following bug report in the kernel 3.1 rc5 dmesg:
>
> [    0.000008] BUG: scheduling while atomic: swapper/0/0x10000002
> [    0.000012] Modules linked in:
> [    0.000015] Pid: 0, comm: swapper Not tainted 3.1.0-rc5-ch+ #2
> [    0.000017] Call Trace:
> [    0.000024]  [<ffffffff81052cb6>] __schedule_bug+0x66/0x70
> [    0.000028]  [<ffffffff8160329d>] schedule+0x99d/0x9b0
> [    0.000032]  [<ffffffff81cf22b5>] ? pidmap_init+0x9f/0xdf
> [    0.000035]  [<ffffffff8105cc7a>] __cond_resched+0x2a/0x40
> [    0.000038]  [<ffffffff81603541>] _cond_resched+0x31/0x40
> [    0.000041]  [<ffffffff8115fb63>] kmem_cache_alloc_trace+0x53/0x160
> [    0.000043]  [<ffffffff81cf22b5>] pidmap_init+0x9f/0xdf
> [    0.000046]  [<ffffffff81cd9b8a>] start_kernel+0x333/0x3c8
> [    0.000049]  [<ffffffff81cd9347>] x86_64_start_reservations+0x132/0x136
> [    0.000051]  [<ffffffff81cd944c>] x86_64_start_kernel+0x101/0x110

Paul McKenney has a patch that solves this oops.  You can find it here:

http://marc.info/?l=linux-kernel&m=131537669921538&w=2

We had discussed getting this into 3.1, but apparently that didn't
happen (yet?).  I thought it had been sent upstream with my tested-by,
but I don't see it included in Linus' tree.

josh
