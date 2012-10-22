Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755719Ab2JVQSM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 12:18:12 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:63961 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751222Ab2JVQSL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 12:18:11 -0400
MIME-Version: 1.0
In-Reply-To: <20121022161040.GC9438@quack.suse.cz>
References: <20121018212357.GA17646@quack.suse.cz>
	<1350596425.1366.15.camel@x61.thuisdomein>
	<20121018220809.GD17646@quack.suse.cz>
	<20121019124454.316ecfac@notabene.brown>
	<CADpTngX=6vWV1fv8x-g8ufKTb3gW2=phPZBHZJHATEcqqjwtYg@mail.gmail.com>
	<CADpTngVnJwmu-E3wJwUaK2CKGBsRoJphRNtDPAO9AHyOnnfeRQ@mail.gmail.com>
	<20121022134541.GA9438@quack.suse.cz>
	<CADpTngX9YNq6Own1gvrHnwizUfG0KfjRuXL2F38n2C+CnOTpDA@mail.gmail.com>
	<20121022154258.GB9438@quack.suse.cz>
	<CADpTngUxFT+Sj1aZDY3iBMLpwgrj5rziTSibWD3HMC_DszZpDw@mail.gmail.com>
	<20121022161040.GC9438@quack.suse.cz>
Date: Mon, 22 Oct 2012 18:18:10 +0200
Message-ID: <CADpTngVHx_7uzEGM+_XGVK2Neh-dgcfxLnGaXT370SzgXtCZQA@mail.gmail.com>
Subject: Re: ext3 issue on 3.6.1
From: Fabio Coatti <fabio.coatti@gmail.com>
To: Jan Kara <jack@suse.cz>
Cc: NeilBrown <neilb@suse.de>, "Myklebust, Trond" <Trond.Myklebust@netapp.com>,
        Paul Bolle <pebolle@tiscali.nl>, linux-kernel@vger.kernel.org,
        Jeff Layton <jlayton@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/10/22 Jan Kara <jack@suse.cz>:
> On Mon 22-10-12 18:01:56, Fabio Coatti wrote:
>> 2012/10/22 Jan Kara <jack@suse.cz>:
>> >> Uhu, my fault, I was sure to have answered to your request, sorry.
>> >> So yes, we have an ext3 R/O partition mounted on that machine. The
>> >> 3.6.3, with patch applied, dmesg is here:
>> >   Interesting. You seem to be using data=journal on R/O partition, don't
>> > you? Can you also attach /proc/mounts?
>> >
>> >   Also please try running a kernel with the attached patch and report the
>> > warning. Thanks!
>>
>> Do you want to try the kernel without touching the mount
>> configuration, right? (I mean, without (say) mounting ext2 the ext3 ro
>> partition, right?)
>   Yes, leave things as they are now...
>
>> right now I can't access the machine, but I recall that the partition
>> is mounted rw, something is wrote onto it and then changed to r/o and
>> among the options there is data=ordered.
>   /proc/mounts should show us whether data=ordered is in use. Actually the
> warning is in function which is called only in data=journal mode so that's
> why I think you are using it...

Ok, got the options:

ro,noatime,errors=continue,barrier=1,data=ordered 0 0

and as expected, the usual warning triggered, but not the message from
your patch:

[  173.408622] ------------[ cut here ]------------
[  173.408725] WARNING: at fs/ext3/inode.c:1754
ext3_journalled_writepage+0x55/0x1a7()
[  173.408850] Hardware name: ProLiant BL465c G7
[  173.408940] Pid: 2142, comm: flush-8:0 Not tainted 3.6.3-p #2
[  173.409034] Call Trace:
[  173.409123]  [<ffffffff81057884>] ? warn_slowpath_common+0x73/0x87
[  173.409219]  [<ffffffff8115cd04>] ? ext3_journalled_writepage+0x55/0x1a7
[  173.409320]  [<ffffffff810a2833>] ? __writepage+0xa/0x21
[  173.409414]  [<ffffffff810a31db>] ? write_cache_pages+0x206/0x2f8
[  173.409509]  [<ffffffff810a2829>] ? set_page_dirty+0x5e/0x5e
[  173.409604]  [<ffffffff81297cfb>] ? queue_unplugged+0x28/0x34
[  173.409698]  [<ffffffff810a330b>] ? generic_writepages+0x3e/0x55
[  173.409793]  [<ffffffff810f4eb0>] ? __writeback_single_inode+0x39/0xd1
[  173.409889]  [<ffffffff810f5c69>] ? writeback_sb_inodes+0x206/0x392
[  173.409983]  [<ffffffff810f5e5c>] ? __writeback_inodes_wb+0x67/0xa2
[  173.410079]  [<ffffffff810f5ffa>] ? wb_writeback+0xfd/0x18b
[  173.410172]  [<ffffffff810a36d1>] ? bdi_dirty_limit+0x27/0x81
[  173.410348]  [<ffffffff810f61c5>] ? wb_do_writeback+0x13d/0x1a2
[  173.410461]  [<ffffffff81061e9b>] ? add_timer_on+0x61/0x61
[  173.410584]  [<ffffffff810f62a9>] ? bdi_writeback_thread+0x7f/0x13e
[  173.410700]  [<ffffffff8106a54d>] ? queue_work_on+0x16/0x1e
[  173.410809]  [<ffffffff810f622a>] ? wb_do_writeback+0x1a2/0x1a2
[  173.410902]  [<ffffffff810f622a>] ? wb_do_writeback+0x1a2/0x1a2
[  173.410996]  [<ffffffff8106e134>] ? kthread+0x81/0x89
[  173.411089]  [<ffffffff81607e74>] ? kernel_thread_helper+0x4/0x10
[  173.411184]  [<ffffffff8106e0b3>] ? kthread_worker_fn+0xe0/0xe0
[  173.411277]  [<ffffffff81607e70>] ? gs_change+0xb/0xb
[  173.411367] ---[ end trace 8243403b245b6cfc ]---

-- 
Fabio
