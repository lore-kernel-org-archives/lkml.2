Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755105Ab0KZQ5D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 11:57:03 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:62773 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753501Ab0KZQ47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 11:56:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:message-id;
        b=u3bog5vCz0M04RvpUoweEXXYuAUZPcaQY3oxlSiOMzQPOib+jgolDJ42hRTGne5rpe
         IwlmpwX4j39psDJiUzDsdpHPn+ZkuWakTbLor6G8c2uEUPm+1UQSSsVqvhrg6SaiewvL
         iDgIbuT7MGfJzJExLf9HEulq7hlJxRtJcQ4fU=
From: Bastien ROUCARIES <roucaries.bastien@gmail.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: Reiserfs deadlock in  2.6.36
Date: Fri, 26 Nov 2010 17:57:05 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.36-trunk-amd64; KDE/4.4.5; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <201011181650.00152.roucaries.bastien@gmail.com> <20101118163048.GE5374@nowhere>
In-Reply-To: <20101118163048.GE5374@nowhere>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_kb+7MiQ6ZyKd7vZ"
Message-Id: <201011261757.08303.roucaries.bastien@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_kb+7MiQ6ZyKd7vZ
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit

Dear frederic,
> Hi Bastien,
> 
> This really looks like a hung task detector report.
> Several tasks are stuck in queue_log_writer(), waiting
> to be woken up on the "journal->j_join_wait" event and
> that never happens because the waker is also stuck.
> The problem is your report doesn't show where the waker
> is stuck, but the hung task detector reports it, it just
> did before or after the chunk you've posted.
> 
> If you could provide me the entire report, I could fix this
> easily.

I have manged to reproduce it after six hour of stress. Unfornatly locked was 
disabled due to a known non bug, in the init sequence. I have used sysrq -t in 
order to get more information to you.

Do I need to try to reproduce it, with a newer kernel ? Or it is sufficient ?

--Boundary-00=_kb+7MiQ6ZyKd7vZ
Content-Type: text/plain;
  charset="UTF-8";
  name="messages"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="messages"

Nov 26 16:27:56 portablebastien kernel: [27960.775903] kded4         D 00000001006907a6     0  2852      1 0x00000000
Nov 26 16:27:56 portablebastien kernel: [27960.777842]  ffff8800d8a97b28 0000000000000046 ffff880000000000 ffff880100000000
Nov 26 16:27:56 portablebastien kernel: [27960.779768]  ffff8800d8a96010 ffff8800d8a97fd8 ffff8800379f4f60 ffff8800379f5230
Nov 26 16:27:56 portablebastien kernel: [27960.781694]  ffff8800379f5228 0000000000014d80 0000000000014d80 ffff8800d8a97fd8
Nov 26 16:27:56 portablebastien kernel: [27960.783594] Call Trace:
Nov 26 16:27:56 portablebastien kernel: [27960.785483]  [<ffffffffa01b8454>] queue_log_writer+0x7e/0xaf [reiserfs]
Nov 26 16:27:56 portablebastien kernel: [27960.787344]  [<ffffffff81044423>] ? default_wake_function+0x0/0xf
Nov 26 16:27:56 portablebastien kernel: [27960.789253]  [<ffffffffa01bc402>] do_journal_begin_r+0x1ee/0x2d8 [reiserfs]
Nov 26 16:27:56 portablebastien kernel: [27960.791142]  [<ffffffffa01bc5ae>] journal_begin+0xc2/0x103 [reiserfs]
Nov 26 16:27:56 portablebastien kernel: [27960.793070]  [<ffffffffa019ebb6>] reiserfs_create+0x105/0x233 [reiserfs]
Nov 26 16:27:56 portablebastien kernel: [27960.794960]  [<ffffffff8110b57d>] ? generic_permission+0x17/0x9a
Nov 26 16:27:56 portablebastien kernel: [27960.796854]  [<ffffffff81171e65>] ? security_inode_permission+0x1c/0x1e
Nov 26 16:27:56 portablebastien kernel: [27960.798714]  [<ffffffff8110c423>] vfs_create+0x6b/0x8d
Nov 26 16:27:56 portablebastien kernel: [27960.800570]  [<ffffffff8110cdee>] do_last+0x26c/0x532
Nov 26 16:27:56 portablebastien kernel: [27960.802377]  [<ffffffff8110eb96>] do_filp_open+0x203/0x599
Nov 26 16:27:56 portablebastien kernel: [27960.804232]  [<ffffffff8134bd2b>] ? _raw_spin_unlock+0x26/0x2a
Nov 26 16:27:56 portablebastien kernel: [27960.806058]  [<ffffffff811184a0>] ? alloc_fd+0x170/0x182
Nov 26 16:27:56 portablebastien kernel: [27960.807911]  [<ffffffff81101366>] do_sys_open+0x5b/0xf7
Nov 26 16:27:56 portablebastien kernel: [27960.809790]  [<ffffffff8134b48e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
Nov 26 16:27:56 portablebastien kernel: [27960.811646]  [<ffffffff8110142b>] sys_open+0x1b/0x1d
Nov 26 16:27:56 portablebastien kernel: [27960.813506]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Nov 26 16:27:56 portablebastien kernel: [27960.815332] INFO: lockdep is turned off.
Nov 26 16:27:56 portablebastien kernel: [27960.819440] kwin          D 000000010068fd60     0  2903   2901 0x00000000
Nov 26 16:27:56 portablebastien kernel: [27960.820758]  ffff8800d8a13a98 0000000000000046 ffff880000000000 ffff88011da21628
Nov 26 16:27:56 portablebastien kernel: [27960.822077]  ffff8800d8a12010 ffff8800d8a13fd8 ffff8800d8b92fa0 ffff8800d8b93270
Nov 26 16:27:56 portablebastien kernel: [27960.823393]  ffff8800d8b93268 0000000000014d80 0000000000014d80 ffff8800d8a13fd8
Nov 26 16:27:56 portablebastien kernel: [27960.824744] Call Trace:
Nov 26 16:27:56 portablebastien kernel: [27960.826077]  [<ffffffffa01b8454>] queue_log_writer+0x7e/0xaf [reiserfs]
Nov 26 16:27:56 portablebastien kernel: [27960.827410]  [<ffffffff81044423>] ? default_wake_function+0x0/0xf
Nov 26 16:27:56 portablebastien kernel: [27960.828734]  [<ffffffffa01bc402>] do_journal_begin_r+0x1ee/0x2d8 [reiserfs]
Nov 26 16:27:56 portablebastien kernel: [27960.830039]  [<ffffffffa01bc5ae>] journal_begin+0xc2/0x103 [reiserfs]
Nov 26 16:27:56 portablebastien kernel: [27960.831336]  [<ffffffffa01aa4f6>] reiserfs_dirty_inode+0x5f/0xa0 [reiserfs]
Nov 26 16:27:56 portablebastien kernel: [27960.832627]  [<ffffffffa01c13f8>] ? security_get+0x41/0x43 [reiserfs]
Nov 26 16:27:56 portablebastien kernel: [27960.833883]  [<ffffffff81120c34>] __mark_inode_dirty+0x2f/0x1d2
Nov 26 16:27:56 portablebastien kernel: [27960.835140]  [<ffffffff81115c82>] file_update_time+0x104/0x128
Nov 26 16:27:56 portablebastien kernel: [27960.836391]  [<ffffffff810c3614>] __generic_file_aio_write+0x162/0x27f
Nov 26 16:27:56 portablebastien kernel: [27960.837608]  [<ffffffff810c378b>] generic_file_aio_write+0x5a/0xa8
Nov 26 16:27:56 portablebastien kernel: [27960.838880]  [<ffffffff81102886>] do_sync_write+0xc6/0x103
Nov 26 16:27:56 portablebastien kernel: [27960.840159]  [<ffffffff81102989>] ? do_sync_read+0xc6/0x103
Nov 26 16:27:56 portablebastien kernel: [27960.841454]  [<ffffffff811721aa>] ? fsnotify_perm+0x45/0x4b
Nov 26 16:27:56 portablebastien kernel: [27960.842785]  [<ffffffff81172207>] ? security_file_permission+0x29/0x2e
Nov 26 16:27:56 portablebastien kernel: [27960.844158]  [<ffffffffa01a3fb2>] reiserfs_file_write+0x48/0x4a [reiserfs]
Nov 26 16:27:56 portablebastien kernel: [27960.845520]  [<ffffffff81102deb>] vfs_write+0xa9/0x105
Nov 26 16:27:56 portablebastien kernel: [27960.846903]  [<ffffffff81102efd>] sys_write+0x45/0x69
Nov 26 16:27:56 portablebastien kernel: [27960.848269]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Nov 26 16:27:56 portablebastien kernel: [27960.849603] INFO: lockdep is turned off.
Nov 26 16:27:56 portablebastien kernel: [27960.853657] kglobalaccel  D 000000010068fef4     0  2905      1 0x00000000
Nov 26 16:27:56 portablebastien kernel: [27960.855016]  ffff8800d59afcc8 0000000000000046 fffffff500000001 0000000000000001
Nov 26 16:27:56 portablebastien kernel: [27960.856416]  ffff8800d59ae010 ffff8800d59affd8 ffff8800d8b96f20 ffff8800d8b971f0
Nov 26 16:27:56 portablebastien kernel: [27960.857786]  ffff8800d8b971e8 0000000000014d80 0000000000014d80 ffff8800d59affd8
Nov 26 16:27:56 portablebastien kernel: [27960.859156] Call Trace:
Nov 26 16:27:56 portablebastien kernel: [27960.860536]  [<ffffffff810c3778>] ? generic_file_aio_write+0x47/0xa8
Nov 26 16:27:56 portablebastien kernel: [27960.861899]  [<ffffffff8134a6ca>] __mutex_lock_common+0x23a/0x36f
Nov 26 16:27:56 portablebastien kernel: [27960.863242]  [<ffffffff810c3778>] ? generic_file_aio_write+0x47/0xa8
Nov 26 16:27:56 portablebastien kernel: [27960.864626]  [<ffffffff8134a8b4>] mutex_lock_nested+0x39/0x3e
Nov 26 16:27:56 portablebastien kernel: [27960.865967]  [<ffffffff810c3778>] generic_file_aio_write+0x47/0xa8
Nov 26 16:27:56 portablebastien kernel: [27960.867317]  [<ffffffff81102886>] do_sync_write+0xc6/0x103
Nov 26 16:27:56 portablebastien kernel: [27960.868688]  [<ffffffff81102989>] ? do_sync_read+0xc6/0x103
Nov 26 16:27:56 portablebastien kernel: [27960.870079]  [<ffffffff811721aa>] ? fsnotify_perm+0x45/0x4b
Nov 26 16:27:56 portablebastien kernel: [27960.871468]  [<ffffffff81172207>] ? security_file_permission+0x29/0x2e
Nov 26 16:27:56 portablebastien kernel: [27960.872854]  [<ffffffffa01a3fb2>] reiserfs_file_write+0x48/0x4a [reiserfs]
Nov 26 16:27:56 portablebastien kernel: [27960.874255]  [<ffffffff81102deb>] vfs_write+0xa9/0x105
Nov 26 16:27:56 portablebastien kernel: [27960.875620]  [<ffffffff81102efd>] sys_write+0x45/0x69
Nov 26 16:27:56 portablebastien kernel: [27960.876991]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Nov 26 16:27:56 portablebastien kernel: [27960.878355] INFO: lockdep is turned off.
Nov 26 16:27:56 portablebastien kernel: [27960.882547] akregator     D ffffc90005743178     0  2976      1 0x00000000
Nov 26 16:27:56 portablebastien kernel: [27960.883963]  ffff8800c7319ae8 0000000000000046 ffff880000000000 ffff88011da21628
Nov 26 16:27:56 portablebastien kernel: [27960.885361]  ffff8800c7318010 ffff8800c7319fd8 ffff8800c708df40 ffff8800c708e210
Nov 26 16:27:56 portablebastien kernel: [27960.886751]  ffff8800c708e208 0000000000014d80 0000000000014d80 ffff8800c7319fd8
Nov 26 16:27:56 portablebastien kernel: [27960.888166] Call Trace:
Nov 26 16:27:56 portablebastien kernel: [27960.889537]  [<ffffffffa01b8454>] queue_log_writer+0x7e/0xaf [reiserfs]
Nov 26 16:27:56 portablebastien kernel: [27960.890897]  [<ffffffff81044423>] ? default_wake_function+0x0/0xf
Nov 26 16:27:56 portablebastien kernel: [27960.892319]  [<ffffffffa01bc402>] do_journal_begin_r+0x1ee/0x2d8 [reiserfs]
Nov 26 16:27:56 portablebastien kernel: [27960.893721]  [<ffffffffa01bc5ae>] journal_begin+0xc2/0x103 [reiserfs]
Nov 26 16:27:56 portablebastien kernel: [27960.895105]  [<ffffffffa01aa4f6>] reiserfs_dirty_inode+0x5f/0xa0 [reiserfs]
Nov 26 16:27:56 portablebastien kernel: [27960.896497]  [<ffffffff81120c34>] __mark_inode_dirty+0x2f/0x1d2
Nov 26 16:27:56 portablebastien kernel: [27960.897858]  [<ffffffff81115da8>] touch_atime+0x102/0x125
Nov 26 16:27:56 portablebastien kernel: [27960.899252]  [<ffffffff810c4559>] generic_file_aio_read+0x562/0x5b7
Nov 26 16:27:56 portablebastien kernel: [27960.900650]  [<ffffffff81102989>] do_sync_read+0xc6/0x103
Nov 26 16:27:56 portablebastien kernel: [27960.902014]  [<ffffffff811721aa>] ? fsnotify_perm+0x45/0x4b
Nov 26 16:27:56 portablebastien kernel: [27960.903381]  [<ffffffff81172207>] ? security_file_permission+0x29/0x2e
Nov 26 16:27:56 portablebastien kernel: [27960.904761]  [<ffffffff81102fc7>] vfs_read+0xa6/0x102
Nov 26 16:27:56 portablebastien kernel: [27960.906126]  [<ffffffff81103aa5>] ? fget_light+0x41/0xcf
Nov 26 16:27:56 portablebastien kernel: [27960.907488]  [<ffffffff811030d9>] sys_read+0x45/0x69
Nov 26 16:27:56 portablebastien kernel: [27960.908898]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Nov 26 16:27:56 portablebastien kernel: [27960.910273] INFO: lockdep is turned off.
Nov 26 16:27:56 portablebastien kernel: [27960.914512] sync          D 0000000100690737     0  2904   2740 0x00000000
Nov 26 16:27:56 portablebastien kernel: [27960.915926]  ffff880016103d48 0000000000000046 ffff880000000000 ffff880100000000
Nov 26 16:27:56 portablebastien kernel: [27960.917365]  ffff880016102010 ffff880016103fd8 ffff8800b7d49fc0 ffff8800b7d4a290
Nov 26 16:27:56 portablebastien kernel: [27960.918792]  ffff8800b7d4a288 0000000000014d80 0000000000014d80 ffff880016103fd8
Nov 26 16:27:56 portablebastien kernel: [27960.920250] Call Trace:
Nov 26 16:27:56 portablebastien kernel: [27960.921624]  [<ffffffffa01b8454>] queue_log_writer+0x7e/0xaf [reiserfs]
Nov 26 16:27:56 portablebastien kernel: [27960.923039]  [<ffffffff81044423>] ? default_wake_function+0x0/0xf
Nov 26 16:27:56 portablebastien kernel: [27960.924491]  [<ffffffffa01bc402>] do_journal_begin_r+0x1ee/0x2d8 [reiserfs]
Nov 26 16:27:56 portablebastien kernel: [27960.925870]  [<ffffffff8112475f>] ? sync_one_sb+0x0/0x1d
Nov 26 16:27:56 portablebastien kernel: [27960.927269]  [<ffffffffa01bc5ae>] journal_begin+0xc2/0x103 [reiserfs]
Nov 26 16:27:56 portablebastien kernel: [27960.928681]  [<ffffffffa01aa450>] reiserfs_sync_fs+0x27/0x5e [reiserfs]
Nov 26 16:27:56 portablebastien kernel: [27960.930052]  [<ffffffff81124747>] __sync_filesystem+0x66/0x7e
Nov 26 16:27:56 portablebastien kernel: [27960.931426]  [<ffffffff8112477a>] sync_one_sb+0x1b/0x1d
Nov 26 16:27:56 portablebastien kernel: [27960.932823]  [<ffffffff81104bdd>] iterate_supers+0x6d/0xc8
Nov 26 16:27:56 portablebastien kernel: [27960.934204]  [<ffffffff811247a6>] sys_sync+0x2a/0x57
Nov 26 16:27:56 portablebastien kernel: [27960.935608]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Nov 26 16:27:56 portablebastien kernel: [27960.937030] INFO: lockdep is turned off.
Nov 26 16:29:56 portablebastien kernel: [28080.939430] kded4         D 00000001006907a6     0  2852      1 0x00000000
Nov 26 16:29:56 portablebastien kernel: [28080.941182]  ffff8800d8a97b28 0000000000000046 ffff880000000000 ffff880100000000
Nov 26 16:29:56 portablebastien kernel: [28080.942953]  ffff8800d8a96010 ffff8800d8a97fd8 ffff8800379f4f60 ffff8800379f5230
Nov 26 16:29:56 portablebastien kernel: [28080.944794]  ffff8800379f5228 0000000000014d80 0000000000014d80 ffff8800d8a97fd8
Nov 26 16:29:56 portablebastien kernel: [28080.946608] Call Trace:
Nov 26 16:29:56 portablebastien kernel: [28080.948427]  [<ffffffffa01b8454>] queue_log_writer+0x7e/0xaf [reiserfs]
Nov 26 16:29:56 portablebastien kernel: [28080.950283]  [<ffffffff81044423>] ? default_wake_function+0x0/0xf
Nov 26 16:29:56 portablebastien kernel: [28080.952188]  [<ffffffffa01bc402>] do_journal_begin_r+0x1ee/0x2d8 [reiserfs]
Nov 26 16:29:56 portablebastien kernel: [28080.952208]  [<ffffffffa01bc5ae>] journal_begin+0xc2/0x103 [reiserfs]
Nov 26 16:29:56 portablebastien kernel: [28080.952223]  [<ffffffffa019ebb6>] reiserfs_create+0x105/0x233 [reiserfs]
Nov 26 16:29:56 portablebastien kernel: [28080.952230]  [<ffffffff8110b57d>] ? generic_permission+0x17/0x9a
Nov 26 16:29:56 portablebastien kernel: [28080.952238]  [<ffffffff81171e65>] ? security_inode_permission+0x1c/0x1e
Nov 26 16:29:56 portablebastien kernel: [28080.952244]  [<ffffffff8110c423>] vfs_create+0x6b/0x8d
Nov 26 16:29:56 portablebastien kernel: [28080.952250]  [<ffffffff8110cdee>] do_last+0x26c/0x532
Nov 26 16:29:56 portablebastien kernel: [28080.952255]  [<ffffffff8110eb96>] do_filp_open+0x203/0x599
Nov 26 16:29:56 portablebastien kernel: [28080.952263]  [<ffffffff8134bd2b>] ? _raw_spin_unlock+0x26/0x2a
Nov 26 16:29:56 portablebastien kernel: [28080.952269]  [<ffffffff811184a0>] ? alloc_fd+0x170/0x182
Nov 26 16:29:56 portablebastien kernel: [28080.952275]  [<ffffffff81101366>] do_sys_open+0x5b/0xf7
Nov 26 16:29:56 portablebastien kernel: [28080.952281]  [<ffffffff8134b48e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
Nov 26 16:29:56 portablebastien kernel: [28080.952286]  [<ffffffff8110142b>] sys_open+0x1b/0x1d
Nov 26 16:29:56 portablebastien kernel: [28080.952292]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Nov 26 16:29:56 portablebastien kernel: [28080.952296] INFO: lockdep is turned off.
Nov 26 16:29:56 portablebastien kernel: [28080.952308] kwin          D 000000010068fd60     0  2903   2901 0x00000000
Nov 26 16:29:56 portablebastien kernel: [28080.952314]  ffff8800d8a13a98 0000000000000046 ffff880000000000 ffff88011da21628
Nov 26 16:29:56 portablebastien kernel: [28080.952321]  ffff8800d8a12010 ffff8800d8a13fd8 ffff8800d8b92fa0 ffff8800d8b93270
Nov 26 16:29:56 portablebastien kernel: [28080.952328]  ffff8800d8b93268 0000000000014d80 0000000000014d80 ffff8800d8a13fd8
Nov 26 16:29:56 portablebastien kernel: [28080.952334] Call Trace:
Nov 26 16:29:56 portablebastien kernel: [28080.952354]  [<ffffffffa01b8454>] queue_log_writer+0x7e/0xaf [reiserfs]
Nov 26 16:29:56 portablebastien kernel: [28080.952361]  [<ffffffff81044423>] ? default_wake_function+0x0/0xf
Nov 26 16:29:56 portablebastien kernel: [28080.952380]  [<ffffffffa01bc402>] do_journal_begin_r+0x1ee/0x2d8 [reiserfs]
Nov 26 16:29:56 portablebastien kernel: [28080.952399]  [<ffffffffa01bc5ae>] journal_begin+0xc2/0x103 [reiserfs]
Nov 26 16:29:56 portablebastien kernel: [28080.952417]  [<ffffffffa01aa4f6>] reiserfs_dirty_inode+0x5f/0xa0 [reiserfs]
Nov 26 16:29:56 portablebastien kernel: [28080.952436]  [<ffffffffa01c13f8>] ? security_get+0x41/0x43 [reiserfs]
Nov 26 16:29:56 portablebastien kernel: [28080.952442]  [<ffffffff81120c34>] __mark_inode_dirty+0x2f/0x1d2
Nov 26 16:29:56 portablebastien kernel: [28080.952448]  [<ffffffff81115c82>] file_update_time+0x104/0x128
Nov 26 16:29:56 portablebastien kernel: [28080.952456]  [<ffffffff810c3614>] __generic_file_aio_write+0x162/0x27f
Nov 26 16:29:56 portablebastien kernel: [28080.952462]  [<ffffffff810c378b>] generic_file_aio_write+0x5a/0xa8
Nov 26 16:29:56 portablebastien kernel: [28080.952468]  [<ffffffff81102886>] do_sync_write+0xc6/0x103
Nov 26 16:29:56 portablebastien kernel: [28080.952473]  [<ffffffff81102989>] ? do_sync_read+0xc6/0x103
Nov 26 16:29:56 portablebastien kernel: [28080.952479]  [<ffffffff811721aa>] ? fsnotify_perm+0x45/0x4b
Nov 26 16:29:56 portablebastien kernel: [28080.952484]  [<ffffffff81172207>] ? security_file_permission+0x29/0x2e
Nov 26 16:29:56 portablebastien kernel: [28080.952501]  [<ffffffffa01a3fb2>] reiserfs_file_write+0x48/0x4a [reiserfs]
Nov 26 16:29:56 portablebastien kernel: [28080.952507]  [<ffffffff81102deb>] vfs_write+0xa9/0x105
Nov 26 16:29:56 portablebastien kernel: [28080.952512]  [<ffffffff81102efd>] sys_write+0x45/0x69
Nov 26 16:29:56 portablebastien kernel: [28080.952518]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Nov 26 16:29:56 portablebastien kernel: [28080.952521] INFO: lockdep is turned off.
Nov 26 16:29:56 portablebastien kernel: [28080.952532] kglobalaccel  D 000000010068fef4     0  2905      1 0x00000000
Nov 26 16:29:56 portablebastien kernel: [28080.952538]  ffff8800d59afcc8 0000000000000046 fffffff500000001 0000000000000001
Nov 26 16:29:56 portablebastien kernel: [28080.952545]  ffff8800d59ae010 ffff8800d59affd8 ffff8800d8b96f20 ffff8800d8b971f0
Nov 26 16:29:56 portablebastien kernel: [28080.952552]  ffff8800d8b971e8 0000000000014d80 0000000000014d80 ffff8800d59affd8
Nov 26 16:29:56 portablebastien kernel: [28080.952558] Call Trace:
Nov 26 16:29:56 portablebastien kernel: [28080.952565]  [<ffffffff810c3778>] ? generic_file_aio_write+0x47/0xa8
Nov 26 16:29:56 portablebastien kernel: [28080.952571]  [<ffffffff8134a6ca>] __mutex_lock_common+0x23a/0x36f
Nov 26 16:29:56 portablebastien kernel: [28080.952577]  [<ffffffff810c3778>] ? generic_file_aio_write+0x47/0xa8
Nov 26 16:29:56 portablebastien kernel: [28080.952582]  [<ffffffff8134a8b4>] mutex_lock_nested+0x39/0x3e
Nov 26 16:29:56 portablebastien kernel: [28080.952588]  [<ffffffff810c3778>] generic_file_aio_write+0x47/0xa8
Nov 26 16:29:56 portablebastien kernel: [28080.952593]  [<ffffffff81102886>] do_sync_write+0xc6/0x103
Nov 26 16:29:56 portablebastien kernel: [28080.952598]  [<ffffffff81102989>] ? do_sync_read+0xc6/0x103
Nov 26 16:29:56 portablebastien kernel: [28080.952604]  [<ffffffff811721aa>] ? fsnotify_perm+0x45/0x4b
Nov 26 16:29:56 portablebastien kernel: [28080.952609]  [<ffffffff81172207>] ? security_file_permission+0x29/0x2e
Nov 26 16:29:56 portablebastien kernel: [28080.952626]  [<ffffffffa01a3fb2>] reiserfs_file_write+0x48/0x4a [reiserfs]
Nov 26 16:29:56 portablebastien kernel: [28080.952631]  [<ffffffff81102deb>] vfs_write+0xa9/0x105
Nov 26 16:29:56 portablebastien kernel: [28080.952637]  [<ffffffff81102efd>] sys_write+0x45/0x69
Nov 26 16:29:56 portablebastien kernel: [28080.952643]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Nov 26 16:29:56 portablebastien kernel: [28080.952646] INFO: lockdep is turned off.
Nov 26 16:29:56 portablebastien kernel: [28080.952665] kalarm        D 00000001006914db     0  2974      1 0x00000000
Nov 26 16:29:56 portablebastien kernel: [28080.952672]  ffff8800cddafcc8 0000000000000046 fffffff500000001 0000000000000000
Nov 26 16:29:56 portablebastien kernel: [28080.952679]  ffff8800cddae010 ffff8800cddaffd8 ffff8800d59fafa0 ffff8800d59fb270
Nov 26 16:29:56 portablebastien kernel: [28080.952685]  ffff8800d59fb268 0000000000014d80 0000000000014d80 ffff8800cddaffd8
Nov 26 16:29:56 portablebastien kernel: [28080.952692] Call Trace:
Nov 26 16:29:56 portablebastien kernel: [28080.952699]  [<ffffffff810c3778>] ? generic_file_aio_write+0x47/0xa8
Nov 26 16:29:56 portablebastien kernel: [28080.952705]  [<ffffffff8134a6ca>] __mutex_lock_common+0x23a/0x36f
Nov 26 16:29:56 portablebastien kernel: [28080.952711]  [<ffffffff810c3778>] ? generic_file_aio_write+0x47/0xa8
Nov 26 16:29:56 portablebastien kernel: [28080.952716]  [<ffffffff8134a8b4>] mutex_lock_nested+0x39/0x3e
Nov 26 16:29:56 portablebastien kernel: [28080.952722]  [<ffffffff810c3778>] generic_file_aio_write+0x47/0xa8
Nov 26 16:29:56 portablebastien kernel: [28080.952728]  [<ffffffff81102886>] do_sync_write+0xc6/0x103
Nov 26 16:29:56 portablebastien kernel: [28080.952733]  [<ffffffff81102989>] ? do_sync_read+0xc6/0x103
Nov 26 16:29:56 portablebastien kernel: [28080.952739]  [<ffffffff81103aa5>] ? fget_light+0x41/0xcf
Nov 26 16:29:56 portablebastien kernel: [28080.952744]  [<ffffffff81103aa5>] ? fget_light+0x41/0xcf
Nov 26 16:29:56 portablebastien kernel: [28080.952749]  [<ffffffff811721aa>] ? fsnotify_perm+0x45/0x4b
Nov 26 16:29:56 portablebastien kernel: [28080.952754]  [<ffffffff81172207>] ? security_file_permission+0x29/0x2e
Nov 26 16:29:56 portablebastien kernel: [28080.952771]  [<ffffffffa01a3fb2>] reiserfs_file_write+0x48/0x4a [reiserfs]
Nov 26 16:29:56 portablebastien kernel: [28080.952777]  [<ffffffff81102deb>] vfs_write+0xa9/0x105
Nov 26 16:29:56 portablebastien kernel: [28080.952782]  [<ffffffff81103aa5>] ? fget_light+0x41/0xcf
Nov 26 16:29:56 portablebastien kernel: [28080.952787]  [<ffffffff81102efd>] sys_write+0x45/0x69
Nov 26 16:29:56 portablebastien kernel: [28080.952793]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Nov 26 16:29:56 portablebastien kernel: [28080.952796] INFO: lockdep is turned off.
Nov 26 16:29:56 portablebastien kernel: [28080.952807] akregator     D ffffc90005743178     0  2976      1 0x00000000
Nov 26 16:29:56 portablebastien kernel: [28080.952813]  ffff8800c7319ae8 0000000000000046 ffff880000000000 ffff88011da21628
Nov 26 16:29:56 portablebastien kernel: [28080.952820]  ffff8800c7318010 ffff8800c7319fd8 ffff8800c708df40 ffff8800c708e210
Nov 26 16:29:56 portablebastien kernel: [28080.952827]  ffff8800c708e208 0000000000014d80 0000000000014d80 ffff8800c7319fd8
Nov 26 16:29:56 portablebastien kernel: [28080.952834] Call Trace:
Nov 26 16:29:56 portablebastien kernel: [28080.952853]  [<ffffffffa01b8454>] queue_log_writer+0x7e/0xaf [reiserfs]
Nov 26 16:29:56 portablebastien kernel: [28080.952859]  [<ffffffff81044423>] ? default_wake_function+0x0/0xf
Nov 26 16:29:56 portablebastien kernel: [28080.952878]  [<ffffffffa01bc402>] do_journal_begin_r+0x1ee/0x2d8 [reiserfs]
Nov 26 16:29:56 portablebastien kernel: [28080.952897]  [<ffffffffa01bc5ae>] journal_begin+0xc2/0x103 [reiserfs]
Nov 26 16:29:56 portablebastien kernel: [28080.952914]  [<ffffffffa01aa4f6>] reiserfs_dirty_inode+0x5f/0xa0 [reiserfs]
Nov 26 16:29:56 portablebastien kernel: [28080.952921]  [<ffffffff81120c34>] __mark_inode_dirty+0x2f/0x1d2
Nov 26 16:29:56 portablebastien kernel: [28080.952926]  [<ffffffff81115da8>] touch_atime+0x102/0x125
Nov 26 16:29:56 portablebastien kernel: [28080.952932]  [<ffffffff810c4559>] generic_file_aio_read+0x562/0x5b7
Nov 26 16:29:56 portablebastien kernel: [28080.952938]  [<ffffffff81102989>] do_sync_read+0xc6/0x103
Nov 26 16:29:56 portablebastien kernel: [28080.952943]  [<ffffffff811721aa>] ? fsnotify_perm+0x45/0x4b
Nov 26 16:29:56 portablebastien kernel: [28080.952949]  [<ffffffff81172207>] ? security_file_permission+0x29/0x2e
Nov 26 16:29:56 portablebastien kernel: [28080.952954]  [<ffffffff81102fc7>] vfs_read+0xa6/0x102
Nov 26 16:29:56 portablebastien kernel: [28080.952959]  [<ffffffff81103aa5>] ? fget_light+0x41/0xcf
Nov 26 16:29:56 portablebastien kernel: [28080.952965]  [<ffffffff811030d9>] sys_read+0x45/0x69
Nov 26 16:29:56 portablebastien kernel: [28080.952970]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Nov 26 16:29:56 portablebastien kernel: [28080.952974] INFO: lockdep is turned off.
Nov 26 16:35:52 portablebastien kernel: [28436.981211] SysRq : HELP : loglevel(0-9) reBoot Crash show-all-locks(D) terminate-all-tasks(E) memory-full-oom-kill(F) kill-all-tasks(I) thaw-filesystems(J) saK show-backtrace-all-active-cpus(L) show-memory-usage(M) nice-all-RT-tasks(N) powerOff show-registers(P) show-all-timers(Q) unRaw Sync show-task-states(T) Unmount force-fb(V) show-blocked-tasks(W) dump-ftrace-buffer(Z) 
Nov 26 16:36:02 portablebastien kernel: [28446.933408] SysRq : HELP : loglevel(0-9) reBoot Crash show-all-locks(D) terminate-all-tasks(E) memory-full-oom-kill(F) kill-all-tasks(I) thaw-filesystems(J) saK show-backtrace-all-active-cpus(L) show-memory-usage(M) nice-all-RT-tasks(N) powerOff show-registers(P) show-all-timers(Q) unRaw Sync show-task-states(T) Unmount force-fb(V) show-blocked-tasks(W) dump-ftrace-buffer(Z) 
Nov 26 16:36:09 portablebastien kernel: [28453.498898] SysRq : HELP : loglevel(0-9) reBoot Crash show-all-locks(D) terminate-all-tasks(E) memory-full-oom-kill(F) kill-all-tasks(I) thaw-filesystems(J) saK show-backtrace-all-active-cpus(L) show-memory-usage(M) nice-all-RT-tasks(N) powerOff show-registers(P) show-all-timers(Q) unRaw Sync show-task-states(T) Unmount force-fb(V) show-blocked-tasks(W) dump-ftrace-buffer(Z) 
Nov 26 16:36:19 portablebastien kernel: [28463.846331] SysRq : HELP : loglevel(0-9) reBoot Crash show-all-locks(D) terminate-all-tasks(E) memory-full-oom-kill(F) kill-all-tasks(I) thaw-filesystems(J) saK show-backtrace-all-active-cpus(L) show-memory-usage(M) nice-all-RT-tasks(N) powerOff show-registers(P) show-all-timers(Q) unRaw Sync show-task-states(T) Unmount force-fb(V) show-blocked-tasks(W) dump-ftrace-buffer(Z) 
Nov 26 16:36:42 portablebastien kernel: [28486.974483] SysRq : HELP : loglevel(0-9) reBoot Crash show-all-locks(D) terminate-all-tasks(E) memory-full-oom-kill(F) kill-all-tasks(I) thaw-filesystems(J) saK show-backtrace-all-active-cpus(L) show-memory-usage(M) nice-all-RT-tasks(N) powerOff show-registers(P) show-all-timers(Q) unRaw Sync show-task-states(T) Unmount force-fb(V) show-blocked-tasks(W) dump-ftrace-buffer(Z) 
Nov 26 16:36:59 portablebastien kernel: [28504.211450] SysRq : HELP : loglevel(0-9) reBoot Crash show-all-locks(D) terminate-all-tasks(E) memory-full-oom-kill(F) kill-all-tasks(I) thaw-filesystems(J) saK show-backtrace-all-active-cpus(L) show-memory-usage(M) nice-all-RT-tasks(N) powerOff show-registers(P) show-all-timers(Q) unRaw Sync show-task-states(T) Unmount force-fb(V) show-blocked-tasks(W) dump-ftrace-buffer(Z) 
Nov 26 16:37:13 portablebastien kernel: [28518.066669] SysRq : Show Locks Held
Nov 26 16:37:13 portablebastien kernel: [28518.068010] INFO: lockdep is turned off.
Nov 26 16:37:51 portablebastien kernel: +0x51/0x55
Nov 26 16:37:51 portablebastien kernel: [28555.348035]  [<ffffffff81112b3f>] ? d_free+0x32/0x4b
Nov 26 16:37:51 portablebastien kernel: [28555.348035]  [<ffffffff81112c96>] ? d_kill+0x67/0x6f
Nov 26 16:37:51 portablebastien kernel: [28555.348035]  [<ffffffff81103eca>] ? fput+0x1b9/0x1c8
Nov 26 16:37:51 portablebastien kernel: [28555.348035]  [<ffffffff81112588>] sys_poll+0x50/0xbb
Nov 26 16:37:51 portablebastien kernel: [28555.348035]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Nov 26 16:37:51 portablebastien kernel: [28555.348035] kio_file      S 0000000000000000     0 10315   2849 0x00000000
Nov 26 16:37:51 portablebastien kernel: [28555.348035]  ffff8800add93908 0000000000000046 ffff8800add938d8 0000000000000046
Nov 26 16:37:51 portablebastien kernel: [28555.348035]  ffff8800add92010 ffff8800add93fd8 ffff8800b7d1df40 ffff8800b7d1e210
Nov 26 16:37:51 portablebastien kernel: [28555.348035]  ffff8800b7d1e208 0000000000014d80 0000000000014d80 ffff8800add93fd8
Nov 26 16:37:51 portablebastien kernel: [28555.348035] Call Trace:
Nov 26 16:37:51 portablebastien kernel: [28555.348035]  [<ffffffff8134a905>] schedule_hrtimeout_range_clock+0x4c/0x12f
Nov 26 16:37:51 portablebastien kernel: [28555.348035]  [<ffffffff81075039>] ? trace_hardirqs_on+0xd/0xf
Nov 26 16:37:51 portablebastien kernel: [28555.348035]  [<ffffffff81064a5b>] ? add_wait_queue+0x3f/0x44
Nov 26 16:37:51 portablebastien kernel: [28555.348035]  [<ffffffff8134a9f6>] schedule_hrtimeout_range+0xe/0x10
Nov 26 16:37:51 portablebastien kernel: [28555.348035]  [<ffffffff811112e4>] poll_schedule_timeout+0x43/0x5f
Nov 26 16:37:51 portablebastien kernel: [28555.348035]  [<ffffffff81111942>] do_select+0x5b2/0x5ec
Nov 26 16:37:51 portablebastien kernel: [28555.348035]  [<ffffffff81111390>] ? do_select+0x0/0x5ec
Nov 26 16:37:51 portablebastien kernel: [28555.348035]  [<ffffffff8111197c>] ? __pollwait+0x0/0xc7
Nov 26 16:37:51 portablebastien kernel: [28555.348035]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:37:51 portablebastien kernel: [28555.348035]  [<ffffffff8128294c>] ? skb_queue_tail+0x1f/0x48
Nov 26 16:37:51 portablebastien kernel: [28555.348035]  [<ffffffff8127e6d7>] ? rcu_read_lock+0x0/0x30
Nov 26 16:37:51 portablebastien kernel: [28555.348035]  [<ffffffff8127e6d7>] ? rcu_read_lock+0x0/0x30
Nov 26 16:37:51 portablebastien kernel: [28555.348035]  [<ffffffff812f9b03>] ? scm_destroy_cred+0x14/0x40
Nov 26 16:37:51 portablebastien kernel: [28555.348035]  [<ffffffff812f9b40>] ? scm_destroy+0x11/0x2a
Nov 26 16:37:51 portablebastien kernel: [28555.348035]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:37:51 portablebastien kernel: [28555.348035]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:37:51 portablebastien kernel: [28555.348035]  [<ffffffff810d9ec8>] ? might_fault+0xa0/0xa7
Nov 26 16:37:51 portablebastien kernel: [28555.348035]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:37:51 portablebastien kernel: [28555.348035]  [<ffffffff81111d17>] core_sys_select+0x21c/0x2b2
Nov 26 16:37:51 portablebastien kernel: [28555.348035]  [<ffffffff81111b33>] ? core_sys_select+0x38/0x2b2
Nov 26 16:37:51 portablebastien kernel: [28555.348035]  [<ffffffff8112f82a>] ? fsnotify+0x79/0x449
Nov 26 16:37:51 portablebastien kernel: [28555.348035]  [<ffffffff8112fbdb>] ? fsnotify+0x42a/0x449
Nov 26 16:37:51 portablebastien kernel: [28555.348035]  [<ffffffff8112f82a>] ? fsnotify+0x79/0x449
Nov 26 16:37:51 portablebastien kernel: [28555.348035]  [<ffffffff81111fe7>] sys_select+0x91/0xb9
Nov 26 16:37:51 portablebastien kernel: [28555.348035]  [<ffffffff8134b48e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
Nov 26 16:37:51 portablebastien kernel: [28555.348035]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Nov 26 16:37:51 portablebastien kernel: [28555.348035] sd_espeak     S 0000000100174381     0 10681   2085 0x00000000
Nov 26 16:37:51 portablebastien kernel: [28555.348035]  ffff88011e705cd8 0000000000000046 ffff880091b61258 0000000000000000
Nov 26 16:37:51 portablebastien kernel: [28555.348035]  ffff88011e704010 ffff88011e705fd8 ffff880091ae8000 ffff880091ae82d0
Nov 26 16:37:51 portablebastien kernel: [28555.348035]  ffff880091ae82c8 0000000000014d80 0000000000014d80 ffff88011e705fd8
Nov 26 16:37:51 portablebastien kernel: [28555.348035] Call Trace:
Nov 26 16:37:51 portablebastien kernel: [28555.348035]  [<ffffffff8110a1e2>] pipe_wait+0x5e/0x7a
Nov 26 16:37:51 portablebastien kernel: [28555.348035]  [<ffffffff8106473b>] ? autoremove_wake_function+0x0/0x34
Nov 26 16:37:51 portablebastien kernel: [28555.348035]  [<ffffffff8134a8b4>] ? mutex_lock_nested+0x39/0x3e
Nov 26 16:37:51 portablebastien kernel: [28555.348035]  [<ffffffff8110aa62>] pipe_read+0x335/0x3b6
Nov 26 16:37:51 portablebastien kernel: [28555.348035]  [<ffffffff81102989>] do_sync_read+0xc6/0x103
Nov 26 16:37:51 portablebastien kernel: [28555.348035]  [<ffffffff81042616>] ? finish_task_switch+0x0/0xdf
Nov 26 16:37:51 portablebastien kernel: [28555.348035]  [<ffffffff811721aa>] ? fsnotify_perm+0x45/0x4b
Nov 26 16:37:51 portablebastien kernel: [28555.348035]  [<ffffffff81172207>] ? security_file_permission+0x29/0x2e
Nov 26 16:37:51 portablebastien kernel: [28555.348035]  [<ffffffff81102fc7>] vfs_read+0xa6/0x102
Nov 26 16:37:51 portablebastien kernel: [28555.348035]  [<ffffffff81103aa5>] ? fget_light+0x41/0xcf
Nov 26 16:37:51 portablebastien kernel: [28555.348035]  [<ffffffff811030d9>] sys_read+0x45/0x69
Nov 26 16:37:51 portablebastien kernel: [28555.348035]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Nov 26 16:37:51 portablebastien kernel: [28555.348035] sd_espeak     S 00000001001743cd     0 10682   2085 0x00000000
Nov 26 16:37:51 portablebastien kernel: [28555.348035]  ffff8800adf9bc28 0000000000000046 ffff8800adf9bcb8 ffff880000000000
Nov 26 16:37:51 portablebastien kernel: [28555.348035]  ffff8800adf9a010 ffff8800adf9bfd8 ffff880091ae8fe0 ffff880091ae92b0
Nov 26 16:37:51 portablebastien kernel: [28555.348035]  ffff880091ae92a8 0000000000014d80 0000000000014d80 ffff8800adf9bfd8
Nov 26 16:37:51 portablebastien kernel: [28555.348035] Call Trace:
Nov 26 16:37:51 portablebastien kernel: [28555.348035]  [<ffffffff81077c58>] futex_wait_queue_me+0x82/0x99
Nov 26 16:37:51 portablebastien kernel: [28555.348035]  [<ffffffff81078c47>] futex_wait+0x148/0x2f9
Nov 26 16:37:51 portablebastien kernel: [28555.348035]  [<ffffffff810676ee>] ? hrtimer_wakeup+0x0/0x21
Nov 26 16:37:51 portablebastien kernel: [28555.348035]  [<ffffffff8106816a>] ? hrtimer_start_range_ns+0xf/0x11
Nov 26 16:37:51 portablebastien kernel: [28555.348035]  [<ffffffff81079ebc>] do_futex+0x95/0x86e
Nov 26 16:37:51 portablebastien kernel: [28555.348035]  [<ffffffff8134f173>] ? do_page_fault+0x16c/0x2c0
Nov 26 16:37:51 portablebastien kernel: [28555.348035]  [<ffffffff8107a7bc>] sys_futex+0x127/0x13f
Nov 26 16:37:51 portablebastien kernel: [28555.348035]  [<ffffffff8134b504>] ? lockdep_sys_exit_thunk+0x35/0x67
Nov 26 16:37:51 portablebastien kernel: [28555.348035]  [<ffffffff8134b48e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
Nov 26 16:37:51 portablebastien kernel: [28555.348035]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Nov 26 16:37:51 portablebastien kernel: [28555.348035] sd_espeak     S 00000000ffffffff     0 10683   2085 0x00000000
Nov 26 16:37:51 portablebastien kernel: [28555.348035]  ffff88003c29bc28 0000000000000046 ffff88003c29bcb8 ffff88003c29bcf0
Nov 26 16:37:51 portablebastien kernel: [28555.348035]  ffff88003c29a010 ffff88003c29bfd8 ffff8800acc30fe0 ffff8800acc312b0
Nov 26 16:37:51 portablebastien kernel: [28555.348035]  ffff8800acc312a8 0000000000014d80 0000000000014d80 ffff88003c29bfd8
Nov 26 16:37:51 portablebastien kernel: [28555.348035] Call Trace:
Nov 26 16:37:51 portablebastien kernel: [28555.348035]  [<ffffffff81077c58>] futex_wait_queue_me+0x82/0x99
Nov 26 16:37:51 portablebastien kernel: [28555.348035]  [<ffffffff81078c47>] futex_wait+0x148/0x2f9
Nov 26 16:37:51 portablebastien kernel: [28555.348035]  [<ffffffff810c2e5a>] ? unlock_page+0x25/0x2a
Nov 26 16:37:51 portablebastien kernel: [28555.348035]  [<ffffffff81079ebc>] do_futex+0x95/0x86e
Nov 26 16:37:51 portablebastien kernel: [28555.348035]  [<ffffffff810581e3>] ? sigprocmask+0x2f/0xc6
Nov 26 16:37:51 portablebastien kernel: [28555.348035]  [<ffffffff810581e3>] ? sigprocmask+0x2f/0xc6
Nov 26 16:37:51 portablebastien kernel: [28555.348035]  [<ffffffff81042616>] ? finish_task_switch+0x0/0xdf
Nov 26 16:37:51 portablebastien kernel: [28555.348035]  [<ffffffff8107a7bc>] sys_futex+0x127/0x13f
Nov 26 16:37:51 portablebastien kernel: [28555.348035]  [<ffffffff8105826e>] ? sigprocmask+0xba/0xc6
Nov 26 16:37:51 portablebastien kernel: [28555.348035]  [<ffffffff8134b48e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
Nov 26 16:37:51 portablebastien kernel: [28555.348035]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Nov 26 16:37:51 portablebastien kernel: [28555.348035] sd_espeak     S 00000000ffffffff     0 10684   2085 0x00000000
Nov 26 16:37:51 portablebastien kernel: [28555.348035]  ffff880018417c28 0000000000000046 ffff880018417cb8 ffff880018417cf0
Nov 26 16:37:51 portablebastien kernel: [28555.348035]  ffff880018416010 ffff880018417fd8 ffff880037a98000 ffff880037a982d0
Nov 26 16:37:51 portablebastien kernel: [28555.348035]  ffff880037a982c8 0000000000014d80 0000000000014d80 ffff880018417fd8
Nov 26 16:37:51 portablebastien kernel: [28555.348035] Call Trace:
Nov 26 16:37:51 portablebastien kernel: [28555.348035]  [<ffffffff81077c58>] futex_wait_queue_me+0x82/0x99
Nov 26 16:37:51 portablebastien kernel: [28555.348035]  [<ffffffff81078c47>] futex_wait+0x148/0x2f9
Nov 26 16:37:51 portablebastien kernel: [28555.348035]  [<ffffffff810c2e5a>] ? unlock_page+0x25/0x2a
Nov 26 16:37:51 portablebastien kernel: [28555.348035]  [<ffffffff81079ebc>] do_futex+0x95/0x86e
Nov 26 16:37:51 portablebastien kernel: [28555.348035]  [<ffffffff810581e3>] ? sigprocmask+0x2f/0xc6
Nov 26 16:37:51 portablebastien kernel: [28555.348035]  [<ffffffff810581e3>] ? sigprocmask+0x2f/0xc6
Nov 26 16:37:51 portablebastien kernel: [28555.348035]  [<ffffffff81042616>] ? finish_task_switch+0x0/0xdf
Nov 26 16:37:51 portablebastien kernel: [28555.348035]  [<ffffffff8107a7bc>] sys_futex+0x127/0x13f
Nov 26 16:37:51 portablebastien kernel: [28555.348035]  [<ffffffff8105826e>] ? sigprocmask+0xba/0xc6
Nov 26 16:37:51 portablebastien kernel: [28555.348035]  [<ffffffff8134b48e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
Nov 26 16:37:51 portablebastien kernel: [28555.348035]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Nov 26 16:37:51 portablebastien kernel: [28555.348035] sd_festival   x ffff88011f658000     0 10685   2085 0x00000000
Nov 26 16:37:51 portablebastien kernel: [28555.348035]  ffff880018425eb8 0000000000000046 ffff88000fcbb438 ffff880002218370
Nov 26 16:37:51 portablebastien kernel: [28555.348035]  ffff880018424010 ffff880018425fd8 ffff880037a9cf60 ffff880037a9d230
Nov 26 16:37:51 portablebastien kernel: [28555.348035]  ffff880037a9d228 0000000000014d80 0000000000014d80 ffff880018425fd8
Nov 26 16:37:51 portablebastien kernel: [28555.348035] Call Trace:
Nov 26 16:37:51 portablebastien kernel: [28555.348035]  [<ffffffff811a2a0a>] ? exit_io_context+0x9b/0xa9
Nov 26 16:37:51 portablebastien kernel: [28555.348035]  [<ffffffff811a29b5>] ? exit_io_context+0x46/0xa9
Nov 26 16:37:51 portablebastien kernel: [28555.348035]  [<ffffffff8104d351>] do_exit+0x702/0x711
Nov 26 16:37:51 portablebastien kernel: [28555.348035]  [<ffffffff8134b504>] ? lockdep_sys_exit_thunk+0x35/0x67
Nov 26 16:37:51 portablebastien kernel: [28555.348035]  [<ffffffff8104d3d8>] do_group_exit+0x78/0xa3
Nov 26 16:37:51 portablebastien kernel: [28555.348035]  [<ffffffff8104d415>] sys_exit_group+0x12/0x16
Nov 26 16:37:51 portablebastien kernel: [28555.348035]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Nov 26 16:37:51 portablebastien kernel: [28555.348035] sd_flite      S 00000001001743f7     0 10686   2085 0x00000000
Nov 26 16:37:51 portablebastien kernel: [28555.348035]  ffff8800c23e3cd8 0000000000000046 ffff8800999fd018 0000000000000046
Nov 26 16:37:51 portablebastien kernel: [28555.348035]  ffff8800c23e2010 ffff8800c23e3fd8 ffff880037a99fc0 ffff880037a9a290
Nov 26 16:37:52 portablebastien kernel: [28555.348035]  ffff880037a9a288 0000000000014d80 0000000000014d80 ffff8800c23e3fd8
Nov 26 16:37:52 portablebastien kernel: [28555.348035] Call Trace:
Nov 26 16:37:52 portablebastien kernel: [28555.348035]  [<ffffffff8110a1e2>] pipe_wait+0x5e/0x7a
Nov 26 16:37:52 portablebastien kernel: [28555.348035]  [<ffffffff8106473b>] ? autoremove_wake_function+0x0/0x34
Nov 26 16:37:52 portablebastien kernel: [28555.348035]  [<ffffffff8134a8b4>] ? mutex_lock_nested+0x39/0x3e
Nov 26 16:37:52 portablebastien kernel: [28555.348035]  [<ffffffff8110aa62>] pipe_read+0x335/0x3b6
Nov 26 16:37:52 portablebastien kernel: [28555.348035]  [<ffffffff8112f82a>] ? fsnotify+0x79/0x449
Nov 26 16:37:52 portablebastien kernel: [28555.348035]  [<ffffffff81102989>] do_sync_read+0xc6/0x103
Nov 26 16:37:52 portablebastien kernel: [28555.348035]  [<ffffffff811721aa>] ? fsnotify_perm+0x45/0x4b
Nov 26 16:37:52 portablebastien kernel: [28555.348035]  [<ffffffff81172207>] ? security_file_permission+0x29/0x2e
Nov 26 16:37:52 portablebastien kernel: [28555.348035]  [<ffffffff81102fc7>] vfs_read+0xa6/0x102
Nov 26 16:37:52 portablebastien kernel: [28555.348035]  [<ffffffff81103aa5>] ? fget_light+0x41/0xcf
Nov 26 16:37:52 portablebastien kernel: [28555.348035]  [<ffffffff811030d9>] sys_read+0x45/0x69
Nov 26 16:37:52 portablebastien kernel: [28555.348035]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Nov 26 16:37:52 portablebastien kernel: [28555.348035] sd_flite      S 00000001001743cd     0 10687   2085 0x00000000
Nov 26 16:37:52 portablebastien kernel: [28555.348035]  ffff880096bbdc28 0000000000000046 ffff880096bbdcb8 ffff880000000000
Nov 26 16:37:52 portablebastien kernel: [28555.348035]  ffff880096bbc010 ffff880096bbdfd8 ffff880037a3afa0 ffff880037a3b270
Nov 26 16:37:52 portablebastien kernel: [28555.348035]  ffff880037a3b268 0000000000014d80 0000000000014d80 ffff880096bbdfd8
Nov 26 16:37:52 portablebastien kernel: [28555.348035] Call Trace:
Nov 26 16:37:52 portablebastien kernel: [28555.348035]  [<ffffffff81077c58>] futex_wait_queue_me+0x82/0x99
Nov 26 16:37:52 portablebastien kernel: [28555.348035]  [<ffffffff81078c47>] futex_wait+0x148/0x2f9
Nov 26 16:37:52 portablebastien kernel: [28555.348035]  [<ffffffff810c2e5a>] ? unlock_page+0x25/0x2a
Nov 26 16:37:52 portablebastien kernel: [28555.348035]  [<ffffffff81079ebc>] do_futex+0x95/0x86e
Nov 26 16:37:52 portablebastien kernel: [28555.348035]  [<ffffffff810581e3>] ? sigprocmask+0x2f/0xc6
Nov 26 16:37:52 portablebastien kernel: [28555.348035]  [<ffffffff810581e3>] ? sigprocmask+0x2f/0xc6
Nov 26 16:37:52 portablebastien kernel: [28555.348035]  [<ffffffff81042616>] ? finish_task_switch+0x0/0xdf
Nov 26 16:37:52 portablebastien kernel: [28555.348035]  [<ffffffff8107a7bc>] sys_futex+0x127/0x13f
Nov 26 16:37:52 portablebastien kernel: [28555.348035]  [<ffffffff8105826e>] ? sigprocmask+0xba/0xc6
Nov 26 16:37:52 portablebastien kernel: [28555.348035]  [<ffffffff8134b48e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
Nov 26 16:37:52 portablebastien kernel: [28555.348035]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Nov 26 16:37:52 portablebastien kernel: [28555.348035] speech-dispat x 00000001001743f7     0 10688   2085 0x00000000
Nov 26 16:37:52 portablebastien kernel: [28555.348035]  ffff8800adf95eb8 0000000000000046 ffff8800adf95e88 0000000000000246
Nov 26 16:37:52 portablebastien kernel: [28555.348035]  ffff8800adf94010 ffff8800adf95fd8 ffff8800b7d18000 ffff8800b7d182d0
Nov 26 16:37:52 portablebastien kernel: [28555.348035]  ffff8800b7d182c8 0000000000014d80 0000000000014d80 ffff8800adf95fd8
Nov 26 16:37:52 portablebastien kernel: [28555.348035] Call Trace:
Nov 26 16:37:52 portablebastien kernel: [28555.348035]  [<ffffffff8104d351>] do_exit+0x702/0x711
Nov 26 16:37:52 portablebastien kernel: [28555.348035]  [<ffffffff8134b504>] ? lockdep_sys_exit_thunk+0x35/0x67
Nov 26 16:37:52 portablebastien kernel: [28555.348035]  [<ffffffff8104d3d8>] do_group_exit+0x78/0xa3
Nov 26 16:37:52 portablebastien kernel: [28555.348035]  [<ffffffff8104d415>] sys_exit_group+0x12/0x16
Nov 26 16:37:52 portablebastien kernel: [28555.348035]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Nov 26 16:37:52 portablebastien kernel: [28555.348035] sd_dummy      S 00000001001743f8     0 10689   2085 0x00000000
Nov 26 16:37:52 portablebastien kernel: [28555.348035]  ffff8800ace67cd8 0000000000000046 ffff8800aa166c18 0000000000000046
Nov 26 16:37:52 portablebastien kernel: [28555.348035]  ffff8800ace66010 ffff8800ace67fd8 ffff8800b7d1bf80 ffff8800b7d1c250
Nov 26 16:37:52 portablebastien kernel: [28555.348035]  ffff8800b7d1c248 0000000000014d80 0000000000014d80 ffff8800ace67fd8
Nov 26 16:37:52 portablebastien kernel: [28555.348035] Call Trace:
Nov 26 16:37:52 portablebastien kernel: [28555.348035]  [<ffffffff8110a1e2>] pipe_wait+0x5e/0x7a
Nov 26 16:37:52 portablebastien kernel: [28555.348035]  [<ffffffff8106473b>] ? autoremove_wake_function+0x0/0x34
Nov 26 16:37:52 portablebastien kernel: [28555.348035]  [<ffffffff8134a8b4>] ? mutex_lock_nested+0x39/0x3e
Nov 26 16:37:52 portablebastien kernel: [28555.348035]  [<ffffffff8110aa62>] pipe_read+0x335/0x3b6
Nov 26 16:37:52 portablebastien kernel: [28555.348035]  [<ffffffff8112f82a>] ? fsnotify+0x79/0x449
Nov 26 16:37:52 portablebastien kernel: [28555.348035]  [<ffffffff81102989>] do_sync_read+0xc6/0x103
Nov 26 16:37:52 portablebastien kernel: [28555.348035]  [<ffffffff811721aa>] ? fsnotify_perm+0x45/0x4b
Nov 26 16:37:52 portablebastien kernel: [28555.348035]  [<ffffffff81172207>] ? security_file_permission+0x29/0x2e
Nov 26 16:37:52 portablebastien kernel: [28555.348035]  [<ffffffff81102fc7>] vfs_read+0xa6/0x102
Nov 26 16:37:52 portablebastien kernel: [28555.348035]  [<ffffffff81103aa5>] ? fget_light+0x41/0xcf
Nov 26 16:37:52 portablebastien kernel: [28555.348035]  [<ffffffff811030d9>] sys_read+0x45/0x69
Nov 26 16:37:52 portablebastien kernel: [28555.348035]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Nov 26 16:37:52 portablebastien kernel: [28555.348035] sd_dummy      S 00000001001743f8     0 10690   2085 0x00000000
Nov 26 16:37:52 portablebastien kernel: [28555.348035]  ffff8800adfcbc28 0000000000000046 ffff8800adfcbcb8 ffff8800adfcbcf0
Nov 26 16:37:52 portablebastien kernel: [28555.348035]  ffff8800adfca010 ffff8800adfcbfd8 ffff8800b7d19fc0 ffff8800b7d1a290
Nov 26 16:37:52 portablebastien kernel: [28555.348035]  ffff8800b7d1a288 0000000000014d80 0000000000014d80 ffff8800adfcbfd8
Nov 26 16:37:54 portablebastien kernel: [28555.348035] Call Trace:
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81077c58>] futex_wait_queue_me+0x82/0x99
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81078c47>] futex_wait+0x148/0x2f9
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810c2e5a>] ? unlock_page+0x25/0x2a
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81079ebc>] do_futex+0x95/0x86e
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810581e3>] ? sigprocmask+0x2f/0xc6
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810581e3>] ? sigprocmask+0x2f/0xc6
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8107a7bc>] sys_futex+0x127/0x13f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8105826e>] ? sigprocmask+0xba/0xc6
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8134b48e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Nov 26 16:37:54 portablebastien kernel: [28555.348035] gvfsd-metadat S 0000000100253bd6     0 13459      1 0x00000000
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff88000f999a58 0000000000000046 ffff88000f999c70 0000000000000000
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff88000f998010 ffff88000f999fd8 ffff880099a4bf80 ffff880099a4c250
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff880099a4c248 0000000000014d80 0000000000014d80 ffff88000f999fd8
Nov 26 16:37:54 portablebastien kernel: [28555.348035] Call Trace:
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8134a905>] schedule_hrtimeout_range_clock+0x4c/0x12f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81075039>] ? trace_hardirqs_on+0xd/0xf
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81064a5b>] ? add_wait_queue+0x3f/0x44
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8134a9f6>] schedule_hrtimeout_range+0xe/0x10
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff811112e4>] poll_schedule_timeout+0x43/0x5f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81112369>] do_sys_poll+0x35a/0x3e5
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8111197c>] ? __pollwait+0x0/0xc7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810c2869>] ? rcu_read_lock+0x0/0x30
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810c2869>] ? rcu_read_lock+0x0/0x30
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810dd245>] ? __do_fault+0x1e3/0x3a4
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810dd245>] ? __do_fault+0x1e3/0x3a4
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810c2e5a>] ? unlock_page+0x25/0x2a
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810dd3d0>] ? __do_fault+0x36e/0x3a4
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810ddd8e>] ? handle_mm_fault+0x33e/0x846
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8134f173>] ? do_page_fault+0x16c/0x2c0
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8106878f>] ? up_read+0x1e/0x37
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81112588>] sys_poll+0x50/0xbb
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Nov 26 16:37:54 portablebastien kernel: [28555.348035] kbibtex       S 0000000000000000     0 15832      1 0x00000000
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff88002aa67908 0000000000000046 ffff88002aa67918 00001a31c8586ca5
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff88002aa66010 ffff88002aa67fd8 ffff8800bff16f20 ffff8800bff171f0
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff8800bff171e8 0000000000014d80 0000000000014d80 ffff88002aa67fd8
Nov 26 16:37:54 portablebastien kernel: [28555.348035] Call Trace:
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8134a9a1>] schedule_hrtimeout_range_clock+0xe8/0x12f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810676ee>] ? hrtimer_wakeup+0x0/0x21
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8106816a>] ? hrtimer_start_range_ns+0xf/0x11
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8134a9f6>] schedule_hrtimeout_range+0xe/0x10
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff811112e4>] poll_schedule_timeout+0x43/0x5f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111942>] do_select+0x5b2/0x5ec
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111390>] ? do_select+0x0/0x5ec
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8111197c>] ? __pollwait+0x0/0xc7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810d9ec8>] ? might_fault+0xa0/0xa7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111d17>] core_sys_select+0x21c/0x2b2
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111b33>] ? core_sys_select+0x38/0x2b2
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81102989>] ? do_sync_read+0xc6/0x103
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8106ccea>] ? ktime_get_ts+0xad/0xba
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111fe7>] sys_select+0x91/0xb9
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Nov 26 16:37:54 portablebastien kernel: [28555.348035] kdeinit       S 00000001002e82c6     0 15835      1 0x00000000
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff8800b2057908 0000000000000046 0000000000000001 00000000000004cf
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff8800b2056010 ffff8800b2057fd8 ffff8800ac1b1fc0 ffff8800ac1b2290
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff8800ac1b2288 0000000000014d80 0000000000014d80 ffff8800b2057fd8
Nov 26 16:37:54 portablebastien kernel: [28555.348035] Call Trace:
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8134a905>] schedule_hrtimeout_range_clock+0x4c/0x12f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81075039>] ? trace_hardirqs_on+0xd/0xf
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81064a5b>] ? add_wait_queue+0x3f/0x44
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8134a9f6>] schedule_hrtimeout_range+0xe/0x10
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff811112e4>] poll_schedule_timeout+0x43/0x5f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111942>] do_select+0x5b2/0x5ec
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111390>] ? do_select+0x0/0x5ec
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8111197c>] ? __pollwait+0x0/0xc7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff812f9b40>] ? scm_destroy+0x11/0x2a
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810d9ec8>] ? might_fault+0xa0/0xa7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111d17>] core_sys_select+0x21c/0x2b2
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111b33>] ? core_sys_select+0x38/0x2b2
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81075039>] ? trace_hardirqs_on+0xd/0xf
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810649d4>] ? remove_wait_queue+0x4c/0x51
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8104c9cb>] ? do_wait+0x1eb/0x22e
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111fe7>] sys_select+0x91/0xb9
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8134b48e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Nov 26 16:37:54 portablebastien kernel: [28555.348035] dcopserver    S 0000000000000000     0 15838      1 0x00000000
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff88004fcbb908 0000000000000046 ffff880000000000 0000000000000001
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff88004fcba010 ffff88004fcbbfd8 ffff88011b88bf80 ffff88011b88c250
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff88011b88c248 0000000000014d80 0000000000014d80 ffff88004fcbbfd8
Nov 26 16:37:54 portablebastien kernel: [28555.348035] Call Trace:
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8134a905>] schedule_hrtimeout_range_clock+0x4c/0x12f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81075039>] ? trace_hardirqs_on+0xd/0xf
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81064a5b>] ? add_wait_queue+0x3f/0x44
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8134a9f6>] schedule_hrtimeout_range+0xe/0x10
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff811112e4>] poll_schedule_timeout+0x43/0x5f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111942>] do_select+0x5b2/0x5ec
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111390>] ? do_select+0x0/0x5ec
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8111197c>] ? __pollwait+0x0/0xc7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810d9ec8>] ? might_fault+0xa0/0xa7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111d17>] core_sys_select+0x21c/0x2b2
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111b33>] ? core_sys_select+0x38/0x2b2
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81102989>] ? do_sync_read+0xc6/0x103
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8127b52d>] ? sockfd_lookup_light+0x1b/0x53
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8127d24c>] ? sys_sendto+0x120/0x14d
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8110fbe7>] ? sys_fcntl+0x325/0x537
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8110fbe7>] ? sys_fcntl+0x325/0x537
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111fe7>] sys_select+0x91/0xb9
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8134b48e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Nov 26 16:37:54 portablebastien kernel: [28555.348035] klauncher     S 00000001006bc422     0 15841  15835 0x00000000
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff8800b209f908 0000000000000046 ffff8800b209f918 000019f900000000
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff8800b209e010 ffff8800b209ffd8 ffff880091aedf40 ffff880091aee210
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff880091aee208 0000000000014d80 0000000000014d80 ffff8800b209ffd8
Nov 26 16:37:54 portablebastien kernel: [28555.348035] Call Trace:
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8134a9a1>] schedule_hrtimeout_range_clock+0xe8/0x12f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810676ee>] ? hrtimer_wakeup+0x0/0x21
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8106816a>] ? hrtimer_start_range_ns+0xf/0x11
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8134a9f6>] schedule_hrtimeout_range+0xe/0x10
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff811112e4>] poll_schedule_timeout+0x43/0x5f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111942>] do_select+0x5b2/0x5ec
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111390>] ? do_select+0x0/0x5ec
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8111197c>] ? __pollwait+0x0/0xc7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810d9ec8>] ? might_fault+0xa0/0xa7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810d9ec8>] ? might_fault+0xa0/0xa7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111d17>] core_sys_select+0x21c/0x2b2
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111b33>] ? core_sys_select+0x38/0x2b2
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8106ccea>] ? ktime_get_ts+0xad/0xba
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111fe7>] sys_select+0x91/0xb9
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Nov 26 16:37:54 portablebastien kernel: [28555.348035] kded          S 00000001006bc67a     0 15843      1 0x00000000
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff880074329908 0000000000000046 ffff880074329918 000019f900000000
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff880074328010 ffff880074329fd8 ffff880091aebf80 ffff880091aec250
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff880091aec248 0000000000014d80 0000000000014d80 ffff880074329fd8
Nov 26 16:37:54 portablebastien kernel: [28555.348035] Call Trace:
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8134a9a1>] schedule_hrtimeout_range_clock+0xe8/0x12f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810676ee>] ? hrtimer_wakeup+0x0/0x21
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8106816a>] ? hrtimer_start_range_ns+0xf/0x11
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8134a9f6>] schedule_hrtimeout_range+0xe/0x10
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff811112e4>] poll_schedule_timeout+0x43/0x5f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111942>] do_select+0x5b2/0x5ec
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111390>] ? do_select+0x0/0x5ec
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8111197c>] ? __pollwait+0x0/0xc7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810d9ec8>] ? might_fault+0xa0/0xa7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111d17>] core_sys_select+0x21c/0x2b2
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111b33>] ? core_sys_select+0x38/0x2b2
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81102989>] ? do_sync_read+0xc6/0x103
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8106ccea>] ? ktime_get_ts+0xad/0xba
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111fe7>] sys_select+0x91/0xb9
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Nov 26 16:37:54 portablebastien kernel: [28555.348035] cpdftocps     S ffff8800b7eddf30     0 17514   1829 0x00000000
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff88003de81e58 0000000000000046 ffff88003de81e28 0000000000000246
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff88003de80010 ffff88003de81fd8 ffff8800b7eddf40 ffff8800b7ede210
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff8800b7ede208 0000000000014d80 0000000000014d80 ffff88003de81fd8
Nov 26 16:37:54 portablebastien kernel: [28555.348035] Call Trace:
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8104c99a>] do_wait+0x1ba/0x22e
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8104caa7>] sys_wait4+0x99/0xbc
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8104af46>] ? child_wait_callback+0x0/0x53
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Nov 26 16:37:54 portablebastien kernel: [28555.348035] socket        S 00000001006bb7ca     0 17515   1829 0x00000000
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff8800ac16de58 0000000000000046 ffff8800ac16dea8 000019fb00000000
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff8800ac16c010 ffff8800ac16dfd8 ffff8800b7ed8000 ffff8800b7ed82d0
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff8800b7ed82c8 0000000000014d80 0000000000014d80 ffff8800ac16dfd8
Nov 26 16:37:54 portablebastien kernel: [28555.348035] Call Trace:
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8134aa77>] do_nanosleep+0x70/0xb2
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81068226>] hrtimer_nanosleep+0xba/0x13b
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810676ee>] ? hrtimer_wakeup+0x0/0x21
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8106816a>] ? hrtimer_start_range_ns+0xf/0x11
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81068305>] sys_nanosleep+0x5e/0x72
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Nov 26 16:37:54 portablebastien kernel: [28555.348035] pdftops       S 0000000000000010     0 17596  17514 0x00000000
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff8800adc8bcd8 0000000000000046 ffff8800acdda9d8 0000000000000046
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff8800adc8a010 ffff8800adc8bfd8 ffff8800c200cf60 ffff8800c200d230
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff8800c200d228 0000000000014d80 0000000000014d80 ffff8800adc8bfd8
Nov 26 16:37:54 portablebastien kernel: [28555.348035] Call Trace:
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8110a1e2>] pipe_wait+0x5e/0x7a
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8106473b>] ? autoremove_wake_function+0x0/0x34
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8134a8b4>] ? mutex_lock_nested+0x39/0x3e
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8110a6be>] pipe_write+0x4c0/0x52f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81102886>] do_sync_write+0xc6/0x103
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81172207>] ? security_file_permission+0x29/0x2e
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81102deb>] vfs_write+0xa9/0x105
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81102efd>] sys_write+0x45/0x69
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Nov 26 16:37:54 portablebastien kernel: [28555.348035] pstops        S 00000001002c39bd     0 17597  17514 0x00000000
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff8800ac3f7cd8 0000000000000046 ffff880113866a98 0000000000000046
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff8800ac3f6010 ffff8800ac3f7fd8 ffff8800c200afa0 ffff8800c200b270
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff8800c200b268 0000000000014d80 0000000000014d80 ffff8800ac3f7fd8
Nov 26 16:37:54 portablebastien kernel: [28555.348035] Call Trace:
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8110a1e2>] pipe_wait+0x5e/0x7a
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8106473b>] ? autoremove_wake_function+0x0/0x34
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8134a8b4>] ? mutex_lock_nested+0x39/0x3e
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8110a6be>] pipe_write+0x4c0/0x52f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81102886>] do_sync_write+0xc6/0x103
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81172207>] ? security_file_permission+0x29/0x2e
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81102deb>] vfs_write+0xa9/0x105
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81102efd>] sys_write+0x45/0x69
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Nov 26 16:37:54 portablebastien kernel: [28555.348035] kio_thumbnail S 0000000000000000     0 17617   2849 0x00000000
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff8800b7f83908 0000000000000046 ffff880002314d80 ffff88011f6c1018
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff8800b7f82010 ffff8800b7f83fd8 ffff88011f6c0fe0 ffff88011f6c12b0
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff88011f6c12a8 0000000000014d80 0000000000014d80 ffff8800b7f83fd8
Nov 26 16:37:54 portablebastien kernel: [28555.348035] Call Trace:
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8134a905>] schedule_hrtimeout_range_clock+0x4c/0x12f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81075039>] ? trace_hardirqs_on+0xd/0xf
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81064a5b>] ? add_wait_queue+0x3f/0x44
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8134a9f6>] schedule_hrtimeout_range+0xe/0x10
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff811112e4>] poll_schedule_timeout+0x43/0x5f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111942>] do_select+0x5b2/0x5ec
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111390>] ? do_select+0x0/0x5ec
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8111197c>] ? __pollwait+0x0/0xc7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81044430>] ? default_wake_function+0xd/0xf
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111a90>] ? pollwake+0x4d/0x4f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81044423>] ? default_wake_function+0x0/0xf
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81075039>] ? trace_hardirqs_on+0xd/0xf
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff812f9b03>] ? scm_destroy_cred+0x14/0x40
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff812f9b40>] ? scm_destroy+0x11/0x2a
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810d9ec8>] ? might_fault+0xa0/0xa7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111d17>] core_sys_select+0x21c/0x2b2
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111b33>] ? core_sys_select+0x38/0x2b2
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8112f82a>] ? fsnotify+0x79/0x449
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8112fbdb>] ? fsnotify+0x42a/0x449
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8112f82a>] ? fsnotify+0x79/0x449
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111fe7>] sys_select+0x91/0xb9
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8134b48e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Nov 26 16:37:54 portablebastien kernel: [28555.348035] kio_file      S 0000000000000000     0 17624   2849 0x00000000
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff880068aa9908 0000000000000046 ffffea00016e7440 0000000000000000
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff880068aa8010 ffff880068aa9fd8 ffff8800bfe98000 ffff8800bfe982d0
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff8800bfe982c8 0000000000014d80 0000000000014d80 ffff880068aa9fd8
Nov 26 16:37:54 portablebastien kernel: [28555.348035] Call Trace:
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8134a905>] schedule_hrtimeout_range_clock+0x4c/0x12f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81075039>] ? trace_hardirqs_on+0xd/0xf
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81064a5b>] ? add_wait_queue+0x3f/0x44
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8134a9f6>] schedule_hrtimeout_range+0xe/0x10
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff811112e4>] poll_schedule_timeout+0x43/0x5f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111942>] do_select+0x5b2/0x5ec
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111390>] ? do_select+0x0/0x5ec
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8111197c>] ? __pollwait+0x0/0xc7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81044430>] ? default_wake_function+0xd/0xf
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111a90>] ? pollwake+0x4d/0x4f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81044423>] ? default_wake_function+0x0/0xf
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81075039>] ? trace_hardirqs_on+0xd/0xf
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff812f9b03>] ? scm_destroy_cred+0x14/0x40
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff812f9b40>] ? scm_destroy+0x11/0x2a
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810d9ec8>] ? might_fault+0xa0/0xa7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111d17>] core_sys_select+0x21c/0x2b2
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111b33>] ? core_sys_select+0x38/0x2b2
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8112f82a>] ? fsnotify+0x79/0x449
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8112fbdb>] ? fsnotify+0x42a/0x449
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8112f82a>] ? fsnotify+0x79/0x449
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111fe7>] sys_select+0x91/0xb9
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8134b48e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Nov 26 16:37:54 portablebastien kernel: [28555.348035] kio_thumbnail S 0000000000000000     0 17633   2849 0x00000000
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff880076755908 0000000000000046 ffff880002214d80 ffff8800bfe9ef58
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff880076754010 ffff880076755fd8 ffff8800bfe9ef20 ffff8800bfe9f1f0
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff8800bfe9f1e8 0000000000014d80 0000000000014d80 ffff880076755fd8
Nov 26 16:37:54 portablebastien kernel: [28555.348035] Call Trace:
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8134a905>] schedule_hrtimeout_range_clock+0x4c/0x12f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81075039>] ? trace_hardirqs_on+0xd/0xf
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81064a5b>] ? add_wait_queue+0x3f/0x44
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8134a9f6>] schedule_hrtimeout_range+0xe/0x10
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff811112e4>] poll_schedule_timeout+0x43/0x5f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111942>] do_select+0x5b2/0x5ec
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111390>] ? do_select+0x0/0x5ec
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8111197c>] ? __pollwait+0x0/0xc7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81044430>] ? default_wake_function+0xd/0xf
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111a90>] ? pollwake+0x4d/0x4f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81044423>] ? default_wake_function+0x0/0xf
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81075039>] ? trace_hardirqs_on+0xd/0xf
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff812f9b03>] ? scm_destroy_cred+0x14/0x40
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff812f9b40>] ? scm_destroy+0x11/0x2a
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810d9ec8>] ? might_fault+0xa0/0xa7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111d17>] core_sys_select+0x21c/0x2b2
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111b33>] ? core_sys_select+0x38/0x2b2
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8112f82a>] ? fsnotify+0x79/0x449
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8112fbdb>] ? fsnotify+0x42a/0x449
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8112f82a>] ? fsnotify+0x79/0x449
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111fe7>] sys_select+0x91/0xb9
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8134b48e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Nov 26 16:37:54 portablebastien kernel: [28555.348035] bash          S 0000000000000000     0 17677   2983 0x00000000
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff8800b20c7ce8 0000000000000046 0000000000000000 0000000000000046
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff8800b20c6010 ffff8800b20c7fd8 ffff880099a25f40 ffff880099a26210
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff880099a26208 0000000000014d80 0000000000014d80 ffff8800b20c7fd8
Nov 26 16:37:54 portablebastien kernel: [28555.348035] Call Trace:
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81075039>] ? trace_hardirqs_on+0xd/0xf
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81349f02>] schedule_timeout+0x31/0xeb
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810569a9>] ? del_timer_sync+0x8e/0xa1
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8105691b>] ? del_timer_sync+0x0/0xa1
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810601e6>] ? flush_delayed_work+0x44/0x48
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8122f474>] n_tty_read+0x4cd/0x7af
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81044423>] ? default_wake_function+0x0/0xf
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8122ab48>] tty_read+0x81/0xc5
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81102fc7>] vfs_read+0xa6/0x102
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8134bca9>] ? _raw_spin_unlock_irq+0x2b/0x36
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff811030d9>] sys_read+0x45/0x69
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Nov 26 16:37:54 portablebastien kernel: [28555.348035] kbibtex       S 00000001006b3375     0 17933   2849 0x00000000
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff8800767d9908 0000000000000046 ffff8800767d9918 00001a1a00000000
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff8800767d8010 ffff8800767d9fd8 ffff8800d4530000 ffff8800d45302d0
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff8800d45302c8 0000000000014d80 0000000000014d80 ffff8800767d9fd8
Nov 26 16:37:54 portablebastien kernel: [28555.348035] Call Trace:
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8134a9a1>] schedule_hrtimeout_range_clock+0xe8/0x12f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810676ee>] ? hrtimer_wakeup+0x0/0x21
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8106816a>] ? hrtimer_start_range_ns+0xf/0x11
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8134a9f6>] schedule_hrtimeout_range+0xe/0x10
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff811112e4>] poll_schedule_timeout+0x43/0x5f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111942>] do_select+0x5b2/0x5ec
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111390>] ? do_select+0x0/0x5ec
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8111197c>] ? __pollwait+0x0/0xc7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810d9ec8>] ? might_fault+0xa0/0xa7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111d17>] core_sys_select+0x21c/0x2b2
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111b33>] ? core_sys_select+0x38/0x2b2
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81102989>] ? do_sync_read+0xc6/0x103
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8106ccea>] ? ktime_get_ts+0xad/0xba
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111fe7>] sys_select+0x91/0xb9
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Nov 26 16:37:54 portablebastien kernel: [28555.348035] kio_file      S 00000001002fccae     0 18055  15835 0x00000000
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff88001ca69908 0000000000000046 ffff880002314d80 ffff880000000000
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff88001ca68010 ffff88001ca69fd8 ffff8800c4421fc0 ffff8800c4422290
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff8800c4422288 0000000000014d80 0000000000014d80 ffff88001ca69fd8
Nov 26 16:37:54 portablebastien kernel: [28555.348035] Call Trace:
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8134a905>] schedule_hrtimeout_range_clock+0x4c/0x12f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81075039>] ? trace_hardirqs_on+0xd/0xf
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81064a5b>] ? add_wait_queue+0x3f/0x44
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8134a9f6>] schedule_hrtimeout_range+0xe/0x10
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff811112e4>] poll_schedule_timeout+0x43/0x5f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111942>] do_select+0x5b2/0x5ec
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111390>] ? do_select+0x0/0x5ec
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8111197c>] ? __pollwait+0x0/0xc7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81044430>] ? default_wake_function+0xd/0xf
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111a90>] ? pollwake+0x4d/0x4f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81044423>] ? default_wake_function+0x0/0xf
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81075039>] ? trace_hardirqs_on+0xd/0xf
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff812f9b03>] ? scm_destroy_cred+0x14/0x40
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff812f9b40>] ? scm_destroy+0x11/0x2a
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810d9ec8>] ? might_fault+0xa0/0xa7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111d17>] core_sys_select+0x21c/0x2b2
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111b33>] ? core_sys_select+0x38/0x2b2
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8112f82a>] ? fsnotify+0x79/0x449
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8112fbdb>] ? fsnotify+0x42a/0x449
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8112f82a>] ? fsnotify+0x79/0x449
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111fe7>] sys_select+0x91/0xb9
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8134b48e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Nov 26 16:37:54 portablebastien kernel: [28555.348035] kio_uiserver  S 0000000000000000     0 18582      1 0x00000000
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff88005036f908 0000000000000046 ffff88005036f8d8 0000000000000000
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff88005036e010 ffff88005036ffd8 ffff88011da6df40 ffff88011da6e210
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff88011da6e208 0000000000014d80 0000000000014d80 ffff88005036ffd8
Nov 26 16:37:54 portablebastien kernel: [28555.348035] Call Trace:
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8134a905>] schedule_hrtimeout_range_clock+0x4c/0x12f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81075039>] ? trace_hardirqs_on+0xd/0xf
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8134a9f6>] schedule_hrtimeout_range+0xe/0x10
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff811112e4>] poll_schedule_timeout+0x43/0x5f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111942>] do_select+0x5b2/0x5ec
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111390>] ? do_select+0x0/0x5ec
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8111197c>] ? __pollwait+0x0/0xc7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810d9ec8>] ? might_fault+0xa0/0xa7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111d17>] core_sys_select+0x21c/0x2b2
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111b33>] ? core_sys_select+0x38/0x2b2
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81102989>] ? do_sync_read+0xc6/0x103
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff811721aa>] ? fsnotify_perm+0x45/0x4b
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111fe7>] sys_select+0x91/0xb9
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8134b48e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Nov 26 16:37:54 portablebastien kernel: [28555.348035] bash          S 0000000100443bed     0 19615   3005 0x00000000
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff88002ab49ce8 0000000000000046 0000000000000000 0000000000000000
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff88002ab48010 ffff88002ab49fd8 ffff8800c2099fc0 ffff8800c209a290
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff8800c209a288 0000000000014d80 0000000000014d80 ffff88002ab49fd8
Nov 26 16:37:54 portablebastien kernel: [28555.348035] Call Trace:
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81349f02>] schedule_timeout+0x31/0xeb
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810569a9>] ? del_timer_sync+0x8e/0xa1
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8105691b>] ? del_timer_sync+0x0/0xa1
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810601e6>] ? flush_delayed_work+0x44/0x48
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8122f474>] n_tty_read+0x4cd/0x7af
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81044423>] ? default_wake_function+0x0/0xf
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8122ab48>] tty_read+0x81/0xc5
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81102fc7>] vfs_read+0xa6/0x102
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8134bca9>] ? _raw_spin_unlock_irq+0x2b/0x36
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff811030d9>] sys_read+0x45/0x69
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Nov 26 16:37:54 portablebastien kernel: [28555.348035] python        S 0000000000000000     0 20085      1 0x00000000
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff8800b20dda58 0000000000000046 ffff8800b20dda18 ffffffff00000000
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff8800b20dc010 ffff8800b20ddfd8 ffff8800b6c84f60 ffff8800b6c85230
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff8800b6c85228 0000000000014d80 0000000000014d80 ffff8800b20ddfd8
Nov 26 16:37:54 portablebastien kernel: [28555.348035] Call Trace:
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff812fc821>] ? unix_write_space+0x0/0xef
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8134a905>] schedule_hrtimeout_range_clock+0x4c/0x12f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81075039>] ? trace_hardirqs_on+0xd/0xf
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81064a5b>] ? add_wait_queue+0x3f/0x44
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8134a9f6>] schedule_hrtimeout_range+0xe/0x10
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff811112e4>] poll_schedule_timeout+0x43/0x5f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81112369>] do_sys_poll+0x35a/0x3e5
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8111197c>] ? __pollwait+0x0/0xc7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81279f40>] ? __sock_recvmsg_nosec+0x65/0x6e
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8127b23f>] ? __sock_recvmsg+0x49/0x54
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8127d81d>] ? sock_aio_read+0xc2/0xd6
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81102989>] ? do_sync_read+0xc6/0x103
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81102606>] ? fsnotify_access+0x61/0x69
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81112588>] sys_poll+0x50/0xbb
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Nov 26 16:37:54 portablebastien kernel: [28555.348035] python        S 00000001005b179c     0 20087      1 0x00000000
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff88003c209c28 0000000000000046 ffff88003c209cb8 ffff880000000000
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff88003c208010 ffff88003c209fd8 ffff8800b7d29fc0 ffff8800b7d2a290
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff8800b7d2a288 0000000000014d80 0000000000014d80 ffff88003c209fd8
Nov 26 16:37:54 portablebastien kernel: [28555.348035] Call Trace:
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81077c58>] futex_wait_queue_me+0x82/0x99
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81078c47>] futex_wait+0x148/0x2f9
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810e1865>] ? vma_merge+0x2ab/0x327
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810e2829>] ? __vm_enough_memory+0x26/0x151
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81079ebc>] do_futex+0x95/0x86e
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8100db8c>] ? arch_get_unmapped_area_topdown+0x4a/0x28a
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810e2677>] ? do_mmap_pgoff+0x28b/0x2ee
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8107a7bc>] sys_futex+0x127/0x13f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810e27df>] ? sys_mmap_pgoff+0x105/0x129
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8134b48e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Nov 26 16:37:54 portablebastien kernel: [28555.348035] bash          S 00000001004afdf9     0 20156   3005 0x00000000
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff880068bb7e58 0000000000000046 ffff880068bb7e28 0000000000000000
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff880068bb6010 ffff880068bb7fd8 ffff8800c200df40 ffff8800c200e210
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff8800c200e208 0000000000014d80 0000000000014d80 ffff880068bb7fd8
Nov 26 16:37:54 portablebastien kernel: [28555.348035] Call Trace:
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8104c99a>] do_wait+0x1ba/0x22e
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8104caa7>] sys_wait4+0x99/0xbc
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8104af46>] ? child_wait_callback+0x0/0x53
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Nov 26 16:37:54 portablebastien kernel: [28555.348035] mc            S 0000000100376b60     0 20717   3012 0x00000000
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff8800503ef908 0000000000000046 ffff8800503ef878 ffffffff00000000
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff8800503ee010 ffff8800503effd8 ffff88011c060000 ffff88011c0602d0
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff88011c0602c8 0000000000014d80 0000000000014d80 ffff8800503effd8
Nov 26 16:37:54 portablebastien kernel: [28555.348035] Call Trace:
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8134a905>] schedule_hrtimeout_range_clock+0x4c/0x12f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8105691b>] ? del_timer_sync+0x0/0xa1
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810601e6>] ? flush_delayed_work+0x44/0x48
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81075039>] ? trace_hardirqs_on+0xd/0xf
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8134a9f6>] schedule_hrtimeout_range+0xe/0x10
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff811112e4>] poll_schedule_timeout+0x43/0x5f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111942>] do_select+0x5b2/0x5ec
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111390>] ? do_select+0x0/0x5ec
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8111197c>] ? __pollwait+0x0/0xc7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81038223>] ? check_preempt_curr+0x1b/0x34
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81044411>] ? try_to_wake_up+0x172/0x184
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810d9ec8>] ? might_fault+0xa0/0xa7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111d17>] core_sys_select+0x21c/0x2b2
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111b33>] ? core_sys_select+0x38/0x2b2
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8112f82a>] ? fsnotify+0x79/0x449
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8105865d>] ? do_sigaction+0x80/0x179
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8105865d>] ? do_sigaction+0x80/0x179
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81075039>] ? trace_hardirqs_on+0xd/0xf
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8134bca9>] ? _raw_spin_unlock_irq+0x2b/0x36
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111fe7>] sys_select+0x91/0xb9
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8134b48e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Nov 26 16:37:54 portablebastien kernel: [28555.348035] bash          S 0000000000000000     0 20719  20717 0x00000000
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff8800b267fce8 0000000000000046 0000000000000000 0000000000000046
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff8800b267e010 ffff8800b267ffd8 ffff8800ac1b0fe0 ffff8800ac1b12b0
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff8800ac1b12a8 0000000000014d80 0000000000014d80 ffff8800b267ffd8
Nov 26 16:37:54 portablebastien kernel: [28555.348035] Call Trace:
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81075039>] ? trace_hardirqs_on+0xd/0xf
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81349f02>] schedule_timeout+0x31/0xeb
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810569a9>] ? del_timer_sync+0x8e/0xa1
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8105691b>] ? del_timer_sync+0x0/0xa1
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810601e6>] ? flush_delayed_work+0x44/0x48
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8122f474>] n_tty_read+0x4cd/0x7af
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81044423>] ? default_wake_function+0x0/0xf
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8122ab48>] tty_read+0x81/0xc5
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81102fc7>] vfs_read+0xa6/0x102
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8134bca9>] ? _raw_spin_unlock_irq+0x2b/0x36
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff811030d9>] sys_read+0x45/0x69
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Nov 26 16:37:54 portablebastien kernel: [28555.348035] bash          S ffff8800c708bf70     0 20735   3005 0x00000000
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff88002e9d9e58 0000000000000046 ffff88002e9d9e28 0000000000000246
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff88002e9d8010 ffff88002e9d9fd8 ffff8800c708bf80 ffff8800c708c250
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff8800c708c248 0000000000014d80 0000000000014d80 ffff88002e9d9fd8
Nov 26 16:37:54 portablebastien kernel: [28555.348035] Call Trace:
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8104c99a>] do_wait+0x1ba/0x22e
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8104caa7>] sys_wait4+0x99/0xbc
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8104af46>] ? child_wait_callback+0x0/0x53
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Nov 26 16:37:54 portablebastien kernel: [28555.348035] mc            S 0000000000000000     0 20739  20735 0x00000000
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff880050209908 0000000000000046 ffff880050209878 ffffffff8134bca9
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff880050208010 ffff880050209fd8 ffff88011bf26f20 ffff88011bf271f0
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff88011bf271e8 0000000000014d80 0000000000014d80 ffff880050209fd8
Nov 26 16:37:54 portablebastien kernel: [28555.348035] Call Trace:
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8134bca9>] ? _raw_spin_unlock_irq+0x2b/0x36
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81056548>] ? try_to_del_timer_sync+0x76/0x84
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8134a905>] schedule_hrtimeout_range_clock+0x4c/0x12f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8105691b>] ? del_timer_sync+0x0/0xa1
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810601e6>] ? flush_delayed_work+0x44/0x48
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81075039>] ? trace_hardirqs_on+0xd/0xf
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8134a9f6>] schedule_hrtimeout_range+0xe/0x10
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff811112e4>] poll_schedule_timeout+0x43/0x5f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111942>] do_select+0x5b2/0x5ec
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111390>] ? do_select+0x0/0x5ec
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8111197c>] ? __pollwait+0x0/0xc7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810d9ec8>] ? might_fault+0xa0/0xa7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810d9ec8>] ? might_fault+0xa0/0xa7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111d17>] core_sys_select+0x21c/0x2b2
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111b33>] ? core_sys_select+0x38/0x2b2
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8105865d>] ? do_sigaction+0x80/0x179
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8105865d>] ? do_sigaction+0x80/0x179
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81075039>] ? trace_hardirqs_on+0xd/0xf
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8134bca9>] ? _raw_spin_unlock_irq+0x2b/0x36
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111fe7>] sys_select+0x91/0xb9
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8134b48e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Nov 26 16:37:54 portablebastien kernel: [28555.348035] bash          S 0000000100544749     0 20741  20739 0x00000000
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff88000fd75ce8 0000000000000046 0000000000000000 0000000000000000
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff88000fd74010 ffff88000fd75fd8 ffff8800b6c82fa0 ffff8800b6c83270
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff8800b6c83268 0000000000014d80 0000000000014d80 ffff88000fd75fd8
Nov 26 16:37:54 portablebastien kernel: [28555.348035] Call Trace:
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81349f02>] schedule_timeout+0x31/0xeb
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810569a9>] ? del_timer_sync+0x8e/0xa1
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8105691b>] ? del_timer_sync+0x0/0xa1
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810601e6>] ? flush_delayed_work+0x44/0x48
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8122f474>] n_tty_read+0x4cd/0x7af
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81044423>] ? default_wake_function+0x0/0xf
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8122ab48>] tty_read+0x81/0xc5
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81102fc7>] vfs_read+0xa6/0x102
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8134bca9>] ? _raw_spin_unlock_irq+0x2b/0x36
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff811030d9>] sys_read+0x45/0x69
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Nov 26 16:37:54 portablebastien kernel: [28555.348035] bash          S ffff88011f782f90     0 22679   3005 0x00000000
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff88000fc9fe58 0000000000000046 ffff88000fc9fe28 0000000000000246
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff88000fc9e010 ffff88000fc9ffd8 ffff88011f782fa0 ffff88011f783270
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff88011f783268 0000000000014d80 0000000000014d80 ffff88000fc9ffd8
Nov 26 16:37:54 portablebastien kernel: [28555.348035] Call Trace:
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8104c99a>] do_wait+0x1ba/0x22e
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8104caa7>] sys_wait4+0x99/0xbc
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8104af46>] ? child_wait_callback+0x0/0x53
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Nov 26 16:37:54 portablebastien kernel: [28555.348035] ssh           S 000000010045109d     0 22705  22679 0x00000000
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff8800936fb908 0000000000000046 ffff8800936fb878 ffffffff00000000
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff8800936fa010 ffff8800936fbfd8 ffff880091b30000 ffff880091b302d0
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff880091b302c8 0000000000014d80 0000000000014d80 ffff8800936fbfd8
Nov 26 16:37:54 portablebastien kernel: [28555.348035] Call Trace:
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8134a905>] schedule_hrtimeout_range_clock+0x4c/0x12f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8105691b>] ? del_timer_sync+0x0/0xa1
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810601e6>] ? flush_delayed_work+0x44/0x48
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81075039>] ? trace_hardirqs_on+0xd/0xf
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8134a9f6>] schedule_hrtimeout_range+0xe/0x10
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff811112e4>] poll_schedule_timeout+0x43/0x5f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111942>] do_select+0x5b2/0x5ec
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111390>] ? do_select+0x0/0x5ec
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8111197c>] ? __pollwait+0x0/0xc7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8103c39c>] ? task_rq_lock+0x4c/0x7e
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81038223>] ? check_preempt_curr+0x1b/0x34
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81044411>] ? try_to_wake_up+0x172/0x184
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810d9ec8>] ? might_fault+0xa0/0xa7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111d17>] core_sys_select+0x21c/0x2b2
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111b33>] ? core_sys_select+0x38/0x2b2
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8112f82a>] ? fsnotify+0x79/0x449
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8112fbdb>] ? fsnotify+0x42a/0x449
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8112f82a>] ? fsnotify+0x79/0x449
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8103b191>] ? __wake_up+0x3f/0x48
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111fe7>] sys_select+0x91/0xb9
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8134b48e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Nov 26 16:37:54 portablebastien kernel: [28555.348035] nautilus      S 0000000000000000     0 24949   3089 0x00000000
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff88011d6b5a58 0000000000000046 ffff88011d6b59e8 0000000000000000
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff88011d6b4010 ffff88011d6b5fd8 ffff88004b335f40 ffff88004b336210
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff88004b336208 0000000000014d80 0000000000014d80 ffff88011d6b5fd8
Nov 26 16:37:54 portablebastien kernel: [28555.348035] Call Trace:
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8134a905>] schedule_hrtimeout_range_clock+0x4c/0x12f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81075039>] ? trace_hardirqs_on+0xd/0xf
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81064a5b>] ? add_wait_queue+0x3f/0x44
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8134a9f6>] schedule_hrtimeout_range+0xe/0x10
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff811112e4>] poll_schedule_timeout+0x43/0x5f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81112369>] do_sys_poll+0x35a/0x3e5
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8111197c>] ? __pollwait+0x0/0xc7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff811721aa>] ? fsnotify_perm+0x45/0x4b
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81172207>] ? security_file_permission+0x29/0x2e
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81112588>] sys_poll+0x50/0xbb
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Nov 26 16:37:54 portablebastien kernel: [28555.348035] gvfsd-trash   S 000000010044e331     0 24951      1 0x00000000
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff88010aecba58 0000000000000046 ffffffff81067dae 0000000000000000
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff88010aeca010 ffff88010aecbfd8 ffff880091b34f60 ffff880091b35230
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff880091b35228 0000000000014d80 0000000000014d80 ffff88010aecbfd8
Nov 26 16:37:54 portablebastien kernel: [28555.348035] Call Trace:
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81067dae>] ? lock_hrtimer_base+0x25/0x4b
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8134a905>] schedule_hrtimeout_range_clock+0x4c/0x12f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81075039>] ? trace_hardirqs_on+0xd/0xf
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81064a5b>] ? add_wait_queue+0x3f/0x44
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8134a9f6>] schedule_hrtimeout_range+0xe/0x10
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff811112e4>] poll_schedule_timeout+0x43/0x5f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81112369>] do_sys_poll+0x35a/0x3e5
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8111197c>] ? __pollwait+0x0/0xc7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8112fbdb>] ? fsnotify+0x42a/0x449
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8112f82a>] ? fsnotify+0x79/0x449
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff811034f6>] ? do_readv_writev+0x10b/0x124
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8106ccea>] ? ktime_get_ts+0xad/0xba
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111286>] ? poll_select_set_timeout+0x61/0x7c
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81112588>] sys_poll+0x50/0xbb
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Nov 26 16:37:54 portablebastien kernel: [28555.348035] gvfsd-burn    S 000000010044df3d     0 24953      1 0x00000000
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff8801175d1a58 0000000000000046 ffff88004b335f40 0000000000000000
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff8801175d0010 ffff8801175d1fd8 ffff88004b330fe0 ffff88004b3312b0
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff88004b3312a8 0000000000014d80 0000000000014d80 ffff8801175d1fd8
Nov 26 16:37:54 portablebastien kernel: [28555.348035] Call Trace:
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8134a905>] schedule_hrtimeout_range_clock+0x4c/0x12f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81075039>] ? trace_hardirqs_on+0xd/0xf
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81064a5b>] ? add_wait_queue+0x3f/0x44
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8134a9f6>] schedule_hrtimeout_range+0xe/0x10
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff811112e4>] poll_schedule_timeout+0x43/0x5f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81112369>] do_sys_poll+0x35a/0x3e5
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8111197c>] ? __pollwait+0x0/0xc7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8127d68c>] ? sock_aio_write+0x0/0xcf
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8127d747>] ? sock_aio_write+0xbb/0xcf
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8112f82a>] ? fsnotify+0x79/0x449
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8112f82a>] ? fsnotify+0x79/0x449
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8103a7a6>] ? rcu_read_lock+0x0/0x30
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8103a7a6>] ? rcu_read_lock+0x0/0x30
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81042616>] ? finish_task_switch+0x0/0xdf
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81075039>] ? trace_hardirqs_on+0xd/0xf
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8134bca9>] ? _raw_spin_unlock_irq+0x2b/0x36
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81042681>] ? finish_task_switch+0x6b/0xdf
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81042616>] ? finish_task_switch+0x0/0xdf
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81349b12>] ? schedule+0x606/0x652
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81112588>] sys_poll+0x50/0xbb
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Nov 26 16:37:54 portablebastien kernel: [28555.348035] kio_trash     S 0000000000000000     0 25510   2849 0x00000000
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff8800b272f908 0000000000000046 0000000000000040 0000000000000004
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff8800b272e010 ffff8800b272ffd8 ffff8800094fef20 ffff8800094ff1f0
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff8800094ff1e8 0000000000014d80 0000000000014d80 ffff8800b272ffd8
Nov 26 16:37:54 portablebastien kernel: [28555.348035] Call Trace:
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8134a905>] schedule_hrtimeout_range_clock+0x4c/0x12f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81075039>] ? trace_hardirqs_on+0xd/0xf
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81064a5b>] ? add_wait_queue+0x3f/0x44
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8134a9f6>] schedule_hrtimeout_range+0xe/0x10
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff811112e4>] poll_schedule_timeout+0x43/0x5f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111942>] do_select+0x5b2/0x5ec
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111390>] ? do_select+0x0/0x5ec
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8111197c>] ? __pollwait+0x0/0xc7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81044430>] ? default_wake_function+0xd/0xf
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111a90>] ? pollwake+0x4d/0x4f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81044423>] ? default_wake_function+0x0/0xf
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81075039>] ? trace_hardirqs_on+0xd/0xf
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff812f9b03>] ? scm_destroy_cred+0x14/0x40
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff812f9b40>] ? scm_destroy+0x11/0x2a
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810d9ec8>] ? might_fault+0xa0/0xa7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111d17>] core_sys_select+0x21c/0x2b2
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111b33>] ? core_sys_select+0x38/0x2b2
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81042616>] ? finish_task_switch+0x0/0xdf
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81075039>] ? trace_hardirqs_on+0xd/0xf
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8134bca9>] ? _raw_spin_unlock_irq+0x2b/0x36
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81042681>] ? finish_task_switch+0x6b/0xdf
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81042616>] ? finish_task_switch+0x0/0xdf
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111fe7>] sys_select+0x91/0xb9
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8134b48e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Nov 26 16:37:54 portablebastien kernel: [28555.348035] firefox-bin   S 0000000100693941     0 25511      1 0x00000000
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff8800b2189a58 0000000000000046 ffff8800b2189a68 0000000000000000
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff8800b2188010 ffff8800b2189fd8 ffff8800094f8fe0 ffff8800094f92b0
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff8800094f92a8 0000000000014d80 0000000000014d80 ffff8800b2189fd8
Nov 26 16:37:54 portablebastien kernel: [28555.348035] Call Trace:
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8134a905>] schedule_hrtimeout_range_clock+0x4c/0x12f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81075039>] ? trace_hardirqs_on+0xd/0xf
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81064a5b>] ? add_wait_queue+0x3f/0x44
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8134a9f6>] schedule_hrtimeout_range+0xe/0x10
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff811112e4>] poll_schedule_timeout+0x43/0x5f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81112369>] do_sys_poll+0x35a/0x3e5
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8111197c>] ? __pollwait+0x0/0xc7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81279f40>] ? __sock_recvmsg_nosec+0x65/0x6e
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8127b23f>] ? __sock_recvmsg+0x49/0x54
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8127d81d>] ? sock_aio_read+0xc2/0xd6
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81102989>] ? do_sync_read+0xc6/0x103
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81102606>] ? fsnotify_access+0x61/0x69
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81112588>] sys_poll+0x50/0xbb
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Nov 26 16:37:54 portablebastien kernel: [28555.348035] firefox-bin   S 00000001006904b2     0 25516      1 0x00000000
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff88008ec17a58 0000000000000046 0000000000000001 ffff880100000000
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff88008ec16010 ffff88008ec17fd8 ffff8800b7d4cf60 ffff8800b7d4d230
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff8800b7d4d228 0000000000014d80 0000000000014d80 ffff88008ec17fd8
Nov 26 16:37:54 portablebastien kernel: [28555.348035] Call Trace:
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8134a905>] schedule_hrtimeout_range_clock+0x4c/0x12f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81075039>] ? trace_hardirqs_on+0xd/0xf
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8134a9f6>] schedule_hrtimeout_range+0xe/0x10
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff811112e4>] poll_schedule_timeout+0x43/0x5f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81112369>] do_sys_poll+0x35a/0x3e5
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8111197c>] ? __pollwait+0x0/0xc7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81279f40>] ? __sock_recvmsg_nosec+0x65/0x6e
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8127b23f>] ? __sock_recvmsg+0x49/0x54
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8127b3af>] ? sock_recvmsg+0xa6/0xbf
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81115db0>] ? touch_atime+0x10a/0x125
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81103aa5>] ? fget_light+0x41/0xcf
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81103aa5>] ? fget_light+0x41/0xcf
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81103b25>] ? fget_light+0xc1/0xcf
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81103aa5>] ? fget_light+0x41/0xcf
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81102989>] ? do_sync_read+0xc6/0x103
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8127b510>] ? fput_light+0xd/0xf
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8127cd1e>] ? sys_recvfrom+0x10f/0x13c
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81102606>] ? fsnotify_access+0x61/0x69
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81112588>] sys_poll+0x50/0xbb
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Nov 26 16:37:54 portablebastien kernel: [28555.348035] firefox-bin   S 00000001006bc81a     0 25517      1 0x00000000
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff88009181dc28 0000000000000046 ffff88009181dd38 ffff880000000000
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff88009181c010 ffff88009181dfd8 ffff8800d8b78fe0 ffff8800d8b792b0
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff8800d8b792a8 0000000000014d80 0000000000014d80 ffff88009181dfd8
Nov 26 16:37:54 portablebastien kernel: [28555.348035] Call Trace:
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81077c58>] futex_wait_queue_me+0x82/0x99
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81078c47>] futex_wait+0x148/0x2f9
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810676ee>] ? hrtimer_wakeup+0x0/0x21
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8106816a>] ? hrtimer_start_range_ns+0xf/0x11
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81079ebc>] do_futex+0x95/0x86e
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8134b48e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8107a7bc>] sys_futex+0x127/0x13f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8134b504>] ? lockdep_sys_exit_thunk+0x35/0x67
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Nov 26 16:37:54 portablebastien kernel: [28555.348035] firefox-bin   S 00000001006a5919     0 25518      1 0x00000000
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff880091871c28 0000000000000046 ffff880091871d38 ffff880000000000
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff880091870010 ffff880091871fd8 ffff8800b7edef20 ffff8800b7edf1f0
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff8800b7edf1e8 0000000000014d80 0000000000014d80 ffff880091871fd8
Nov 26 16:37:54 portablebastien kernel: [28555.348035] Call Trace:
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81077c58>] futex_wait_queue_me+0x82/0x99
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81078c47>] futex_wait+0x148/0x2f9
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810676ee>] ? hrtimer_wakeup+0x0/0x21
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8106816a>] ? hrtimer_start_range_ns+0xf/0x11
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81079ebc>] do_futex+0x95/0x86e
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8107a7bc>] sys_futex+0x127/0x13f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Nov 26 16:37:54 portablebastien kernel: [28555.348035] firefox-bin   S 000000010068f8cd     0 25563      1 0x00000000
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff8800937e3c28 0000000000000046 ffff8800937e3cb8 ffff880000000000
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff8800937e2010 ffff8800937e3fd8 ffff880037a7df40 ffff880037a7e210
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff880037a7e208 0000000000014d80 0000000000014d80 ffff8800937e3fd8
Nov 26 16:37:54 portablebastien kernel: [28555.348035] Call Trace:
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81077c58>] futex_wait_queue_me+0x82/0x99
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81078c47>] futex_wait+0x148/0x2f9
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8104dee1>] ? current_fs_time+0x22/0x29
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81103aa5>] ? fget_light+0x41/0xcf
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8112f82a>] ? fsnotify+0x79/0x449
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81079ebc>] do_futex+0x95/0x86e
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8112f82a>] ? fsnotify+0x79/0x449
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8107a7bc>] sys_futex+0x127/0x13f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8134b48e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Nov 26 16:37:54 portablebastien kernel: [28555.348035] firefox-bin   S 00000000ffffffff     0 25564      1 0x00000000
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff8800d4493c28 0000000000000046 ffff8800d4493cb8 ffff8800d4493cf0
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff8800d4492010 ffff8800d4493fd8 ffff880099a4ef20 ffff880099a4f1f0
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff880099a4f1e8 0000000000014d80 0000000000014d80 ffff8800d4493fd8
Nov 26 16:37:54 portablebastien kernel: [28555.348035] Call Trace:
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81077c58>] futex_wait_queue_me+0x82/0x99
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81078c47>] futex_wait+0x148/0x2f9
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8103b5d0>] ? update_curr+0xff/0x108
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8103bcdd>] ? dequeue_entity+0x1b/0x117
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81079ebc>] do_futex+0x95/0x86e
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81042616>] ? finish_task_switch+0x0/0xdf
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81042616>] ? finish_task_switch+0x0/0xdf
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81075039>] ? trace_hardirqs_on+0xd/0xf
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8107a7bc>] sys_futex+0x127/0x13f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8134b48e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Nov 26 16:37:54 portablebastien kernel: [28555.348035] firefox-bin   S 00000000ffffffff     0 25568      1 0x00000000
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff8800adff7c28 0000000000000046 ffff8800adff7cb8 ffff8800adff7cf0
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff8800adff6010 ffff8800adff7fd8 ffff88011f6c3f80 ffff88011f6c4250
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff88011f6c4248 0000000000014d80 0000000000014d80 ffff8800adff7fd8
Nov 26 16:37:54 portablebastien kernel: [28555.348035] Call Trace:
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81077c58>] futex_wait_queue_me+0x82/0x99
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81078c47>] futex_wait+0x148/0x2f9
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8104dee1>] ? current_fs_time+0x22/0x29
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8112f82a>] ? fsnotify+0x79/0x449
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81079ebc>] do_futex+0x95/0x86e
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8112f82a>] ? fsnotify+0x79/0x449
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8107a7bc>] sys_futex+0x127/0x13f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8134b48e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Nov 26 16:37:54 portablebastien kernel: [28555.348035] firefox-bin   S 000000010067a575     0 25583      1 0x00000000
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff8800b214fc28 0000000000000046 ffff8800b214fcb8 ffff880000000000
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff8800b214e010 ffff8800b214ffd8 ffff88011da6afa0 ffff88011da6b270
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff88011da6b268 0000000000014d80 0000000000014d80 ffff8800b214ffd8
Nov 26 16:37:54 portablebastien kernel: [28555.348035] Call Trace:
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81077c58>] futex_wait_queue_me+0x82/0x99
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81078c47>] futex_wait+0x148/0x2f9
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8104dee1>] ? current_fs_time+0x22/0x29
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8113a38e>] ? fcntl_setlk+0x244/0x3c2
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81079ebc>] do_futex+0x95/0x86e
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8113a4f4>] ? fcntl_setlk+0x3aa/0x3c2
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8107a7bc>] sys_futex+0x127/0x13f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8134b48e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Nov 26 16:37:54 portablebastien kernel: [28555.348035] octave        S 00000001005fcb4e     0 26553  20156 0x00000000
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff880117a31ce8 0000000000000046 0000000000000000 0000000000000046
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff880117a30010 ffff880117a31fd8 ffff8800094f8000 ffff8800094f82d0
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff8800094f82c8 0000000000014d80 0000000000014d80 ffff880117a31fd8
Nov 26 16:37:54 portablebastien kernel: [28555.348035] Call Trace:
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81075039>] ? trace_hardirqs_on+0xd/0xf
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81349f02>] schedule_timeout+0x31/0xeb
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810569a9>] ? del_timer_sync+0x8e/0xa1
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8105691b>] ? del_timer_sync+0x0/0xa1
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810601e6>] ? flush_delayed_work+0x44/0x48
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8122f474>] n_tty_read+0x4cd/0x7af
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81044423>] ? default_wake_function+0x0/0xf
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8122ab48>] tty_read+0x81/0xc5
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81102fc7>] vfs_read+0xa6/0x102
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8134bca9>] ? _raw_spin_unlock_irq+0x2b/0x36
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff811030d9>] sys_read+0x45/0x69
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Nov 26 16:37:54 portablebastien kernel: [28555.348035] kio_http      S 000000010068d405     0 26739   2849 0x00000000
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff88010afa5908 0000000000000046 ffff88010afa5918 0000000000000000
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff88010afa4010 ffff88010afa5fd8 ffff88011c5bef20 ffff88011c5bf1f0
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff88011c5bf1e8 0000000000014d80 0000000000014d80 ffff88010afa5fd8
Nov 26 16:37:54 portablebastien kernel: [28555.348035] Call Trace:
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8134a905>] schedule_hrtimeout_range_clock+0x4c/0x12f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81075039>] ? trace_hardirqs_on+0xd/0xf
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81064a5b>] ? add_wait_queue+0x3f/0x44
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8134a9f6>] schedule_hrtimeout_range+0xe/0x10
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff811112e4>] poll_schedule_timeout+0x43/0x5f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111942>] do_select+0x5b2/0x5ec
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111390>] ? do_select+0x0/0x5ec
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8111197c>] ? __pollwait+0x0/0xc7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81044430>] ? default_wake_function+0xd/0xf
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111a90>] ? pollwake+0x4d/0x4f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81044423>] ? default_wake_function+0x0/0xf
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81075039>] ? trace_hardirqs_on+0xd/0xf
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff812f9b03>] ? scm_destroy_cred+0x14/0x40
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff812f9b40>] ? scm_destroy+0x11/0x2a
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810d9ec8>] ? might_fault+0xa0/0xa7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111d17>] core_sys_select+0x21c/0x2b2
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111b33>] ? core_sys_select+0x38/0x2b2
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8112f82a>] ? fsnotify+0x79/0x449
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8112fbdb>] ? fsnotify+0x42a/0x449
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8112f82a>] ? fsnotify+0x79/0x449
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111fe7>] sys_select+0x91/0xb9
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8134b48e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Nov 26 16:37:54 portablebastien kernel: [28555.348035] gnuplot       S 0000000000000000     0 27427  26553 0x00000000
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff8800b6c2d908 0000000000000046 ffff88011c318000 0000000000000000
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff8800b6c2c010 ffff8800b6c2dfd8 ffff88011f6c1fc0 ffff88011f6c2290
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff88011f6c2288 0000000000014d80 0000000000014d80 ffff8800b6c2dfd8
Nov 26 16:37:54 portablebastien kernel: [28555.348035] Call Trace:
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8134a905>] schedule_hrtimeout_range_clock+0x4c/0x12f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81075039>] ? trace_hardirqs_on+0xd/0xf
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8134a9f6>] schedule_hrtimeout_range+0xe/0x10
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff811112e4>] poll_schedule_timeout+0x43/0x5f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111942>] do_select+0x5b2/0x5ec
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111390>] ? do_select+0x0/0x5ec
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8111197c>] ? __pollwait+0x0/0xc7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81038223>] ? check_preempt_curr+0x1b/0x34
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81073728>] ? trace_hardirqs_off+0xd/0xf
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8134bcef>] ? _raw_spin_unlock_irqrestore+0x3b/0x51
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81044430>] ? default_wake_function+0xd/0xf
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810d9ec8>] ? might_fault+0xa0/0xa7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111d17>] core_sys_select+0x21c/0x2b2
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111b33>] ? core_sys_select+0x38/0x2b2
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8112f82a>] ? fsnotify+0x79/0x449
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8112fbdb>] ? fsnotify+0x42a/0x449
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8112f82a>] ? fsnotify+0x79/0x449
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111fe7>] sys_select+0x91/0xb9
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8134b48e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Nov 26 16:37:54 portablebastien kernel: [28555.348035] gnuplot_x11   S 0000000000000000     0 27430  27427 0x00000000
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff88001cadf908 0000000000000046 0000000000000001 0000000000000000
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff88001cade010 ffff88001cadffd8 ffff880037a78000 ffff880037a782d0
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff880037a782c8 0000000000014d80 0000000000014d80 ffff88001cadffd8
Nov 26 16:37:54 portablebastien kernel: [28555.348035] Call Trace:
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8134a905>] schedule_hrtimeout_range_clock+0x4c/0x12f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81075039>] ? trace_hardirqs_on+0xd/0xf
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81064a5b>] ? add_wait_queue+0x3f/0x44
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8134a9f6>] schedule_hrtimeout_range+0xe/0x10
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff811112e4>] poll_schedule_timeout+0x43/0x5f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111942>] do_select+0x5b2/0x5ec
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111390>] ? do_select+0x0/0x5ec
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8111197c>] ? __pollwait+0x0/0xc7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff812fb5b8>] ? unix_stream_recvmsg+0x5a3/0x5c3
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff812fb826>] ? unix_stream_sendmsg+0x24e/0x2d0
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810d9ec8>] ? might_fault+0xa0/0xa7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111d17>] core_sys_select+0x21c/0x2b2
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111b33>] ? core_sys_select+0x38/0x2b2
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81102989>] ? do_sync_read+0xc6/0x103
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff811721aa>] ? fsnotify_perm+0x45/0x4b
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111fe7>] sys_select+0x91/0xb9
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8134b48e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Nov 26 16:37:54 portablebastien kernel: [28555.348035] kio_trash     S 00000001004fcad8     0 27926   2849 0x00000000
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff8801177a1908 0000000000000046 ffff8801177a18c8 ffffffff00000001
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff8801177a0010 ffff8801177a1fd8 ffff88004b331fc0 ffff88004b332290
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff88004b332288 0000000000014d80 0000000000014d80 ffff8801177a1fd8
Nov 26 16:37:54 portablebastien kernel: [28555.348035] Call Trace:
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8134a905>] schedule_hrtimeout_range_clock+0x4c/0x12f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81075039>] ? trace_hardirqs_on+0xd/0xf
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81064a5b>] ? add_wait_queue+0x3f/0x44
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8134a9f6>] schedule_hrtimeout_range+0xe/0x10
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff811112e4>] poll_schedule_timeout+0x43/0x5f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111942>] do_select+0x5b2/0x5ec
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111390>] ? do_select+0x0/0x5ec
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff811132f9>] ? d_rehash+0x23/0x44
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8111197c>] ? __pollwait+0x0/0xc7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8128294c>] ? skb_queue_tail+0x1f/0x48
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8127e6d7>] ? rcu_read_lock+0x0/0x30
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8127e6d7>] ? rcu_read_lock+0x0/0x30
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff812f9b03>] ? scm_destroy_cred+0x14/0x40
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff812f9b40>] ? scm_destroy+0x11/0x2a
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810d9ec8>] ? might_fault+0xa0/0xa7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111d17>] core_sys_select+0x21c/0x2b2
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111b33>] ? core_sys_select+0x38/0x2b2
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8112f82a>] ? fsnotify+0x79/0x449
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8112fbdb>] ? fsnotify+0x42a/0x449
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8112f82a>] ? fsnotify+0x79/0x449
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111fe7>] sys_select+0x91/0xb9
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8134b48e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Nov 26 16:37:54 portablebastien kernel: [28555.348035] krunner       S 00000001006bc2c1     0 27964      1 0x00000000
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff88001fab7a58 0000000000000046 ffff88001fab7a68 000019f900000000
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff88001fab6010 ffff88001fab7fd8 ffff8800b7d1cf60 ffff8800b7d1d230
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff8800b7d1d228 0000000000014d80 0000000000014d80 ffff88001fab7fd8
Nov 26 16:37:54 portablebastien kernel: [28555.348035] Call Trace:
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8134a9a1>] schedule_hrtimeout_range_clock+0xe8/0x12f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810676ee>] ? hrtimer_wakeup+0x0/0x21
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8106816a>] ? hrtimer_start_range_ns+0xf/0x11
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8134a9f6>] schedule_hrtimeout_range+0xe/0x10
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff811112e4>] poll_schedule_timeout+0x43/0x5f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81112369>] do_sys_poll+0x35a/0x3e5
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8111197c>] ? __pollwait+0x0/0xc7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81102989>] ? do_sync_read+0xc6/0x103
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff811721aa>] ? fsnotify_perm+0x45/0x4b
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8106ccea>] ? ktime_get_ts+0xad/0xba
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111286>] ? poll_select_set_timeout+0x61/0x7c
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81112588>] sys_poll+0x50/0xbb
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Nov 26 16:37:54 portablebastien kernel: [28555.348035] gnuplot       S 0000000000000000     0 28473  26553 0x00000000
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff880064495908 0000000000000046 ffff8800644958e8 ffffffff00000000
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff880064494010 ffff880064495fd8 ffff88011c23bf80 ffff88011c23c250
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff88011c23c248 0000000000014d80 0000000000014d80 ffff880064495fd8
Nov 26 16:37:54 portablebastien kernel: [28555.348035] Call Trace:
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8134a905>] schedule_hrtimeout_range_clock+0x4c/0x12f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81075039>] ? trace_hardirqs_on+0xd/0xf
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8134a9f6>] schedule_hrtimeout_range+0xe/0x10
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff811112e4>] poll_schedule_timeout+0x43/0x5f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111942>] do_select+0x5b2/0x5ec
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111390>] ? do_select+0x0/0x5ec
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8103a7a6>] ? rcu_read_lock+0x0/0x30
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8111197c>] ? __pollwait+0x0/0xc7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81038223>] ? check_preempt_curr+0x1b/0x34
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81073728>] ? trace_hardirqs_off+0xd/0xf
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8134bcef>] ? _raw_spin_unlock_irqrestore+0x3b/0x51
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81044430>] ? default_wake_function+0xd/0xf
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810d9ec8>] ? might_fault+0xa0/0xa7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111d17>] core_sys_select+0x21c/0x2b2
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111b33>] ? core_sys_select+0x38/0x2b2
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8112f82a>] ? fsnotify+0x79/0x449
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8112fbdb>] ? fsnotify+0x42a/0x449
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8112f82a>] ? fsnotify+0x79/0x449
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111fe7>] sys_select+0x91/0xb9
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8134b48e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Nov 26 16:37:54 portablebastien kernel: [28555.348035] gnuplot_x11   S 0000000000000000     0 28474  28473 0x00000000
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff880019f51908 0000000000000046 0000000000000000 ffff880000000000
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff880019f50010 ffff880019f51fd8 ffff880093624f60 ffff880093625230
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff880093625228 0000000000014d80 0000000000014d80 ffff880019f51fd8
Nov 26 16:37:54 portablebastien kernel: [28555.348035] Call Trace:
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8134a905>] schedule_hrtimeout_range_clock+0x4c/0x12f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81075039>] ? trace_hardirqs_on+0xd/0xf
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81064a5b>] ? add_wait_queue+0x3f/0x44
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8134a9f6>] schedule_hrtimeout_range+0xe/0x10
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff811112e4>] poll_schedule_timeout+0x43/0x5f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111942>] do_select+0x5b2/0x5ec
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111390>] ? do_select+0x0/0x5ec
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8111197c>] ? __pollwait+0x0/0xc7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff812fb5b8>] ? unix_stream_recvmsg+0x5a3/0x5c3
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff812fb826>] ? unix_stream_sendmsg+0x24e/0x2d0
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810d9ec8>] ? might_fault+0xa0/0xa7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111d17>] core_sys_select+0x21c/0x2b2
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111b33>] ? core_sys_select+0x38/0x2b2
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81102989>] ? do_sync_read+0xc6/0x103
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff811721aa>] ? fsnotify_perm+0x45/0x4b
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111fe7>] sys_select+0x91/0xb9
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8134b48e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Nov 26 16:37:54 portablebastien kernel: [28555.348035] kworker/1:1   S 0000000000015740     0 30251      2 0x00000000
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff880039857e50 0000000000000046 ffffffff8105f151 ffff88011dab2e40
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff880039856010 ffff880039857fd8 ffff880037a78fe0 ffff880037a792b0
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff880037a792a8 0000000000014d80 0000000000014d80 ffff880039857fd8
Nov 26 16:37:54 portablebastien kernel: [28555.348035] Call Trace:
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8105f151>] ? process_one_work+0x31e/0x392
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81060ef3>] worker_thread+0x24c/0x251
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81060ca7>] ? worker_thread+0x0/0x251
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810642a2>] kthread+0x8c/0x94
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8100a964>] kernel_thread_helper+0x4/0x10
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8134c110>] ? restore_args+0x0/0x30
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81064216>] ? kthread+0x0/0x94
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8100a960>] ? kernel_thread_helper+0x0/0x10
Nov 26 16:37:54 portablebastien kernel: [28555.348035] bash          S 0000000000000000     0 30541   3005 0x00000000
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff880016099ce8 0000000000000046 0000000000000000 0000000000000046
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff880016098010 ffff880016099fd8 ffff880037a7bf80 ffff880037a7c250
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff880037a7c248 0000000000014d80 0000000000014d80 ffff880016099fd8
Nov 26 16:37:54 portablebastien kernel: [28555.348035] Call Trace:
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81075039>] ? trace_hardirqs_on+0xd/0xf
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81349f02>] schedule_timeout+0x31/0xeb
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810569a9>] ? del_timer_sync+0x8e/0xa1
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8105691b>] ? del_timer_sync+0x0/0xa1
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810601e6>] ? flush_delayed_work+0x44/0x48
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8122f474>] n_tty_read+0x4cd/0x7af
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81044423>] ? default_wake_function+0x0/0xf
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8122ab48>] tty_read+0x81/0xc5
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81102fc7>] vfs_read+0xa6/0x102
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8134bca9>] ? _raw_spin_unlock_irq+0x2b/0x36
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff811030d9>] sys_read+0x45/0x69
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Nov 26 16:37:54 portablebastien kernel: [28555.348035] kio_file      S 00000001006985e0     0 31524   2849 0x00000000
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff88000fc1b908 0000000000000046 ffffea00020f3620 0000000000000000
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff88000fc1a010 ffff88000fc1bfd8 ffff8800d4534f60 ffff8800d4535230
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff8800d4535228 0000000000014d80 0000000000014d80 ffff88000fc1bfd8
Nov 26 16:37:54 portablebastien kernel: [28555.348035] Call Trace:
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8134a905>] schedule_hrtimeout_range_clock+0x4c/0x12f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81075039>] ? trace_hardirqs_on+0xd/0xf
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81064a5b>] ? add_wait_queue+0x3f/0x44
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8134a9f6>] schedule_hrtimeout_range+0xe/0x10
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff811112e4>] poll_schedule_timeout+0x43/0x5f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111942>] do_select+0x5b2/0x5ec
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111390>] ? do_select+0x0/0x5ec
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8103d088>] ? select_task_rq_fair+0x70d/0x712
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8111197c>] ? __pollwait+0x0/0xc7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81044430>] ? default_wake_function+0xd/0xf
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111a90>] ? pollwake+0x4d/0x4f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81044423>] ? default_wake_function+0x0/0xf
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81075039>] ? trace_hardirqs_on+0xd/0xf
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff812f9b03>] ? scm_destroy_cred+0x14/0x40
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff812f9b40>] ? scm_destroy+0x11/0x2a
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810d9ec8>] ? might_fault+0xa0/0xa7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111d17>] core_sys_select+0x21c/0x2b2
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111b33>] ? core_sys_select+0x38/0x2b2
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8112f82a>] ? fsnotify+0x79/0x449
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8112fbdb>] ? fsnotify+0x42a/0x449
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8112f82a>] ? fsnotify+0x79/0x449
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111fe7>] sys_select+0x91/0xb9
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8134b48e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Nov 26 16:37:54 portablebastien kernel: [28555.348035] okular        D 000000010069a3b0     0 31706   2849 0x00000000
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff8800645cf9c8 0000000000000046 ffff880000000000 ffff880100000000
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff8800645ce010 ffff8800645cffd8 ffff8800bfe9bf80 ffff8800bfe9c250
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff8800bfe9c248 0000000000014d80 0000000000014d80 ffff8800645cffd8
Nov 26 16:37:54 portablebastien kernel: [28555.348035] Call Trace:
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffffa01b8454>] queue_log_writer+0x7e/0xaf [reiserfs]
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81044423>] ? default_wake_function+0x0/0xf
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffffa01bc402>] do_journal_begin_r+0x1ee/0x2d8 [reiserfs]
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffffa01bc5ae>] journal_begin+0xc2/0x103 [reiserfs]
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffffa01a1a05>] reiserfs_truncate_file+0x191/0x29f [reiserfs]
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffffa01a3b5c>] reiserfs_vfs_truncate_file+0x28/0x35 [reiserfs]
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810ccd3d>] vmtruncate+0x3f/0x4a
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffffa019fcfe>] reiserfs_setattr+0x29f/0x328 [reiserfs]
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81117569>] notify_change+0x19d/0x298
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff811021b8>] do_truncate+0x67/0x84
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8110b45a>] ? get_write_access+0x41/0x48
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8110cfe5>] do_last+0x463/0x532
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8110eb96>] do_filp_open+0x203/0x599
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8134bd2b>] ? _raw_spin_unlock+0x26/0x2a
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff811184a0>] ? alloc_fd+0x170/0x182
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81101366>] do_sys_open+0x5b/0xf7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8134b48e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8110142b>] sys_open+0x1b/0x1d
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Nov 26 16:37:54 portablebastien kernel: [28555.348035] gnuplot       S 0000000000000000     0 32616  26553 0x00000000
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff880039837908 0000000000000046 ffff8800398378e8 ffffffff81126533
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff880039836010 ffff880039837fd8 ffff8800b7d4ef20 ffff8800b7d4f1f0
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff8800b7d4f1e8 0000000000014d80 0000000000014d80 ffff880039837fd8
Nov 26 16:37:54 portablebastien kernel: [28555.348035] Call Trace:
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81126533>] ? __find_get_block+0x1a3/0x1b5
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8134a905>] schedule_hrtimeout_range_clock+0x4c/0x12f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810c72bc>] ? zone_watermark_ok+0x24/0xb5
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81075039>] ? trace_hardirqs_on+0xd/0xf
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8134a9f6>] schedule_hrtimeout_range+0xe/0x10
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff811112e4>] poll_schedule_timeout+0x43/0x5f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111942>] do_select+0x5b2/0x5ec
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111390>] ? do_select+0x0/0x5ec
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8103a7a6>] ? rcu_read_lock+0x0/0x30
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8111197c>] ? __pollwait+0x0/0xc7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8110a79a>] ? pipe_read+0x6d/0x3b6
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8103b115>] ? __wake_up_sync_key+0x22/0x52
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8103b115>] ? __wake_up_sync_key+0x22/0x52
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810d9ec8>] ? might_fault+0xa0/0xa7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111d17>] core_sys_select+0x21c/0x2b2
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111b33>] ? core_sys_select+0x38/0x2b2
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81102989>] ? do_sync_read+0xc6/0x103
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111fe7>] sys_select+0x91/0xb9
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8134b48e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Nov 26 16:37:54 portablebastien kernel: [28555.348035] gnuplot_x11   S 0000000000000000     0 32617  32616 0x00000000
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff88003de05908 0000000000000046 0000000000000000 0000000000000000
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff88003de04010 ffff88003de05fd8 ffff8800b7d4df40 ffff8800b7d4e210
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff8800b7d4e208 0000000000014d80 0000000000014d80 ffff88003de05fd8
Nov 26 16:37:54 portablebastien kernel: [28555.348035] Call Trace:
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8134a905>] schedule_hrtimeout_range_clock+0x4c/0x12f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81075039>] ? trace_hardirqs_on+0xd/0xf
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81064a5b>] ? add_wait_queue+0x3f/0x44
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8134a9f6>] schedule_hrtimeout_range+0xe/0x10
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff811112e4>] poll_schedule_timeout+0x43/0x5f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111942>] do_select+0x5b2/0x5ec
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111390>] ? do_select+0x0/0x5ec
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8111197c>] ? __pollwait+0x0/0xc7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff812fb5b8>] ? unix_stream_recvmsg+0x5a3/0x5c3
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff812fb826>] ? unix_stream_sendmsg+0x24e/0x2d0
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810d9ec8>] ? might_fault+0xa0/0xa7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111d17>] core_sys_select+0x21c/0x2b2
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111b33>] ? core_sys_select+0x38/0x2b2
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81102989>] ? do_sync_read+0xc6/0x103
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff811721aa>] ? fsnotify_perm+0x45/0x4b
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111fe7>] sys_select+0x91/0xb9
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8134b48e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Nov 26 16:37:54 portablebastien kernel: [28555.348035] aspell        S ffff88000f91bec8     0 32645   9241 0x00000000
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff88000f91bcd8 0000000000000046 ffff88002ff2fc18 0000000000000046
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff88000f91a010 ffff88000f91bfd8 ffff88004b330000 ffff88004b3302d0
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff88004b3302c8 0000000000014d80 0000000000014d80 ffff88000f91bfd8
Nov 26 16:37:54 portablebastien kernel: [28555.348035] Call Trace:
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8110a1e2>] pipe_wait+0x5e/0x7a
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8106473b>] ? autoremove_wake_function+0x0/0x34
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8134a8b4>] ? mutex_lock_nested+0x39/0x3e
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8110aa62>] pipe_read+0x335/0x3b6
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8112f82a>] ? fsnotify+0x79/0x449
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81102989>] do_sync_read+0xc6/0x103
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff811721aa>] ? fsnotify_perm+0x45/0x4b
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81172207>] ? security_file_permission+0x29/0x2e
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81102fc7>] vfs_read+0xa6/0x102
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff811030d9>] sys_read+0x45/0x69
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Nov 26 16:37:54 portablebastien kernel: [28555.348035] kworker/0:2   S 0000000000015740     0   855      2 0x00000000
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff8800c738fe50 0000000000000046 ffffffff8105f151 ffff88002fedb780
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff8800c738e010 ffff8800c738ffd8 ffff8800c200ef20 ffff8800c200f1f0
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff8800c200f1e8 0000000000014d80 0000000000014d80 ffff8800c738ffd8
Nov 26 16:37:54 portablebastien kernel: [28555.348035] Call Trace:
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8105f151>] ? process_one_work+0x31e/0x392
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81060ef3>] worker_thread+0x24c/0x251
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81060ca7>] ? worker_thread+0x0/0x251
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810642a2>] kthread+0x8c/0x94
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8100a964>] kernel_thread_helper+0x4/0x10
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8134c110>] ? restore_args+0x0/0x30
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81064216>] ? kthread+0x0/0x94
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8100a960>] ? kernel_thread_helper+0x0/0x10
Nov 26 16:37:54 portablebastien kernel: [28555.348035] kio_http      S 000000010068d49b     0  1177   2849 0x00000000
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff8800918a9908 0000000000000046 ffff880000000041 0000000000000000
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff8800918a8010 ffff8800918a9fd8 ffff880091b31fc0 ffff880091b32290
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff880091b32288 0000000000014d80 0000000000014d80 ffff8800918a9fd8
Nov 26 16:37:54 portablebastien kernel: [28555.348035] Call Trace:
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8134a905>] schedule_hrtimeout_range_clock+0x4c/0x12f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81075039>] ? trace_hardirqs_on+0xd/0xf
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81064a5b>] ? add_wait_queue+0x3f/0x44
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8134a9f6>] schedule_hrtimeout_range+0xe/0x10
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff811112e4>] poll_schedule_timeout+0x43/0x5f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111942>] do_select+0x5b2/0x5ec
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111390>] ? do_select+0x0/0x5ec
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8111197c>] ? __pollwait+0x0/0xc7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8128294c>] ? skb_queue_tail+0x1f/0x48
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8127e6d7>] ? rcu_read_lock+0x0/0x30
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8127e6d7>] ? rcu_read_lock+0x0/0x30
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff812f9b03>] ? scm_destroy_cred+0x14/0x40
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff812f9b40>] ? scm_destroy+0x11/0x2a
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810d9ec8>] ? might_fault+0xa0/0xa7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111d17>] core_sys_select+0x21c/0x2b2
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111b33>] ? core_sys_select+0x38/0x2b2
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8112f82a>] ? fsnotify+0x79/0x449
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8112fbdb>] ? fsnotify+0x42a/0x449
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8112f82a>] ? fsnotify+0x79/0x449
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111fe7>] sys_select+0x91/0xb9
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8134b48e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Nov 26 16:37:54 portablebastien kernel: [28555.348035] kworker/u:0   S 0000000000015740     0  1333      2 0x00000000
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff88002feebe50 0000000000000046 ffffffff8105f151 ffff8800c457f480
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff88002feea010 ffff88002feebfd8 ffff880091b30fe0 ffff880091b312b0
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff880091b312a8 0000000000014d80 0000000000014d80 ffff88002feebfd8
Nov 26 16:37:54 portablebastien kernel: [28555.348035] Call Trace:
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8105f151>] ? process_one_work+0x31e/0x392
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81060ef3>] worker_thread+0x24c/0x251
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81060ca7>] ? worker_thread+0x0/0x251
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810642a2>] kthread+0x8c/0x94
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8100a964>] kernel_thread_helper+0x4/0x10
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8134c110>] ? restore_args+0x0/0x30
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81064216>] ? kthread+0x0/0x94
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8100a960>] ? kernel_thread_helper+0x0/0x10
Nov 26 16:37:54 portablebastien kernel: [28555.348035] kio_http      S 0000000000000000     0  1346   2849 0x00000000
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff88000fda3908 0000000000000046 ffff880000000041 0000000000000046
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff88000fda2010 ffff88000fda3fd8 ffff8800b6c81fc0 ffff8800b6c82290
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff8800b6c82288 0000000000014d80 0000000000014d80 ffff88000fda3fd8
Nov 26 16:37:54 portablebastien kernel: [28555.348035] Call Trace:
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8134a905>] schedule_hrtimeout_range_clock+0x4c/0x12f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81075039>] ? trace_hardirqs_on+0xd/0xf
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81064a5b>] ? add_wait_queue+0x3f/0x44
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8134a9f6>] schedule_hrtimeout_range+0xe/0x10
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff811112e4>] poll_schedule_timeout+0x43/0x5f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111942>] do_select+0x5b2/0x5ec
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111390>] ? do_select+0x0/0x5ec
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8111197c>] ? __pollwait+0x0/0xc7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8128294c>] ? skb_queue_tail+0x1f/0x48
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8127e6d7>] ? rcu_read_lock+0x0/0x30
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8127e6d7>] ? rcu_read_lock+0x0/0x30
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff812f9b03>] ? scm_destroy_cred+0x14/0x40
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff812f9b40>] ? scm_destroy+0x11/0x2a
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810d9ec8>] ? might_fault+0xa0/0xa7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111d17>] core_sys_select+0x21c/0x2b2
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111b33>] ? core_sys_select+0x38/0x2b2
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8112f82a>] ? fsnotify+0x79/0x449
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8112fbdb>] ? fsnotify+0x42a/0x449
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8112f82a>] ? fsnotify+0x79/0x449
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111fe7>] sys_select+0x91/0xb9
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8134b48e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Nov 26 16:37:54 portablebastien kernel: [28555.348035] kio_smtp      S 0000000000000000     0  1585   2849 0x00000000
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff8800767df908 0000000000000046 ffff8800767df888 ffffffff8134b670
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff8800767de010 ffff8800767dffd8 ffff880093620000 ffff8800936202d0
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff8800936202c8 0000000000014d80 0000000000014d80 ffff8800767dffd8
Nov 26 16:37:54 portablebastien kernel: [28555.348035] Call Trace:
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8134b670>] ? _raw_spin_lock+0x34/0x3b
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8134a905>] schedule_hrtimeout_range_clock+0x4c/0x12f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81075039>] ? trace_hardirqs_on+0xd/0xf
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81064a5b>] ? add_wait_queue+0x3f/0x44
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8134a9f6>] schedule_hrtimeout_range+0xe/0x10
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff811112e4>] poll_schedule_timeout+0x43/0x5f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111942>] do_select+0x5b2/0x5ec
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111390>] ? do_select+0x0/0x5ec
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8111197c>] ? __pollwait+0x0/0xc7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8128294c>] ? skb_queue_tail+0x1f/0x48
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8127e6d7>] ? rcu_read_lock+0x0/0x30
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8127e6d7>] ? rcu_read_lock+0x0/0x30
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff812f9b03>] ? scm_destroy_cred+0x14/0x40
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff812f9b40>] ? scm_destroy+0x11/0x2a
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810d9ec8>] ? might_fault+0xa0/0xa7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111d17>] core_sys_select+0x21c/0x2b2
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111b33>] ? core_sys_select+0x38/0x2b2
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8112f82a>] ? fsnotify+0x79/0x449
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8112fbdb>] ? fsnotify+0x42a/0x449
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8112f82a>] ? fsnotify+0x79/0x449
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111fe7>] sys_select+0x91/0xb9
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8134b48e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Nov 26 16:37:54 portablebastien kernel: [28555.348035] bash          S 000000010066610d     0  1589   3005 0x00000000
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff88002fe1fce8 0000000000000046 0000000000000000 0000000000000000
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff88002fe1e010 ffff88002fe1ffd8 ffff880093623f80 ffff880093624250
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff880093624248 0000000000014d80 0000000000014d80 ffff88002fe1ffd8
Nov 26 16:37:54 portablebastien kernel: [28555.348035] Call Trace:
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81349f02>] schedule_timeout+0x31/0xeb
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810569a9>] ? del_timer_sync+0x8e/0xa1
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8105691b>] ? del_timer_sync+0x0/0xa1
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810601e6>] ? flush_delayed_work+0x44/0x48
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8122f474>] n_tty_read+0x4cd/0x7af
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81044423>] ? default_wake_function+0x0/0xf
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8122ab48>] tty_read+0x81/0xc5
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81102fc7>] vfs_read+0xa6/0x102
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8134bca9>] ? _raw_spin_unlock_irq+0x2b/0x36
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff811030d9>] sys_read+0x45/0x69
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Nov 26 16:37:54 portablebastien kernel: [28555.348035] kio_http      S 0000000000000000     0  1593   2849 0x00000000
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff88000fd2b908 0000000000000046 ffff88000fd2b868 ffffffff8134a32b
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff88000fd2a010 ffff88000fd2bfd8 ffff880093626f20 ffff8800936271f0
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff8800936271e8 0000000000014d80 0000000000014d80 ffff88000fd2bfd8
Nov 26 16:37:54 portablebastien kernel: [28555.348035] Call Trace:
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8134a32b>] ? mutex_unlock+0x9/0xb
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8134a905>] schedule_hrtimeout_range_clock+0x4c/0x12f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81075039>] ? trace_hardirqs_on+0xd/0xf
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81064a5b>] ? add_wait_queue+0x3f/0x44
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8134a9f6>] schedule_hrtimeout_range+0xe/0x10
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff811112e4>] poll_schedule_timeout+0x43/0x5f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111942>] do_select+0x5b2/0x5ec
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111390>] ? do_select+0x0/0x5ec
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff812a3e3b>] ? sch_direct_xmit+0x98/0x14e
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8111197c>] ? __pollwait+0x0/0xc7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8128294c>] ? skb_queue_tail+0x1f/0x48
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8127e6d7>] ? rcu_read_lock+0x0/0x30
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8127e6d7>] ? rcu_read_lock+0x0/0x30
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff812f9b03>] ? scm_destroy_cred+0x14/0x40
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff812f9b40>] ? scm_destroy+0x11/0x2a
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810d9ec8>] ? might_fault+0xa0/0xa7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111d17>] core_sys_select+0x21c/0x2b2
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111b33>] ? core_sys_select+0x38/0x2b2
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8112f82a>] ? fsnotify+0x79/0x449
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8112fbdb>] ? fsnotify+0x42a/0x449
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8112f82a>] ? fsnotify+0x79/0x449
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111fe7>] sys_select+0x91/0xb9
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8134b48e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Nov 26 16:37:54 portablebastien kernel: [28555.348035] kio_http      S 0000000000000000     0  2175   2849 0x00000000
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff88001cb57908 0000000000000046 ffff88001cb57918 0000000000000000
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff88001cb56010 ffff88001cb57fd8 ffff8800b7d4bf80 ffff8800b7d4c250
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff8800b7d4c248 0000000000014d80 0000000000014d80 ffff88001cb57fd8
Nov 26 16:37:54 portablebastien kernel: [28555.348035] Call Trace:
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8134a905>] schedule_hrtimeout_range_clock+0x4c/0x12f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81075039>] ? trace_hardirqs_on+0xd/0xf
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81064a5b>] ? add_wait_queue+0x3f/0x44
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8134a9f6>] schedule_hrtimeout_range+0xe/0x10
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff811112e4>] poll_schedule_timeout+0x43/0x5f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111942>] do_select+0x5b2/0x5ec
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111390>] ? do_select+0x0/0x5ec
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff812a3e3b>] ? sch_direct_xmit+0x98/0x14e
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8111197c>] ? __pollwait+0x0/0xc7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8128294c>] ? skb_queue_tail+0x1f/0x48
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8127e6d7>] ? rcu_read_lock+0x0/0x30
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8127e6d7>] ? rcu_read_lock+0x0/0x30
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff812f9b03>] ? scm_destroy_cred+0x14/0x40
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff812f9b40>] ? scm_destroy+0x11/0x2a
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810d9ec8>] ? might_fault+0xa0/0xa7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111d17>] core_sys_select+0x21c/0x2b2
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111b33>] ? core_sys_select+0x38/0x2b2
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8112f82a>] ? fsnotify+0x79/0x449
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8112fbdb>] ? fsnotify+0x42a/0x449
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8112f82a>] ? fsnotify+0x79/0x449
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111fe7>] sys_select+0x91/0xb9
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8134b48e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Nov 26 16:37:54 portablebastien kernel: [28555.348035] pickup        S 00000001006bba8a     0  2297   2414 0x00000000
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff88000fc6be08 0000000000000046 ffffffff810564ac 0000000000000000
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff88000fc6a010 ffff88000fc6bfd8 ffff8800094fdf40 ffff8800094fe210
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff8800094fe208 0000000000014d80 0000000000014d80 ffff88000fc6bfd8
Nov 26 16:37:54 portablebastien kernel: [28555.348035] Call Trace:
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810564ac>] ? lock_timer_base+0x27/0x4d
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81349f84>] schedule_timeout+0xb3/0xeb
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810565d3>] ? process_timeout+0x0/0xb
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff811334bd>] sys_epoll_wait+0x1b1/0x2b1
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81044423>] ? default_wake_function+0x0/0xf
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Nov 26 16:37:54 portablebastien kernel: [28555.348035] kio_http      S 000000010069b801     0  2298   2849 0x00000000
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff8800b7e61908 0000000000000046 ffff8800b7e61918 0000000000000000
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff8800b7e60010 ffff8800b7e61fd8 ffff8800094fbf80 ffff8800094fc250
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff8800094fc248 0000000000014d80 0000000000014d80 ffff8800b7e61fd8
Nov 26 16:37:54 portablebastien kernel: [28555.348035] Call Trace:
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8134a905>] schedule_hrtimeout_range_clock+0x4c/0x12f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81075039>] ? trace_hardirqs_on+0xd/0xf
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81064a5b>] ? add_wait_queue+0x3f/0x44
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8134a9f6>] schedule_hrtimeout_range+0xe/0x10
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff811112e4>] poll_schedule_timeout+0x43/0x5f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111942>] do_select+0x5b2/0x5ec
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111390>] ? do_select+0x0/0x5ec
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8111197c>] ? __pollwait+0x0/0xc7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8128294c>] ? skb_queue_tail+0x1f/0x48
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8127e6d7>] ? rcu_read_lock+0x0/0x30
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8127e6d7>] ? rcu_read_lock+0x0/0x30
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff812f9b03>] ? scm_destroy_cred+0x14/0x40
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff812f9b40>] ? scm_destroy+0x11/0x2a
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810d9ec8>] ? might_fault+0xa0/0xa7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111d17>] core_sys_select+0x21c/0x2b2
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111b33>] ? core_sys_select+0x38/0x2b2
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8112f82a>] ? fsnotify+0x79/0x449
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8112fbdb>] ? fsnotify+0x42a/0x449
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8112f82a>] ? fsnotify+0x79/0x449
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111fe7>] sys_select+0x91/0xb9
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8134b48e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Nov 26 16:37:54 portablebastien kernel: [28555.348035] kio_http      S 0000000100690fa3     0  2741   2849 0x00000000
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff8800b2785908 0000000000000046 ffffffff81067dae 0000000000000000
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff8800b2784010 ffff8800b2785fd8 ffff88011bf20000 ffff88011bf202d0
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff88011bf202c8 0000000000014d80 0000000000014d80 ffff8800b2785fd8
Nov 26 16:37:54 portablebastien kernel: [28555.348035] Call Trace:
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81067dae>] ? lock_hrtimer_base+0x25/0x4b
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8134a905>] schedule_hrtimeout_range_clock+0x4c/0x12f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81075039>] ? trace_hardirqs_on+0xd/0xf
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81064a5b>] ? add_wait_queue+0x3f/0x44
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8134a9f6>] schedule_hrtimeout_range+0xe/0x10
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff811112e4>] poll_schedule_timeout+0x43/0x5f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111942>] do_select+0x5b2/0x5ec
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111390>] ? do_select+0x0/0x5ec
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff812a3e3b>] ? sch_direct_xmit+0x98/0x14e
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8111197c>] ? __pollwait+0x0/0xc7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff812b9ca6>] ? ip_finish_output2+0x1d5/0x218
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff812b9d4c>] ? ip_finish_output+0x63/0x68
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810564ac>] ? lock_timer_base+0x27/0x4d
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810564ac>] ? lock_timer_base+0x27/0x4d
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81056c0e>] ? __mod_timer+0x126/0x138
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810d9ec8>] ? might_fault+0xa0/0xa7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111d17>] core_sys_select+0x21c/0x2b2
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111b33>] ? core_sys_select+0x38/0x2b2
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810f9214>] ? __slab_free+0x85/0x287
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81075039>] ? trace_hardirqs_on+0xd/0xf
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81112b09>] ? __d_free+0x51/0x55
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81112b3f>] ? d_free+0x32/0x4b
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81112c96>] ? d_kill+0x67/0x6f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81111fe7>] sys_select+0x91/0xb9
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8134b48e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Nov 26 16:37:54 portablebastien kernel: [28555.348035] sync          D 0000000100690737     0  2904   2740 0x00000000
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff880016103d48 0000000000000046 ffff880000000000 ffff880100000000
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff880016102010 ffff880016103fd8 ffff8800b7d49fc0 ffff8800b7d4a290
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff8800b7d4a288 0000000000014d80 0000000000014d80 ffff880016103fd8
Nov 26 16:37:54 portablebastien kernel: [28555.348035] Call Trace:
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffffa01b8454>] queue_log_writer+0x7e/0xaf [reiserfs]
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81044423>] ? default_wake_function+0x0/0xf
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffffa01bc402>] do_journal_begin_r+0x1ee/0x2d8 [reiserfs]
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8112475f>] ? sync_one_sb+0x0/0x1d
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffffa01bc5ae>] journal_begin+0xc2/0x103 [reiserfs]
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffffa01aa450>] reiserfs_sync_fs+0x27/0x5e [reiserfs]
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81124747>] __sync_filesystem+0x66/0x7e
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8112477a>] sync_one_sb+0x1b/0x1d
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81104bdd>] iterate_supers+0x6d/0xc8
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff811247a6>] sys_sync+0x2a/0x57
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Nov 26 16:37:54 portablebastien kernel: [28555.348035] kworker/u:1   S 0000000000015740     0  3030      2 0x00000000
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff880093fe1e50 0000000000000046 ffffffff8105f151 ffff88002fedb900
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff880093fe0010 ffff880093fe1fd8 ffff8800bfe9afa0 ffff8800bfe9b270
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff8800bfe9b268 0000000000014d80 0000000000014d80 ffff880093fe1fd8
Nov 26 16:37:54 portablebastien kernel: [28555.348035] Call Trace:
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8105f151>] ? process_one_work+0x31e/0x392
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81060ef3>] worker_thread+0x24c/0x251
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81060ca7>] ? worker_thread+0x0/0x251
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810642a2>] kthread+0x8c/0x94
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8100a964>] kernel_thread_helper+0x4/0x10
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8134c110>] ? restore_args+0x0/0x30
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81064216>] ? kthread+0x0/0x94
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8100a960>] ? kernel_thread_helper+0x0/0x10
Nov 26 16:37:54 portablebastien kernel: [28555.348035] kworker/1:2   S 0000000000015740     0  3040      2 0x00000000
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff88009196de50 0000000000000046 ffffffff8105f151 ffff88002fedb180
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff88009196c010 ffff88009196dfd8 ffff880091b32fa0 ffff880091b33270
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff880091b33268 0000000000014d80 0000000000014d80 ffff88009196dfd8
Nov 26 16:37:54 portablebastien kernel: [28555.348035] Call Trace:
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8105f151>] ? process_one_work+0x31e/0x392
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81060ef3>] worker_thread+0x24c/0x251
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81060ca7>] ? worker_thread+0x0/0x251
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810642a2>] kthread+0x8c/0x94
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8100a964>] kernel_thread_helper+0x4/0x10
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8134c110>] ? restore_args+0x0/0x30
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81064216>] ? kthread+0x0/0x94
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8100a960>] ? kernel_thread_helper+0x0/0x10
Nov 26 16:37:54 portablebastien kernel: [28555.348035] kworker/0:0   R  running task        0  3047      2 0x00000000
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff8800b21e7bf0 ffffffff811e75c2 ffff88011d83a684 ffff88011d83a7d8
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  07008800000000aa 0000001c00000013 00000000000000ff ffff88011da2c800
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  0000000000000001 0000000000000000 000000000000002f ffff88011d262000
Nov 26 16:37:54 portablebastien kernel: [28555.348035] Call Trace:
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff811e759c>] ? fbcon_redraw+0xcb/0x15d
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff811e7c6d>] fbcon_scroll+0x63f/0xc04
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8123ac50>] scrup+0x74/0xe8
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8123adf6>] lf+0x2d/0x67
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8123b058>] vt_console_print+0x1c3/0x2cd
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8123d460>] ? console_callback+0x0/0x107
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810494d5>] __call_console_drivers+0x67/0x79
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81049540>] _call_console_drivers+0x59/0x5d
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81049a22>] release_console_sem+0x121/0x1e5
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8123d562>] console_callback+0x102/0x107
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8105f056>] process_one_work+0x223/0x392
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8105efc8>] ? process_one_work+0x195/0x392
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81060de0>] worker_thread+0x139/0x251
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81060ca7>] ? worker_thread+0x0/0x251
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810642a2>] kthread+0x8c/0x94
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8100a964>] kernel_thread_helper+0x4/0x10
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8134c110>] ? restore_args+0x0/0x30
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81064216>] ? kthread+0x0/0x94
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8100a960>] ? kernel_thread_helper+0x0/0x10
Nov 26 16:37:54 portablebastien kernel: [28555.348035] kworker/u:2   S 00000001006bc4b1     0  3065      2 0x00000000
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff8800c207be50 0000000000000046 ffffffff8105f151 ffff880000000000
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff8800c207a010 ffff8800c207bfd8 ffff8800bfe99fc0 ffff8800bfe9a290
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff8800bfe9a288 0000000000014d80 0000000000014d80 ffff8800c207bfd8
Nov 26 16:37:54 portablebastien kernel: [28555.348035] Call Trace:
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8105f151>] ? process_one_work+0x31e/0x392
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81060ef3>] worker_thread+0x24c/0x251
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81060ca7>] ? worker_thread+0x0/0x251
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810642a2>] kthread+0x8c/0x94
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8100a964>] kernel_thread_helper+0x4/0x10
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8134c110>] ? restore_args+0x0/0x30
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81064216>] ? kthread+0x0/0x94
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8100a960>] ? kernel_thread_helper+0x0/0x10
Nov 26 16:37:54 portablebastien kernel: [28555.348035] kworker/0:1   S 00000001006ba4fb     0  3084      2 0x00000000
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff8800c47d1e50 0000000000000046 ffffffff8105f151 ffff880000000000
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff8800c47d0010 ffff8800c47d1fd8 ffff8800c4420fe0 ffff8800c44212b0
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  ffff8800c44212a8 0000000000014d80 0000000000014d80 ffff8800c47d1fd8
Nov 26 16:37:54 portablebastien kernel: [28555.348035] Call Trace:
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8105f151>] ? process_one_work+0x31e/0x392
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81060ef3>] worker_thread+0x24c/0x251
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81060ca7>] ? worker_thread+0x0/0x251
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff810642a2>] kthread+0x8c/0x94
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8100a964>] kernel_thread_helper+0x4/0x10
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8134c110>] ? restore_args+0x0/0x30
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff81064216>] ? kthread+0x0/0x94
Nov 26 16:37:54 portablebastien kernel: [28555.348035]  [<ffffffff8100a960>] ? kernel_thread_helper+0x0/0x10
Nov 26 16:37:54 portablebastien kernel: [28555.348035] Sched Debug Version: v0.09, 2.6.36 #4
Nov 26 16:37:54 portablebastien kernel: [28555.348035] now at 28555401.721753 msecs
Nov 26 16:37:54 portablebastien kernel: [28555.348035]   .jiffies                                 : 4302031123
Nov 26 16:37:54 portablebastien kernel: [28555.348035]   .sysctl_sched_latency                    : 12.000000
Nov 26 16:37:54 portablebastien kernel: [28555.348035]   .sysctl_sched_min_granularity            : 1.500000
Nov 26 16:37:54 portablebastien kernel: [28555.348035]   .sysctl_sched_wakeup_granularity         : 2.000000
Nov 26 16:37:54 portablebastien kernel: [28555.348035]   .sysctl_sched_child_runs_first           : 0
Nov 26 16:37:54 portablebastien kernel: [28555.348035]   .sysctl_sched_features                   : 15471
Nov 26 16:37:54 portablebastien kernel: [28555.348035]   .sysctl_sched_tunable_scaling            : 1 (logaritmic)
Nov 26 16:37:54 portablebastien kernel: [28555.348035] 
Nov 26 16:37:54 portablebastien kernel: [28555.348035] cpu#0, 2094.747 MHz
Nov 26 16:37:54 portablebastien kernel: [28555.348035]   .nr_running                    : 1
Nov 26 16:37:54 portablebastien kernel: [28555.348035]   .load                          : 1024
Nov 26 16:37:54 portablebastien kernel: [28555.348035]   .nr_switches                   : 29242820
Nov 26 16:37:54 portablebastien kernel: [28555.348035]   .nr_load_updates               : 2850759
Nov 26 16:37:54 portablebastien kernel: [28555.348035]   .nr_uninterruptible            : 7
Nov 26 16:37:54 portablebastien kernel: [28555.348035]   .next_balance                  : 4302.031171
Nov 26 16:37:54 portablebastien kernel: [28555.348035]   .curr->pid                     : 3047
Nov 26 16:37:54 portablebastien kernel: [28555.348035]   .clock                         : 28555360.290876
Nov 26 16:37:54 portablebastien kernel: [28555.348035]   .cpu_load[0]                   : 0
Nov 26 16:37:54 portablebastien kernel: [28555.348035]   .cpu_load[1]                   : 0
Nov 26 16:37:54 portablebastien kernel: [28555.348035]   .cpu_load[2]                   : 2
Nov 26 16:37:54 portablebastien kernel: [28555.348035]   .cpu_load[3]                   : 14
Nov 26 16:37:54 portablebastien kernel: [28555.348035]   .cpu_load[4]                   : 27
Nov 26 16:37:54 portablebastien kernel: [28555.348035] 
Nov 26 16:37:54 portablebastien kernel: [28555.348035] cfs_rq[0]:/
Nov 26 16:37:54 portablebastien kernel: [28555.348035]   .exec_clock                    : 0.000000
Nov 26 16:37:54 portablebastien kernel: [28555.348035]   .MIN_vruntime                  : 0.000001
Nov 26 16:37:54 portablebastien kernel: [28555.348035]   .min_vruntime                  : 23781130.231019
Nov 26 16:37:54 portablebastien kernel: [28555.348035]   .max_vruntime                  : 0.000001
Nov 26 16:37:54 portablebastien kernel: [28555.348035]   .spread                        : 0.000000
Nov 26 16:37:54 portablebastien kernel: [28555.348035]   .spread0                       : 0.000000
Nov 26 16:37:54 portablebastien kernel: [28555.348035]   .nr_running                    : 1
Nov 26 16:37:54 portablebastien kernel: [28555.348035]   .load                          : 1024
Nov 26 16:37:54 portablebastien kernel: [28555.348035]   .nr_spread_over                : 0
Nov 26 16:37:54 portablebastien kernel: [28555.348035]   .shares                        : 0
Nov 26 16:37:54 portablebastien kernel: [28555.348035] 
Nov 26 16:37:54 portablebastien kernel: [28555.348035] rt_rq[0]:
Nov 26 16:37:54 portablebastien kernel: [28555.348035]   .rt_nr_running                 : 0
Nov 26 16:37:54 portablebastien kernel: [28555.348035]   .rt_throttled                  : 0
Nov 26 16:37:54 portablebastien kernel: [28555.348035]   .rt_time                       : 0.000000
Nov 26 16:37:54 portablebastien kernel: [28555.348035]   .rt_runtime                    : 900.000000
Nov 26 16:37:54 portablebastien kernel: [28555.348035] 
Nov 26 16:37:54 portablebastien kernel: [28555.348035] runnable tasks:
Nov 26 16:37:54 portablebastien kernel: [28555.348035]             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
Nov 26 16:37:54 portablebastien kernel: [28555.348035] ----------------------------------------------------------------------------------------------------------
Nov 26 16:37:54 portablebastien kernel: [28555.348035] R    kworker/0:0  3047  23781130.231019      2020   120               0               0               0.000000               0.000000               0.000000 /
Nov 26 16:37:54 portablebastien kernel: [28555.348035] 
Nov 26 16:37:54 portablebastien kernel: [28555.348035] cpu#1, 2094.747 MHz
Nov 26 16:37:54 portablebastien kernel: [28555.348035]   .nr_running                    : 1
Nov 26 16:37:54 portablebastien kernel: [28555.348035]   .load                          : 1024
Nov 26 16:37:54 portablebastien kernel: [28555.348035]   .nr_switches                   : 25664381
Nov 26 16:37:54 portablebastien kernel: [28555.348035]   .nr_load_updates               : 2933397
Nov 26 16:37:54 portablebastien kernel: [28555.348035]   .nr_uninterruptible            : 3
Nov 26 16:37:54 portablebastien kernel: [28555.348035]   .next_balance                  : 4302.031145
Nov 26 16:37:54 portablebastien kernel: [28555.348035]   .curr->pid                     : 3732
Nov 26 16:37:54 portablebastien kernel: [28555.348035]   .clock                         : 28555264.053675
Nov 26 16:37:54 portablebastien kernel: [28555.348035]   .cpu_load[0]                   : 1024
Nov 26 16:37:54 portablebastien kernel: [28555.348035]   .cpu_load[1]                   : 512
Nov 26 16:37:54 portablebastien kernel: [28555.348035]   .cpu_load[2]                   : 259
Nov 26 16:37:54 portablebastien kernel: [28555.348035]   .cpu_load[3]                   : 147
Nov 26 16:37:54 portablebastien kernel: [28555.348035]   .cpu_load[4]                   : 100
Nov 26 16:37:54 portablebastien kernel: [28555.348035] 
Nov 26 16:37:54 portablebastien kernel: [28555.348035] cfs_rq[1]:/
Nov 26 16:37:54 portablebastien kernel: [28555.348035]   .exec_clock                    : 0.000000
Nov 26 16:37:54 portablebastien kernel: [28555.348035]   .MIN_vruntime                  : 0.000001
Nov 26 16:37:54 portablebastien kernel: [28555.348035]   .min_vruntime                  : 34453765.595831
Nov 26 16:37:54 portablebastien kernel: [28555.348035]   .max_vruntime                  : 0.000001
Nov 26 16:37:54 portablebastien kernel: [28555.348035]   .spread                        : 0.000000
Nov 26 16:37:54 portablebastien kernel: [28555.348035]   .spread0                       : 10672635.364812
Nov 26 16:37:54 portablebastien kernel: [28555.348035]   .nr_running                    : 1
Nov 26 16:37:54 portablebastien kernel: [28555.348035]   .load                          : 1024
Nov 26 16:37:54 portablebastien kernel: [28555.348035]   .nr_spread_over                : 0
Nov 26 16:37:54 portablebastien kernel: [28555.348035]   .shares                        : 0
Nov 26 16:37:54 portablebastien kernel: [28555.348035] 
Nov 26 16:37:54 portablebastien kernel: [28555.348035] rt_rq[1]:
Nov 26 16:37:54 portablebastien kernel: [28555.348035]   .rt_nr_running                 : 0
Nov 26 16:37:54 portablebastien kernel: [28555.348035]   .rt_throttled                  : 0
Nov 26 16:37:54 portablebastien kernel: [28555.348035]   .rt_time                       : 0.000000
Nov 26 16:37:54 portablebastien kernel: [28555.348035]   .rt_runtime                    : 1000.000000
Nov 26 16:37:54 portablebastien kernel: [28555.348035] 
Nov 26 16:37:54 portablebastien kernel: [28555.348035] runnable tasks:
Nov 26 16:37:54 portablebastien kernel: [28555.348035]             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
Nov 26 16:37:54 portablebastien kernel: [28555.348035] ----------------------------------------------------------------------------------------------------------
Nov 26 16:37:54 portablebastien kernel: [28555.348035] R           bash  3732  34453761.839181      1007   120               0               0               0.000000               0.000000               0.000000 /
Nov 26 16:37:54 portablebastien kernel: [28555.348035] 
Nov 26 16:37:54 portablebastien kernel: [28555.348035] INFO: lockdep is turned off.
Nov 26 16:39:17 portablebastien kernel: 127e6d7>] ? rcu_read_lock+0x0/0x30
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff812f9b03>] ? scm_destroy_cred+0x14/0x40
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff812f9b40>] ? scm_destroy+0x11/0x2a
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810d9ec8>] ? might_fault+0xa0/0xa7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111d17>] core_sys_select+0x21c/0x2b2
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111b33>] ? core_sys_select+0x38/0x2b2
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8112f82a>] ? fsnotify+0x79/0x449
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8112fbdb>] ? fsnotify+0x42a/0x449
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8112f82a>] ? fsnotify+0x79/0x449
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111fe7>] sys_select+0x91/0xb9
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8134b48e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Nov 26 16:39:17 portablebastien kernel: [28641.882112] sd_espeak     S 0000000100174381     0 10681   2085 0x00000000
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff88011e705cd8 0000000000000046 ffff880091b61258 0000000000000000
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff88011e704010 ffff88011e705fd8 ffff880091ae8000 ffff880091ae82d0
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff880091ae82c8 0000000000014d80 0000000000014d80 ffff88011e705fd8
Nov 26 16:39:17 portablebastien kernel: [28641.882112] Call Trace:
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8110a1e2>] pipe_wait+0x5e/0x7a
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8106473b>] ? autoremove_wake_function+0x0/0x34
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8134a8b4>] ? mutex_lock_nested+0x39/0x3e
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8110aa62>] pipe_read+0x335/0x3b6
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81102989>] do_sync_read+0xc6/0x103
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81042616>] ? finish_task_switch+0x0/0xdf
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff811721aa>] ? fsnotify_perm+0x45/0x4b
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81172207>] ? security_file_permission+0x29/0x2e
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81102fc7>] vfs_read+0xa6/0x102
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81103aa5>] ? fget_light+0x41/0xcf
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff811030d9>] sys_read+0x45/0x69
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Nov 26 16:39:17 portablebastien kernel: [28641.882112] sd_espeak     S 00000001001743cd     0 10682   2085 0x00000000
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff8800adf9bc28 0000000000000046 ffff8800adf9bcb8 ffff880000000000
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff8800adf9a010 ffff8800adf9bfd8 ffff880091ae8fe0 ffff880091ae92b0
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff880091ae92a8 0000000000014d80 0000000000014d80 ffff8800adf9bfd8
Nov 26 16:39:17 portablebastien kernel: [28641.882112] Call Trace:
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81077c58>] futex_wait_queue_me+0x82/0x99
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81078c47>] futex_wait+0x148/0x2f9
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810676ee>] ? hrtimer_wakeup+0x0/0x21
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8106816a>] ? hrtimer_start_range_ns+0xf/0x11
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81079ebc>] do_futex+0x95/0x86e
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8134f173>] ? do_page_fault+0x16c/0x2c0
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8107a7bc>] sys_futex+0x127/0x13f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8134b504>] ? lockdep_sys_exit_thunk+0x35/0x67
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8134b48e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Nov 26 16:39:17 portablebastien kernel: [28641.882112] sd_espeak     S 00000000ffffffff     0 10683   2085 0x00000000
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff88003c29bc28 0000000000000046 ffff88003c29bcb8 ffff88003c29bcf0
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff88003c29a010 ffff88003c29bfd8 ffff8800acc30fe0 ffff8800acc312b0
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff8800acc312a8 0000000000014d80 0000000000014d80 ffff88003c29bfd8
Nov 26 16:39:17 portablebastien kernel: [28641.882112] Call Trace:
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81077c58>] futex_wait_queue_me+0x82/0x99
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81078c47>] futex_wait+0x148/0x2f9
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810c2e5a>] ? unlock_page+0x25/0x2a
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81079ebc>] do_futex+0x95/0x86e
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810581e3>] ? sigprocmask+0x2f/0xc6
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810581e3>] ? sigprocmask+0x2f/0xc6
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81042616>] ? finish_task_switch+0x0/0xdf
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8107a7bc>] sys_futex+0x127/0x13f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8105826e>] ? sigprocmask+0xba/0xc6
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8134b48e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Nov 26 16:39:17 portablebastien kernel: [28641.882112] sd_espeak     S 00000000ffffffff     0 10684   2085 0x00000000
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff880018417c28 0000000000000046 ffff880018417cb8 ffff880018417cf0
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff880018416010 ffff880018417fd8 ffff880037a98000 ffff880037a982d0
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff880037a982c8 0000000000014d80 0000000000014d80 ffff880018417fd8
Nov 26 16:39:17 portablebastien kernel: [28641.882112] Call Trace:
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81077c58>] futex_wait_queue_me+0x82/0x99
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81078c47>] futex_wait+0x148/0x2f9
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810c2e5a>] ? unlock_page+0x25/0x2a
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81079ebc>] do_futex+0x95/0x86e
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810581e3>] ? sigprocmask+0x2f/0xc6
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810581e3>] ? sigprocmask+0x2f/0xc6
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81042616>] ? finish_task_switch+0x0/0xdf
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8107a7bc>] sys_futex+0x127/0x13f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8105826e>] ? sigprocmask+0xba/0xc6
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8134b48e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Nov 26 16:39:17 portablebastien kernel: [28641.882112] sd_festival   x ffff88011f658000     0 10685   2085 0x00000000
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff880018425eb8 0000000000000046 ffff88000fcbb438 ffff880002218370
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff880018424010 ffff880018425fd8 ffff880037a9cf60 ffff880037a9d230
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff880037a9d228 0000000000014d80 0000000000014d80 ffff880018425fd8
Nov 26 16:39:17 portablebastien kernel: [28641.882112] Call Trace:
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff811a2a0a>] ? exit_io_context+0x9b/0xa9
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff811a29b5>] ? exit_io_context+0x46/0xa9
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8104d351>] do_exit+0x702/0x711
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8134b504>] ? lockdep_sys_exit_thunk+0x35/0x67
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8104d3d8>] do_group_exit+0x78/0xa3
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8104d415>] sys_exit_group+0x12/0x16
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Nov 26 16:39:17 portablebastien kernel: [28641.882112] sd_flite      S 00000001001743f7     0 10686   2085 0x00000000
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff8800c23e3cd8 0000000000000046 ffff8800999fd018 0000000000000046
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff8800c23e2010 ffff8800c23e3fd8 ffff880037a99fc0 ffff880037a9a290
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff880037a9a288 0000000000014d80 0000000000014d80 ffff8800c23e3fd8
Nov 26 16:39:17 portablebastien kernel: [28641.882112] Call Trace:
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8110a1e2>] pipe_wait+0x5e/0x7a
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8106473b>] ? autoremove_wake_function+0x0/0x34
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8134a8b4>] ? mutex_lock_nested+0x39/0x3e
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8110aa62>] pipe_read+0x335/0x3b6
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8112f82a>] ? fsnotify+0x79/0x449
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81102989>] do_sync_read+0xc6/0x103
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff811721aa>] ? fsnotify_perm+0x45/0x4b
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81172207>] ? security_file_permission+0x29/0x2e
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81102fc7>] vfs_read+0xa6/0x102
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81103aa5>] ? fget_light+0x41/0xcf
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff811030d9>] sys_read+0x45/0x69
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Nov 26 16:39:17 portablebastien kernel: [28641.882112] sd_flite      S 00000001001743cd     0 10687   2085 0x00000000
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff880096bbdc28 0000000000000046 ffff880096bbdcb8 ffff880000000000
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff880096bbc010 ffff880096bbdfd8 ffff880037a3afa0 ffff880037a3b270
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff880037a3b268 0000000000014d80 0000000000014d80 ffff880096bbdfd8
Nov 26 16:39:17 portablebastien kernel: [28641.882112] Call Trace:
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81077c58>] futex_wait_queue_me+0x82/0x99
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81078c47>] futex_wait+0x148/0x2f9
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810c2e5a>] ? unlock_page+0x25/0x2a
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81079ebc>] do_futex+0x95/0x86e
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810581e3>] ? sigprocmask+0x2f/0xc6
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810581e3>] ? sigprocmask+0x2f/0xc6
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81042616>] ? finish_task_switch+0x0/0xdf
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8107a7bc>] sys_futex+0x127/0x13f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8105826e>] ? sigprocmask+0xba/0xc6
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8134b48e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Nov 26 16:39:17 portablebastien kernel: [28641.882112] speech-dispat x 00000001001743f7     0 10688   2085 0x00000000
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff8800adf95eb8 0000000000000046 ffff8800adf95e88 0000000000000246
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff8800adf94010 ffff8800adf95fd8 ffff8800b7d18000 ffff8800b7d182d0
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff8800b7d182c8 0000000000014d80 0000000000014d80 ffff8800adf95fd8
Nov 26 16:39:17 portablebastien kernel: [28641.882112] Call Trace:
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8104d351>] do_exit+0x702/0x711
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8134b504>] ? lockdep_sys_exit_thunk+0x35/0x67
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8104d3d8>] do_group_exit+0x78/0xa3
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8104d415>] sys_exit_group+0x12/0x16
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Nov 26 16:39:17 portablebastien kernel: [28641.882112] sd_dummy      S 00000001001743f8     0 10689   2085 0x00000000
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff8800ace67cd8 0000000000000046 ffff8800aa166c18 0000000000000046
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff8800ace66010 ffff8800ace67fd8 ffff8800b7d1bf80 ffff8800b7d1c250
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff8800b7d1c248 0000000000014d80 0000000000014d80 ffff8800ace67fd8
Nov 26 16:39:17 portablebastien kernel: [28641.882112] Call Trace:
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8110a1e2>] pipe_wait+0x5e/0x7a
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8106473b>] ? autoremove_wake_function+0x0/0x34
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8134a8b4>] ? mutex_lock_nested+0x39/0x3e
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8110aa62>] pipe_read+0x335/0x3b6
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8112f82a>] ? fsnotify+0x79/0x449
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81102989>] do_sync_read+0xc6/0x103
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff811721aa>] ? fsnotify_perm+0x45/0x4b
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81172207>] ? security_file_permission+0x29/0x2e
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81102fc7>] vfs_read+0xa6/0x102
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81103aa5>] ? fget_light+0x41/0xcf
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff811030d9>] sys_read+0x45/0x69
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Nov 26 16:39:17 portablebastien kernel: [28641.882112] sd_dummy      S 00000001001743f8     0 10690   2085 0x00000000
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff8800adfcbc28 0000000000000046 ffff8800adfcbcb8 ffff8800adfcbcf0
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff8800adfca010 ffff8800adfcbfd8 ffff8800b7d19fc0 ffff8800b7d1a290
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff8800b7d1a288 0000000000014d80 0000000000014d80 ffff8800adfcbfd8
Nov 26 16:39:17 portablebastien kernel: [28641.882112] Call Trace:
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81077c58>] futex_wait_queue_me+0x82/0x99
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81078c47>] futex_wait+0x148/0x2f9
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810c2e5a>] ? unlock_page+0x25/0x2a
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81079ebc>] do_futex+0x95/0x86e
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810581e3>] ? sigprocmask+0x2f/0xc6
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810581e3>] ? sigprocmask+0x2f/0xc6
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8107a7bc>] sys_futex+0x127/0x13f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8105826e>] ? sigprocmask+0xba/0xc6
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8134b48e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Nov 26 16:39:17 portablebastien kernel: [28641.882112] gvfsd-metadat S 0000000100253bd6     0 13459      1 0x00000000
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff88000f999a58 0000000000000046 ffff88000f999c70 0000000000000000
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff88000f998010 ffff88000f999fd8 ffff880099a4bf80 ffff880099a4c250
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff880099a4c248 0000000000014d80 0000000000014d80 ffff88000f999fd8
Nov 26 16:39:17 portablebastien kernel: [28641.882112] Call Trace:
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8134a905>] schedule_hrtimeout_range_clock+0x4c/0x12f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81075039>] ? trace_hardirqs_on+0xd/0xf
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81064a5b>] ? add_wait_queue+0x3f/0x44
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8134a9f6>] schedule_hrtimeout_range+0xe/0x10
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff811112e4>] poll_schedule_timeout+0x43/0x5f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81112369>] do_sys_poll+0x35a/0x3e5
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8111197c>] ? __pollwait+0x0/0xc7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810c2869>] ? rcu_read_lock+0x0/0x30
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810c2869>] ? rcu_read_lock+0x0/0x30
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810dd245>] ? __do_fault+0x1e3/0x3a4
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810dd245>] ? __do_fault+0x1e3/0x3a4
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810c2e5a>] ? unlock_page+0x25/0x2a
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810dd3d0>] ? __do_fault+0x36e/0x3a4
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810ddd8e>] ? handle_mm_fault+0x33e/0x846
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8134f173>] ? do_page_fault+0x16c/0x2c0
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8106878f>] ? up_read+0x1e/0x37
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81112588>] sys_poll+0x50/0xbb
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Nov 26 16:39:17 portablebastien kernel: [28641.882112] kbibtex       S 0000000000000000     0 15832      1 0x00000000
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff88002aa67908 0000000000000046 ffff88002aa67918 00001a31c8586ca5
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff88002aa66010 ffff88002aa67fd8 ffff8800bff16f20 ffff8800bff171f0
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff8800bff171e8 0000000000014d80 0000000000014d80 ffff88002aa67fd8
Nov 26 16:39:17 portablebastien kernel: [28641.882112] Call Trace:
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8134a9a1>] schedule_hrtimeout_range_clock+0xe8/0x12f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810676ee>] ? hrtimer_wakeup+0x0/0x21
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8106816a>] ? hrtimer_start_range_ns+0xf/0x11
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8134a9f6>] schedule_hrtimeout_range+0xe/0x10
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff811112e4>] poll_schedule_timeout+0x43/0x5f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111942>] do_select+0x5b2/0x5ec
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111390>] ? do_select+0x0/0x5ec
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8111197c>] ? __pollwait+0x0/0xc7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810d9ec8>] ? might_fault+0xa0/0xa7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111d17>] core_sys_select+0x21c/0x2b2
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111b33>] ? core_sys_select+0x38/0x2b2
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81102989>] ? do_sync_read+0xc6/0x103
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8106ccea>] ? ktime_get_ts+0xad/0xba
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111fe7>] sys_select+0x91/0xb9
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Nov 26 16:39:17 portablebastien kernel: [28641.882112] kdeinit       S 00000001002e82c6     0 15835      1 0x00000000
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff8800b2057908 0000000000000046 0000000000000001 00000000000004cf
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff8800b2056010 ffff8800b2057fd8 ffff8800ac1b1fc0 ffff8800ac1b2290
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff8800ac1b2288 0000000000014d80 0000000000014d80 ffff8800b2057fd8
Nov 26 16:39:17 portablebastien kernel: [28641.882112] Call Trace:
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8134a905>] schedule_hrtimeout_range_clock+0x4c/0x12f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81075039>] ? trace_hardirqs_on+0xd/0xf
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81064a5b>] ? add_wait_queue+0x3f/0x44
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8134a9f6>] schedule_hrtimeout_range+0xe/0x10
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff811112e4>] poll_schedule_timeout+0x43/0x5f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111942>] do_select+0x5b2/0x5ec
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111390>] ? do_select+0x0/0x5ec
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8111197c>] ? __pollwait+0x0/0xc7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff812f9b40>] ? scm_destroy+0x11/0x2a
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810d9ec8>] ? might_fault+0xa0/0xa7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111d17>] core_sys_select+0x21c/0x2b2
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111b33>] ? core_sys_select+0x38/0x2b2
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81075039>] ? trace_hardirqs_on+0xd/0xf
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810649d4>] ? remove_wait_queue+0x4c/0x51
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8104c9cb>] ? do_wait+0x1eb/0x22e
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111fe7>] sys_select+0x91/0xb9
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8134b48e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Nov 26 16:39:17 portablebastien kernel: [28641.882112] dcopserver    S 0000000000000000     0 15838      1 0x00000000
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff88004fcbb908 0000000000000046 ffff880000000000 0000000000000001
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff88004fcba010 ffff88004fcbbfd8 ffff88011b88bf80 ffff88011b88c250
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff88011b88c248 0000000000014d80 0000000000014d80 ffff88004fcbbfd8
Nov 26 16:39:17 portablebastien kernel: [28641.882112] Call Trace:
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8134a905>] schedule_hrtimeout_range_clock+0x4c/0x12f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81075039>] ? trace_hardirqs_on+0xd/0xf
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81064a5b>] ? add_wait_queue+0x3f/0x44
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8134a9f6>] schedule_hrtimeout_range+0xe/0x10
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff811112e4>] poll_schedule_timeout+0x43/0x5f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111942>] do_select+0x5b2/0x5ec
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111390>] ? do_select+0x0/0x5ec
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8111197c>] ? __pollwait+0x0/0xc7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810d9ec8>] ? might_fault+0xa0/0xa7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111d17>] core_sys_select+0x21c/0x2b2
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111b33>] ? core_sys_select+0x38/0x2b2
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81102989>] ? do_sync_read+0xc6/0x103
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8127b52d>] ? sockfd_lookup_light+0x1b/0x53
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8127d24c>] ? sys_sendto+0x120/0x14d
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8110fbe7>] ? sys_fcntl+0x325/0x537
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8110fbe7>] ? sys_fcntl+0x325/0x537
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111fe7>] sys_select+0x91/0xb9
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8134b48e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Nov 26 16:39:17 portablebastien kernel: [28641.882112] klauncher     S 00000001006c1bf5     0 15841  15835 0x00000000
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff8800b209f908 0000000000000046 ffff8800b209f918 00001a0e00000000
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff8800b209e010 ffff8800b209ffd8 ffff880091aedf40 ffff880091aee210
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff880091aee208 0000000000014d80 0000000000014d80 ffff8800b209ffd8
Nov 26 16:39:17 portablebastien kernel: [28641.882112] Call Trace:
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8134a9a1>] schedule_hrtimeout_range_clock+0xe8/0x12f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810676ee>] ? hrtimer_wakeup+0x0/0x21
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8106816a>] ? hrtimer_start_range_ns+0xf/0x11
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8134a9f6>] schedule_hrtimeout_range+0xe/0x10
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff811112e4>] poll_schedule_timeout+0x43/0x5f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111942>] do_select+0x5b2/0x5ec
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111390>] ? do_select+0x0/0x5ec
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8111197c>] ? __pollwait+0x0/0xc7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810d9ec8>] ? might_fault+0xa0/0xa7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810d9ec8>] ? might_fault+0xa0/0xa7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111d17>] core_sys_select+0x21c/0x2b2
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111b33>] ? core_sys_select+0x38/0x2b2
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8106ccea>] ? ktime_get_ts+0xad/0xba
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111fe7>] sys_select+0x91/0xb9
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Nov 26 16:39:17 portablebastien kernel: [28641.882112] kded          S 00000001006c1985     0 15843      1 0x00000000
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff880074329908 0000000000000046 ffff880074329918 00001a0c00000000
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff880074328010 ffff880074329fd8 ffff880091aebf80 ffff880091aec250
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff880091aec248 0000000000014d80 0000000000014d80 ffff880074329fd8
Nov 26 16:39:17 portablebastien kernel: [28641.882112] Call Trace:
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8134a9a1>] schedule_hrtimeout_range_clock+0xe8/0x12f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810676ee>] ? hrtimer_wakeup+0x0/0x21
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8106816a>] ? hrtimer_start_range_ns+0xf/0x11
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8134a9f6>] schedule_hrtimeout_range+0xe/0x10
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff811112e4>] poll_schedule_timeout+0x43/0x5f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111942>] do_select+0x5b2/0x5ec
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111390>] ? do_select+0x0/0x5ec
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8111197c>] ? __pollwait+0x0/0xc7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810d9ec8>] ? might_fault+0xa0/0xa7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111d17>] core_sys_select+0x21c/0x2b2
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111b33>] ? core_sys_select+0x38/0x2b2
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81102989>] ? do_sync_read+0xc6/0x103
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8106ccea>] ? ktime_get_ts+0xad/0xba
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111fe7>] sys_select+0x91/0xb9
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Nov 26 16:39:17 portablebastien kernel: [28641.882112] cpdftocps     S ffff8800b7eddf30     0 17514   1829 0x00000000
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff88003de81e58 0000000000000046 ffff88003de81e28 0000000000000246
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff88003de80010 ffff88003de81fd8 ffff8800b7eddf40 ffff8800b7ede210
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff8800b7ede208 0000000000014d80 0000000000014d80 ffff88003de81fd8
Nov 26 16:39:17 portablebastien kernel: [28641.882112] Call Trace:
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8104c99a>] do_wait+0x1ba/0x22e
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8104caa7>] sys_wait4+0x99/0xbc
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8104af46>] ? child_wait_callback+0x0/0x53
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Nov 26 16:39:17 portablebastien kernel: [28641.882112] socket        S 00000001006bd52a     0 17515   1829 0x00000000
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff8800ac16dd78 0000000000000046 ffff8800ac16dce8 ffffffff00000000
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff8800ac16c010 ffff8800ac16dfd8 ffff8800b7ed8000 ffff8800b7ed82d0
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff8800b7ed82c8 0000000000014d80 0000000000014d80 ffff8800ac16dfd8
Nov 26 16:39:17 portablebastien kernel: [28641.882112] Call Trace:
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81349f02>] schedule_timeout+0x31/0xeb
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81075039>] ? trace_hardirqs_on+0xd/0xf
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8104f4dd>] ? _local_bh_enable_ip+0xc7/0xd2
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8104f4f1>] ? local_bh_enable_ip+0x9/0xb
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8134bc7a>] ? _raw_spin_unlock_bh+0x2f/0x33
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8127eb4e>] ? release_sock+0x148/0x151
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff812dffbf>] inet_stream_connect+0x14b/0x24d
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8106473b>] ? autoremove_wake_function+0x0/0x34
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8127d31a>] sys_connect+0x90/0xd0
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8134bd2b>] ? _raw_spin_unlock+0x26/0x2a
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8134b48e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Nov 26 16:39:17 portablebastien kernel: [28641.882112] pdftops       S 0000000000000010     0 17596  17514 0x00000000
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff8800adc8bcd8 0000000000000046 ffff8800acdda9d8 0000000000000046
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff8800adc8a010 ffff8800adc8bfd8 ffff8800c200cf60 ffff8800c200d230
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff8800c200d228 0000000000014d80 0000000000014d80 ffff8800adc8bfd8
Nov 26 16:39:17 portablebastien kernel: [28641.882112] Call Trace:
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8110a1e2>] pipe_wait+0x5e/0x7a
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8106473b>] ? autoremove_wake_function+0x0/0x34
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8134a8b4>] ? mutex_lock_nested+0x39/0x3e
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8110a6be>] pipe_write+0x4c0/0x52f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81102886>] do_sync_write+0xc6/0x103
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81172207>] ? security_file_permission+0x29/0x2e
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81102deb>] vfs_write+0xa9/0x105
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81102efd>] sys_write+0x45/0x69
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Nov 26 16:39:17 portablebastien kernel: [28641.882112] pstops        S 00000001002c39bd     0 17597  17514 0x00000000
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff8800ac3f7cd8 0000000000000046 ffff880113866a98 0000000000000046
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff8800ac3f6010 ffff8800ac3f7fd8 ffff8800c200afa0 ffff8800c200b270
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff8800c200b268 0000000000014d80 0000000000014d80 ffff8800ac3f7fd8
Nov 26 16:39:17 portablebastien kernel: [28641.882112] Call Trace:
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8110a1e2>] pipe_wait+0x5e/0x7a
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8106473b>] ? autoremove_wake_function+0x0/0x34
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8134a8b4>] ? mutex_lock_nested+0x39/0x3e
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8110a6be>] pipe_write+0x4c0/0x52f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81102886>] do_sync_write+0xc6/0x103
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81172207>] ? security_file_permission+0x29/0x2e
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81102deb>] vfs_write+0xa9/0x105
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81102efd>] sys_write+0x45/0x69
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Nov 26 16:39:17 portablebastien kernel: [28641.882112] kio_thumbnail S 0000000000000000     0 17617   2849 0x00000000
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff8800b7f83908 0000000000000046 ffff880002314d80 ffff88011f6c1018
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff8800b7f82010 ffff8800b7f83fd8 ffff88011f6c0fe0 ffff88011f6c12b0
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff88011f6c12a8 0000000000014d80 0000000000014d80 ffff8800b7f83fd8
Nov 26 16:39:17 portablebastien kernel: [28641.882112] Call Trace:
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8134a905>] schedule_hrtimeout_range_clock+0x4c/0x12f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81075039>] ? trace_hardirqs_on+0xd/0xf
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81064a5b>] ? add_wait_queue+0x3f/0x44
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8134a9f6>] schedule_hrtimeout_range+0xe/0x10
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff811112e4>] poll_schedule_timeout+0x43/0x5f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111942>] do_select+0x5b2/0x5ec
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111390>] ? do_select+0x0/0x5ec
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8111197c>] ? __pollwait+0x0/0xc7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81044430>] ? default_wake_function+0xd/0xf
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111a90>] ? pollwake+0x4d/0x4f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81044423>] ? default_wake_function+0x0/0xf
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81075039>] ? trace_hardirqs_on+0xd/0xf
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff812f9b03>] ? scm_destroy_cred+0x14/0x40
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff812f9b40>] ? scm_destroy+0x11/0x2a
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810d9ec8>] ? might_fault+0xa0/0xa7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111d17>] core_sys_select+0x21c/0x2b2
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111b33>] ? core_sys_select+0x38/0x2b2
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8112f82a>] ? fsnotify+0x79/0x449
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8112fbdb>] ? fsnotify+0x42a/0x449
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8112f82a>] ? fsnotify+0x79/0x449
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111fe7>] sys_select+0x91/0xb9
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8134b48e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Nov 26 16:39:17 portablebastien kernel: [28641.882112] kio_file      S 0000000000000000     0 17624   2849 0x00000000
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff880068aa9908 0000000000000046 ffffea00016e7440 0000000000000000
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff880068aa8010 ffff880068aa9fd8 ffff8800bfe98000 ffff8800bfe982d0
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff8800bfe982c8 0000000000014d80 0000000000014d80 ffff880068aa9fd8
Nov 26 16:39:17 portablebastien kernel: [28641.882112] Call Trace:
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8134a905>] schedule_hrtimeout_range_clock+0x4c/0x12f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81075039>] ? trace_hardirqs_on+0xd/0xf
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81064a5b>] ? add_wait_queue+0x3f/0x44
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8134a9f6>] schedule_hrtimeout_range+0xe/0x10
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff811112e4>] poll_schedule_timeout+0x43/0x5f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111942>] do_select+0x5b2/0x5ec
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111390>] ? do_select+0x0/0x5ec
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8111197c>] ? __pollwait+0x0/0xc7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81044430>] ? default_wake_function+0xd/0xf
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111a90>] ? pollwake+0x4d/0x4f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81044423>] ? default_wake_function+0x0/0xf
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81075039>] ? trace_hardirqs_on+0xd/0xf
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff812f9b03>] ? scm_destroy_cred+0x14/0x40
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff812f9b40>] ? scm_destroy+0x11/0x2a
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810d9ec8>] ? might_fault+0xa0/0xa7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111d17>] core_sys_select+0x21c/0x2b2
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111b33>] ? core_sys_select+0x38/0x2b2
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8112f82a>] ? fsnotify+0x79/0x449
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8112fbdb>] ? fsnotify+0x42a/0x449
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8112f82a>] ? fsnotify+0x79/0x449
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111fe7>] sys_select+0x91/0xb9
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8134b48e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Nov 26 16:39:17 portablebastien kernel: [28641.882112] kio_thumbnail S 0000000000000000     0 17633   2849 0x00000000
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff880076755908 0000000000000046 ffff880002214d80 ffff8800bfe9ef58
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff880076754010 ffff880076755fd8 ffff8800bfe9ef20 ffff8800bfe9f1f0
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff8800bfe9f1e8 0000000000014d80 0000000000014d80 ffff880076755fd8
Nov 26 16:39:17 portablebastien kernel: [28641.882112] Call Trace:
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8134a905>] schedule_hrtimeout_range_clock+0x4c/0x12f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81075039>] ? trace_hardirqs_on+0xd/0xf
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81064a5b>] ? add_wait_queue+0x3f/0x44
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8134a9f6>] schedule_hrtimeout_range+0xe/0x10
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff811112e4>] poll_schedule_timeout+0x43/0x5f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111942>] do_select+0x5b2/0x5ec
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111390>] ? do_select+0x0/0x5ec
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8111197c>] ? __pollwait+0x0/0xc7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81044430>] ? default_wake_function+0xd/0xf
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111a90>] ? pollwake+0x4d/0x4f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81044423>] ? default_wake_function+0x0/0xf
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81075039>] ? trace_hardirqs_on+0xd/0xf
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff812f9b03>] ? scm_destroy_cred+0x14/0x40
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff812f9b40>] ? scm_destroy+0x11/0x2a
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810d9ec8>] ? might_fault+0xa0/0xa7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111d17>] core_sys_select+0x21c/0x2b2
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111b33>] ? core_sys_select+0x38/0x2b2
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8112f82a>] ? fsnotify+0x79/0x449
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8112fbdb>] ? fsnotify+0x42a/0x449
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8112f82a>] ? fsnotify+0x79/0x449
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111fe7>] sys_select+0x91/0xb9
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8134b48e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Nov 26 16:39:17 portablebastien kernel: [28641.882112] bash          S 0000000000000000     0 17677   2983 0x00000000
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff8800b20c7ce8 0000000000000046 0000000000000000 0000000000000046
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff8800b20c6010 ffff8800b20c7fd8 ffff880099a25f40 ffff880099a26210
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff880099a26208 0000000000014d80 0000000000014d80 ffff8800b20c7fd8
Nov 26 16:39:17 portablebastien kernel: [28641.882112] Call Trace:
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81075039>] ? trace_hardirqs_on+0xd/0xf
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81349f02>] schedule_timeout+0x31/0xeb
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810569a9>] ? del_timer_sync+0x8e/0xa1
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8105691b>] ? del_timer_sync+0x0/0xa1
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810601e6>] ? flush_delayed_work+0x44/0x48
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8122f474>] n_tty_read+0x4cd/0x7af
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81044423>] ? default_wake_function+0x0/0xf
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8122ab48>] tty_read+0x81/0xc5
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81102fc7>] vfs_read+0xa6/0x102
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8134bca9>] ? _raw_spin_unlock_irq+0x2b/0x36
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff811030d9>] sys_read+0x45/0x69
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Nov 26 16:39:17 portablebastien kernel: [28641.882112] kbibtex       S 00000001006b3375     0 17933   2849 0x00000000
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff8800767d9908 0000000000000046 ffff8800767d9918 00001a1a00000000
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff8800767d8010 ffff8800767d9fd8 ffff8800d4530000 ffff8800d45302d0
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff8800d45302c8 0000000000014d80 0000000000014d80 ffff8800767d9fd8
Nov 26 16:39:17 portablebastien kernel: [28641.882112] Call Trace:
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8134a9a1>] schedule_hrtimeout_range_clock+0xe8/0x12f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810676ee>] ? hrtimer_wakeup+0x0/0x21
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8106816a>] ? hrtimer_start_range_ns+0xf/0x11
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8134a9f6>] schedule_hrtimeout_range+0xe/0x10
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff811112e4>] poll_schedule_timeout+0x43/0x5f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111942>] do_select+0x5b2/0x5ec
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111390>] ? do_select+0x0/0x5ec
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8111197c>] ? __pollwait+0x0/0xc7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810d9ec8>] ? might_fault+0xa0/0xa7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111d17>] core_sys_select+0x21c/0x2b2
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111b33>] ? core_sys_select+0x38/0x2b2
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81102989>] ? do_sync_read+0xc6/0x103
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8106ccea>] ? ktime_get_ts+0xad/0xba
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111fe7>] sys_select+0x91/0xb9
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Nov 26 16:39:17 portablebastien kernel: [28641.882112] kio_file      S 00000001002fccae     0 18055  15835 0x00000000
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff88001ca69908 0000000000000046 ffff880002314d80 ffff880000000000
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff88001ca68010 ffff88001ca69fd8 ffff8800c4421fc0 ffff8800c4422290
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff8800c4422288 0000000000014d80 0000000000014d80 ffff88001ca69fd8
Nov 26 16:39:17 portablebastien kernel: [28641.882112] Call Trace:
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8134a905>] schedule_hrtimeout_range_clock+0x4c/0x12f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81075039>] ? trace_hardirqs_on+0xd/0xf
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81064a5b>] ? add_wait_queue+0x3f/0x44
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8134a9f6>] schedule_hrtimeout_range+0xe/0x10
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff811112e4>] poll_schedule_timeout+0x43/0x5f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111942>] do_select+0x5b2/0x5ec
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111390>] ? do_select+0x0/0x5ec
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8111197c>] ? __pollwait+0x0/0xc7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81044430>] ? default_wake_function+0xd/0xf
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111a90>] ? pollwake+0x4d/0x4f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81044423>] ? default_wake_function+0x0/0xf
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81075039>] ? trace_hardirqs_on+0xd/0xf
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff812f9b03>] ? scm_destroy_cred+0x14/0x40
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff812f9b40>] ? scm_destroy+0x11/0x2a
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810d9ec8>] ? might_fault+0xa0/0xa7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111d17>] core_sys_select+0x21c/0x2b2
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111b33>] ? core_sys_select+0x38/0x2b2
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8112f82a>] ? fsnotify+0x79/0x449
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8112fbdb>] ? fsnotify+0x42a/0x449
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8112f82a>] ? fsnotify+0x79/0x449
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111fe7>] sys_select+0x91/0xb9
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8134b48e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Nov 26 16:39:17 portablebastien kernel: [28641.882112] kio_uiserver  S 0000000000000000     0 18582      1 0x00000000
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff88005036f908 0000000000000046 ffff88005036f8d8 0000000000000000
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff88005036e010 ffff88005036ffd8 ffff88011da6df40 ffff88011da6e210
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff88011da6e208 0000000000014d80 0000000000014d80 ffff88005036ffd8
Nov 26 16:39:17 portablebastien kernel: [28641.882112] Call Trace:
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8134a905>] schedule_hrtimeout_range_clock+0x4c/0x12f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81075039>] ? trace_hardirqs_on+0xd/0xf
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8134a9f6>] schedule_hrtimeout_range+0xe/0x10
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff811112e4>] poll_schedule_timeout+0x43/0x5f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111942>] do_select+0x5b2/0x5ec
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111390>] ? do_select+0x0/0x5ec
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8111197c>] ? __pollwait+0x0/0xc7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810d9ec8>] ? might_fault+0xa0/0xa7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111d17>] core_sys_select+0x21c/0x2b2
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111b33>] ? core_sys_select+0x38/0x2b2
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81102989>] ? do_sync_read+0xc6/0x103
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff811721aa>] ? fsnotify_perm+0x45/0x4b
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111fe7>] sys_select+0x91/0xb9
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8134b48e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Nov 26 16:39:17 portablebastien kernel: [28641.882112] bash          S 0000000100443bed     0 19615   3005 0x00000000
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff88002ab49ce8 0000000000000046 0000000000000000 0000000000000000
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff88002ab48010 ffff88002ab49fd8 ffff8800c2099fc0 ffff8800c209a290
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff8800c209a288 0000000000014d80 0000000000014d80 ffff88002ab49fd8
Nov 26 16:39:17 portablebastien kernel: [28641.882112] Call Trace:
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81349f02>] schedule_timeout+0x31/0xeb
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810569a9>] ? del_timer_sync+0x8e/0xa1
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8105691b>] ? del_timer_sync+0x0/0xa1
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810601e6>] ? flush_delayed_work+0x44/0x48
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8122f474>] n_tty_read+0x4cd/0x7af
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81044423>] ? default_wake_function+0x0/0xf
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8122ab48>] tty_read+0x81/0xc5
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81102fc7>] vfs_read+0xa6/0x102
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8134bca9>] ? _raw_spin_unlock_irq+0x2b/0x36
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff811030d9>] sys_read+0x45/0x69
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Nov 26 16:39:17 portablebastien kernel: [28641.882112] python        S 0000000000000000     0 20085      1 0x00000000
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff8800b20dda58 0000000000000046 ffff8800b20dda18 ffffffff00000000
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff8800b20dc010 ffff8800b20ddfd8 ffff8800b6c84f60 ffff8800b6c85230
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff8800b6c85228 0000000000014d80 0000000000014d80 ffff8800b20ddfd8
Nov 26 16:39:17 portablebastien kernel: [28641.882112] Call Trace:
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff812fc821>] ? unix_write_space+0x0/0xef
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8134a905>] schedule_hrtimeout_range_clock+0x4c/0x12f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81075039>] ? trace_hardirqs_on+0xd/0xf
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81064a5b>] ? add_wait_queue+0x3f/0x44
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8134a9f6>] schedule_hrtimeout_range+0xe/0x10
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff811112e4>] poll_schedule_timeout+0x43/0x5f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81112369>] do_sys_poll+0x35a/0x3e5
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8111197c>] ? __pollwait+0x0/0xc7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81279f40>] ? __sock_recvmsg_nosec+0x65/0x6e
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8127b23f>] ? __sock_recvmsg+0x49/0x54
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8127d81d>] ? sock_aio_read+0xc2/0xd6
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81102989>] ? do_sync_read+0xc6/0x103
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81102606>] ? fsnotify_access+0x61/0x69
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81112588>] sys_poll+0x50/0xbb
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Nov 26 16:39:17 portablebastien kernel: [28641.882112] python        S 00000001005b179c     0 20087      1 0x00000000
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff88003c209c28 0000000000000046 ffff88003c209cb8 ffff880000000000
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff88003c208010 ffff88003c209fd8 ffff8800b7d29fc0 ffff8800b7d2a290
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff8800b7d2a288 0000000000014d80 0000000000014d80 ffff88003c209fd8
Nov 26 16:39:17 portablebastien kernel: [28641.882112] Call Trace:
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81077c58>] futex_wait_queue_me+0x82/0x99
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81078c47>] futex_wait+0x148/0x2f9
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810e1865>] ? vma_merge+0x2ab/0x327
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810e2829>] ? __vm_enough_memory+0x26/0x151
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81079ebc>] do_futex+0x95/0x86e
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8100db8c>] ? arch_get_unmapped_area_topdown+0x4a/0x28a
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810e2677>] ? do_mmap_pgoff+0x28b/0x2ee
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8107a7bc>] sys_futex+0x127/0x13f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810e27df>] ? sys_mmap_pgoff+0x105/0x129
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8134b48e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Nov 26 16:39:17 portablebastien kernel: [28641.882112] bash          S 00000001004afdf9     0 20156   3005 0x00000000
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff880068bb7e58 0000000000000046 ffff880068bb7e28 0000000000000000
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff880068bb6010 ffff880068bb7fd8 ffff8800c200df40 ffff8800c200e210
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff8800c200e208 0000000000014d80 0000000000014d80 ffff880068bb7fd8
Nov 26 16:39:17 portablebastien kernel: [28641.882112] Call Trace:
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8104c99a>] do_wait+0x1ba/0x22e
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8104caa7>] sys_wait4+0x99/0xbc
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8104af46>] ? child_wait_callback+0x0/0x53
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Nov 26 16:39:17 portablebastien kernel: [28641.882112] mc            S 0000000100376b60     0 20717   3012 0x00000000
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff8800503ef908 0000000000000046 ffff8800503ef878 ffffffff00000000
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff8800503ee010 ffff8800503effd8 ffff88011c060000 ffff88011c0602d0
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff88011c0602c8 0000000000014d80 0000000000014d80 ffff8800503effd8
Nov 26 16:39:17 portablebastien kernel: [28641.882112] Call Trace:
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8134a905>] schedule_hrtimeout_range_clock+0x4c/0x12f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8105691b>] ? del_timer_sync+0x0/0xa1
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810601e6>] ? flush_delayed_work+0x44/0x48
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81075039>] ? trace_hardirqs_on+0xd/0xf
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8134a9f6>] schedule_hrtimeout_range+0xe/0x10
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff811112e4>] poll_schedule_timeout+0x43/0x5f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111942>] do_select+0x5b2/0x5ec
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111390>] ? do_select+0x0/0x5ec
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8111197c>] ? __pollwait+0x0/0xc7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81038223>] ? check_preempt_curr+0x1b/0x34
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81044411>] ? try_to_wake_up+0x172/0x184
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810d9ec8>] ? might_fault+0xa0/0xa7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111d17>] core_sys_select+0x21c/0x2b2
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111b33>] ? core_sys_select+0x38/0x2b2
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8112f82a>] ? fsnotify+0x79/0x449
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8105865d>] ? do_sigaction+0x80/0x179
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8105865d>] ? do_sigaction+0x80/0x179
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81075039>] ? trace_hardirqs_on+0xd/0xf
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8134bca9>] ? _raw_spin_unlock_irq+0x2b/0x36
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111fe7>] sys_select+0x91/0xb9
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8134b48e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Nov 26 16:39:17 portablebastien kernel: [28641.882112] bash          S 0000000000000000     0 20719  20717 0x00000000
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff8800b267fce8 0000000000000046 0000000000000000 0000000000000046
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff8800b267e010 ffff8800b267ffd8 ffff8800ac1b0fe0 ffff8800ac1b12b0
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff8800ac1b12a8 0000000000014d80 0000000000014d80 ffff8800b267ffd8
Nov 26 16:39:17 portablebastien kernel: [28641.882112] Call Trace:
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81075039>] ? trace_hardirqs_on+0xd/0xf
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81349f02>] schedule_timeout+0x31/0xeb
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810569a9>] ? del_timer_sync+0x8e/0xa1
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8105691b>] ? del_timer_sync+0x0/0xa1
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810601e6>] ? flush_delayed_work+0x44/0x48
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8122f474>] n_tty_read+0x4cd/0x7af
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81044423>] ? default_wake_function+0x0/0xf
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8122ab48>] tty_read+0x81/0xc5
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81102fc7>] vfs_read+0xa6/0x102
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8134bca9>] ? _raw_spin_unlock_irq+0x2b/0x36
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff811030d9>] sys_read+0x45/0x69
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Nov 26 16:39:17 portablebastien kernel: [28641.882112] bash          S ffff8800c708bf70     0 20735   3005 0x00000000
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff88002e9d9e58 0000000000000046 ffff88002e9d9e28 0000000000000246
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff88002e9d8010 ffff88002e9d9fd8 ffff8800c708bf80 ffff8800c708c250
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff8800c708c248 0000000000014d80 0000000000014d80 ffff88002e9d9fd8
Nov 26 16:39:17 portablebastien kernel: [28641.882112] Call Trace:
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8104c99a>] do_wait+0x1ba/0x22e
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8104caa7>] sys_wait4+0x99/0xbc
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8104af46>] ? child_wait_callback+0x0/0x53
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Nov 26 16:39:17 portablebastien kernel: [28641.882112] mc            S 0000000000000000     0 20739  20735 0x00000000
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff880050209908 0000000000000046 ffff880050209878 ffffffff8134bca9
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff880050208010 ffff880050209fd8 ffff88011bf26f20 ffff88011bf271f0
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff88011bf271e8 0000000000014d80 0000000000014d80 ffff880050209fd8
Nov 26 16:39:17 portablebastien kernel: [28641.882112] Call Trace:
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8134bca9>] ? _raw_spin_unlock_irq+0x2b/0x36
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81056548>] ? try_to_del_timer_sync+0x76/0x84
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8134a905>] schedule_hrtimeout_range_clock+0x4c/0x12f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8105691b>] ? del_timer_sync+0x0/0xa1
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810601e6>] ? flush_delayed_work+0x44/0x48
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81075039>] ? trace_hardirqs_on+0xd/0xf
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8134a9f6>] schedule_hrtimeout_range+0xe/0x10
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff811112e4>] poll_schedule_timeout+0x43/0x5f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111942>] do_select+0x5b2/0x5ec
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111390>] ? do_select+0x0/0x5ec
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8111197c>] ? __pollwait+0x0/0xc7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810d9ec8>] ? might_fault+0xa0/0xa7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810d9ec8>] ? might_fault+0xa0/0xa7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111d17>] core_sys_select+0x21c/0x2b2
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111b33>] ? core_sys_select+0x38/0x2b2
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8105865d>] ? do_sigaction+0x80/0x179
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8105865d>] ? do_sigaction+0x80/0x179
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81075039>] ? trace_hardirqs_on+0xd/0xf
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8134bca9>] ? _raw_spin_unlock_irq+0x2b/0x36
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111fe7>] sys_select+0x91/0xb9
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8134b48e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Nov 26 16:39:17 portablebastien kernel: [28641.882112] bash          S 0000000100544749     0 20741  20739 0x00000000
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff88000fd75ce8 0000000000000046 0000000000000000 0000000000000000
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff88000fd74010 ffff88000fd75fd8 ffff8800b6c82fa0 ffff8800b6c83270
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff8800b6c83268 0000000000014d80 0000000000014d80 ffff88000fd75fd8
Nov 26 16:39:17 portablebastien kernel: [28641.882112] Call Trace:
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81349f02>] schedule_timeout+0x31/0xeb
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810569a9>] ? del_timer_sync+0x8e/0xa1
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8105691b>] ? del_timer_sync+0x0/0xa1
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810601e6>] ? flush_delayed_work+0x44/0x48
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8122f474>] n_tty_read+0x4cd/0x7af
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81044423>] ? default_wake_function+0x0/0xf
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8122ab48>] tty_read+0x81/0xc5
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81102fc7>] vfs_read+0xa6/0x102
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8134bca9>] ? _raw_spin_unlock_irq+0x2b/0x36
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff811030d9>] sys_read+0x45/0x69
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Nov 26 16:39:17 portablebastien kernel: [28641.882112] bash          S ffff88011f782f90     0 22679   3005 0x00000000
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff88000fc9fe58 0000000000000046 ffff88000fc9fe28 0000000000000246
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff88000fc9e010 ffff88000fc9ffd8 ffff88011f782fa0 ffff88011f783270
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff88011f783268 0000000000014d80 0000000000014d80 ffff88000fc9ffd8
Nov 26 16:39:17 portablebastien kernel: [28641.882112] Call Trace:
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8104c99a>] do_wait+0x1ba/0x22e
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8104caa7>] sys_wait4+0x99/0xbc
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8104af46>] ? child_wait_callback+0x0/0x53
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Nov 26 16:39:17 portablebastien kernel: [28641.882112] ssh           S 000000010045109d     0 22705  22679 0x00000000
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff8800936fb908 0000000000000046 ffff8800936fb878 ffffffff00000000
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff8800936fa010 ffff8800936fbfd8 ffff880091b30000 ffff880091b302d0
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff880091b302c8 0000000000014d80 0000000000014d80 ffff8800936fbfd8
Nov 26 16:39:17 portablebastien kernel: [28641.882112] Call Trace:
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8134a905>] schedule_hrtimeout_range_clock+0x4c/0x12f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8105691b>] ? del_timer_sync+0x0/0xa1
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810601e6>] ? flush_delayed_work+0x44/0x48
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81075039>] ? trace_hardirqs_on+0xd/0xf
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8134a9f6>] schedule_hrtimeout_range+0xe/0x10
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff811112e4>] poll_schedule_timeout+0x43/0x5f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111942>] do_select+0x5b2/0x5ec
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111390>] ? do_select+0x0/0x5ec
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8111197c>] ? __pollwait+0x0/0xc7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8103c39c>] ? task_rq_lock+0x4c/0x7e
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81038223>] ? check_preempt_curr+0x1b/0x34
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81044411>] ? try_to_wake_up+0x172/0x184
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810d9ec8>] ? might_fault+0xa0/0xa7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111d17>] core_sys_select+0x21c/0x2b2
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111b33>] ? core_sys_select+0x38/0x2b2
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8112f82a>] ? fsnotify+0x79/0x449
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8112fbdb>] ? fsnotify+0x42a/0x449
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8112f82a>] ? fsnotify+0x79/0x449
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8103b191>] ? __wake_up+0x3f/0x48
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111fe7>] sys_select+0x91/0xb9
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8134b48e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Nov 26 16:39:17 portablebastien kernel: [28641.882112] nautilus      S 0000000000000000     0 24949   3089 0x00000000
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff88011d6b5a58 0000000000000046 ffff88011d6b59e8 0000000000000000
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff88011d6b4010 ffff88011d6b5fd8 ffff88004b335f40 ffff88004b336210
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff88004b336208 0000000000014d80 0000000000014d80 ffff88011d6b5fd8
Nov 26 16:39:17 portablebastien kernel: [28641.882112] Call Trace:
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8134a905>] schedule_hrtimeout_range_clock+0x4c/0x12f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81075039>] ? trace_hardirqs_on+0xd/0xf
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81064a5b>] ? add_wait_queue+0x3f/0x44
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8134a9f6>] schedule_hrtimeout_range+0xe/0x10
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff811112e4>] poll_schedule_timeout+0x43/0x5f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81112369>] do_sys_poll+0x35a/0x3e5
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8111197c>] ? __pollwait+0x0/0xc7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff811721aa>] ? fsnotify_perm+0x45/0x4b
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81172207>] ? security_file_permission+0x29/0x2e
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81112588>] sys_poll+0x50/0xbb
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Nov 26 16:39:17 portablebastien kernel: [28641.882112] gvfsd-trash   S 000000010044e331     0 24951      1 0x00000000
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff88010aecba58 0000000000000046 ffffffff81067dae 0000000000000000
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff88010aeca010 ffff88010aecbfd8 ffff880091b34f60 ffff880091b35230
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff880091b35228 0000000000014d80 0000000000014d80 ffff88010aecbfd8
Nov 26 16:39:17 portablebastien kernel: [28641.882112] Call Trace:
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81067dae>] ? lock_hrtimer_base+0x25/0x4b
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8134a905>] schedule_hrtimeout_range_clock+0x4c/0x12f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81075039>] ? trace_hardirqs_on+0xd/0xf
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81064a5b>] ? add_wait_queue+0x3f/0x44
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8134a9f6>] schedule_hrtimeout_range+0xe/0x10
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff811112e4>] poll_schedule_timeout+0x43/0x5f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81112369>] do_sys_poll+0x35a/0x3e5
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8111197c>] ? __pollwait+0x0/0xc7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8112fbdb>] ? fsnotify+0x42a/0x449
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8112f82a>] ? fsnotify+0x79/0x449
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff811034f6>] ? do_readv_writev+0x10b/0x124
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8106ccea>] ? ktime_get_ts+0xad/0xba
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111286>] ? poll_select_set_timeout+0x61/0x7c
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81112588>] sys_poll+0x50/0xbb
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Nov 26 16:39:17 portablebastien kernel: [28641.882112] gvfsd-burn    S 000000010044df3d     0 24953      1 0x00000000
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff8801175d1a58 0000000000000046 ffff88004b335f40 0000000000000000
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff8801175d0010 ffff8801175d1fd8 ffff88004b330fe0 ffff88004b3312b0
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff88004b3312a8 0000000000014d80 0000000000014d80 ffff8801175d1fd8
Nov 26 16:39:17 portablebastien kernel: [28641.882112] Call Trace:
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8134a905>] schedule_hrtimeout_range_clock+0x4c/0x12f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81075039>] ? trace_hardirqs_on+0xd/0xf
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81064a5b>] ? add_wait_queue+0x3f/0x44
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8134a9f6>] schedule_hrtimeout_range+0xe/0x10
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff811112e4>] poll_schedule_timeout+0x43/0x5f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81112369>] do_sys_poll+0x35a/0x3e5
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8111197c>] ? __pollwait+0x0/0xc7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8127d68c>] ? sock_aio_write+0x0/0xcf
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8127d747>] ? sock_aio_write+0xbb/0xcf
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8112f82a>] ? fsnotify+0x79/0x449
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8112f82a>] ? fsnotify+0x79/0x449
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8103a7a6>] ? rcu_read_lock+0x0/0x30
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8103a7a6>] ? rcu_read_lock+0x0/0x30
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81042616>] ? finish_task_switch+0x0/0xdf
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81075039>] ? trace_hardirqs_on+0xd/0xf
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8134bca9>] ? _raw_spin_unlock_irq+0x2b/0x36
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81042681>] ? finish_task_switch+0x6b/0xdf
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81042616>] ? finish_task_switch+0x0/0xdf
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81349b12>] ? schedule+0x606/0x652
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81112588>] sys_poll+0x50/0xbb
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Nov 26 16:39:17 portablebastien kernel: [28641.882112] kio_trash     S 0000000000000000     0 25510   2849 0x00000000
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff8800b272f908 0000000000000046 0000000000000040 0000000000000004
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff8800b272e010 ffff8800b272ffd8 ffff8800094fef20 ffff8800094ff1f0
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff8800094ff1e8 0000000000014d80 0000000000014d80 ffff8800b272ffd8
Nov 26 16:39:17 portablebastien kernel: [28641.882112] Call Trace:
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8134a905>] schedule_hrtimeout_range_clock+0x4c/0x12f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81075039>] ? trace_hardirqs_on+0xd/0xf
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81064a5b>] ? add_wait_queue+0x3f/0x44
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8134a9f6>] schedule_hrtimeout_range+0xe/0x10
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff811112e4>] poll_schedule_timeout+0x43/0x5f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111942>] do_select+0x5b2/0x5ec
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111390>] ? do_select+0x0/0x5ec
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8111197c>] ? __pollwait+0x0/0xc7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81044430>] ? default_wake_function+0xd/0xf
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111a90>] ? pollwake+0x4d/0x4f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81044423>] ? default_wake_function+0x0/0xf
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81075039>] ? trace_hardirqs_on+0xd/0xf
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff812f9b03>] ? scm_destroy_cred+0x14/0x40
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff812f9b40>] ? scm_destroy+0x11/0x2a
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810d9ec8>] ? might_fault+0xa0/0xa7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111d17>] core_sys_select+0x21c/0x2b2
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111b33>] ? core_sys_select+0x38/0x2b2
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81042616>] ? finish_task_switch+0x0/0xdf
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81075039>] ? trace_hardirqs_on+0xd/0xf
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8134bca9>] ? _raw_spin_unlock_irq+0x2b/0x36
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81042681>] ? finish_task_switch+0x6b/0xdf
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81042616>] ? finish_task_switch+0x0/0xdf
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111fe7>] sys_select+0x91/0xb9
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8134b48e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Nov 26 16:39:17 portablebastien kernel: [28641.882112] firefox-bin   S 0000000100693941     0 25511      1 0x00000000
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff8800b2189a58 0000000000000046 ffff8800b2189a68 0000000000000000
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff8800b2188010 ffff8800b2189fd8 ffff8800094f8fe0 ffff8800094f92b0
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff8800094f92a8 0000000000014d80 0000000000014d80 ffff8800b2189fd8
Nov 26 16:39:17 portablebastien kernel: [28641.882112] Call Trace:
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8134a905>] schedule_hrtimeout_range_clock+0x4c/0x12f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81075039>] ? trace_hardirqs_on+0xd/0xf
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81064a5b>] ? add_wait_queue+0x3f/0x44
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8134a9f6>] schedule_hrtimeout_range+0xe/0x10
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff811112e4>] poll_schedule_timeout+0x43/0x5f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81112369>] do_sys_poll+0x35a/0x3e5
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8111197c>] ? __pollwait+0x0/0xc7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81279f40>] ? __sock_recvmsg_nosec+0x65/0x6e
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8127b23f>] ? __sock_recvmsg+0x49/0x54
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8127d81d>] ? sock_aio_read+0xc2/0xd6
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81102989>] ? do_sync_read+0xc6/0x103
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81102606>] ? fsnotify_access+0x61/0x69
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81112588>] sys_poll+0x50/0xbb
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Nov 26 16:39:17 portablebastien kernel: [28641.882112] firefox-bin   S 00000001006904b2     0 25516      1 0x00000000
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff88008ec17a58 0000000000000046 0000000000000001 ffff880100000000
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff88008ec16010 ffff88008ec17fd8 ffff8800b7d4cf60 ffff8800b7d4d230
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff8800b7d4d228 0000000000014d80 0000000000014d80 ffff88008ec17fd8
Nov 26 16:39:17 portablebastien kernel: [28641.882112] Call Trace:
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8134a905>] schedule_hrtimeout_range_clock+0x4c/0x12f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81075039>] ? trace_hardirqs_on+0xd/0xf
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8134a9f6>] schedule_hrtimeout_range+0xe/0x10
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff811112e4>] poll_schedule_timeout+0x43/0x5f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81112369>] do_sys_poll+0x35a/0x3e5
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8111197c>] ? __pollwait+0x0/0xc7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81279f40>] ? __sock_recvmsg_nosec+0x65/0x6e
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8127b23f>] ? __sock_recvmsg+0x49/0x54
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8127b3af>] ? sock_recvmsg+0xa6/0xbf
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81115db0>] ? touch_atime+0x10a/0x125
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81103aa5>] ? fget_light+0x41/0xcf
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81103aa5>] ? fget_light+0x41/0xcf
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81103b25>] ? fget_light+0xc1/0xcf
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81103aa5>] ? fget_light+0x41/0xcf
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81102989>] ? do_sync_read+0xc6/0x103
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8127b510>] ? fput_light+0xd/0xf
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8127cd1e>] ? sys_recvfrom+0x10f/0x13c
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81102606>] ? fsnotify_access+0x61/0x69
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81112588>] sys_poll+0x50/0xbb
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Nov 26 16:39:17 portablebastien kernel: [28641.882112] firefox-bin   S 00000001006c1ca3     0 25517      1 0x00000000
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff88009181dc28 0000000000000046 ffff88009181dd38 ffff880000000000
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff88009181c010 ffff88009181dfd8 ffff8800d8b78fe0 ffff8800d8b792b0
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff8800d8b792a8 0000000000014d80 0000000000014d80 ffff88009181dfd8
Nov 26 16:39:17 portablebastien kernel: [28641.882112] Call Trace:
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81077c58>] futex_wait_queue_me+0x82/0x99
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81078c47>] futex_wait+0x148/0x2f9
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810676ee>] ? hrtimer_wakeup+0x0/0x21
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8106816a>] ? hrtimer_start_range_ns+0xf/0x11
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81079ebc>] do_futex+0x95/0x86e
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8134b48e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8107a7bc>] sys_futex+0x127/0x13f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8134b504>] ? lockdep_sys_exit_thunk+0x35/0x67
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Nov 26 16:39:17 portablebastien kernel: [28641.882112] firefox-bin   S 00000001006a5919     0 25518      1 0x00000000
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff880091871c28 0000000000000046 ffff880091871d38 ffff880000000000
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff880091870010 ffff880091871fd8 ffff8800b7edef20 ffff8800b7edf1f0
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff8800b7edf1e8 0000000000014d80 0000000000014d80 ffff880091871fd8
Nov 26 16:39:17 portablebastien kernel: [28641.882112] Call Trace:
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81077c58>] futex_wait_queue_me+0x82/0x99
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81078c47>] futex_wait+0x148/0x2f9
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810676ee>] ? hrtimer_wakeup+0x0/0x21
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8106816a>] ? hrtimer_start_range_ns+0xf/0x11
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81079ebc>] do_futex+0x95/0x86e
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8107a7bc>] sys_futex+0x127/0x13f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Nov 26 16:39:17 portablebastien kernel: [28641.882112] firefox-bin   S 000000010068f8cd     0 25563      1 0x00000000
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff8800937e3c28 0000000000000046 ffff8800937e3cb8 ffff880000000000
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff8800937e2010 ffff8800937e3fd8 ffff880037a7df40 ffff880037a7e210
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff880037a7e208 0000000000014d80 0000000000014d80 ffff8800937e3fd8
Nov 26 16:39:17 portablebastien kernel: [28641.882112] Call Trace:
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81077c58>] futex_wait_queue_me+0x82/0x99
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81078c47>] futex_wait+0x148/0x2f9
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8104dee1>] ? current_fs_time+0x22/0x29
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81103aa5>] ? fget_light+0x41/0xcf
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8112f82a>] ? fsnotify+0x79/0x449
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81079ebc>] do_futex+0x95/0x86e
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8112f82a>] ? fsnotify+0x79/0x449
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8107a7bc>] sys_futex+0x127/0x13f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8134b48e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Nov 26 16:39:17 portablebastien kernel: [28641.882112] firefox-bin   S 00000000ffffffff     0 25564      1 0x00000000
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff8800d4493c28 0000000000000046 ffff8800d4493cb8 ffff8800d4493cf0
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff8800d4492010 ffff8800d4493fd8 ffff880099a4ef20 ffff880099a4f1f0
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff880099a4f1e8 0000000000014d80 0000000000014d80 ffff8800d4493fd8
Nov 26 16:39:17 portablebastien kernel: [28641.882112] Call Trace:
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81077c58>] futex_wait_queue_me+0x82/0x99
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81078c47>] futex_wait+0x148/0x2f9
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8103b5d0>] ? update_curr+0xff/0x108
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8103bcdd>] ? dequeue_entity+0x1b/0x117
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81079ebc>] do_futex+0x95/0x86e
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81042616>] ? finish_task_switch+0x0/0xdf
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81042616>] ? finish_task_switch+0x0/0xdf
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81075039>] ? trace_hardirqs_on+0xd/0xf
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8107a7bc>] sys_futex+0x127/0x13f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8134b48e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Nov 26 16:39:17 portablebastien kernel: [28641.882112] firefox-bin   S 00000000ffffffff     0 25568      1 0x00000000
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff8800adff7c28 0000000000000046 ffff8800adff7cb8 ffff8800adff7cf0
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff8800adff6010 ffff8800adff7fd8 ffff88011f6c3f80 ffff88011f6c4250
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff88011f6c4248 0000000000014d80 0000000000014d80 ffff8800adff7fd8
Nov 26 16:39:17 portablebastien kernel: [28641.882112] Call Trace:
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81077c58>] futex_wait_queue_me+0x82/0x99
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81078c47>] futex_wait+0x148/0x2f9
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8104dee1>] ? current_fs_time+0x22/0x29
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8112f82a>] ? fsnotify+0x79/0x449
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81079ebc>] do_futex+0x95/0x86e
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8112f82a>] ? fsnotify+0x79/0x449
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8107a7bc>] sys_futex+0x127/0x13f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8134b48e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Nov 26 16:39:17 portablebastien kernel: [28641.882112] firefox-bin   S 000000010067a575     0 25583      1 0x00000000
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff8800b214fc28 0000000000000046 ffff8800b214fcb8 ffff880000000000
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff8800b214e010 ffff8800b214ffd8 ffff88011da6afa0 ffff88011da6b270
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff88011da6b268 0000000000014d80 0000000000014d80 ffff8800b214ffd8
Nov 26 16:39:17 portablebastien kernel: [28641.882112] Call Trace:
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81077c58>] futex_wait_queue_me+0x82/0x99
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81078c47>] futex_wait+0x148/0x2f9
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8104dee1>] ? current_fs_time+0x22/0x29
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8113a38e>] ? fcntl_setlk+0x244/0x3c2
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81079ebc>] do_futex+0x95/0x86e
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8113a4f4>] ? fcntl_setlk+0x3aa/0x3c2
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8107a7bc>] sys_futex+0x127/0x13f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8134b48e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Nov 26 16:39:17 portablebastien kernel: [28641.882112] octave        S 00000001005fcb4e     0 26553  20156 0x00000000
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff880117a31ce8 0000000000000046 0000000000000000 0000000000000046
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff880117a30010 ffff880117a31fd8 ffff8800094f8000 ffff8800094f82d0
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff8800094f82c8 0000000000014d80 0000000000014d80 ffff880117a31fd8
Nov 26 16:39:17 portablebastien kernel: [28641.882112] Call Trace:
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81075039>] ? trace_hardirqs_on+0xd/0xf
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81349f02>] schedule_timeout+0x31/0xeb
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810569a9>] ? del_timer_sync+0x8e/0xa1
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8105691b>] ? del_timer_sync+0x0/0xa1
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810601e6>] ? flush_delayed_work+0x44/0x48
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8122f474>] n_tty_read+0x4cd/0x7af
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81044423>] ? default_wake_function+0x0/0xf
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8122ab48>] tty_read+0x81/0xc5
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81102fc7>] vfs_read+0xa6/0x102
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8134bca9>] ? _raw_spin_unlock_irq+0x2b/0x36
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff811030d9>] sys_read+0x45/0x69
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Nov 26 16:39:17 portablebastien kernel: [28641.882112] kio_http      S 000000010068d405     0 26739   2849 0x00000000
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff88010afa5908 0000000000000046 ffff88010afa5918 0000000000000000
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff88010afa4010 ffff88010afa5fd8 ffff88011c5bef20 ffff88011c5bf1f0
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff88011c5bf1e8 0000000000014d80 0000000000014d80 ffff88010afa5fd8
Nov 26 16:39:17 portablebastien kernel: [28641.882112] Call Trace:
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8134a905>] schedule_hrtimeout_range_clock+0x4c/0x12f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81075039>] ? trace_hardirqs_on+0xd/0xf
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81064a5b>] ? add_wait_queue+0x3f/0x44
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8134a9f6>] schedule_hrtimeout_range+0xe/0x10
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff811112e4>] poll_schedule_timeout+0x43/0x5f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111942>] do_select+0x5b2/0x5ec
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111390>] ? do_select+0x0/0x5ec
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8111197c>] ? __pollwait+0x0/0xc7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81044430>] ? default_wake_function+0xd/0xf
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111a90>] ? pollwake+0x4d/0x4f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81044423>] ? default_wake_function+0x0/0xf
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81075039>] ? trace_hardirqs_on+0xd/0xf
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff812f9b03>] ? scm_destroy_cred+0x14/0x40
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff812f9b40>] ? scm_destroy+0x11/0x2a
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810d9ec8>] ? might_fault+0xa0/0xa7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111d17>] core_sys_select+0x21c/0x2b2
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111b33>] ? core_sys_select+0x38/0x2b2
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8112f82a>] ? fsnotify+0x79/0x449
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8112fbdb>] ? fsnotify+0x42a/0x449
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8112f82a>] ? fsnotify+0x79/0x449
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111fe7>] sys_select+0x91/0xb9
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8134b48e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Nov 26 16:39:17 portablebastien kernel: [28641.882112] gnuplot       S 0000000000000000     0 27427  26553 0x00000000
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff8800b6c2d908 0000000000000046 ffff88011c318000 0000000000000000
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff8800b6c2c010 ffff8800b6c2dfd8 ffff88011f6c1fc0 ffff88011f6c2290
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff88011f6c2288 0000000000014d80 0000000000014d80 ffff8800b6c2dfd8
Nov 26 16:39:17 portablebastien kernel: [28641.882112] Call Trace:
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8134a905>] schedule_hrtimeout_range_clock+0x4c/0x12f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81075039>] ? trace_hardirqs_on+0xd/0xf
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8134a9f6>] schedule_hrtimeout_range+0xe/0x10
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff811112e4>] poll_schedule_timeout+0x43/0x5f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111942>] do_select+0x5b2/0x5ec
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111390>] ? do_select+0x0/0x5ec
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8111197c>] ? __pollwait+0x0/0xc7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81038223>] ? check_preempt_curr+0x1b/0x34
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81073728>] ? trace_hardirqs_off+0xd/0xf
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8134bcef>] ? _raw_spin_unlock_irqrestore+0x3b/0x51
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81044430>] ? default_wake_function+0xd/0xf
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810d9ec8>] ? might_fault+0xa0/0xa7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111d17>] core_sys_select+0x21c/0x2b2
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111b33>] ? core_sys_select+0x38/0x2b2
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8112f82a>] ? fsnotify+0x79/0x449
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8112fbdb>] ? fsnotify+0x42a/0x449
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8112f82a>] ? fsnotify+0x79/0x449
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111fe7>] sys_select+0x91/0xb9
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8134b48e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Nov 26 16:39:17 portablebastien kernel: [28641.882112] gnuplot_x11   S 0000000000000000     0 27430  27427 0x00000000
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff88001cadf908 0000000000000046 0000000000000001 0000000000000000
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff88001cade010 ffff88001cadffd8 ffff880037a78000 ffff880037a782d0
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff880037a782c8 0000000000014d80 0000000000014d80 ffff88001cadffd8
Nov 26 16:39:17 portablebastien kernel: [28641.882112] Call Trace:
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8134a905>] schedule_hrtimeout_range_clock+0x4c/0x12f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81075039>] ? trace_hardirqs_on+0xd/0xf
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81064a5b>] ? add_wait_queue+0x3f/0x44
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8134a9f6>] schedule_hrtimeout_range+0xe/0x10
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff811112e4>] poll_schedule_timeout+0x43/0x5f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111942>] do_select+0x5b2/0x5ec
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111390>] ? do_select+0x0/0x5ec
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8111197c>] ? __pollwait+0x0/0xc7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff812fb5b8>] ? unix_stream_recvmsg+0x5a3/0x5c3
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff812fb826>] ? unix_stream_sendmsg+0x24e/0x2d0
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810d9ec8>] ? might_fault+0xa0/0xa7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111d17>] core_sys_select+0x21c/0x2b2
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111b33>] ? core_sys_select+0x38/0x2b2
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81102989>] ? do_sync_read+0xc6/0x103
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff811721aa>] ? fsnotify_perm+0x45/0x4b
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111fe7>] sys_select+0x91/0xb9
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8134b48e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Nov 26 16:39:17 portablebastien kernel: [28641.882112] kio_trash     S 00000001004fcad8     0 27926   2849 0x00000000
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff8801177a1908 0000000000000046 ffff8801177a18c8 ffffffff00000001
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff8801177a0010 ffff8801177a1fd8 ffff88004b331fc0 ffff88004b332290
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff88004b332288 0000000000014d80 0000000000014d80 ffff8801177a1fd8
Nov 26 16:39:17 portablebastien kernel: [28641.882112] Call Trace:
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8134a905>] schedule_hrtimeout_range_clock+0x4c/0x12f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81075039>] ? trace_hardirqs_on+0xd/0xf
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81064a5b>] ? add_wait_queue+0x3f/0x44
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8134a9f6>] schedule_hrtimeout_range+0xe/0x10
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff811112e4>] poll_schedule_timeout+0x43/0x5f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111942>] do_select+0x5b2/0x5ec
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111390>] ? do_select+0x0/0x5ec
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff811132f9>] ? d_rehash+0x23/0x44
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8111197c>] ? __pollwait+0x0/0xc7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8128294c>] ? skb_queue_tail+0x1f/0x48
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8127e6d7>] ? rcu_read_lock+0x0/0x30
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8127e6d7>] ? rcu_read_lock+0x0/0x30
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff812f9b03>] ? scm_destroy_cred+0x14/0x40
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff812f9b40>] ? scm_destroy+0x11/0x2a
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810d9ec8>] ? might_fault+0xa0/0xa7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111d17>] core_sys_select+0x21c/0x2b2
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111b33>] ? core_sys_select+0x38/0x2b2
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8112f82a>] ? fsnotify+0x79/0x449
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8112fbdb>] ? fsnotify+0x42a/0x449
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8112f82a>] ? fsnotify+0x79/0x449
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111fe7>] sys_select+0x91/0xb9
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8134b48e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Nov 26 16:39:17 portablebastien kernel: [28641.882112] krunner       S 00000001006c1b0a     0 27964      1 0x00000000
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff88001fab7a58 0000000000000046 ffff88001fab7a68 00001a0e00000000
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff88001fab6010 ffff88001fab7fd8 ffff8800b7d1cf60 ffff8800b7d1d230
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff8800b7d1d228 0000000000014d80 0000000000014d80 ffff88001fab7fd8
Nov 26 16:39:17 portablebastien kernel: [28641.882112] Call Trace:
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8134a9a1>] schedule_hrtimeout_range_clock+0xe8/0x12f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810676ee>] ? hrtimer_wakeup+0x0/0x21
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8106816a>] ? hrtimer_start_range_ns+0xf/0x11
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8134a9f6>] schedule_hrtimeout_range+0xe/0x10
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff811112e4>] poll_schedule_timeout+0x43/0x5f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81112369>] do_sys_poll+0x35a/0x3e5
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8111197c>] ? __pollwait+0x0/0xc7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81102989>] ? do_sync_read+0xc6/0x103
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff811721aa>] ? fsnotify_perm+0x45/0x4b
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8106ccea>] ? ktime_get_ts+0xad/0xba
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111286>] ? poll_select_set_timeout+0x61/0x7c
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81112588>] sys_poll+0x50/0xbb
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Nov 26 16:39:17 portablebastien kernel: [28641.882112] gnuplot       S 0000000000000000     0 28473  26553 0x00000000
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff880064495908 0000000000000046 ffff8800644958e8 ffffffff00000000
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff880064494010 ffff880064495fd8 ffff88011c23bf80 ffff88011c23c250
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff88011c23c248 0000000000014d80 0000000000014d80 ffff880064495fd8
Nov 26 16:39:17 portablebastien kernel: [28641.882112] Call Trace:
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8134a905>] schedule_hrtimeout_range_clock+0x4c/0x12f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81075039>] ? trace_hardirqs_on+0xd/0xf
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8134a9f6>] schedule_hrtimeout_range+0xe/0x10
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff811112e4>] poll_schedule_timeout+0x43/0x5f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111942>] do_select+0x5b2/0x5ec
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111390>] ? do_select+0x0/0x5ec
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8103a7a6>] ? rcu_read_lock+0x0/0x30
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8111197c>] ? __pollwait+0x0/0xc7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81038223>] ? check_preempt_curr+0x1b/0x34
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81073728>] ? trace_hardirqs_off+0xd/0xf
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8134bcef>] ? _raw_spin_unlock_irqrestore+0x3b/0x51
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81044430>] ? default_wake_function+0xd/0xf
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810d9ec8>] ? might_fault+0xa0/0xa7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111d17>] core_sys_select+0x21c/0x2b2
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111b33>] ? core_sys_select+0x38/0x2b2
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8112f82a>] ? fsnotify+0x79/0x449
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8112fbdb>] ? fsnotify+0x42a/0x449
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8112f82a>] ? fsnotify+0x79/0x449
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111fe7>] sys_select+0x91/0xb9
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8134b48e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Nov 26 16:39:17 portablebastien kernel: [28641.882112] gnuplot_x11   S 0000000000000000     0 28474  28473 0x00000000
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff880019f51908 0000000000000046 0000000000000000 ffff880000000000
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff880019f50010 ffff880019f51fd8 ffff880093624f60 ffff880093625230
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff880093625228 0000000000014d80 0000000000014d80 ffff880019f51fd8
Nov 26 16:39:17 portablebastien kernel: [28641.882112] Call Trace:
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8134a905>] schedule_hrtimeout_range_clock+0x4c/0x12f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81075039>] ? trace_hardirqs_on+0xd/0xf
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81064a5b>] ? add_wait_queue+0x3f/0x44
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8134a9f6>] schedule_hrtimeout_range+0xe/0x10
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff811112e4>] poll_schedule_timeout+0x43/0x5f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111942>] do_select+0x5b2/0x5ec
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111390>] ? do_select+0x0/0x5ec
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8111197c>] ? __pollwait+0x0/0xc7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff812fb5b8>] ? unix_stream_recvmsg+0x5a3/0x5c3
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff812fb826>] ? unix_stream_sendmsg+0x24e/0x2d0
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810d9ec8>] ? might_fault+0xa0/0xa7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111d17>] core_sys_select+0x21c/0x2b2
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111b33>] ? core_sys_select+0x38/0x2b2
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81102989>] ? do_sync_read+0xc6/0x103
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff811721aa>] ? fsnotify_perm+0x45/0x4b
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111fe7>] sys_select+0x91/0xb9
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8134b48e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Nov 26 16:39:17 portablebastien kernel: [28641.882112] kworker/1:1   S 0000000000015740     0 30251      2 0x00000000
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff880039857e50 0000000000000046 ffffffff8105f151 ffff88011dab2e40
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff880039856010 ffff880039857fd8 ffff880037a78fe0 ffff880037a792b0
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff880037a792a8 0000000000014d80 0000000000014d80 ffff880039857fd8
Nov 26 16:39:17 portablebastien kernel: [28641.882112] Call Trace:
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8105f151>] ? process_one_work+0x31e/0x392
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81060ef3>] worker_thread+0x24c/0x251
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81060ca7>] ? worker_thread+0x0/0x251
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810642a2>] kthread+0x8c/0x94
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8100a964>] kernel_thread_helper+0x4/0x10
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8134c110>] ? restore_args+0x0/0x30
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81064216>] ? kthread+0x0/0x94
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8100a960>] ? kernel_thread_helper+0x0/0x10
Nov 26 16:39:17 portablebastien kernel: [28641.882112] bash          S 0000000000000000     0 30541   3005 0x00000000
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff880016099ce8 0000000000000046 0000000000000000 0000000000000046
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff880016098010 ffff880016099fd8 ffff880037a7bf80 ffff880037a7c250
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff880037a7c248 0000000000014d80 0000000000014d80 ffff880016099fd8
Nov 26 16:39:17 portablebastien kernel: [28641.882112] Call Trace:
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81075039>] ? trace_hardirqs_on+0xd/0xf
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81349f02>] schedule_timeout+0x31/0xeb
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810569a9>] ? del_timer_sync+0x8e/0xa1
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8105691b>] ? del_timer_sync+0x0/0xa1
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810601e6>] ? flush_delayed_work+0x44/0x48
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8122f474>] n_tty_read+0x4cd/0x7af
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81044423>] ? default_wake_function+0x0/0xf
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8122ab48>] tty_read+0x81/0xc5
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81102fc7>] vfs_read+0xa6/0x102
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8134bca9>] ? _raw_spin_unlock_irq+0x2b/0x36
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff811030d9>] sys_read+0x45/0x69
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Nov 26 16:39:17 portablebastien kernel: [28641.882112] kio_file      S 00000001006985e0     0 31524   2849 0x00000000
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff88000fc1b908 0000000000000046 ffffea00020f3620 0000000000000000
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff88000fc1a010 ffff88000fc1bfd8 ffff8800d4534f60 ffff8800d4535230
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff8800d4535228 0000000000014d80 0000000000014d80 ffff88000fc1bfd8
Nov 26 16:39:17 portablebastien kernel: [28641.882112] Call Trace:
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8134a905>] schedule_hrtimeout_range_clock+0x4c/0x12f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81075039>] ? trace_hardirqs_on+0xd/0xf
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81064a5b>] ? add_wait_queue+0x3f/0x44
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8134a9f6>] schedule_hrtimeout_range+0xe/0x10
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff811112e4>] poll_schedule_timeout+0x43/0x5f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111942>] do_select+0x5b2/0x5ec
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111390>] ? do_select+0x0/0x5ec
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8103d088>] ? select_task_rq_fair+0x70d/0x712
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8111197c>] ? __pollwait+0x0/0xc7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81044430>] ? default_wake_function+0xd/0xf
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111a90>] ? pollwake+0x4d/0x4f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81044423>] ? default_wake_function+0x0/0xf
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81075039>] ? trace_hardirqs_on+0xd/0xf
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff812f9b03>] ? scm_destroy_cred+0x14/0x40
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff812f9b40>] ? scm_destroy+0x11/0x2a
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810d9ec8>] ? might_fault+0xa0/0xa7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111d17>] core_sys_select+0x21c/0x2b2
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111b33>] ? core_sys_select+0x38/0x2b2
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8112f82a>] ? fsnotify+0x79/0x449
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8112fbdb>] ? fsnotify+0x42a/0x449
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8112f82a>] ? fsnotify+0x79/0x449
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111fe7>] sys_select+0x91/0xb9
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8134b48e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Nov 26 16:39:17 portablebastien kernel: [28641.882112] okular        D 000000010069a3b0     0 31706   2849 0x00000000
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff8800645cf9c8 0000000000000046 ffff880000000000 ffff880100000000
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff8800645ce010 ffff8800645cffd8 ffff8800bfe9bf80 ffff8800bfe9c250
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff8800bfe9c248 0000000000014d80 0000000000014d80 ffff8800645cffd8
Nov 26 16:39:17 portablebastien kernel: [28641.882112] Call Trace:
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffffa01b8454>] queue_log_writer+0x7e/0xaf [reiserfs]
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81044423>] ? default_wake_function+0x0/0xf
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffffa01bc402>] do_journal_begin_r+0x1ee/0x2d8 [reiserfs]
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffffa01bc5ae>] journal_begin+0xc2/0x103 [reiserfs]
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffffa01a1a05>] reiserfs_truncate_file+0x191/0x29f [reiserfs]
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffffa01a3b5c>] reiserfs_vfs_truncate_file+0x28/0x35 [reiserfs]
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810ccd3d>] vmtruncate+0x3f/0x4a
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffffa019fcfe>] reiserfs_setattr+0x29f/0x328 [reiserfs]
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81117569>] notify_change+0x19d/0x298
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff811021b8>] do_truncate+0x67/0x84
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8110b45a>] ? get_write_access+0x41/0x48
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8110cfe5>] do_last+0x463/0x532
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8110eb96>] do_filp_open+0x203/0x599
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8134bd2b>] ? _raw_spin_unlock+0x26/0x2a
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff811184a0>] ? alloc_fd+0x170/0x182
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81101366>] do_sys_open+0x5b/0xf7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8134b48e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8110142b>] sys_open+0x1b/0x1d
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Nov 26 16:39:17 portablebastien kernel: [28641.882112] gnuplot       S 0000000000000000     0 32616  26553 0x00000000
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff880039837908 0000000000000046 ffff8800398378e8 ffffffff81126533
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff880039836010 ffff880039837fd8 ffff8800b7d4ef20 ffff8800b7d4f1f0
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff8800b7d4f1e8 0000000000014d80 0000000000014d80 ffff880039837fd8
Nov 26 16:39:17 portablebastien kernel: [28641.882112] Call Trace:
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81126533>] ? __find_get_block+0x1a3/0x1b5
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8134a905>] schedule_hrtimeout_range_clock+0x4c/0x12f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810c72bc>] ? zone_watermark_ok+0x24/0xb5
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81075039>] ? trace_hardirqs_on+0xd/0xf
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8134a9f6>] schedule_hrtimeout_range+0xe/0x10
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff811112e4>] poll_schedule_timeout+0x43/0x5f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111942>] do_select+0x5b2/0x5ec
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111390>] ? do_select+0x0/0x5ec
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8103a7a6>] ? rcu_read_lock+0x0/0x30
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8111197c>] ? __pollwait+0x0/0xc7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8110a79a>] ? pipe_read+0x6d/0x3b6
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8103b115>] ? __wake_up_sync_key+0x22/0x52
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8103b115>] ? __wake_up_sync_key+0x22/0x52
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810d9ec8>] ? might_fault+0xa0/0xa7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111d17>] core_sys_select+0x21c/0x2b2
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111b33>] ? core_sys_select+0x38/0x2b2
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81102989>] ? do_sync_read+0xc6/0x103
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111fe7>] sys_select+0x91/0xb9
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8134b48e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Nov 26 16:39:17 portablebastien kernel: [28641.882112] gnuplot_x11   S 0000000000000000     0 32617  32616 0x00000000
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff88003de05908 0000000000000046 0000000000000000 0000000000000000
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff88003de04010 ffff88003de05fd8 ffff8800b7d4df40 ffff8800b7d4e210
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff8800b7d4e208 0000000000014d80 0000000000014d80 ffff88003de05fd8
Nov 26 16:39:17 portablebastien kernel: [28641.882112] Call Trace:
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8134a905>] schedule_hrtimeout_range_clock+0x4c/0x12f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81075039>] ? trace_hardirqs_on+0xd/0xf
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81064a5b>] ? add_wait_queue+0x3f/0x44
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8134a9f6>] schedule_hrtimeout_range+0xe/0x10
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff811112e4>] poll_schedule_timeout+0x43/0x5f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111942>] do_select+0x5b2/0x5ec
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111390>] ? do_select+0x0/0x5ec
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8111197c>] ? __pollwait+0x0/0xc7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff812fb5b8>] ? unix_stream_recvmsg+0x5a3/0x5c3
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff812fb826>] ? unix_stream_sendmsg+0x24e/0x2d0
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810d9ec8>] ? might_fault+0xa0/0xa7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111d17>] core_sys_select+0x21c/0x2b2
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111b33>] ? core_sys_select+0x38/0x2b2
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81102989>] ? do_sync_read+0xc6/0x103
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff811721aa>] ? fsnotify_perm+0x45/0x4b
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111fe7>] sys_select+0x91/0xb9
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8134b48e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Nov 26 16:39:17 portablebastien kernel: [28641.882112] aspell        S ffff88000f91bec8     0 32645   9241 0x00000000
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff88000f91bcd8 0000000000000046 ffff88002ff2fc18 0000000000000046
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff88000f91a010 ffff88000f91bfd8 ffff88004b330000 ffff88004b3302d0
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff88004b3302c8 0000000000014d80 0000000000014d80 ffff88000f91bfd8
Nov 26 16:39:17 portablebastien kernel: [28641.882112] Call Trace:
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8110a1e2>] pipe_wait+0x5e/0x7a
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8106473b>] ? autoremove_wake_function+0x0/0x34
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8134a8b4>] ? mutex_lock_nested+0x39/0x3e
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8110aa62>] pipe_read+0x335/0x3b6
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8112f82a>] ? fsnotify+0x79/0x449
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81102989>] do_sync_read+0xc6/0x103
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff811721aa>] ? fsnotify_perm+0x45/0x4b
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81172207>] ? security_file_permission+0x29/0x2e
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81102fc7>] vfs_read+0xa6/0x102
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff811030d9>] sys_read+0x45/0x69
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Nov 26 16:39:17 portablebastien kernel: [28641.882112] kworker/0:2   S 0000000000015740     0   855      2 0x00000000
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff8800c738fe50 0000000000000046 ffffffff8105f151 ffff88002fedb780
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff8800c738e010 ffff8800c738ffd8 ffff8800c200ef20 ffff8800c200f1f0
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff8800c200f1e8 0000000000014d80 0000000000014d80 ffff8800c738ffd8
Nov 26 16:39:17 portablebastien kernel: [28641.882112] Call Trace:
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8105f151>] ? process_one_work+0x31e/0x392
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81060ef3>] worker_thread+0x24c/0x251
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81060ca7>] ? worker_thread+0x0/0x251
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810642a2>] kthread+0x8c/0x94
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8100a964>] kernel_thread_helper+0x4/0x10
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8134c110>] ? restore_args+0x0/0x30
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81064216>] ? kthread+0x0/0x94
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8100a960>] ? kernel_thread_helper+0x0/0x10
Nov 26 16:39:17 portablebastien kernel: [28641.882112] kio_http      S 000000010068d49b     0  1177   2849 0x00000000
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff8800918a9908 0000000000000046 ffff880000000041 0000000000000000
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff8800918a8010 ffff8800918a9fd8 ffff880091b31fc0 ffff880091b32290
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff880091b32288 0000000000014d80 0000000000014d80 ffff8800918a9fd8
Nov 26 16:39:17 portablebastien kernel: [28641.882112] Call Trace:
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8134a905>] schedule_hrtimeout_range_clock+0x4c/0x12f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81075039>] ? trace_hardirqs_on+0xd/0xf
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81064a5b>] ? add_wait_queue+0x3f/0x44
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8134a9f6>] schedule_hrtimeout_range+0xe/0x10
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff811112e4>] poll_schedule_timeout+0x43/0x5f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111942>] do_select+0x5b2/0x5ec
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111390>] ? do_select+0x0/0x5ec
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8111197c>] ? __pollwait+0x0/0xc7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8128294c>] ? skb_queue_tail+0x1f/0x48
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8127e6d7>] ? rcu_read_lock+0x0/0x30
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8127e6d7>] ? rcu_read_lock+0x0/0x30
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff812f9b03>] ? scm_destroy_cred+0x14/0x40
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff812f9b40>] ? scm_destroy+0x11/0x2a
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810d9ec8>] ? might_fault+0xa0/0xa7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111d17>] core_sys_select+0x21c/0x2b2
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111b33>] ? core_sys_select+0x38/0x2b2
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8112f82a>] ? fsnotify+0x79/0x449
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8112fbdb>] ? fsnotify+0x42a/0x449
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8112f82a>] ? fsnotify+0x79/0x449
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111fe7>] sys_select+0x91/0xb9
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8134b48e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Nov 26 16:39:17 portablebastien kernel: [28641.882112] kio_http      S 0000000000000000     0  1346   2849 0x00000000
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff88000fda3908 0000000000000046 ffff880000000041 0000000000000046
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff88000fda2010 ffff88000fda3fd8 ffff8800b6c81fc0 ffff8800b6c82290
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff8800b6c82288 0000000000014d80 0000000000014d80 ffff88000fda3fd8
Nov 26 16:39:17 portablebastien kernel: [28641.882112] Call Trace:
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8134a905>] schedule_hrtimeout_range_clock+0x4c/0x12f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81075039>] ? trace_hardirqs_on+0xd/0xf
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81064a5b>] ? add_wait_queue+0x3f/0x44
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8134a9f6>] schedule_hrtimeout_range+0xe/0x10
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff811112e4>] poll_schedule_timeout+0x43/0x5f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111942>] do_select+0x5b2/0x5ec
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111390>] ? do_select+0x0/0x5ec
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8111197c>] ? __pollwait+0x0/0xc7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8128294c>] ? skb_queue_tail+0x1f/0x48
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8127e6d7>] ? rcu_read_lock+0x0/0x30
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8127e6d7>] ? rcu_read_lock+0x0/0x30
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff812f9b03>] ? scm_destroy_cred+0x14/0x40
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff812f9b40>] ? scm_destroy+0x11/0x2a
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810d9ec8>] ? might_fault+0xa0/0xa7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111d17>] core_sys_select+0x21c/0x2b2
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111b33>] ? core_sys_select+0x38/0x2b2
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8112f82a>] ? fsnotify+0x79/0x449
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8112fbdb>] ? fsnotify+0x42a/0x449
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8112f82a>] ? fsnotify+0x79/0x449
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111fe7>] sys_select+0x91/0xb9
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8134b48e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Nov 26 16:39:17 portablebastien kernel: [28641.882112] kio_smtp      S 0000000000000000     0  1585   2849 0x00000000
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff8800767df908 0000000000000046 ffff8800767df888 ffffffff8134b670
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff8800767de010 ffff8800767dffd8 ffff880093620000 ffff8800936202d0
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff8800936202c8 0000000000014d80 0000000000014d80 ffff8800767dffd8
Nov 26 16:39:17 portablebastien kernel: [28641.882112] Call Trace:
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8134b670>] ? _raw_spin_lock+0x34/0x3b
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8134a905>] schedule_hrtimeout_range_clock+0x4c/0x12f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81075039>] ? trace_hardirqs_on+0xd/0xf
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81064a5b>] ? add_wait_queue+0x3f/0x44
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8134a9f6>] schedule_hrtimeout_range+0xe/0x10
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff811112e4>] poll_schedule_timeout+0x43/0x5f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111942>] do_select+0x5b2/0x5ec
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111390>] ? do_select+0x0/0x5ec
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8111197c>] ? __pollwait+0x0/0xc7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8128294c>] ? skb_queue_tail+0x1f/0x48
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8127e6d7>] ? rcu_read_lock+0x0/0x30
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8127e6d7>] ? rcu_read_lock+0x0/0x30
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff812f9b03>] ? scm_destroy_cred+0x14/0x40
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff812f9b40>] ? scm_destroy+0x11/0x2a
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810d9ec8>] ? might_fault+0xa0/0xa7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111d17>] core_sys_select+0x21c/0x2b2
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111b33>] ? core_sys_select+0x38/0x2b2
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8112f82a>] ? fsnotify+0x79/0x449
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8112fbdb>] ? fsnotify+0x42a/0x449
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8112f82a>] ? fsnotify+0x79/0x449
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111fe7>] sys_select+0x91/0xb9
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8134b48e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Nov 26 16:39:17 portablebastien kernel: [28641.882112] bash          S 000000010066610d     0  1589   3005 0x00000000
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff88002fe1fce8 0000000000000046 0000000000000000 0000000000000000
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff88002fe1e010 ffff88002fe1ffd8 ffff880093623f80 ffff880093624250
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff880093624248 0000000000014d80 0000000000014d80 ffff88002fe1ffd8
Nov 26 16:39:17 portablebastien kernel: [28641.882112] Call Trace:
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81349f02>] schedule_timeout+0x31/0xeb
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810569a9>] ? del_timer_sync+0x8e/0xa1
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8105691b>] ? del_timer_sync+0x0/0xa1
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810601e6>] ? flush_delayed_work+0x44/0x48
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8122f474>] n_tty_read+0x4cd/0x7af
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81044423>] ? default_wake_function+0x0/0xf
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8122ab48>] tty_read+0x81/0xc5
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81102fc7>] vfs_read+0xa6/0x102
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8134bca9>] ? _raw_spin_unlock_irq+0x2b/0x36
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff811030d9>] sys_read+0x45/0x69
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Nov 26 16:39:17 portablebastien kernel: [28641.882112] kio_http      S 0000000000000000     0  1593   2849 0x00000000
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff88000fd2b908 0000000000000046 ffff88000fd2b868 ffffffff8134a32b
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff88000fd2a010 ffff88000fd2bfd8 ffff880093626f20 ffff8800936271f0
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff8800936271e8 0000000000014d80 0000000000014d80 ffff88000fd2bfd8
Nov 26 16:39:17 portablebastien kernel: [28641.882112] Call Trace:
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8134a32b>] ? mutex_unlock+0x9/0xb
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8134a905>] schedule_hrtimeout_range_clock+0x4c/0x12f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81075039>] ? trace_hardirqs_on+0xd/0xf
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81064a5b>] ? add_wait_queue+0x3f/0x44
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8134a9f6>] schedule_hrtimeout_range+0xe/0x10
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff811112e4>] poll_schedule_timeout+0x43/0x5f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111942>] do_select+0x5b2/0x5ec
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111390>] ? do_select+0x0/0x5ec
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff812a3e3b>] ? sch_direct_xmit+0x98/0x14e
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8111197c>] ? __pollwait+0x0/0xc7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8128294c>] ? skb_queue_tail+0x1f/0x48
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8127e6d7>] ? rcu_read_lock+0x0/0x30
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8127e6d7>] ? rcu_read_lock+0x0/0x30
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff812f9b03>] ? scm_destroy_cred+0x14/0x40
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff812f9b40>] ? scm_destroy+0x11/0x2a
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810d9ec8>] ? might_fault+0xa0/0xa7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111d17>] core_sys_select+0x21c/0x2b2
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111b33>] ? core_sys_select+0x38/0x2b2
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8112f82a>] ? fsnotify+0x79/0x449
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8112fbdb>] ? fsnotify+0x42a/0x449
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8112f82a>] ? fsnotify+0x79/0x449
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111fe7>] sys_select+0x91/0xb9
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8134b48e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Nov 26 16:39:17 portablebastien kernel: [28641.882112] kio_http      S 0000000000000000     0  2175   2849 0x00000000
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff88001cb57908 0000000000000046 ffff88001cb57918 0000000000000000
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff88001cb56010 ffff88001cb57fd8 ffff8800b7d4bf80 ffff8800b7d4c250
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff8800b7d4c248 0000000000014d80 0000000000014d80 ffff88001cb57fd8
Nov 26 16:39:17 portablebastien kernel: [28641.882112] Call Trace:
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8134a905>] schedule_hrtimeout_range_clock+0x4c/0x12f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81075039>] ? trace_hardirqs_on+0xd/0xf
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81064a5b>] ? add_wait_queue+0x3f/0x44
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8134a9f6>] schedule_hrtimeout_range+0xe/0x10
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff811112e4>] poll_schedule_timeout+0x43/0x5f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111942>] do_select+0x5b2/0x5ec
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111390>] ? do_select+0x0/0x5ec
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff812a3e3b>] ? sch_direct_xmit+0x98/0x14e
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8111197c>] ? __pollwait+0x0/0xc7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8128294c>] ? skb_queue_tail+0x1f/0x48
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8127e6d7>] ? rcu_read_lock+0x0/0x30
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8127e6d7>] ? rcu_read_lock+0x0/0x30
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff812f9b03>] ? scm_destroy_cred+0x14/0x40
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff812f9b40>] ? scm_destroy+0x11/0x2a
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810d9ec8>] ? might_fault+0xa0/0xa7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111d17>] core_sys_select+0x21c/0x2b2
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111b33>] ? core_sys_select+0x38/0x2b2
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8112f82a>] ? fsnotify+0x79/0x449
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8112fbdb>] ? fsnotify+0x42a/0x449
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8112f82a>] ? fsnotify+0x79/0x449
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111fe7>] sys_select+0x91/0xb9
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8134b48e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Nov 26 16:39:17 portablebastien kernel: [28641.882112] pickup        S 00000001006bf55a     0  2297   2414 0x00000000
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff88000fc6be08 0000000000000046 ffffffff810564ac 0000000000000000
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff88000fc6a010 ffff88000fc6bfd8 ffff8800094fdf40 ffff8800094fe210
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff8800094fe208 0000000000014d80 0000000000014d80 ffff88000fc6bfd8
Nov 26 16:39:17 portablebastien kernel: [28641.882112] Call Trace:
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810564ac>] ? lock_timer_base+0x27/0x4d
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81349f84>] schedule_timeout+0xb3/0xeb
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810565d3>] ? process_timeout+0x0/0xb
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff811334bd>] sys_epoll_wait+0x1b1/0x2b1
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81044423>] ? default_wake_function+0x0/0xf
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Nov 26 16:39:17 portablebastien kernel: [28641.882112] kio_http      S 000000010069b801     0  2298   2849 0x00000000
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff8800b7e61908 0000000000000046 ffff8800b7e61918 0000000000000000
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff8800b7e60010 ffff8800b7e61fd8 ffff8800094fbf80 ffff8800094fc250
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff8800094fc248 0000000000014d80 0000000000014d80 ffff8800b7e61fd8
Nov 26 16:39:17 portablebastien kernel: [28641.882112] Call Trace:
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8134a905>] schedule_hrtimeout_range_clock+0x4c/0x12f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81075039>] ? trace_hardirqs_on+0xd/0xf
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81064a5b>] ? add_wait_queue+0x3f/0x44
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8134a9f6>] schedule_hrtimeout_range+0xe/0x10
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff811112e4>] poll_schedule_timeout+0x43/0x5f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111942>] do_select+0x5b2/0x5ec
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111390>] ? do_select+0x0/0x5ec
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8111197c>] ? __pollwait+0x0/0xc7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8128294c>] ? skb_queue_tail+0x1f/0x48
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8127e6d7>] ? rcu_read_lock+0x0/0x30
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8127e6d7>] ? rcu_read_lock+0x0/0x30
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff812f9b03>] ? scm_destroy_cred+0x14/0x40
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff812f9b40>] ? scm_destroy+0x11/0x2a
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810d9ec8>] ? might_fault+0xa0/0xa7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111d17>] core_sys_select+0x21c/0x2b2
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111b33>] ? core_sys_select+0x38/0x2b2
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8112f82a>] ? fsnotify+0x79/0x449
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8112fbdb>] ? fsnotify+0x42a/0x449
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8112f82a>] ? fsnotify+0x79/0x449
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111fe7>] sys_select+0x91/0xb9
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8134b48e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Nov 26 16:39:17 portablebastien kernel: [28641.882112] kio_http      S 0000000100690fa3     0  2741   2849 0x00000000
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff8800b2785908 0000000000000046 ffffffff81067dae 0000000000000000
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff8800b2784010 ffff8800b2785fd8 ffff88011bf20000 ffff88011bf202d0
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff88011bf202c8 0000000000014d80 0000000000014d80 ffff8800b2785fd8
Nov 26 16:39:17 portablebastien kernel: [28641.882112] Call Trace:
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81067dae>] ? lock_hrtimer_base+0x25/0x4b
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8134a905>] schedule_hrtimeout_range_clock+0x4c/0x12f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81075039>] ? trace_hardirqs_on+0xd/0xf
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81064a5b>] ? add_wait_queue+0x3f/0x44
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8134a9f6>] schedule_hrtimeout_range+0xe/0x10
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff811112e4>] poll_schedule_timeout+0x43/0x5f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111942>] do_select+0x5b2/0x5ec
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111390>] ? do_select+0x0/0x5ec
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff812a3e3b>] ? sch_direct_xmit+0x98/0x14e
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8111197c>] ? __pollwait+0x0/0xc7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111a43>] ? pollwake+0x0/0x4f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff812b9ca6>] ? ip_finish_output2+0x1d5/0x218
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff812b9d4c>] ? ip_finish_output+0x63/0x68
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810564ac>] ? lock_timer_base+0x27/0x4d
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810564ac>] ? lock_timer_base+0x27/0x4d
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81056c0e>] ? __mod_timer+0x126/0x138
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810d9ec8>] ? might_fault+0xa0/0xa7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810d9e7f>] ? might_fault+0x57/0xa7
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111d17>] core_sys_select+0x21c/0x2b2
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111b33>] ? core_sys_select+0x38/0x2b2
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810f9214>] ? __slab_free+0x85/0x287
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81075039>] ? trace_hardirqs_on+0xd/0xf
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81112b09>] ? __d_free+0x51/0x55
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81112b3f>] ? d_free+0x32/0x4b
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81112c96>] ? d_kill+0x67/0x6f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81111fe7>] sys_select+0x91/0xb9
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8134b48e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Nov 26 16:39:17 portablebastien kernel: [28641.882112] sync          D 0000000100690737     0  2904   2740 0x00000000
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff880016103d48 0000000000000046 ffff880000000000 ffff880100000000
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff880016102010 ffff880016103fd8 ffff8800b7d49fc0 ffff8800b7d4a290
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff8800b7d4a288 0000000000014d80 0000000000014d80 ffff880016103fd8
Nov 26 16:39:17 portablebastien kernel: [28641.882112] Call Trace:
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffffa01b8454>] queue_log_writer+0x7e/0xaf [reiserfs]
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81044423>] ? default_wake_function+0x0/0xf
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffffa01bc402>] do_journal_begin_r+0x1ee/0x2d8 [reiserfs]
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8112475f>] ? sync_one_sb+0x0/0x1d
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffffa01bc5ae>] journal_begin+0xc2/0x103 [reiserfs]
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffffa01aa450>] reiserfs_sync_fs+0x27/0x5e [reiserfs]
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81124747>] __sync_filesystem+0x66/0x7e
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8112477a>] sync_one_sb+0x1b/0x1d
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81104bdd>] iterate_supers+0x6d/0xc8
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff811247a6>] sys_sync+0x2a/0x57
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Nov 26 16:39:17 portablebastien kernel: [28641.882112] kworker/u:1   S 00000001006bed56     0  3030      2 0x00000000
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff880093fe1e50 0000000000000046 ffff880093fe1e20 0000000000000046
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff880093fe0010 ffff880093fe1fd8 ffff8800bfe9afa0 ffff8800bfe9b270
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff8800bfe9b268 0000000000014d80 0000000000014d80 ffff880093fe1fd8
Nov 26 16:39:17 portablebastien kernel: [28641.882112] Call Trace:
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81060ef3>] worker_thread+0x24c/0x251
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81060ca7>] ? worker_thread+0x0/0x251
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810642a2>] kthread+0x8c/0x94
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8100a964>] kernel_thread_helper+0x4/0x10
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8134c110>] ? restore_args+0x0/0x30
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81064216>] ? kthread+0x0/0x94
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8100a960>] ? kernel_thread_helper+0x0/0x10
Nov 26 16:39:17 portablebastien kernel: [28641.882112] kworker/1:2   S 0000000000015740     0  3040      2 0x00000000
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff88009196de50 0000000000000046 ffffffff8105f151 ffff88002fedb180
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff88009196c010 ffff88009196dfd8 ffff880091b32fa0 ffff880091b33270
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff880091b33268 0000000000014d80 0000000000014d80 ffff88009196dfd8
Nov 26 16:39:17 portablebastien kernel: [28641.882112] Call Trace:
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8105f151>] ? process_one_work+0x31e/0x392
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81060ef3>] worker_thread+0x24c/0x251
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81060ca7>] ? worker_thread+0x0/0x251
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810642a2>] kthread+0x8c/0x94
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8100a964>] kernel_thread_helper+0x4/0x10
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8134c110>] ? restore_args+0x0/0x30
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81064216>] ? kthread+0x0/0x94
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8100a960>] ? kernel_thread_helper+0x0/0x10
Nov 26 16:39:17 portablebastien kernel: [28641.882112] kworker/0:0   R  running task        0  3047      2 0x00000000
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff8800b21e7bf0 ffffffff811e759c ffff88011d830730 ffff88011d83ba70
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  07008800000000aa 0000002a00000005 00000000000000ff ffff88011da2c800
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  0000000000000001 0000000000000000 000000000000002f ffff88011d262000
Nov 26 16:39:17 portablebastien kernel: [28641.882112] Call Trace:
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff811e759c>] ? fbcon_redraw+0xcb/0x15d
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff811e7c6d>] fbcon_scroll+0x63f/0xc04
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8123ac50>] scrup+0x74/0xe8
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8123adf6>] lf+0x2d/0x67
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8123b058>] vt_console_print+0x1c3/0x2cd
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8123d460>] ? console_callback+0x0/0x107
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810494d5>] __call_console_drivers+0x67/0x79
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81049540>] _call_console_drivers+0x59/0x5d
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81049a22>] release_console_sem+0x121/0x1e5
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8123d562>] console_callback+0x102/0x107
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8105f056>] process_one_work+0x223/0x392
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8105efc8>] ? process_one_work+0x195/0x392
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81060de0>] worker_thread+0x139/0x251
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81060ca7>] ? worker_thread+0x0/0x251
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810642a2>] kthread+0x8c/0x94
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8100a964>] kernel_thread_helper+0x4/0x10
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8134c110>] ? restore_args+0x0/0x30
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81064216>] ? kthread+0x0/0x94
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8100a960>] ? kernel_thread_helper+0x0/0x10
Nov 26 16:39:17 portablebastien kernel: [28641.882112] kworker/u:2   S 00000001006c1ca3     0  3065      2 0x00000000
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff8800c207be50 0000000000000046 ffffffff8105f151 ffff880000000000
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff8800c207a010 ffff8800c207bfd8 ffff8800bfe99fc0 ffff8800bfe9a290
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff8800bfe9a288 0000000000014d80 0000000000014d80 ffff8800c207bfd8
Nov 26 16:39:17 portablebastien kernel: [28641.882112] Call Trace:
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8105f151>] ? process_one_work+0x31e/0x392
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81060ef3>] worker_thread+0x24c/0x251
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81060ca7>] ? worker_thread+0x0/0x251
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810642a2>] kthread+0x8c/0x94
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8100a964>] kernel_thread_helper+0x4/0x10
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8134c110>] ? restore_args+0x0/0x30
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81064216>] ? kthread+0x0/0x94
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8100a960>] ? kernel_thread_helper+0x0/0x10
Nov 26 16:39:17 portablebastien kernel: [28641.882112] kworker/0:1   S 0000000000015740     0  3084      2 0x00000000
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff8800c47d1e50 0000000000000046 ffffffff8105f151 ffff8800bfa4a0c0
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff8800c47d0010 ffff8800c47d1fd8 ffff8800c4420fe0 ffff8800c44212b0
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff8800c44212a8 0000000000014d80 0000000000014d80 ffff8800c47d1fd8
Nov 26 16:39:17 portablebastien kernel: [28641.882112] Call Trace:
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8105f151>] ? process_one_work+0x31e/0x392
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81060ef3>] worker_thread+0x24c/0x251
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81060ca7>] ? worker_thread+0x0/0x251
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810642a2>] kthread+0x8c/0x94
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8100a964>] kernel_thread_helper+0x4/0x10
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8134c110>] ? restore_args+0x0/0x30
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81064216>] ? kthread+0x0/0x94
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8100a960>] ? kernel_thread_helper+0x0/0x10
Nov 26 16:39:17 portablebastien kernel: [28641.882112] kworker/1:0   R  running task        0  3086      2 0x00000000
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff880038369e50 0000000000000046 ffffffff8105f151 ffff88009cdaf480
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff880038368010 ffff880038369fd8 ffff880099a49fc0 ffff880099a4a290
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff880099a4a288 0000000000014d80 0000000000014d80 ffff880038369fd8
Nov 26 16:39:17 portablebastien kernel: [28641.882112] Call Trace:
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8105f151>] ? process_one_work+0x31e/0x392
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81060ef3>] worker_thread+0x24c/0x251
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81060ca7>] ? worker_thread+0x0/0x251
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810642a2>] kthread+0x8c/0x94
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8100a964>] kernel_thread_helper+0x4/0x10
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8134c110>] ? restore_args+0x0/0x30
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81064216>] ? kthread+0x0/0x94
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8100a960>] ? kernel_thread_helper+0x0/0x10
Nov 26 16:39:17 portablebastien kernel: [28641.882112] kworker/1:3   S 00000001006c1906     0  3087      2 0x00000000
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff88000fcb3e50 0000000000000046 ffffffff8105f151 ffff880000000000
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff88000fcb2010 ffff88000fcb3fd8 ffff88011bc36f20 ffff88011bc371f0
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  ffff88011bc371e8 0000000000014d80 0000000000014d80 ffff88000fcb3fd8
Nov 26 16:39:17 portablebastien kernel: [28641.882112] Call Trace:
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8105f151>] ? process_one_work+0x31e/0x392
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81060ef3>] worker_thread+0x24c/0x251
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81060ca7>] ? worker_thread+0x0/0x251
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff810642a2>] kthread+0x8c/0x94
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8100a964>] kernel_thread_helper+0x4/0x10
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8134c110>] ? restore_args+0x0/0x30
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff81064216>] ? kthread+0x0/0x94
Nov 26 16:39:17 portablebastien kernel: [28641.882112]  [<ffffffff8100a960>] ? kernel_thread_helper+0x0/0x10
Nov 26 16:39:17 portablebastien kernel: [28641.882112] Sched Debug Version: v0.09, 2.6.36 #4
Nov 26 16:39:17 portablebastien kernel: [28641.882112] now at 28641934.655316 msecs
Nov 26 16:39:17 portablebastien kernel: [28641.882112]   .jiffies                                 : 4302052768
Nov 26 16:39:17 portablebastien kernel: [28641.882112]   .sysctl_sched_latency                    : 12.000000
Nov 26 16:39:17 portablebastien kernel: [28641.882112]   .sysctl_sched_min_granularity            : 1.500000
Nov 26 16:39:17 portablebastien kernel: [28641.882112]   .sysctl_sched_wakeup_granularity         : 2.000000
Nov 26 16:39:17 portablebastien kernel: [28641.882112]   .sysctl_sched_child_runs_first           : 0
Nov 26 16:39:17 portablebastien kernel: [28641.882112]   .sysctl_sched_features                   : 15471
Nov 26 16:39:17 portablebastien kernel: [28641.882112]   .sysctl_sched_tunable_scaling            : 1 (logaritmic)
Nov 26 16:39:17 portablebastien kernel: [28641.882112] 
Nov 26 16:39:17 portablebastien kernel: [28641.882112] cpu#0, 2094.747 MHz
Nov 26 16:39:17 portablebastien kernel: [28641.882112]   .nr_running                    : 1
Nov 26 16:39:17 portablebastien kernel: [28641.882112]   .load                          : 1024
Nov 26 16:39:17 portablebastien kernel: [28641.882112]   .nr_switches                   : 29257880
Nov 26 16:39:17 portablebastien kernel: [28641.882112]   .nr_load_updates               : 2853082
Nov 26 16:39:17 portablebastien kernel: [28641.882112]   .nr_uninterruptible            : 6
Nov 26 16:39:17 portablebastien kernel: [28641.882112]   .next_balance                  : 4302.052805
Nov 26 16:39:17 portablebastien kernel: [28641.882112]   .curr->pid                     : 3047
Nov 26 16:39:17 portablebastien kernel: [28641.882112]   .clock                         : 28641888.792276
Nov 26 16:39:17 portablebastien kernel: [28641.882112]   .cpu_load[0]                   : 1024
Nov 26 16:39:17 portablebastien kernel: [28641.882112]   .cpu_load[1]                   : 640
Nov 26 16:39:17 portablebastien kernel: [28641.882112]   .cpu_load[2]                   : 400
Nov 26 16:39:17 portablebastien kernel: [28641.882112]   .cpu_load[3]                   : 229
Nov 26 16:39:17 portablebastien kernel: [28641.882112]   .cpu_load[4]                   : 134
Nov 26 16:39:17 portablebastien kernel: [28641.882112] 
Nov 26 16:39:17 portablebastien kernel: [28641.882112] cfs_rq[0]:/
Nov 26 16:39:17 portablebastien kernel: [28641.882112]   .exec_clock                    : 0.000000
Nov 26 16:39:17 portablebastien kernel: [28641.882112]   .MIN_vruntime                  : 0.000001
Nov 26 16:39:17 portablebastien kernel: [28641.882112]   .min_vruntime                  : 23788416.602551
Nov 26 16:39:17 portablebastien kernel: [28641.882112]   .max_vruntime                  : 0.000001
Nov 26 16:39:17 portablebastien kernel: [28641.882112]   .spread                        : 0.000000
Nov 26 16:39:17 portablebastien kernel: [28641.882112]   .spread0                       : 0.000000
Nov 26 16:39:17 portablebastien kernel: [28641.882112]   .nr_running                    : 1
Nov 26 16:39:17 portablebastien kernel: [28641.882112]   .load                          : 1024
Nov 26 16:39:17 portablebastien kernel: [28641.882112]   .nr_spread_over                : 0
Nov 26 16:39:17 portablebastien kernel: [28641.882112]   .shares                        : 0
Nov 26 16:39:17 portablebastien kernel: [28641.882112] 
Nov 26 16:39:17 portablebastien kernel: [28641.882112] rt_rq[0]:
Nov 26 16:39:17 portablebastien kernel: [28641.882112]   .rt_nr_running                 : 0
Nov 26 16:39:17 portablebastien kernel: [28641.882112]   .rt_throttled                  : 0
Nov 26 16:39:17 portablebastien kernel: [28641.882112]   .rt_time                       : 0.000000
Nov 26 16:39:17 portablebastien kernel: [28641.882112]   .rt_runtime                    : 900.000000
Nov 26 16:39:17 portablebastien kernel: [28641.882112] 
Nov 26 16:39:17 portablebastien kernel: [28641.882112] runnable tasks:
Nov 26 16:39:17 portablebastien kernel: [28641.882112]             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
Nov 26 16:39:17 portablebastien kernel: [28641.882112] ----------------------------------------------------------------------------------------------------------
Nov 26 16:39:17 portablebastien kernel: [28641.882112] R    kworker/0:0  3047  23788416.602551      3734   120               0               0               0.000000               0.000000               0.000000 /
Nov 26 16:39:17 portablebastien kernel: [28641.882112] 
Nov 26 16:39:17 portablebastien kernel: [28641.882112] cpu#1, 2094.747 MHz
Nov 26 16:39:17 portablebastien kernel: [28641.882112]   .nr_running                    : 2
Nov 26 16:39:17 portablebastien kernel: [28641.882112]   .load                          : 2048
Nov 26 16:39:17 portablebastien kernel: [28641.882112]   .nr_switches                   : 25681909
Nov 26 16:39:17 portablebastien kernel: [28641.882112]   .nr_load_updates               : 2936103
Nov 26 16:39:17 portablebastien kernel: [28641.882112]   .nr_uninterruptible            : 4
Nov 26 16:39:17 portablebastien kernel: [28641.882112]   .next_balance                  : 4302.052777
Nov 26 16:39:17 portablebastien kernel: [28641.882112]   .curr->pid                     : 3732
Nov 26 16:39:17 portablebastien kernel: [28641.882112]   .clock                         : 28641780.019105
Nov 26 16:39:17 portablebastien kernel: [28641.882112]   .cpu_load[0]                   : 1024
Nov 26 16:39:17 portablebastien kernel: [28641.882112]   .cpu_load[1]                   : 512
Nov 26 16:39:17 portablebastien kernel: [28641.882112]   .cpu_load[2]                   : 264
Nov 26 16:39:17 portablebastien kernel: [28641.882112]   .cpu_load[3]                   : 156
Nov 26 16:39:17 portablebastien kernel: [28641.882112]   .cpu_load[4]                   : 108
Nov 26 16:39:17 portablebastien kernel: [28641.882112] 
Nov 26 16:39:17 portablebastien kernel: [28641.882112] cfs_rq[1]:/
Nov 26 16:39:17 portablebastien kernel: [28641.882112]   .exec_clock                    : 0.000000
Nov 26 16:39:17 portablebastien kernel: [28641.882112]   .MIN_vruntime                  : 34459071.625741
Nov 26 16:39:17 portablebastien kernel: [28641.882112]   .min_vruntime                  : 34459077.625741
Nov 26 16:39:17 portablebastien kernel: [28641.882112]   .max_vruntime                  : 34459071.625741
Nov 26 16:39:17 portablebastien kernel: [28641.882112]   .spread                        : 0.000000
Nov 26 16:39:17 portablebastien kernel: [28641.882112]   .spread0                       : 10670661.023190
Nov 26 16:39:17 portablebastien kernel: [28641.882112]   .nr_running                    : 2
Nov 26 16:39:17 portablebastien kernel: [28641.882112]   .load                          : 2048
Nov 26 16:39:17 portablebastien kernel: [28641.882112]   .nr_spread_over                : 0
Nov 26 16:39:17 portablebastien kernel: [28641.882112]   .shares                        : 0
Nov 26 16:39:17 portablebastien kernel: [28641.882112] 
Nov 26 16:39:17 portablebastien kernel: [28641.882112] rt_rq[1]:
Nov 26 16:39:17 portablebastien kernel: [28641.882112]   .rt_nr_running                 : 0
Nov 26 16:39:17 portablebastien kernel: [28641.882112]   .rt_throttled                  : 0
Nov 26 16:39:17 portablebastien kernel: [28641.882112]   .rt_time                       : 1.163056
Nov 26 16:39:17 portablebastien kernel: [28641.882112]   .rt_runtime                    : 1000.000000
Nov 26 16:39:17 portablebastien kernel: [28641.882112] 
Nov 26 16:39:17 portablebastien kernel: [28641.882112] runnable tasks:
Nov 26 16:39:17 portablebastien kernel: [28641.882112]             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
Nov 26 16:39:17 portablebastien kernel: [28641.882112] ----------------------------------------------------------------------------------------------------------
Nov 26 16:39:17 portablebastien kernel: [28641.882112] R           bash  3732  34459072.415485      1149   120               0               0               0.000000               0.000000               0.000000 /
Nov 26 16:39:17 portablebastien kernel: [28641.882112]      kworker/1:0  3086  34459071.625741      2232   120               0               0               0.000000               0.000000               0.000000 /
Nov 26 16:39:17 portablebastien kernel: [28641.882112] 
Nov 26 16:39:17 portablebastien kernel: [28641.882112] INFO: lockdep is turned off.
Nov 26 16:42:11 portablebastien kernel: [28815.698944] SysRq : Show Blocked State
Nov 26 16:42:11 portablebastien kernel: [28815.700165]   task                        PC stack   pid father
Nov 26 16:42:11 portablebastien kernel: [28815.701394] sync_supers   D ffffc90005743178     0    17      2 0x00000000
Nov 26 16:42:11 portablebastien kernel: [28815.701394]  ffff88011f761ca0 0000000000000046 ffff880100000000 ffff88011da21688
Nov 26 16:42:11 portablebastien kernel: [28815.701394]  ffff88011f760010 ffff88011f761fd8 ffff88011f6d9fc0 ffff88011f6da290
Nov 26 16:42:11 portablebastien kernel: [28815.701394]  ffff88011f6da288 0000000000014d80 0000000000014d80 ffff88011f761fd8
Nov 26 16:42:11 portablebastien kernel: [28815.701394] Call Trace:
Nov 26 16:42:11 portablebastien kernel: [28815.701394]  [<ffffffffa01b8454>] queue_log_writer+0x7e/0xaf [reiserfs]
Nov 26 16:42:11 portablebastien kernel: [28815.701394]  [<ffffffff81044423>] ? default_wake_function+0x0/0xf
Nov 26 16:42:11 portablebastien kernel: [28815.701394]  [<ffffffffa01bb4cb>] do_journal_end+0x201/0xda8 [reiserfs]
Nov 26 16:42:11 portablebastien kernel: [28815.701394]  [<ffffffffa01bc4ab>] ? do_journal_begin_r+0x297/0x2d8 [reiserfs]
Nov 26 16:42:11 portablebastien kernel: [28815.701394]  [<ffffffff810d802e>] ? bdi_sync_supers+0x0/0x51
Nov 26 16:42:11 portablebastien kernel: [28815.701394]  [<ffffffffa01bc0e6>] journal_end_sync+0x74/0x7d [reiserfs]
Nov 26 16:42:11 portablebastien kernel: [28815.701394]  [<ffffffffa01aa464>] reiserfs_sync_fs+0x3b/0x5e [reiserfs]
Nov 26 16:42:11 portablebastien kernel: [28815.701394]  [<ffffffff810d802e>] ? bdi_sync_supers+0x0/0x51
Nov 26 16:42:11 portablebastien kernel: [28815.701394]  [<ffffffff8134abee>] ? down_read+0x47/0x5c
Nov 26 16:42:11 portablebastien kernel: [28815.701394]  [<ffffffffa01aa495>] reiserfs_write_super+0xe/0x10 [reiserfs]
Nov 26 16:42:11 portablebastien kernel: [28815.701394]  [<ffffffff81104cb3>] sync_supers+0x7b/0xd6
Nov 26 16:42:11 portablebastien kernel: [28815.701394]  [<ffffffff810d806d>] bdi_sync_supers+0x3f/0x51
Nov 26 16:42:11 portablebastien kernel: [28815.701394]  [<ffffffff810d802e>] ? bdi_sync_supers+0x0/0x51
Nov 26 16:42:11 portablebastien kernel: [28815.701394]  [<ffffffff810642a2>] kthread+0x8c/0x94
Nov 26 16:42:11 portablebastien kernel: [28815.701394]  [<ffffffff8100a964>] kernel_thread_helper+0x4/0x10
Nov 26 16:42:11 portablebastien kernel: [28815.701394]  [<ffffffff8134c110>] ? restore_args+0x0/0x30
Nov 26 16:42:11 portablebastien kernel: [28815.701394]  [<ffffffff81064216>] ? kthread+0x0/0x94
Nov 26 16:42:11 portablebastien kernel: [28815.701394]  [<ffffffff8100a960>] ? kernel_thread_helper+0x0/0x10
Nov 26 16:42:11 portablebastien kernel: [28815.701394] kded4         D 00000001006907a6     0  2852      1 0x00000000
Nov 26 16:42:11 portablebastien kernel: [28815.701394]  ffff8800d8a97b28 0000000000000046 ffff880000000000 ffff880100000000
Nov 26 16:42:11 portablebastien kernel: [28815.701394]  ffff8800d8a96010 ffff8800d8a97fd8 ffff8800379f4f60 ffff8800379f5230
Nov 26 16:42:11 portablebastien kernel: [28815.701394]  ffff8800379f5228 0000000000014d80 0000000000014d80 ffff8800d8a97fd8
Nov 26 16:42:11 portablebastien kernel: [28815.701394] Call Trace:
Nov 26 16:42:11 portablebastien kernel: [28815.701394]  [<ffffffffa01b8454>] queue_log_writer+0x7e/0xaf [reiserfs]
Nov 26 16:42:11 portablebastien kernel: [28815.701394]  [<ffffffff81044423>] ? default_wake_function+0x0/0xf
Nov 26 16:42:11 portablebastien kernel: [28815.701394]  [<ffffffffa01bc402>] do_journal_begin_r+0x1ee/0x2d8 [reiserfs]
Nov 26 16:42:11 portablebastien kernel: [28815.701394]  [<ffffffffa01bc5ae>] journal_begin+0xc2/0x103 [reiserfs]
Nov 26 16:42:11 portablebastien kernel: [28815.701394]  [<ffffffffa019ebb6>] reiserfs_create+0x105/0x233 [reiserfs]
Nov 26 16:42:11 portablebastien kernel: [28815.701394]  [<ffffffff8110b57d>] ? generic_permission+0x17/0x9a
Nov 26 16:42:11 portablebastien kernel: [28815.701394]  [<ffffffff81171e65>] ? security_inode_permission+0x1c/0x1e
Nov 26 16:42:11 portablebastien kernel: [28815.701394]  [<ffffffff8110c423>] vfs_create+0x6b/0x8d
Nov 26 16:42:11 portablebastien kernel: [28815.701394]  [<ffffffff8110cdee>] do_last+0x26c/0x532
Nov 26 16:42:11 portablebastien kernel: [28815.701394]  [<ffffffff8110eb96>] do_filp_open+0x203/0x599
Nov 26 16:42:11 portablebastien kernel: [28815.701394]  [<ffffffff8134bd2b>] ? _raw_spin_unlock+0x26/0x2a
Nov 26 16:42:11 portablebastien kernel: [28815.701394]  [<ffffffff811184a0>] ? alloc_fd+0x170/0x182
Nov 26 16:42:11 portablebastien kernel: [28815.701394]  [<ffffffff81101366>] do_sys_open+0x5b/0xf7
Nov 26 16:42:11 portablebastien kernel: [28815.701394]  [<ffffffff8134b48e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
Nov 26 16:42:11 portablebastien kernel: [28815.701394]  [<ffffffff8110142b>] sys_open+0x1b/0x1d
Nov 26 16:42:11 portablebastien kernel: [28815.701394]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Nov 26 16:42:11 portablebastien kernel: [28815.701394] kwin          D 000000010068fd60     0  2903   2901 0x00000000
Nov 26 16:42:11 portablebastien kernel: [28815.773720]  ffff8800d8a13a98 0000000000000046 ffff880000000000 ffff88011da21628
Nov 26 16:42:11 portablebastien kernel: [28815.773720]  ffff8800d8a12010 ffff8800d8a13fd8 ffff8800d8b92fa0 ffff8800d8b93270
Nov 26 16:42:11 portablebastien kernel: [28815.773720]  ffff8800d8b93268 0000000000014d80 0000000000014d80 ffff8800d8a13fd8
Nov 26 16:42:11 portablebastien kernel: [28815.773720] Call Trace:
Nov 26 16:42:11 portablebastien kernel: [28815.773720]  [<ffffffffa01b8454>] queue_log_writer+0x7e/0xaf [reiserfs]
Nov 26 16:42:11 portablebastien kernel: [28815.773720]  [<ffffffff81044423>] ? default_wake_function+0x0/0xf
Nov 26 16:42:11 portablebastien kernel: [28815.773720]  [<ffffffffa01bc402>] do_journal_begin_r+0x1ee/0x2d8 [reiserfs]
Nov 26 16:42:11 portablebastien kernel: [28815.773720]  [<ffffffffa01bc5ae>] journal_begin+0xc2/0x103 [reiserfs]
Nov 26 16:42:11 portablebastien kernel: [28815.773720]  [<ffffffffa01aa4f6>] reiserfs_dirty_inode+0x5f/0xa0 [reiserfs]
Nov 26 16:42:11 portablebastien kernel: [28815.773720]  [<ffffffffa01c13f8>] ? security_get+0x41/0x43 [reiserfs]
Nov 26 16:42:11 portablebastien kernel: [28815.773720]  [<ffffffff81120c34>] __mark_inode_dirty+0x2f/0x1d2
Nov 26 16:42:11 portablebastien kernel: [28815.773720]  [<ffffffff81115c82>] file_update_time+0x104/0x128
Nov 26 16:42:11 portablebastien kernel: [28815.773720]  [<ffffffff810c3614>] __generic_file_aio_write+0x162/0x27f
Nov 26 16:42:11 portablebastien kernel: [28815.773720]  [<ffffffff810c378b>] generic_file_aio_write+0x5a/0xa8
Nov 26 16:42:11 portablebastien kernel: [28815.773720]  [<ffffffff81102886>] do_sync_write+0xc6/0x103
Nov 26 16:42:11 portablebastien kernel: [28815.773720]  [<ffffffff81102989>] ? do_sync_read+0xc6/0x103
Nov 26 16:42:11 portablebastien kernel: [28815.773720]  [<ffffffff811721aa>] ? fsnotify_perm+0x45/0x4b
Nov 26 16:42:11 portablebastien kernel: [28815.773720]  [<ffffffff81172207>] ? security_file_permission+0x29/0x2e
Nov 26 16:42:11 portablebastien kernel: [28815.773720]  [<ffffffffa01a3fb2>] reiserfs_file_write+0x48/0x4a [reiserfs]
Nov 26 16:42:11 portablebastien kernel: [28815.773720]  [<ffffffff81102deb>] vfs_write+0xa9/0x105
Nov 26 16:42:11 portablebastien kernel: [28815.773720]  [<ffffffff81102efd>] sys_write+0x45/0x69
Nov 26 16:42:11 portablebastien kernel: [28815.773720]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Nov 26 16:42:11 portablebastien kernel: [28815.773720] kglobalaccel  D 000000010068fef4     0  2905      1 0x00000000
Nov 26 16:42:11 portablebastien kernel: [28815.773720]  ffff8800d59afcc8 0000000000000046 fffffff500000001 0000000000000001
Nov 26 16:42:11 portablebastien kernel: [28815.773720]  ffff8800d59ae010 ffff8800d59affd8 ffff8800d8b96f20 ffff8800d8b971f0
Nov 26 16:42:11 portablebastien kernel: [28815.773720]  ffff8800d8b971e8 0000000000014d80 0000000000014d80 ffff8800d59affd8
Nov 26 16:42:11 portablebastien kernel: [28815.773720] Call Trace:
Nov 26 16:42:11 portablebastien kernel: [28815.773720]  [<ffffffff810c3778>] ? generic_file_aio_write+0x47/0xa8
Nov 26 16:42:11 portablebastien kernel: [28815.773720]  [<ffffffff8134a6ca>] __mutex_lock_common+0x23a/0x36f
Nov 26 16:42:11 portablebastien kernel: [28815.773720]  [<ffffffff810c3778>] ? generic_file_aio_write+0x47/0xa8
Nov 26 16:42:11 portablebastien kernel: [28815.773720]  [<ffffffff8134a8b4>] mutex_lock_nested+0x39/0x3e
Nov 26 16:42:11 portablebastien kernel: [28815.773720]  [<ffffffff810c3778>] generic_file_aio_write+0x47/0xa8
Nov 26 16:42:11 portablebastien kernel: [28815.773720]  [<ffffffff81102886>] do_sync_write+0xc6/0x103
Nov 26 16:42:11 portablebastien kernel: [28815.773720]  [<ffffffff81102989>] ? do_sync_read+0xc6/0x103
Nov 26 16:42:11 portablebastien kernel: [28815.773720]  [<ffffffff811721aa>] ? fsnotify_perm+0x45/0x4b
Nov 26 16:42:11 portablebastien kernel: [28815.773720]  [<ffffffff81172207>] ? security_file_permission+0x29/0x2e
Nov 26 16:42:11 portablebastien kernel: [28815.773720]  [<ffffffffa01a3fb2>] reiserfs_file_write+0x48/0x4a [reiserfs]
Nov 26 16:42:11 portablebastien kernel: [28815.773720]  [<ffffffff81102deb>] vfs_write+0xa9/0x105
Nov 26 16:42:11 portablebastien kernel: [28815.773720]  [<ffffffff81102efd>] sys_write+0x45/0x69
Nov 26 16:42:11 portablebastien kernel: [28815.773720]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Nov 26 16:42:11 portablebastien kernel: [28815.773720] virtuoso-t    D ffffc90005743178     0  2939   2930 0x00000000
Nov 26 16:42:11 portablebastien kernel: [28815.773720]  ffff8800cdd9db28 0000000000000046 ffff880000000000 ffff88011da21628
Nov 26 16:42:11 portablebastien kernel: [28815.773720]  ffff8800cdd9c010 ffff8800cdd9dfd8 ffff8800d5942fa0 ffff8800d5943270
Nov 26 16:42:11 portablebastien kernel: [28815.773720]  ffff8800d5943268 0000000000014d80 0000000000014d80 ffff8800cdd9dfd8
Nov 26 16:42:11 portablebastien kernel: [28815.773720] Call Trace:
Nov 26 16:42:11 portablebastien kernel: [28815.773720]  [<ffffffffa01b8454>] queue_log_writer+0x7e/0xaf [reiserfs]
Nov 26 16:42:11 portablebastien kernel: [28815.773720]  [<ffffffff81044423>] ? default_wake_function+0x0/0xf
Nov 26 16:42:11 portablebastien kernel: [28815.773720]  [<ffffffffa01bc402>] do_journal_begin_r+0x1ee/0x2d8 [reiserfs]
Nov 26 16:42:11 portablebastien kernel: [28815.773720]  [<ffffffffa01bc5ae>] journal_begin+0xc2/0x103 [reiserfs]
Nov 26 16:42:11 portablebastien kernel: [28815.773720]  [<ffffffffa019ebb6>] reiserfs_create+0x105/0x233 [reiserfs]
Nov 26 16:42:11 portablebastien kernel: [28815.773720]  [<ffffffff8110b57d>] ? generic_permission+0x17/0x9a
Nov 26 16:42:11 portablebastien kernel: [28815.773720]  [<ffffffff81171e65>] ? security_inode_permission+0x1c/0x1e
Nov 26 16:42:11 portablebastien kernel: [28815.773720]  [<ffffffff8110c423>] vfs_create+0x6b/0x8d
Nov 26 16:42:11 portablebastien kernel: [28815.773720]  [<ffffffff8110cdee>] do_last+0x26c/0x532
Nov 26 16:42:11 portablebastien kernel: [28815.773720]  [<ffffffff8110eb96>] do_filp_open+0x203/0x599
Nov 26 16:42:11 portablebastien kernel: [28815.773720]  [<ffffffff8134bd2b>] ? _raw_spin_unlock+0x26/0x2a
Nov 26 16:42:11 portablebastien kernel: [28815.773720]  [<ffffffff811184a0>] ? alloc_fd+0x170/0x182
Nov 26 16:42:11 portablebastien kernel: [28815.773720]  [<ffffffff81101366>] do_sys_open+0x5b/0xf7
Nov 26 16:42:11 portablebastien kernel: [28815.773720]  [<ffffffff8134b48e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
Nov 26 16:42:11 portablebastien kernel: [28815.773720]  [<ffffffff8110142b>] sys_open+0x1b/0x1d
Nov 26 16:42:11 portablebastien kernel: [28815.773720]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Nov 26 16:42:11 portablebastien kernel: [28815.773720] kalarm        D 00000001006914db     0  2974      1 0x00000000
Nov 26 16:42:11 portablebastien kernel: [28815.773720]  ffff8800cddafcc8 0000000000000046 fffffff500000001 0000000000000000
Nov 26 16:42:11 portablebastien kernel: [28815.773720]  ffff8800cddae010 ffff8800cddaffd8 ffff8800d59fafa0 ffff8800d59fb270
Nov 26 16:42:11 portablebastien kernel: [28815.773720]  ffff8800d59fb268 0000000000014d80 0000000000014d80 ffff8800cddaffd8
Nov 26 16:42:11 portablebastien kernel: [28815.773720] Call Trace:
Nov 26 16:42:11 portablebastien kernel: [28815.773720]  [<ffffffff810c3778>] ? generic_file_aio_write+0x47/0xa8
Nov 26 16:42:11 portablebastien kernel: [28815.773720]  [<ffffffff8134a6ca>] __mutex_lock_common+0x23a/0x36f
Nov 26 16:42:11 portablebastien kernel: [28815.773720]  [<ffffffff810c3778>] ? generic_file_aio_write+0x47/0xa8
Nov 26 16:42:11 portablebastien kernel: [28815.773720]  [<ffffffff8134a8b4>] mutex_lock_nested+0x39/0x3e
Nov 26 16:42:11 portablebastien kernel: [28815.773720]  [<ffffffff810c3778>] generic_file_aio_write+0x47/0xa8
Nov 26 16:42:11 portablebastien kernel: [28815.773720]  [<ffffffff81102886>] do_sync_write+0xc6/0x103
Nov 26 16:42:11 portablebastien kernel: [28815.773720]  [<ffffffff81102989>] ? do_sync_read+0xc6/0x103
Nov 26 16:42:11 portablebastien kernel: [28815.773720]  [<ffffffff81103aa5>] ? fget_light+0x41/0xcf
Nov 26 16:42:11 portablebastien kernel: [28815.773720]  [<ffffffff81103aa5>] ? fget_light+0x41/0xcf
Nov 26 16:42:11 portablebastien kernel: [28815.773720]  [<ffffffff811721aa>] ? fsnotify_perm+0x45/0x4b
Nov 26 16:42:11 portablebastien kernel: [28815.773720]  [<ffffffff81172207>] ? security_file_permission+0x29/0x2e
Nov 26 16:42:11 portablebastien kernel: [28815.773720]  [<ffffffffa01a3fb2>] reiserfs_file_write+0x48/0x4a [reiserfs]
Nov 26 16:42:11 portablebastien kernel: [28815.773720]  [<ffffffff81102deb>] vfs_write+0xa9/0x105
Nov 26 16:42:11 portablebastien kernel: [28815.773720]  [<ffffffff81103aa5>] ? fget_light+0x41/0xcf
Nov 26 16:42:11 portablebastien kernel: [28815.773720]  [<ffffffff81102efd>] sys_write+0x45/0x69
Nov 26 16:42:11 portablebastien kernel: [28815.773720]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Nov 26 16:42:11 portablebastien kernel: [28815.773720] akregator     D ffffc90005743178     0  2976      1 0x00000000
Nov 26 16:42:11 portablebastien kernel: [28815.773720]  ffff8800c7319ae8 0000000000000046 ffff880000000000 ffff88011da21628
Nov 26 16:42:11 portablebastien kernel: [28815.773720]  ffff8800c7318010 ffff8800c7319fd8 ffff8800c708df40 ffff8800c708e210
Nov 26 16:42:11 portablebastien kernel: [28815.773720]  ffff8800c708e208 0000000000014d80 0000000000014d80 ffff8800c7319fd8
Nov 26 16:42:11 portablebastien kernel: [28815.773720] Call Trace:
Nov 26 16:42:11 portablebastien kernel: [28815.773720]  [<ffffffffa01b8454>] queue_log_writer+0x7e/0xaf [reiserfs]
Nov 26 16:42:11 portablebastien kernel: [28815.773720]  [<ffffffff81044423>] ? default_wake_function+0x0/0xf
Nov 26 16:42:11 portablebastien kernel: [28815.773720]  [<ffffffffa01bc402>] do_journal_begin_r+0x1ee/0x2d8 [reiserfs]
Nov 26 16:42:11 portablebastien kernel: [28815.773720]  [<ffffffffa01bc5ae>] journal_begin+0xc2/0x103 [reiserfs]
Nov 26 16:42:11 portablebastien kernel: [28815.773720]  [<ffffffffa01aa4f6>] reiserfs_dirty_inode+0x5f/0xa0 [reiserfs]
Nov 26 16:42:11 portablebastien kernel: [28815.773720]  [<ffffffff81120c34>] __mark_inode_dirty+0x2f/0x1d2
Nov 26 16:42:11 portablebastien kernel: [28815.773720]  [<ffffffff81115da8>] touch_atime+0x102/0x125
Nov 26 16:42:11 portablebastien kernel: [28815.773720]  [<ffffffff810c4559>] generic_file_aio_read+0x562/0x5b7
Nov 26 16:42:11 portablebastien kernel: [28815.773720]  [<ffffffff81102989>] do_sync_read+0xc6/0x103
Nov 26 16:42:11 portablebastien kernel: [28815.773720]  [<ffffffff811721aa>] ? fsnotify_perm+0x45/0x4b
Nov 26 16:42:11 portablebastien kernel: [28815.773720]  [<ffffffff81172207>] ? security_file_permission+0x29/0x2e
Nov 26 16:42:11 portablebastien kernel: [28815.773720]  [<ffffffff81102fc7>] vfs_read+0xa6/0x102
Nov 26 16:42:11 portablebastien kernel: [28815.773720]  [<ffffffff81103aa5>] ? fget_light+0x41/0xcf
Nov 26 16:42:11 portablebastien kernel: [28815.773720]  [<ffffffff811030d9>] sys_read+0x45/0x69
Nov 26 16:42:11 portablebastien kernel: [28815.773720]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Nov 26 16:42:11 portablebastien kernel: [28815.773720] mysqld        D 00000001006bbf27     0  3155   3133 0x00000000
Nov 26 16:42:11 portablebastien kernel: [28815.773720]  ffff8800a7623a98 0000000000000046 ffff880000000000 ffff880100000000
Nov 26 16:42:11 portablebastien kernel: [28815.773720]  ffff8800a7622010 ffff8800a7623fd8 ffff8800aa284f60 ffff8800aa285230
Nov 26 16:42:11 portablebastien kernel: [28815.773720]  ffff8800aa285228 0000000000014d80 0000000000014d80 ffff8800a7623fd8
Nov 26 16:42:11 portablebastien kernel: [28815.773720] Call Trace:
Nov 26 16:42:11 portablebastien kernel: [28815.773720]  [<ffffffffa01b8454>] queue_log_writer+0x7e/0xaf [reiserfs]
Nov 26 16:42:11 portablebastien kernel: [28815.773720]  [<ffffffff81044423>] ? default_wake_function+0x0/0xf
Nov 26 16:42:11 portablebastien kernel: [28815.773720]  [<ffffffffa01bc402>] do_journal_begin_r+0x1ee/0x2d8 [reiserfs]
Nov 26 16:42:11 portablebastien kernel: [28815.773720]  [<ffffffffa01bc5ae>] journal_begin+0xc2/0x103 [reiserfs]
Nov 26 16:42:11 portablebastien kernel: [28815.773720]  [<ffffffffa01aa4f6>] reiserfs_dirty_inode+0x5f/0xa0 [reiserfs]
Nov 26 16:42:11 portablebastien kernel: [28815.773720]  [<ffffffffa01c13f8>] ? security_get+0x41/0x43 [reiserfs]
Nov 26 16:42:11 portablebastien kernel: [28815.773720]  [<ffffffff81120c34>] __mark_inode_dirty+0x2f/0x1d2
Nov 26 16:42:11 portablebastien kernel: [28815.773720]  [<ffffffff81115c82>] file_update_time+0x104/0x128
Nov 26 16:42:11 portablebastien kernel: [28815.773720]  [<ffffffff810c3614>] __generic_file_aio_write+0x162/0x27f
Nov 26 16:42:11 portablebastien kernel: [28815.773720]  [<ffffffff810c378b>] generic_file_aio_write+0x5a/0xa8
Nov 26 16:42:11 portablebastien kernel: [28815.773720]  [<ffffffff81102886>] do_sync_write+0xc6/0x103
Nov 26 16:42:11 portablebastien kernel: [28815.773720]  [<ffffffff81103aa5>] ? fget_light+0x41/0xcf
Nov 26 16:42:11 portablebastien kernel: [28815.773720]  [<ffffffff81103aa5>] ? fget_light+0x41/0xcf
Nov 26 16:42:11 portablebastien kernel: [28815.773720]  [<ffffffff81172207>] ? security_file_permission+0x29/0x2e
Nov 26 16:42:11 portablebastien kernel: [28815.773720]  [<ffffffffa01a3fb2>] reiserfs_file_write+0x48/0x4a [reiserfs]
Nov 26 16:42:11 portablebastien kernel: [28815.773720]  [<ffffffff81102deb>] vfs_write+0xa9/0x105
Nov 26 16:42:11 portablebastien kernel: [28815.773720]  [<ffffffff81103aa5>] ? fget_light+0x41/0xcf
Nov 26 16:42:11 portablebastien kernel: [28815.773720]  [<ffffffff81102e9c>] sys_pwrite64+0x55/0x71
Nov 26 16:42:11 portablebastien kernel: [28815.773720]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Nov 26 16:42:11 portablebastien kernel: [28815.773720] okular        D 000000010069a3b0     0 31706   2849 0x00000000
Nov 26 16:42:11 portablebastien kernel: [28815.773720]  ffff8800645cf9c8 0000000000000046 ffff880000000000 ffff880100000000
Nov 26 16:42:11 portablebastien kernel: [28815.773720]  ffff8800645ce010 ffff8800645cffd8 ffff8800bfe9bf80 ffff8800bfe9c250
Nov 26 16:42:11 portablebastien kernel: [28815.773720]  ffff8800bfe9c248 0000000000014d80 0000000000014d80 ffff8800645cffd8
Nov 26 16:42:11 portablebastien kernel: [28815.773720] Call Trace:
Nov 26 16:42:11 portablebastien kernel: [28815.773720]  [<ffffffffa01b8454>] queue_log_writer+0x7e/0xaf [reiserfs]
Nov 26 16:42:11 portablebastien kernel: [28815.773720]  [<ffffffff81044423>] ? default_wake_function+0x0/0xf
Nov 26 16:42:11 portablebastien kernel: [28815.773720]  [<ffffffffa01bc402>] do_journal_begin_r+0x1ee/0x2d8 [reiserfs]
Nov 26 16:42:11 portablebastien kernel: [28815.773720]  [<ffffffffa01bc5ae>] journal_begin+0xc2/0x103 [reiserfs]
Nov 26 16:42:11 portablebastien kernel: [28815.773720]  [<ffffffffa01a1a05>] reiserfs_truncate_file+0x191/0x29f [reiserfs]
Nov 26 16:42:11 portablebastien kernel: [28815.773720]  [<ffffffffa01a3b5c>] reiserfs_vfs_truncate_file+0x28/0x35 [reiserfs]
Nov 26 16:42:11 portablebastien kernel: [28815.773720]  [<ffffffff810ccd3d>] vmtruncate+0x3f/0x4a
Nov 26 16:42:11 portablebastien kernel: [28815.773720]  [<ffffffffa019fcfe>] reiserfs_setattr+0x29f/0x328 [reiserfs]
Nov 26 16:42:11 portablebastien kernel: [28815.773720]  [<ffffffff81117569>] notify_change+0x19d/0x298
Nov 26 16:42:11 portablebastien kernel: [28815.773720]  [<ffffffff811021b8>] do_truncate+0x67/0x84
Nov 26 16:42:11 portablebastien kernel: [28815.773720]  [<ffffffff8110b45a>] ? get_write_access+0x41/0x48
Nov 26 16:42:11 portablebastien kernel: [28815.773720]  [<ffffffff8110cfe5>] do_last+0x463/0x532
Nov 26 16:42:11 portablebastien kernel: [28815.773720]  [<ffffffff8110eb96>] do_filp_open+0x203/0x599
Nov 26 16:42:11 portablebastien kernel: [28815.773720]  [<ffffffff8134bd2b>] ? _raw_spin_unlock+0x26/0x2a
Nov 26 16:42:11 portablebastien kernel: [28815.773720]  [<ffffffff811184a0>] ? alloc_fd+0x170/0x182
Nov 26 16:42:11 portablebastien kernel: [28815.773720]  [<ffffffff81101366>] do_sys_open+0x5b/0xf7
Nov 26 16:42:11 portablebastien kernel: [28815.773720]  [<ffffffff8134b48e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
Nov 26 16:42:11 portablebastien kernel: [28815.773720]  [<ffffffff8110142b>] sys_open+0x1b/0x1d
Nov 26 16:42:11 portablebastien kernel: [28815.773720]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Nov 26 16:42:11 portablebastien kernel: [28815.773720] sync          D 0000000100690737     0  2904   2740 0x00000000
Nov 26 16:42:11 portablebastien kernel: [28815.773720]  ffff880016103d48 0000000000000046 ffff880000000000 ffff880100000000
Nov 26 16:42:11 portablebastien kernel: [28815.773720]  ffff880016102010 ffff880016103fd8 ffff8800b7d49fc0 ffff8800b7d4a290
Nov 26 16:42:11 portablebastien kernel: [28815.773720]  ffff8800b7d4a288 0000000000014d80 0000000000014d80 ffff880016103fd8
Nov 26 16:42:11 portablebastien kernel: [28815.773720] Call Trace:
Nov 26 16:42:11 portablebastien kernel: [28815.773720]  [<ffffffffa01b8454>] queue_log_writer+0x7e/0xaf [reiserfs]
Nov 26 16:42:11 portablebastien kernel: [28815.773720]  [<ffffffff81044423>] ? default_wake_function+0x0/0xf
Nov 26 16:42:11 portablebastien kernel: [28815.773720]  [<ffffffffa01bc402>] do_journal_begin_r+0x1ee/0x2d8 [reiserfs]
Nov 26 16:42:11 portablebastien kernel: [28815.773720]  [<ffffffff8112475f>] ? sync_one_sb+0x0/0x1d
Nov 26 16:42:11 portablebastien kernel: [28815.773720]  [<ffffffffa01bc5ae>] journal_begin+0xc2/0x103 [reiserfs]
Nov 26 16:42:11 portablebastien kernel: [28815.773720]  [<ffffffffa01aa450>] reiserfs_sync_fs+0x27/0x5e [reiserfs]
Nov 26 16:42:11 portablebastien kernel: [28815.773720]  [<ffffffff81124747>] __sync_filesystem+0x66/0x7e
Nov 26 16:42:11 portablebastien kernel: [28815.773720]  [<ffffffff8112477a>] sync_one_sb+0x1b/0x1d
Nov 26 16:42:11 portablebastien kernel: [28815.773720]  [<ffffffff81104bdd>] iterate_supers+0x6d/0xc8
Nov 26 16:42:11 portablebastien kernel: [28815.773720]  [<ffffffff811247a6>] sys_sync+0x2a/0x57
Nov 26 16:42:11 portablebastien kernel: [28815.773720]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Nov 26 16:42:11 portablebastien kernel: [28815.773720] Sched Debug Version: v0.09, 2.6.36 #4
Nov 26 16:42:11 portablebastien kernel: [28815.773720] now at 28815776.319493 msecs
Nov 26 16:42:11 portablebastien kernel: [28815.773720]   .jiffies                                 : 4302096239
Nov 26 16:42:11 portablebastien kernel: [28815.773720]   .sysctl_sched_latency                    : 12.000000
Nov 26 16:42:11 portablebastien kernel: [28815.773720]   .sysctl_sched_min_granularity            : 1.500000
Nov 26 16:42:11 portablebastien kernel: [28815.773720]   .sysctl_sched_wakeup_granularity         : 2.000000
Nov 26 16:42:11 portablebastien kernel: [28815.773720]   .sysctl_sched_child_runs_first           : 0
Nov 26 16:42:11 portablebastien kernel: [28815.773720]   .sysctl_sched_features                   : 15471
Nov 26 16:42:11 portablebastien kernel: [28815.773720]   .sysctl_sched_tunable_scaling            : 1 (logaritmic)
Nov 26 16:42:11 portablebastien kernel: [28815.773720] 
Nov 26 16:42:11 portablebastien kernel: [28815.773720] cpu#0, 2094.747 MHz
Nov 26 16:42:11 portablebastien kernel: [28815.773720]   .nr_running                    : 1
Nov 26 16:42:11 portablebastien kernel: [28815.773720]   .load                          : 1024
Nov 26 16:42:11 portablebastien kernel: [28815.773720]   .nr_switches                   : 29286351
Nov 26 16:42:11 portablebastien kernel: [28815.773720]   .nr_load_updates               : 2854528
Nov 26 16:42:11 portablebastien kernel: [28815.773720]   .nr_uninterruptible            : 7
Nov 26 16:42:11 portablebastien kernel: [28815.773720]   .next_balance                  : 4302.096182
Nov 26 16:42:11 portablebastien kernel: [28815.773720]   .curr->pid                     : 3169
Nov 26 16:42:11 portablebastien kernel: [28815.773720]   .clock                         : 28815773.720492
Nov 26 16:42:11 portablebastien kernel: [28815.773720]   .cpu_load[0]                   : 0
Nov 26 16:42:11 portablebastien kernel: [28815.773720]   .cpu_load[1]                   : 336
Nov 26 16:42:11 portablebastien kernel: [28815.773720]   .cpu_load[2]                   : 582
Nov 26 16:42:11 portablebastien kernel: [28815.773720]   .cpu_load[3]                   : 484
Nov 26 16:42:11 portablebastien kernel: [28815.773720]   .cpu_load[4]                   : 307
Nov 26 16:42:11 portablebastien kernel: [28815.773720] 
Nov 26 16:42:11 portablebastien kernel: [28815.773720] cfs_rq[0]:/
Nov 26 16:42:11 portablebastien kernel: [28815.773720]   .exec_clock                    : 0.000000
Nov 26 16:42:11 portablebastien kernel: [28815.773720]   .MIN_vruntime                  : 0.000001
Nov 26 16:42:11 portablebastien kernel: [28815.773720]   .min_vruntime                  : 23793305.960103
Nov 26 16:42:11 portablebastien kernel: [28815.773720]   .max_vruntime                  : 0.000001
Nov 26 16:42:11 portablebastien kernel: [28815.773720]   .spread                        : 0.000000
Nov 26 16:42:11 portablebastien kernel: [28815.773720]   .spread0                       : 0.000000
Nov 26 16:42:11 portablebastien kernel: [28815.773720]   .nr_running                    : 1
Nov 26 16:42:11 portablebastien kernel: [28815.773720]   .load                          : 1024
Nov 26 16:42:11 portablebastien kernel: [28815.773720]   .nr_spread_over                : 0
Nov 26 16:42:11 portablebastien kernel: [28815.773720]   .shares                        : 0
Nov 26 16:42:11 portablebastien kernel: [28815.773720] 
Nov 26 16:42:11 portablebastien kernel: [28815.773720] rt_rq[0]:
Nov 26 16:42:11 portablebastien kernel: [28815.773720]   .rt_nr_running                 : 0
Nov 26 16:42:11 portablebastien kernel: [28815.773720]   .rt_throttled                  : 0
Nov 26 16:42:11 portablebastien kernel: [28815.773720]   .rt_time                       : 0.000000
Nov 26 16:42:11 portablebastien kernel: [28815.773720]   .rt_runtime                    : 1000.000000
Nov 26 16:42:11 portablebastien kernel: [28815.773720] 
Nov 26 16:42:11 portablebastien kernel: [28815.773720] runnable tasks:
Nov 26 16:42:11 portablebastien kernel: [28815.773720]             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
Nov 26 16:42:11 portablebastien kernel: [28815.773720] ----------------------------------------------------------------------------------------------------------
Nov 26 16:42:11 portablebastien kernel: [28815.773720] R    kworker/0:2  3169  23793300.071530       140   120               0               0               0.000000               0.000000               0.000000 /
Nov 26 16:42:11 portablebastien kernel: [28815.773720] 
Nov 26 16:42:11 portablebastien kernel: [28815.773720] cpu#1, 2094.747 MHz
Nov 26 16:42:11 portablebastien kernel: [28815.773720]   .nr_running                    : 1
Nov 26 16:42:11 portablebastien kernel: [28815.773720]   .load                          : 1024
Nov 26 16:42:11 portablebastien kernel: [28815.773720]   .nr_switches                   : 25715436
Nov 26 16:42:11 portablebastien kernel: [28815.773720]   .nr_load_updates               : 2940401
Nov 26 16:42:11 portablebastien kernel: [28815.773720]   .nr_uninterruptible            : 3
Nov 26 16:42:11 portablebastien kernel: [28815.773720]   .next_balance                  : 4302.096247
Nov 26 16:42:11 portablebastien kernel: [28815.773720]   .curr->pid                     : 3732
Nov 26 16:42:11 portablebastien kernel: [28815.773720]   .clock                         : 28815697.377964
Nov 26 16:42:11 portablebastien kernel: [28815.773720]   .cpu_load[0]                   : 1024
Nov 26 16:42:11 portablebastien kernel: [28815.773720]   .cpu_load[1]                   : 512
Nov 26 16:42:11 portablebastien kernel: [28815.773720]   .cpu_load[2]                   : 259
Nov 26 16:42:11 portablebastien kernel: [28815.773720]   .cpu_load[3]                   : 159
Nov 26 16:42:11 portablebastien kernel: [28815.773720]   .cpu_load[4]                   : 135
Nov 26 16:42:11 portablebastien kernel: [28815.773720] 
Nov 26 16:42:11 portablebastien kernel: [28815.773720] cfs_rq[1]:/
Nov 26 16:42:11 portablebastien kernel: [28815.773720]   .exec_clock                    : 0.000000
Nov 26 16:42:11 portablebastien kernel: [28815.773720]   .MIN_vruntime                  : 0.000001
Nov 26 16:42:11 portablebastien kernel: [28815.773720]   .min_vruntime                  : 34468434.288668
Nov 26 16:42:11 portablebastien kernel: [28815.773720]   .max_vruntime                  : 0.000001
Nov 26 16:42:11 portablebastien kernel: [28815.773720]   .spread                        : 0.000000
Nov 26 16:42:11 portablebastien kernel: [28815.773720]   .spread0                       : 10675128.328565
Nov 26 16:42:11 portablebastien kernel: [28815.773720]   .nr_running                    : 1
Nov 26 16:42:11 portablebastien kernel: [28815.773720]   .load                          : 1024
Nov 26 16:42:11 portablebastien kernel: [28815.773720]   .nr_spread_over                : 0
Nov 26 16:42:11 portablebastien kernel: [28815.773720]   .shares                        : 0
Nov 26 16:42:11 portablebastien kernel: [28815.773720] 
Nov 26 16:42:11 portablebastien kernel: [28815.773720] rt_rq[1]:
Nov 26 16:42:11 portablebastien kernel: [28815.773720]   .rt_nr_running                 : 0
Nov 26 16:42:11 portablebastien kernel: [28815.773720]   .rt_throttled                  : 0
Nov 26 16:42:11 portablebastien kernel: [28815.773720]   .rt_time                       : 0.000000
Nov 26 16:42:11 portablebastien kernel: [28815.773720]   .rt_runtime                    : 900.000000
Nov 26 16:42:11 portablebastien kernel: [28815.773720] 
Nov 26 16:42:11 portablebastien kernel: [28815.773720] runnable tasks:
Nov 26 16:42:11 portablebastien kernel: [28815.773720]             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
Nov 26 16:42:11 portablebastien kernel: [28815.773720] ----------------------------------------------------------------------------------------------------------
Nov 26 16:42:11 portablebastien kernel: [28815.773720] R           bash  3732  34468428.288668      1182   120               0               0               0.000000               0.000000               0.000000 /
Nov 26 16:42:11 portablebastien kernel: [28815.773720] 
Nov 26 16:43:08 portablebastien kernel: [28872.807914] SysRq : HELP : loglevel(0-9) reBoot Crash show-all-locks(D) terminate-all-tasks(E) memory-full-oom-kill(F) kill-all-tasks(I) thaw-filesystems(J) saK show-backtrace-all-active-cpus(L) show-memory-usage(M) nice-all-RT-tasks(N) powerOff show-registers(P) show-all-timers(Q) unRaw Sync show-task-states(T) Unmount force-fb(V) show-blocked-tasks(W) dump-ftrace-buffer(Z) 
Nov 26 16:43:14 portablebastien kernel: [28878.519113] SysRq : Show Locks Held
Nov 26 16:43:14 portablebastien kernel: [28878.520551] INFO: lockdep is turned off.
Nov 26 16:43:54 portablebastien kernel: [28918.601444] SysRq : Emergency Sync
Nov 26 16:44:04 portablebastien kernel: [28928.510898] SysRq : Emergency Remount R/O
--Boundary-00=_kb+7MiQ6ZyKd7vZ--
