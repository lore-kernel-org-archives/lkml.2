Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753375Ab2J3Nox (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 09:44:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3815 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752096Ab2J3Now (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 09:44:52 -0400
Date: Tue, 30 Oct 2012 14:44:50 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>
Subject: NULL pointer dereference at fat_detach
Message-ID: <20121030134449.GA5435@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

>From time to time Fedora users reports crash at fat_detach.
It happens randomly and seldom. Seems to be related with
unmount operation.

Early reports are from 3.0 and problem still randomly occurs
on recent kernels.

Calltraces looks like below:

BUG: unable to handle kernel NULL pointer dereference at 0000009c
IP: [<c046d983>] do_raw_spin_lock+0xd/0x1e

[<c07fcc94>] _raw_spin_lock+0xd/0xf
[<f8fe03de>] fat_detach+0x20/0x59 [fat]
[<f8fe0874>] fat_evict_inode+0x5b/0x5e [fat]
[<c05058ad>] evict+0x57/0xe9
[<c0505a67>] iput+0xf8/0xfd
[<c051ce0f>] fsnotify_destroy_mark+0xdf/0xf8
[<c051e488>] sys_inotify_rm_watch+0x59/0x79
[<c07fcfbc>] syscall_call+0x7/0xb

what most likely indicate that fat_evict is called with
inode with i_sb->s_fs_info == NULL.

Some more info about this problem can be found here:
https://bugzilla.redhat.com/show_bug.cgi?id=768534

Any insight on this isssue is welcome.

Thanks
Stanislaw 
