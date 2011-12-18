Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751808Ab1LROdS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Dec 2011 09:33:18 -0500
Received: from gateway.alibaba-inc.com ([121.0.29.128]:56587 "EHLO
	CNHZ-ExGW-01.ali.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751127Ab1LROdQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Dec 2011 09:33:16 -0500
X-Greylist: delayed 901 seconds by postgrey-1.27 at vger.kernel.org; Sun, 18 Dec 2011 09:33:15 EST
X-AuditID: 0a14034b-b7cb9ae000002f99-4d-4eedf621aab8
To: undisclosed-recipients:;
Message-ID: <4EEDF620.8070008@taobao.com>
Date: Sun, 18 Dec 2011 22:18:08 +0800
From: boyu <boyu.mt@taobao.com>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
CC: LKML <linux-kernel@vger.kernel.org>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger@dilger.ca>,
        <tm@tao.ma>
Subject: [PATCH V3 00/21] ext4: Add inline data support.
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [10.20.8.3]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ted, Andreas and list,
        This is the v3 attempt to add inline data support to ext4 inode.
For more information about the background, please refer to the thread
http://marc.info/?l=linux-ext4&m=131715205428067&w=2

Changelog from v2 to v3:
1. Add support for evict data from inode if we can store xattr in it.
2. Add support for fiemap
3. Some nasty bug fixes

The v2 can be found here:
http://marc.info/?l=linux-ext4&m=132189338604177&w=2

The v1 can be found here:
http://marc.info/?l=linux-ext4&m=131961438221255&w=2

any suggestions are welcomed.

git diff --stat master..
 fs/ext4/Makefile  |    2 +-
 fs/ext4/dir.c     |   39 +-
 fs/ext4/ext4.h    |   77 +++-
 fs/ext4/extents.c |   18 +-
 fs/ext4/ialloc.c  |    4 +
 fs/ext4/inline.c  | 1642 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/ext4/inode.c   |  236 ++++++--
 fs/ext4/namei.c   |  364 +++++++++----
 fs/ext4/xattr.c   |   64 +--
 fs/ext4/xattr.h   |  263 +++++++++
 10 files changed, 2481 insertions(+), 228 deletions(-)

Thanks
Tao


________________________________

This email (including any attachments) is confidential and may be legally privileged. If you received this email in error, please delete it immediately and do not copy it or use it for any purpose or disclose its contents to any other person. Thank you.

本电邮(包括任何附件)可能含有机密资料并受法律保护。如您不是正确的收件人，请您立即删除本邮件。请不要将本电邮进行复制并用作任何其他用途、或透露本邮件之内容。谢谢。
