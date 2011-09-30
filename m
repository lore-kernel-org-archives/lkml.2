Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754234Ab1I3PCx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 11:02:53 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:48986 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751454Ab1I3PCv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 11:02:51 -0400
MIME-Version: 1.0
Date: Fri, 30 Sep 2011 23:02:49 +0800
Message-ID: <CAD+1EGN=QRTk4gd+QKRyh3RxN_J64sz3+_zYtt0-4zoQbFpXNQ@mail.gmail.com>
Subject: [RFC]fs/ramfs/inode.c
From: harryxiyou <harryxiyou@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,
When i read ramfs's inode file fs/ramfs/inode.c. I just see the following codes
and get some confusions.

[......]
static void ramfs_kill_sb(struct super_block *sb)
{
           kfree(sb->s_fs_info);
           kill_litter_super(sb);
}
[.....]

If we can really free the sb->s_fs_info successfully everytime? Ok, you may say
kfree returns no value. But how we can guarantee it can be freed
right. And The same
problem with the function kill_litter_super(sb). We  also have some
other functions, which
i have the same confusions. I have searched the relevant codes about
kfree() with the tool
ctags and cscope, but i get so many relevant codes. I can not
distinguish which is the right
one. I think if we can not let the os stop, we just printk the
relevant error logs and make os
run as usual.


Thanks
Harry Wei
