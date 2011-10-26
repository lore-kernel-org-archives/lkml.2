Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754450Ab1JZHco (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 03:32:44 -0400
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:34349 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753123Ab1JZHcn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 03:32:43 -0400
Message-ID: <4EA7B788.3040503@tao.ma>
Date: Wed, 26 Oct 2011 15:32:24 +0800
From: Tao Ma <tm@tao.ma>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: "Ted Ts'o" <tytso@mit.edu>, ext4 development <linux-ext4@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH V1 00/17] ext4: Add inline data support.
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1390:box585.bluehost.com:colyli:tao.ma} {sentby:smtp auth 182.92.247.2 authed with tm@tao.ma}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ted, Andreas and list,
	This is my 1st attempt to add inline data support to ext4 inode. For
more information about the background, please refer to the thread
http://marc.info/?l=linux-ext4&m=131715205428067&w=2
When I sent out the RFC on Sep.27, Andreas suggested that we can use the
space of xattr to put inline data. So this is the 1st version using that
method. It should be easy to change if we decide to use other places in
inode(e.g the unused extent space) since all the inline data
manipulation function is wrapped with function like ext4_*_inline_data.

Currently I use all the space between i_extra_isize and inode_size if
inode_size = 256. For inode_size > 256, half of that space is used so as
to leave some space for other xattrs.

This is only a V1 and there are still something to do(e.g. I am thinking
of using unused extent space), but I'd like to send it out earlier so
that it can be reviewed ASAP.

Some simple tests shows that with a linux-3.0 vanilla source, the new
dir can save 1% disk space. For my "/usr", it can save about 3.2%
spaces. I guess for volume with future bigalloc support, it should save
more space for us for small dir. I also run some other tests and it
seems the code is OK for a try. I haven't found a good test cases that
can test the small file/dir(tens of bytes in my case) performance where
inline data should have some good number.

Any comments are welcomed.

git diff --stat

fs/ext4/dir.c    |  117 ++++++++++-
fs/ext4/ext4.h   |   15 +-
fs/ext4/ialloc.c |    4 +
fs/ext4/inode.c  |  583 +++++++++++++++++++++++++++++++++++++++++++++++---
fs/ext4/namei.c  |  629
+++++++++++++++++++++++++++++++++++++++++++++---------
fs/ext4/xattr.c  |  216 +++++++++++++++++++
fs/ext4/xattr.h  |   68 ++++++
7 files changed, 1489 insertions(+), 143 deletions(-)

Thanks
Tao
