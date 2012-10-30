Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934687Ab2J3Vax (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 17:30:53 -0400
Received: from cpsmtpb-ews09.kpnxchange.com ([213.75.39.14]:64301 "EHLO
	cpsmtpb-ews09.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750947Ab2J3Vav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 17:30:51 -0400
Message-ID: <1351632646.1339.72.camel@x61.thuisdomein>
Subject: Re: NULL pointer dereference at fat_detach
From: Paul Bolle <pebolle@tiscali.nl>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, linux-kernel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>
Date: Tue, 30 Oct 2012 22:30:46 +0100
In-Reply-To: <20121030134449.GA5435@redhat.com>
References: <20121030134449.GA5435@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 30 Oct 2012 21:30:46.0489 (UTC) FILETIME=[D2DA2490:01CDB6E5]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-10-30 at 14:44 +0100, Stanislaw Gruszka wrote:
> From time to time Fedora users reports crash at fat_detach.
> It happens randomly and seldom. Seems to be related with
> unmount operation.
> 
> Early reports are from 3.0 and problem still randomly occurs
> on recent kernels.
> 
> Calltraces looks like below:
> 
> BUG: unable to handle kernel NULL pointer dereference at 0000009c
> IP: [<c046d983>] do_raw_spin_lock+0xd/0x1e
> 
> [<c07fcc94>] _raw_spin_lock+0xd/0xf
> [<f8fe03de>] fat_detach+0x20/0x59 [fat]
> [<f8fe0874>] fat_evict_inode+0x5b/0x5e [fat]
> [<c05058ad>] evict+0x57/0xe9
> [<c0505a67>] iput+0xf8/0xfd
> [<c051ce0f>] fsnotify_destroy_mark+0xdf/0xf8
> [<c051e488>] sys_inotify_rm_watch+0x59/0x79
> [<c07fcfbc>] syscall_call+0x7/0xb
> 
> what most likely indicate that fat_evict is called with
> inode with i_sb->s_fs_info == NULL.
> 
> Some more info about this problem can be found here:
> https://bugzilla.redhat.com/show_bug.cgi?id=768534
> 
> Any insight on this isssue is welcome.

0) I remembered running into an almost identical Oops recently, but not
reporting it because I was unable to reproduce it. It appeared to be
triggered by unmounting and/or removing a USB stick.

1) For what it's worth, the last few lines in the logs before this Oops
were:
    [...] 
    Oct 17 11:50:41 x61 udisksd[1170]: Mounted /dev/sdb1 at /run/media/[...]/LIVE on behalf of uid 1000
    Oct 17 11:52:36 x61 udisksd[1170]: Cleaning up mount point /run/media/[...]/LIVE (device 8:17 is not mounted)
    Oct 17 11:52:36 x61 kernel: [15141.653798] VFS: Busy inodes after unmount of sdb1. Self-destruct in 5 seconds.  Have a nice day...


Paul Bolle

