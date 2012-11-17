Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753948Ab2KQImk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2012 03:42:40 -0500
Received: from mail.parknet.co.jp ([210.171.160.6]:60932 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753149Ab2KQImj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2012 03:42:39 -0500
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: The bug of iput() removal from flusher thread?
Date: Sat, 17 Nov 2012 17:42:30 +0900
Message-ID: <8762541uyx.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

In 169ebd90131b2ffca74bb2dbe7eeacd39fb83714 commit, writeback doesn't
__iget()/iput() anymore.

This means nobody moves the inode to lru list. I.e.

	new_inode()
	dirty_inode()
	iput_final()
		/* keep inode without adding lru */
	flush indoes
        /* clean inode is not on lru */

I noticed this situation in my FS though, I think the same bug is on all
FSes of linus tree too, after this commit.

Am I missing the something?

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
