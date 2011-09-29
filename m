Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755771Ab1I2WLc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 18:11:32 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:56207 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751640Ab1I2WLb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 18:11:31 -0400
MIME-Version: 1.0
In-Reply-To: <CAOH1cHmFuXn3uZbyZy94-cBGCPDxLsJuskkYRteeBs75iLhssw@mail.gmail.com>
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
Date: Thu, 29 Sep 2011 15:11:30 -0700
Message-ID: <CAOH1cHn3_aeVYC73YO43zf5piKOO_=MJwbbVfhW8eAWnDahRrw@mail.gmail.com>
Subject: Re: [Linux-cachefs] 3.0.3 64-bit Crash running fscache/cachefilesd
From: Mark Moseley <moseleymark@gmail.com>
Cc: Linux filesystem caching discussion list 
	<linux-cachefs@redhat.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 29, 2011 at 12:02 PM, Mark Moseley <moseleymark@gmail.com> wrote:
> On Thu, Sep 29, 2011 at 9:30 AM, David Howells <dhowells@redhat.com> wrote:
>> Mark Moseley <moseleymark@gmail.com> wrote:
>>
>>> >> [12999.564897] FS-Cache: Cookie 'NFS.fh' still has outstanding reads
>>> >
>>> > Hopefully the patch set I sent to you will deal with this.
>>> >
>>> > David
>>>
>>> Not sure what you mean. Was there another patch besides the one to get
>>> more info in the traceback?
>>
>> I emailed a set of 13 patches to you a short time before that.  Hopefully
>> they'll fix the outstanding-reads problem the bad-page-state problem.
>
> Sorry, I just had this thread sitting open in gmail and I was looking
> for the patch within it. I see all those emails you sent. I'll try to
> get those patched in today. Thanks!
>

With those 13 patches, I get this traceback. Nothing before or after
in logs or console.


[ 1499.098817] ------------[ cut here ]------------
[ 1499.108048] kernel BUG at fs/fscache/operation.c:408!
[ 1499.108675] invalid opcode: 0000 [#1] SMP
[ 1499.108675] CPU 2
[ 1499.108675] Modules linked in: xfs ioatdma dca loop joydev evdev
psmouse dcdbas pcspkr serio_raw i5000_edac edac_core i5k_amb shpchp
pci_hotplug sg sr_mod]
[ 1499.108675]
[ 1499.108675] Pid: 8062, comm: httpd Not tainted 3.1.0-rc8 #1 Dell
Inc. PowerEdge 1950/0DT097
[ 1499.108675] RIP: 0010:[<ffffffff81197b24>]  [<ffffffff81197b24>]
fscache_put_operation+0x304/0x330
[ 1499.108675] RSP: 0018:ffff880062f739d8  EFLAGS: 00010296
[ 1499.108675] RAX: 0000000000000025 RBX: ffff8800c5122e84 RCX: ffffffff81ddf040
[ 1499.108675] RDX: 00000000ffffffff RSI: 0000000000000082 RDI: ffffffff81ddef30
[ 1499.108675] RBP: ffff880062f739f8 R08: 0000000000000005 R09: 0000000000000000
[ 1499.108675] R10: 0000000000000000 R11: 0000000000000003 R12: ffff8800c5122e40
[ 1499.108675] R13: ffff880037a2cd20 R14: ffff880087c7a058 R15: ffff880087c7a000
[ 1499.108675] FS:  00007f63dcf636e0(0000) GS:ffff88022fc80000(0000)
knlGS:0000000000000000
[ 1499.108675] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1499.108675] CR2: 00007f0c0a91f000 CR3: 0000000062ec2000 CR4: 00000000000006e0
[ 1499.108675] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 1499.108675] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 1499.108675] Process httpd (pid: 8062, threadinfo ffff880062f72000,
task ffff880087e58000)
[ 1499.108675] Stack:
[ 1499.108675]  ffff880062f73bf8 0000000000000000 ffff880062f73bf8
ffff880037a2cd20
[ 1499.108675]  ffff880062f73a68 ffffffff8119aa7e ffff88006540e000
ffff880062f73ad4
[ 1499.108675]  ffff88008e9a4308 ffff880037a2cd20 ffff880062f73a48
ffff8800c5122e40
[ 1499.108675] Call Trace:
[ 1499.108675]  [<ffffffff8119aa7e>] __fscache_read_or_alloc_pages+0x1fe/0x530
[ 1499.108675]  [<ffffffff81250780>] __nfs_readpages_from_fscache+0x70/0x1c0
[ 1499.108675]  [<ffffffff8123142a>] nfs_readpages+0xca/0x1e0
[ 1499.108675]  [<ffffffff815f3c06>] ? rpc_do_put_task+0x36/0x50
[ 1499.108675]  [<ffffffff8122755b>] ? alloc_nfs_open_context+0x4b/0x110
[ 1499.108675]  [<ffffffff815ecd1a>] ? rpc_call_sync+0x5a/0x70
[ 1499.108675]  [<ffffffff810e7e9a>] __do_page_cache_readahead+0x1ca/0x270
[ 1499.108675]  [<ffffffff810e7f61>] ra_submit+0x21/0x30
[ 1499.108675]  [<ffffffff810e818d>] ondemand_readahead+0x11d/0x250
[ 1499.108675]  [<ffffffff810e83b6>] page_cache_sync_readahead+0x36/0x60
[ 1499.108675]  [<ffffffff810dffa4>] generic_file_aio_read+0x454/0x770
[ 1499.108675]  [<ffffffff81224ce1>] nfs_file_read+0xe1/0x130
[ 1499.108675]  [<ffffffff81121bd9>] do_sync_read+0xd9/0x120
[ 1499.108675]  [<ffffffff8114088f>] ? mntput+0x1f/0x40
[ 1499.108675]  [<ffffffff811238cb>] ? fput+0x1cb/0x260
[ 1499.600056]  [<ffffffff81122938>] vfs_read+0xc8/0x180
[ 1499.600056]  [<ffffffff81122af5>] sys_read+0x55/0x90
