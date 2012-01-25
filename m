Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755602Ab2AYBuf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 20:50:35 -0500
Received: from mail.nudt.edu.cn ([61.187.54.11]:45340 "HELO nudt.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1755569Ab2AYBue (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 20:50:34 -0500
Date: Wed, 25 Jan 2012 09:37:05 +0800
From: "Li Wang" <liwang@nudt.edu.cn>
Subject: Re:[PATCH 1/3] eCryptfs: Make truncate path killable
To: ecryptfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Message-Id: <120125093705f78ff96d4632e50c58fad5979e142606@nudt.edu.cn>
MIME-Version: 1.0
X-Mailer: eYou WebMail 5.0.3
X-Eyou-Client: 218.88.165.8
Content-Type: text/plain;
 charset="GBK"
X-Eyou-Sender: <liwang@nudt.edu.cn>
X-Eyou-MID: <48291792ca7ce7a988b189d4bfd8e440>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q0P1ogZw000671

Hi Tyler,
    Is it more polite to invoke cond_resched() at the beginning/end of the potentially long-time loop?

Cheers,
Li Wang





---------- Origin message ----------
>From£º"Tyler Hicks" <tyhicks@canonical.com>
>To£ºecryptfs@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
>Subject£º[PATCH 1/3] eCryptfs: Make truncate path killable
>Date£º2012-01-21 06:35:05

ecryptfs_write() handles the truncation of eCryptfs inodes. It grabs a
page, zeroes out the appropriate portions, and then encrypts the page
before writing it to the lower filesystem. It was unkillable and due to
the lack of sparse file support could result in tying up a large portion
of system resources, while encrypting pages of zeros, with no way for
the truncate operation to be stopped from userspace.

This patch adds the ability for ecryptfs_write() to detect a pending
fatal signal and return as gracefully as possible. The intent is to
leave the lower file in a useable state, while still allowing a user to
break out of the encryption loop. If a pending fatal signal is detected,
the eCryptfs inode size is updated to reflect the modified inode size
and then -EINTR is returned.

Signed-off-by: Tyler Hicks <tyhicks@canonical.com>
Cc: <stable@vger.kernel.org>
---
fs/ecryptfs/read_write.c | 19 ++++++++++++++-----
1 files changed, 14 insertions(+), 5 deletions(-)
 ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
