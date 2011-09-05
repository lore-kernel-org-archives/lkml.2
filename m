Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754155Ab1IEOSD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 10:18:03 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42089 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753912Ab1IEOSA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 10:18:00 -0400
Date: Mon, 5 Sep 2011 16:17:53 +0200
From: Jan Kara <jack@suse.cz>
To: Harald Dunkel <harri@afaics.de>
Cc: Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: filesystem access vs 120 seconds timeouts
Message-ID: <20110905141753.GG5466@quack.suse.cz>
References: <4E4F5AC8.3060302@afaics.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E4F5AC8.3060302@afaics.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hello,

On Sat 20-08-11 08:57:12, Harald Dunkel wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> on huge disk IO operations I get something like this from time
> to time:
> 
> [ 6220.508495] INFO: task jbd2/sdb3-8:1616 blocked for more than 120 seconds.
> [ 6220.540831] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [ 6220.573046] jbd2/sdb3-8     D 0000000000000000     0  1616      2 0x00000000
> [ 6220.573053]  ffff88021216e050 0000000000000046 ffff8801eab35a40 0000000000000000
> [ 6220.573058]  ffffffff81401020 ffff8802121bbfd8 0000000000010300 0000000000004000
> [ 6220.573063]  ffff8802106cbac0 ffff8802106cba70 ffff88020ec1c000 ffffffff81136cc1
> [ 6220.573069] Call Trace:
> [ 6220.573078]  [<ffffffff81136cc1>] ? cfq_add_rq_rb+0xb6/0xc7
> [ 6220.573085]  [<ffffffff8113a973>] ? kobject_get+0x12/0x17
> [ 6220.573093]  [<ffffffff811cf573>] ? scsi_request_fn+0x374/0x44f
> [ 6220.573100]  [<ffffffff81083800>] ? find_get_page+0x4a/0x76
> [ 6220.573105]  [<ffffffff810838f8>] ? __lock_page+0x66/0x66
> [ 6220.573111]  [<ffffffff812a97aa>] ? io_schedule+0x4b/0x5d
> [ 6220.573116]  [<ffffffff810838fe>] ? sleep_on_page+0x6/0xa
> [ 6220.573121]  [<ffffffff812a9c8e>] ? __wait_on_bit+0x3e/0x71
> [ 6220.573127]  [<ffffffff81083a54>] ? wait_on_page_bit+0x6e/0x73
> [ 6220.573133]  [<ffffffff8104960b>] ? autoremove_wake_function+0x2a/0x2a
> [ 6220.573138]  [<ffffffff81083b04>] ? filemap_fdatawait_range+0x73/0x121
> [ 6220.573155]  [<ffffffff81129921>] ? submit_bio+0xb3/0xbc
> [ 6220.573166]  [<ffffffffa017aabb>] ? jbd2_journal_commit_transaction+0x75f/0xf84 [jbd2]
> [ 6220.573170]  [<ffffffff8103d6b7>] ? lock_timer_base.isra.25+0x22/0x47
> [ 6220.573174]  [<ffffffffa017d70c>] ? kjournald2+0xc0/0x20a [jbd2]
> [ 6220.573177]  [<ffffffff810495e1>] ? abort_exclusive_wait+0x79/0x79
> [ 6220.573181]  [<ffffffffa017d64c>] ? commit_timeout+0x5/0x5 [jbd2]
> [ 6220.573184]  [<ffffffff81049016>] ? kthread+0x76/0x7e
> [ 6220.573187]  [<ffffffff812ac814>] ? kernel_thread_helper+0x4/0x10
> [ 6220.573190]  [<ffffffff81048fa0>] ? kthread_worker_fn+0x139/0x139
> [ 6220.573192]  [<ffffffff812ac810>] ? gs_change+0xb/0xb
> 
> 
> Is the timeout of 120 seconds still reasonable? Should I simply switch
> off the message, as suggested?
  Hmm, yeah. The warning is in fact saying that some process blocked for
more than 120s on some lock. Usually that indicates that something went
really wrong but there are some cases like waiting for IO where it can
simply take so long for IO to finish when the load is big enough... So if
these messages annoy you, just switch the warning off.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
