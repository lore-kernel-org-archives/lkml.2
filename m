Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755885Ab0FASLn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 14:11:43 -0400
Received: from 63.mail-out.ovh.net ([91.121.185.56]:53690 "HELO
	63.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751266Ab0FASLl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 14:11:41 -0400
Message-ID: <4C054D57.1090705@example.com>
Date: Tue, 01 Jun 2010 20:11:35 +0200
From: Piotr Hosowicz <piotr@hosowicz.com>
Reply-To: piotr@hosowicz.com
Organization: hosowicz.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100515 Icedove/3.0.4
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.35-rc1 keeps giving me bug alerts
References: <4C02E909.9080304@example.com>
In-Reply-To: <4C02E909.9080304@example.com>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 5573486014592151832
X-Ovh-Remote: 95.49.239.219 (afjf219.neoplus.adsl.tpnet.pl)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31.05.2010 00:39, Piotr Hosowicz wrote:
> Hello,
>
> I've just built and bootedd 2.6.35-rc1 and see:
>
> May 31 00:15:50 aapi205 kernel: [ 266.685572] BUG: using
> smp_processor_id() in preemptible [00000000] code: bash/5310
> May 31 00:15:50 aapi205 kernel: [ 266.685579] caller is
> native_sched_clock+0x3c/0x68
> May 31 00:15:50 aapi205 kernel: [ 266.685583] Pid: 5310, comm: bash
> Tainted: P 2.6.35-rc1 #1
> May 31 00:15:50 aapi205 kernel: [ 266.685584] Call Trace:
> May 31 00:15:50 aapi205 kernel: [ 266.685590] [<ffffffff811a39a7>]
> debug_smp_processor_id+0xc7/0xe0
> May 31 00:15:50 aapi205 kernel: [ 266.685593] [<ffffffff81009b97>]
> native_sched_clock+0x3c/0x68
> May 31 00:15:50 aapi205 kernel: [ 266.685596] [<ffffffff81009a5d>]
> sched_clock+0x9/0xd
> May 31 00:15:50 aapi205 kernel: [ 266.685600] [<ffffffff811815b0>]
> blk_rq_init+0x92/0x9e
> May 31 00:15:50 aapi205 kernel: [ 266.685604] [<ffffffff8118335e>]
> get_request+0x1bf/0x2cb
> May 31 00:15:50 aapi205 kernel: [ 266.685607] [<ffffffff81183497>]
> get_request_wait+0x2d/0x1a1
> May 31 00:15:50 aapi205 kernel: [ 266.685626] [<ffffffffa017ade7>] ?
> check_block_validity+0x30/0x63 [ext4]
> May 31 00:15:50 aapi205 kernel: [ 266.685630] [<ffffffff81035838>] ?
> get_parent_ip+0x11/0x42
> May 31 00:15:50 aapi205 kernel: [ 266.685633] [<ffffffff81036fcc>] ?
> add_preempt_count+0xad/0xb2
> May 31 00:15:50 aapi205 kernel: [ 266.685637] [<ffffffff81183b06>]
> __make_request+0x333/0x456
> May 31 00:15:50 aapi205 kernel: [ 266.685640] [<ffffffff81182dc8>]
> generic_make_request+0x24d/0x2c2
> May 31 00:15:50 aapi205 kernel: [ 266.685644] [<ffffffff81114347>] ?
> do_mpage_readpage+0x3c9/0x47e
> May 31 00:15:50 aapi205 kernel: [ 266.685648] [<ffffffff81182f0a>]
> submit_bio+0xcd/0xea
> May 31 00:15:50 aapi205 kernel: [ 266.685652] [<ffffffff810b9636>] ?
> __lru_cache_add+0x73/0x91
> May 31 00:15:50 aapi205 kernel: [ 266.685655] [<ffffffff81113db3>]
> mpage_bio_submit+0x22/0x26
> May 31 00:15:50 aapi205 kernel: [ 266.685658] [<ffffffff81114560>]
> mpage_readpages+0x107/0x11b
> May 31 00:15:50 aapi205 kernel: [ 266.685668] [<ffffffffa017e29c>] ?
> ext4_get_block+0x0/0x13 [ext4]
> May 31 00:15:50 aapi205 kernel: [ 266.685677] [<ffffffffa017e29c>] ?
> ext4_get_block+0x0/0x13 [ext4]
> May 31 00:15:50 aapi205 kernel: [ 266.685681] [<ffffffff810dccbe>] ?
> alloc_pages_current+0xa2/0xc5
> May 31 00:15:50 aapi205 kernel: [ 266.685691] [<ffffffffa017c09f>]
> ext4_readpages+0x18/0x1a [ext4]
> May 31 00:15:50 aapi205 kernel: [ 266.685695] [<ffffffff810b8a8b>]
> __do_page_cache_readahead+0x128/0x1be
> May 31 00:15:50 aapi205 kernel: [ 266.685698] [<ffffffff810b8b3d>]
> ra_submit+0x1c/0x20
> May 31 00:15:50 aapi205 kernel: [ 266.685701] [<ffffffff810b8f1d>]
> ondemand_readahead+0x1b1/0x1c4
> May 31 00:15:50 aapi205 kernel: [ 266.685705] [<ffffffff810b9004>]
> page_cache_sync_readahead+0x38/0x3c
> May 31 00:15:50 aapi205 kernel: [ 266.685709] [<ffffffff810b2190>]
> generic_file_aio_read+0x264/0x5a0
> May 31 00:15:50 aapi205 kernel: [ 266.685713] [<ffffffff810eb802>]
> do_sync_read+0xc6/0x103
> May 31 00:15:50 aapi205 kernel: [ 266.685726] [<ffffffffa01a51a7>] ?
> ext4_xattr_security_get+0x25/0x27 [ext4]
> May 31 00:15:50 aapi205 kernel: [ 266.685730] [<ffffffff81104646>] ?
> generic_getxattr+0x5a/0x5e
> May 31 00:15:50 aapi205 kernel: [ 266.685734] [<ffffffff81154d69>] ?
> get_vfs_caps_from_disk+0x4d/0xc8
> May 31 00:15:50 aapi205 kernel: [ 266.685737] [<ffffffff8115542a>] ?
> security_file_permission+0x11/0x13
> May 31 00:15:50 aapi205 kernel: [ 266.685740] [<ffffffff810ebe18>]
> vfs_read+0xa6/0x103
> May 31 00:15:50 aapi205 kernel: [ 266.685744] [<ffffffff810f1420>]
> kernel_read+0x3c/0x4b
> May 31 00:15:50 aapi205 kernel: [ 266.685747] [<ffffffff810f1515>]
> prepare_binprm+0xe6/0xeb
> May 31 00:15:50 aapi205 kernel: [ 266.685750] [<ffffffff810f1e02>]
> do_execve+0x1eb/0x35d
> May 31 00:15:50 aapi205 kernel: [ 266.685754] [<ffffffff8100a72b>]
> sys_execve+0x3e/0x55
> May 31 00:15:50 aapi205 kernel: [ 266.685757] [<ffffffff81002f5a>]
> stub_execve+0x6a/0xc0
> May 31 00:15:50 aapi205 kernel: [ 266.703681] BUG: using
> smp_processor_id() in preemptible [00000000] code: cp/5310
>
> (snip, it goes like that on)
>
> I've built just before source from git pull and it worked without such
> bug. Will it be fixed at last? I've reported it on linux-next group
> without response and here - without solution. It annoys me because I
> dont know what I am typing when I build nvidia graphics driver straight
> after boot. I attach relevant files.

Ok, I just now uptaded the source and built the kernel - the problem 
apparently disappeared. I hope that it did so permanently.

Cheers,

Piotr Hosowicz

-- 
Z cyklu "Uroki demokracji", czyli pytania i odpowiedzi w teledurniejach:
- W którym kraju znajduje siê Mount Everest?
- Hm, to nie Szkocja, prawda?
NP: Slash - Ghost (Feat. Ian Astbury)
NB: 2.6.35-rc1-20100601-1920+
