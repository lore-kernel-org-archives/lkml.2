Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757181Ab2BWV1x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 16:27:53 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:58410 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757165Ab2BWV1v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 16:27:51 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of neilaclarkson@gmail.com designates 10.180.109.225 as permitted sender) smtp.mail=neilaclarkson@gmail.com; dkim=pass header.i=neilaclarkson@gmail.com
MIME-Version: 1.0
Date: Thu, 23 Feb 2012 21:27:50 +0000
Message-ID: <CADzG2TCx8OtpBqwEA1VNN-PUFcPU5WBns2D5LtsZZu9mXUgeOQ@mail.gmail.com>
Subject: ext4 superblock last write time clearly isnt the last write time
From: Neil Clarkson <neilaclarkson@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Isn't the s_wtime field of the ext4 superblock supposed to show the
time, in seconds since the epoch, of the last write to the file
system? All the public domain info I found seems to indicate so, as
does this excerpt of code from 'static int ext4_commit_super(struct
super_block *sb, int sync)'

	/*
	 * If the file system is mounted read-only, don't update the
	 * superblock write time.  This avoids updating the superblock
	 * write time when we are mounting the root file system
	 * read/only but we need to replay the journal; at that point,
	 * for people who are east of GMT and who make their clock
	 * tick in localtime for Windows bug-for-bug compatibility,
	 * the clock is set in the future, and this will cause e2fsck
	 * to complain and force a full file system check.
	 */
	if (!(sb->s_flags & MS_RDONLY))
		es->s_wtime = cpu_to_le32(get_seconds());


Yet I noticed, on the 3 systems available to me, that it isn't
anything of the sort. Using dumpe2fs -h to show the timestamp fields
in the superblock, one seems be set at a half hour post file system
creation, the others clearly mirror the last mount time. None of them
are showing the time of the last write. None of them are mounted read
only.

Linux Wallace 3.0.0-16-generic #28-Ubuntu SMP Fri Jan 27 17:44:39 UTC
2012 x86_64 x86_64 x86_64 GNU/Linux (Ubuntu 11.10)

Filesystem created:       Wed Nov 23 13:42:18 2011
Last mount time:          Tue Feb 21 09:07:54 2012
Last write time:          Wed Nov 23 14:12:57 2011

Linux VM-OpenSUSE2 2.6.37.1-1.2-desktop #1 SMP PREEMPT 2011-02-21
10:34:10 +0100 x86_64 x86_64 x86_64 GNU/Linux (Open SUSE 11.4)

Filesystem created:       Fri Sep 23 18:04:27 2011
Last mount time:          Fri Jan 27 09:34:55 2012
Last write time:          Fri Jan 27 09:34:55 2012

Linux fedoraVM 2.6.35.6-45.fc14.i686 #1 SMP Mon Oct 18 23:56:17 UTC
2010 i686 i686 i386 GNU/Linux (Fedora 14)

Filesystem created:       Wed Nov  3 07:24:17 2010
Last mount time:          Fri Feb  3 13:04:41 2012
Last write time:          Fri Feb  3 13:04:41 2012

Clearly I'm missing something? Anyone know what? I've not found any
hints so far.
