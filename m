Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753589Ab1AJQb2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 11:31:28 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:51152 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753398Ab1AJQb0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 11:31:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=rCSgm0t5U2wXDAyAzXFyHqBVguc302wT2o5SkuF2Aog5UmlipciuePfVq30UWtGNB/
         BwA5WWYFSiTbkwGa5vPJkX8BoRJtJzGWg88Xk9GaXfIzMlUUZhWJl8hKsY1inIuFNhMd
         tI1rumY0QG5MYS6qUWWH7A0hWSKp6Czf4d+Pg=
MIME-Version: 1.0
In-Reply-To: <4D2ADD43.2020702@gmail.com>
References: <201101070014.p070Egpo023959@imap1.linux-foundation.org>
	<4D2ADD43.2020702@gmail.com>
Date: Tue, 11 Jan 2011 01:31:25 +0900
Message-ID: <AANLkTin7h=R0cfzpeuvpTAGRFCsFocJezpW7Riz5Za4z@mail.gmail.com>
Subject: Re: WARNING: at kernel/workqueue.c [was: mmotm 2011-01-06-15-41 uploaded]
From: Minchan Kim <minchan.kim@gmail.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        mm-commits@vger.kernel.org, Tejun Heo <tj@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/1/10 Jiri Slaby <jirislaby@gmail.com>:
> On 01/07/2011 12:41 AM, akpm@linux-foundation.org wrote:
>> The mm-of-the-moment snapshot 2011-01-06-15-41 has been uploaded to
>
> Hello, I get this during boot:
> NMI watchdog enabled, takes one hw-pmu counter.
> Booting Node   0, Processors  #1
> CPU1: Thermal LVT vector (0xfa) already installed
> NMI watchdog enabled, takes one hw-pmu counter.
> Brought up 2 CPUs
> Total of 2 processors activated (11970.26 BogoMIPS).
> devtmpfs: initialized
> ------------[ cut here ]------------
> WARNING: at kernel/workqueue.c:1202 worker_enter_idle+0xd0/0x140()
> Hardware name: To Be Filled By O.E.M.
> Modules linked in:
> Pid: 5, comm: kworker/u:0 Not tainted 2.6.37-mm1_64+ #1343
> Call Trace:
>  [<ffffffff8106ad2a>] ? warn_slowpath_common+0x7a/0xb0
>  [<ffffffff8106ad75>] ? warn_slowpath_null+0x15/0x20
>  [<ffffffff8107f690>] ? worker_enter_idle+0xd0/0x140
>  [<ffffffff81081e28>] ? worker_thread+0x208/0x320
>  [<ffffffff81081c20>] ? worker_thread+0x0/0x320
>  [<ffffffff81086436>] ? kthread+0x96/0xa0
>  [<ffffffff81030b14>] ? kernel_thread_helper+0x4/0x10
>  [<ffffffff810863a0>] ? kthread+0x0/0xa0
>  [<ffffffff81030b10>] ? kernel_thread_helper+0x0/0x10
> ---[ end trace 4eaa2a86a8e2da22 ]---
>
> Probably a result of the workqueue rewrite...

Here it is, too.
mmotm-01-06

[    0.735057] input: Power Button as
/devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    0.735106] ACPI: Power Button [PWRF]
[    0.735380] ACPI: acpi_idle registered with cpuidle
[    0.737261] ------------[ cut here ]------------
[    0.737270] isapnp: Scanning for PnP cards...
[    0.737341] WARNING: at kernel/workqueue.c:1202
worker_enter_idle+0xc7/0x130()
[    0.737388] Hardware name: 965P-DS3
[    0.737425] Modules linked in:
[    0.737488] Pid: 5, comm: kworker/u:0 Not tainted 2.6.37-mm1+ #2
[    0.737527] Call Trace:
[    0.737567]  [<c014a412>] ? warn_slowpath_common+0x72/0xa0
[    0.737607]  [<c01611c7>] ? worker_enter_idle+0xc7/0x130
[    0.737648]  [<c01611c7>] ? worker_enter_idle+0xc7/0x130
[    0.737688]  [<c014a462>] ? warn_slowpath_null+0x22/0x30
[    0.737728]  [<c01611c7>] ? worker_enter_idle+0xc7/0x130
[    0.737769]  [<c0163e47>] ? worker_thread+0x1d7/0x3a0
[    0.737809]  [<c0163c70>] ? worker_thread+0x0/0x3a0
[    0.737848]  [<c01678c4>] ? kthread+0x74/0x80
[    0.737887]  [<c0167850>] ? kthread+0x0/0x80
[    0.737926]  [<c0103686>] ? kernel_thread_helper+0x6/0x10
[    0.737970] ---[ end trace e93713a9d40cd06c ]---
[    1.090221] isapnp: No Plug & Play device found
[    1.090392] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    1.110781] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    1.372584] 00:06: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    1.437762] brd: module loaded






-- 
Kind regards,
Minchan Kim
