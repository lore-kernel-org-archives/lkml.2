Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760926Ab2EIT65 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 15:58:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33899 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756490Ab2EIT64 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 15:58:56 -0400
Date: Wed, 9 May 2012 15:58:48 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Szymon Gruszczynski <sz.gruszczynski@googlemail.com>,
        Fedora Kernel Team <kernel-team@fedoraproject.org>,
        Al Viro <viro@zeniv.linux.org>, Tejun Heo <tj@kernel.org>
Subject: stack overflow in printk_all_partitions.
Message-ID: <20120509195848.GA961@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Szymon Gruszczynski <sz.gruszczynski@googlemail.com>,
	Fedora Kernel Team <kernel-team@fedoraproject.org>,
	Al Viro <viro@zeniv.linux.org>, Tejun Heo <tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Szymon (cc'd) reported this oops that prevents his machine booting
a 3.3.4 kernel.

[ 2.892504] Kernel panic - not syncing: stack-protector: Kernel stack corrupted in: ffffffff81b14c7e
[ 2.892506]
[ 2.892872] [<ffffffff815e226b>] panic+0xba/0x1c6
[ 2.892961] [<ffffffff81b14c7e>] ? printk_all_partitions+0x259/0x26xb
[ 2.893057] [<ffffffff810566bb>] __stack_chk_fail+0x1b/0x20
[ 2.893147] [<ffffffff81b15c7e>] printk_all_paritions+0x259/0x26xb
[ 2.893244] [<ffffffff81aedfe0>] mount_block_root+0x1bc/0x27f
[ 2.893336] [<ffffffff81aee0fa>] mount_root+0x57/0x5b
[ 2.893425] [<ffffffff81aee23b>] prepare_namespace+0x13d/0x176
[ 2.893522] [<ffffffff8107eec0>] ? release_tgcred.isra.4+0x330/0x30
[ 2.893616] [<ffffffff81aedd60>] kernel_init+0x155/0x15a
[ 2.893708] [<ffffffff81087b97>] ? schedule_tail+0x27/0xb0
[ 2.893800] [<ffffffff815f4d24>] kernel_thread_helper+0x5/0x10
[ 2.893893] [<ffffffff81aedc0b>] ? start_kernel+0x3c5/0x3c5
[ 2.893984] [<ffffffff815f4d20>] ? gs_change+0x13/0x13

His partition tables don't look anything out of the ordinary to me.
http://wklej.org/id/748085/

Any ideas what's going wrong here ?

original report at https://bugzilla.redhat.com/show_bug.cgi?id=819624,
though all pertinent info so far is captured above.

	Dave
