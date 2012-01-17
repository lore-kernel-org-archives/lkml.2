Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755029Ab2AQQPl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 11:15:41 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:56992 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754682Ab2AQQPj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 11:15:39 -0500
MIME-Version: 1.0
In-Reply-To: <4F1544EA.5060907@linux.vnet.ibm.com>
References: <20120111000051.GA28874@dztty>
	<CACVXFVMZhVFZajbZxng9dJqicy1XCK5n_QZLoefvkLkXvMsSZg@mail.gmail.com>
	<4F10929E.8070007@linux.vnet.ibm.com>
	<CA+55aFzGZ_eSTChemYczKr3-0zQ3J3MJ3TfGtxh9wkhSKrrfCA@mail.gmail.com>
	<4F10BDF7.8030306@linux.vnet.ibm.com>
	<CA+55aFyD=9MZCyo-Tq0J7g2p9Qvp=S+GADpUfoQ0dcde_bvzSg@mail.gmail.com>
	<4F10EB5B.5060804@linux.vnet.ibm.com>
	<1326766892.16150.21.camel@sbsiddha-desk.sc.intel.com>
	<4F1544EA.5060907@linux.vnet.ibm.com>
Date: Wed, 18 Jan 2012 00:15:38 +0800
Message-ID: <CAAJw_ZtPZLPgi2z-0zB0n3hk9xzEbTnb1QGi1LjM5DC02t_W7A@mail.gmail.com>
Subject: Re: x86/mce: machine check warning during poweroff
From: Jeff Chua <jeff.chua.linux@gmail.com>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ming Lei <tom.leiming@gmail.com>, Djalal Harouni <tixxdz@opendz.org>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Tony Luck <tony.luck@intel.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@linux.intel.com>,
        linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        Kay Sievers <kay.sievers@vrfy.org>,
        gouders@et.bocholt.fh-gelsenkirchen.de,
        Marcos Souza <marcos.mage@gmail.com>,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "tglx@linutronix.de" <tglx@linutronix.de>, prasad@linux.vnet.ibm.com,
        justinmattock@gmail.com, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mel Gorman <mgorman@suse.de>, Gilad Ben-Yossef <gilad@benyossef.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 17, 2012 at 5:52 PM, Srivatsa S. Bhat
<srivatsa.bhat@linux.vnet.ibm.com> wrote:
> On 01/17/2012 07:51 AM, Suresh Siddha wrote:
>
>> On Sat, 2012-01-14 at 08:11 +0530, Srivatsa S. Bhat wrote:
>>> Of course, the warnings at drivers/base/core.c: device_release()
>>> as well as the IPI to offline cpu warnings still appear but are rather
>>> unrelated and harmless to the issue being discussed.
>>
>> As far the IPI offline cpu warnings are concerned, appended patch should
>> fix it. Can you please give it a try? Peterz, can you please review and
>> queue it after Srivatsa confirms that it works? Thanks.
>
>
> Hi Suresh,
>
> Thanks for the patch, but unfortunately it doesn't fix the problem!
> Exactly the same stack traces are seen during a CPU Hotplug stress test.
> (I didn't even have to stress it - it is so fragile that just a script
> to offline all cpus except the boot cpu was good enough to reproduce the
> problem easily.)

Works for me. But I'm still seeing this only during boot. Related?
Shall I bisect?


Freeing unused kernel memory: 520k freed
Write protecting the kernel read-only data: 8192k
Freeing unused kernel memory: 1140k freed
Freeing unused kernel memory: 464k freed
Adding 8290300k swap on /dev/sda3.  Priority:-1 extents:1 across:8290300k SS
vmalloc: allocation failure: 0 bytes
modprobe: page allocation failure: order:0, mode:0xd2
Pid: 1914, comm: modprobe Not tainted 3.2.0 #6
Call Trace:
[<ffffffff8107c1ff>] ? 0xffffffff8107c1ff
[<ffffffff81061fec>] ? 0xffffffff81061fec
[<ffffffff8109ab6c>] ? 0xffffffff8109ab6c
[<ffffffff81061fec>] ? 0xffffffff81061fec
[<ffffffff8101bacc>] ? 0xffffffff8101bacc
[<ffffffff81061fec>] ? 0xffffffff81061fec
[<ffffffff81061fec>] ? 0xffffffff81061fec
[<ffffffff81062ec8>] ? 0xffffffff81062ec8
[<ffffffff810637c1>] ? 0xffffffff810637c1
[<ffffffff814d9cb9>] ? 0xffffffff814d9cb9
Mem-Info:
Node 0 DMA per-cpu:
CPU    0: hi:    0, btch:   1 usd:   0
CPU    1: hi:    0, btch:   1 usd:   0
CPU    2: hi:    0, btch:   1 usd:   0
CPU    3: hi:    0, btch:   1 usd:   0
Node 0 DMA32 per-cpu:
CPU    0: hi:  186, btch:  31 usd: 158
CPU    1: hi:  186, btch:  31 usd:  25
CPU    2: hi:  186, btch:  31 usd:   0
CPU    3: hi:  186, btch:  31 usd:   0
Node 0 Normal per-cpu:
CPU    0: hi:  186, btch:  31 usd:  93
CPU    1: hi:  186, btch:  31 usd:  74
CPU    2: hi:  186, btch:  31 usd: 170
CPU    3: hi:  186, btch:  31 usd:  60
active_anon:6162 inactive_anon:1 isolated_anon:0
active_file:1782 inactive_file:5164 isolated_file:0
unevictable:0 dirty:0 writeback:0 unstable:0
free:1963131 slab_reclaimable:818 slab_unreclaimable:2728
mapped:1639 shmem:3 pagetables:292 bounce:0


Thanks,
Jeff
