Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754806Ab1F2RFs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 13:05:48 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:49723 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752147Ab1F2RFp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 13:05:45 -0400
MIME-Version: 1.0
In-Reply-To: <1309275310-10987-1-git-send-email-josef@redhat.com>
References: <1309275310-10987-1-git-send-email-josef@redhat.com>
Date: Wed, 29 Jun 2011 19:05:44 +0200
Message-ID: <BANLkTikE46adv1PvGRKOcREUi-FQN7WmhQ@mail.gmail.com>
Subject: Re: [PATCH] fs: push i_mutex and filemap_write_and_wait down into
 ->fsync() handlers
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: Josef Bacik <josef@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        viro@zeniv.linux.org.uk, hch@infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 28, 2011 at 5:35 PM, Josef Bacik <josef@redhat.com> wrote:
> Btrfs needs to be able to control how filemap_write_and_wait_range() is called
> in fsync to make it less of a painful operation, so push down taking i_mutex and
> the calling of filemap_write_and_wait() down into the ->fsync() handlers.  Some
> file systems can drop taking the i_mutex altogether it seems, like ext3 and
> ocfs2.  For correctness sake I just pushed everything down in all cases to make
> sure that we keep the current behavior the same for everybody, and then each
> individual fs maintainer can make up their mind about what to do from there.
> Thanks,
>
> Signed-off-by: Josef Bacik <josef@redhat.com>

A small note from checkpatch.pl:

ERROR: "foo * bar" should be "foo *bar"
#1109: FILE: fs/hostfs/hostfs_kern.c:367:
+       struct inode * inode = file->f_mapping->host;

-- 
Thanks,
//richard
