Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933888Ab0FFLp4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jun 2010 07:45:56 -0400
Received: from DMZ-MAILSEC-SCANNER-1.MIT.EDU ([18.9.25.12]:57637 "EHLO
	dmz-mailsec-scanner-1.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750991Ab0FFLpz convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jun 2010 07:45:55 -0400
X-AuditID: 1209190c-b7bd2ae000005d05-23-4c0b8a719a05
Subject: Re: ext4 2.6.35-rc2 regression (ext4: Make sure the MOVE_EXT ioctl can't overwrite append-only files)
Mime-Version: 1.0 (Apple Message framework v1078)
Content-Type: text/plain; charset=us-ascii
From: Theodore Tso <tytso@MIT.EDU>
In-Reply-To: <20100606081601.GA1807@arch.tripp.de>
Date: Sun, 6 Jun 2010 07:45:48 -0400
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       linux-ext4@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <DB34C7CA-53EC-47B0-AD31-4C729B983C11@mit.edu>
References: <20100606081601.GA1807@arch.tripp.de>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
X-Mailer: Apple Mail (2.1078)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jun 6, 2010, at 4:16 AM, Markus Trippelsdorf wrote:

> Commit 1f5a81e41f8b1a782c68d3843e9ec1bfaadf7d72
> "ext4: Make sure the MOVE_EXT ioctl can't overwrite append-only files"
> causes the following kernel BUG on my machine (x86_64):
> 
> BUG: Bad page map in process mpd  pte:720072000000000 pmd:11d2f7067
> addr:00007f6b09f82000 vm_flags:08000070 anon_vma:(null) mapping:ffff88011b1cec18 index:132
> vma->vm_ops->fault: filemap_fault+0x0/0x31e
> vma->vm_file->f_op->mmap: ext4_file_mmap+0x0/0x54
> Pid: 1672, comm: mpd Not tainted 2.6.35-rc2-00032-g78a5aa2 #45
> Call Trace:
> [<ffffffff810b7a35>] print_bad_pte+0x1d0/0x1e9
> [<ffffffff810b8c9b>] unmap_vmas+0x50c/0x803
> [<ffffffff810be003>] exit_mmap+0xc4/0x14a
> [<ffffffff81057bc6>] mmput+0x2d/0xb9

What makes you think it was the commit you cited that is causing this crash?  Unless you are specifically using e2defrag (or write code which explicitly calls this ext4-specific ioctl), the code path in question wouldn't even be entered, and I see nothing in this stack trace to indicate it was caused by this change.

(And in fact in a subsequent e-mail I see that you've tried reverting both changes to ext4 between rc1 and rc2 and it didn't seem to help.)

Have you tried bisecting the kernel to find commit which introduced this problem?   What was the last kernel that didn't have these problem for you?  -rc1?   How easy is this to reproduce?   Does this happen as soon as you boot up your system?

Thanks,

-- Ted

