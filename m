Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756772Ab2AXO15 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 09:27:57 -0500
Received: from mail.nudt.edu.cn ([61.187.54.11]:42920 "HELO nudt.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1756745Ab2AXO1z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 09:27:55 -0500
Date: Tue, 24 Jan 2012 22:14:24 +0800
From: "Li Wang" <liwang@nudt.edu.cn>
Subject: Re:[PATCH 2/3 v2] eCryptfs: Check inode changes in setattr
To: "Linus Torvalds" <torvalds@linux-foundation.org>,
        john.johansen@canonical.com, dustin.kirkland@gazzang.com,
        "Cong Wang" <xiyou.wangcong@gmail.com>, ecryptfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        "Tyler Hicks" <tyhicks@canonical.com>
References: <20120124063246.GA5692@boyd>
 <527389872.29922@eyou.net>
In-Reply-To: <527389872.29922@eyou.net>
Message-Id: <120124221424f4f1daa3ab344ab8e4d4ba1bae21070f@nudt.edu.cn>
MIME-Version: 1.0
X-Mailer: eYou WebMail 5.0.3
X-Eyou-Client: 218.88.165.153
Content-Type: text/plain;
 charset="GBK"
X-Eyou-Sender: <liwang@nudt.edu.cn>
X-Eyou-MID: <6aaaddc4af0b5742fc2fd97f364b028e>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q0OESCk6029495

Hi Tyler,
  We think that is good, except it is not very elegant to invoke 
inode_newsize_ok with the ecryptfs (upper) inode and lower size, nevertheless, we donot have other better choices and it is wrapped in 
ecryptfs_inode_newsize_ok...
  In a word, we are with you.

Cheers,
Li Wang





---------- Origin message ----------
>From£º"Tyler Hicks" <tyhicks@canonical.com>
>To£ºecryptfs@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
>Subject£º[PATCH 2/3 v2] eCryptfs: Check inode changes in setattr
>Date£º2012-01-24 15:37:32

Most filesystems call inode_change_ok() very early in ->setattr(), but
eCryptfs didn't call it at all. It allowed the lower filesystem to make
the call in its ->setattr() function. Then, eCryptfs would copy the
appropriate inode attributes from the lower inode to the eCryptfs inode.

This patch changes that and actually calls inode_change_ok() on the
eCryptfs inode, fairly early in ecryptfs_setattr(). Ideally, the call
would happen earlier in ecryptfs_setattr(), but there are some possible
inode initialization steps that must happen first.

Since the call was already being made on the lower inode, the change in
functionality should be minimal, except for the case of a file extending
truncate call. In that case, inode_newsize_ok() was never being
called on the eCryptfs inode. Rather than inode_newsize_ok() catching
maximum file size errors early on, eCryptfs would encrypt zeroed pages
and write them to the lower filesystem until the lower filesystem's
write path caught the error in generic_write_checks(). This patch
introduces a new function, called ecryptfs_inode_newsize_ok(), which
checks if the new lower file size is within the appropriate limits when
the truncate operation will be growing the lower file. ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
