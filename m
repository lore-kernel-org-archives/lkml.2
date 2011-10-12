Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753880Ab1JLSLD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 14:11:03 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:52131 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751941Ab1JLSLB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 14:11:01 -0400
MIME-Version: 1.0
In-Reply-To: <9908.1318413955@redhat.com>
References: <CAOH1cHnymZ1WasD4q+HXbeQb9wBAWmS9f451gEekA0-YjCZtLA@mail.gmail.com>
	<2150.1314882260@redhat.com>
	<CAOH1cHnLfLQzZ8022ivfFkbug=adU1AYZPJOqdTnrqh9vuAAxg@mail.gmail.com>
	<CAOH1cHm-hbC=KZJsT1H5ohVEJVzNvqaKatKVS+s2nKVkAMgX9w@mail.gmail.com>
	<5149.1317036720@redhat.com>
	<CAOH1cHn3QF0QtR7KKN9gk5CiUvLqxsni0yi9bgCmJ8f=N1v27Q@mail.gmail.com>
	<CAOH1cHmTWdCHAprmbH7cfmZCVakdayR3jd031da2X2N3FmjfPw@mail.gmail.com>
	<6324.1317308270@redhat.com>
	<CAOH1cHn0tc-_dFe1PovpKmTE5pnMp40ZXi5TR9+i=ozviTdinA@mail.gmail.com>
	<12748.1317313818@redhat.com>
	<CAOH1cHmFuXn3uZbyZy94-cBGCPDxLsJuskkYRteeBs75iLhssw@mail.gmail.com>
	<CAOH1cHn3_aeVYC73YO43zf5piKOO_=MJwbbVfhW8eAWnDahRrw@mail.gmail.com>
	<18003.1317336244@redhat.com>
	<CAOH1cHmeX56+dZEidR4AAwEkz2kr7-J12vky5G8s0vzfbO39yw@mail.gmail.com>
	<6261.1317385734@redhat.com>
	<CAOH1cHkVjTSBvqvaoWnxTB1V-dOtj1cCT_kMZpJdsyNNeUoBag@mail.gmail.com>
	<8905.1317984176@redhat.com>
	<1448.1318338420@redhat.com>
	<CAOH1cHkTiitknOsjnu9n7B2Ax+pSgM-EFDFJodjDnamxt3RMCA@mail.gmail.com>
	<9908.1318413955@redhat.com>
Date: Wed, 12 Oct 2011 11:10:59 -0700
Message-ID: <CAOH1cHkg_eQRCHxOxiOPgO=-aZfnjts-tLFQFKffk5JjEfqy2w@mail.gmail.com>
Subject: Re: [Linux-cachefs] 3.0.3 64-bit Crash running fscache/cachefilesd
From: Mark Moseley <moseleymark@gmail.com>
To: David Howells <dhowells@redhat.com>
Cc: Linux filesystem caching discussion list 
	<linux-cachefs@redhat.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 12, 2011 at 3:05 AM, David Howells <dhowells@redhat.com> wrote:
> Mark Moseley <moseleymark@gmail.com> wrote:
>
>> > Hmmm...  An object is being added to the object list twice.  It may
>> > indicate a free before an object is finished with.  Do you have slab
>> > debugging turned on?
>>
>> It's compiled in but not currently enabled. Should I do so? And
>> anything I should be looking for in it?
>
> This raises another question: Which of CONFIG_SLAB/SLOB/SLUB are you actually
> using?
>
> David
>

I had SLUB. I have CONFIG_SLUB_DEBUG but not CONFIG_SLUB_DEBUG_ON.

I've recompiled with SLAB and CONFIG_DEBUG_SLAB enabled though:

CONFIG_SLAB=y
CONFIG_SLABINFO=y
CONFIG_DEBUG_SLAB=y
CONFIG_DEBUG_SLAB_LEAK=y

Any flags anywhere that I need to set?

I've also cleared out the fscache cache. When I initially booted into
the 3.1.0-rc8 with SLAB, I was already at the cachefilesd.conf limit,
space-wise, and it would crash almost immediately (basically as soon
as load balancers started directing traffic to it again). I didn't
have console, so I don't have the full traceback for these ones, but a
little of the top actually made it to the logs:


[  117.654487] FS-Cache: Cache "mycache" added (type cachefiles)
[  117.654494] CacheFiles: File cache on sdb6 registered
[  184.943653] ------------[ cut here ]------------
[  184.952933] kernel BUG at fs/fscache/object-list.c:83!
[  184.960676] invalid opcode: 0000 [#1] SMP
[  184.960676] CPU 1
[  184.960676] Modules linked in: xfs ioatdma dca loop joydev evdev
dcdbas psmouse serio_raw pcspkr i5000_edac edac_core i5k_amb shpchp pc
i_hotplug sg sr_mod cdrom ehci_hcd uhci_hcd sd_mod crc_t10dif [last
unloaded: scsi_wait_scan]
[  184.960676]
[  184.960676] Pid: 638, comm: kworker/u:2 Not tainted 3.1.0-rc8 #1
Dell Inc. PowerEdge 1950/0DT097
[  184.960676] RIP: 0010:[<ffffffff8119d15c>]  [<ffffffff8119d15c>]
fscache_object_destroy+0x4c/0x50
[  184.960676] RSP: 0000:ffff880224cebd90  EFLAGS: 00010246
[  184.960676] RAX: 0000000000000011 RBX: ffff88021920a5e8 RCX: ffff8801d6b92a38
[  184.960676] RDX: 0000000000000010 RSI: 000000000000006b RDI: ffffffff81c94b10

This was the 2nd one, after I'd panicked it starting up cachefilesd a
couple of minutes earlier (which was also "kernel BUG at
fs/fscache/object-list.c:83"), so I figured I should clear the cache.
