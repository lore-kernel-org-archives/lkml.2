Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757533Ab1IHA0j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 20:26:39 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:60336 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756158Ab1IHA0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 20:26:38 -0400
MIME-Version: 1.0
Date: Thu, 8 Sep 2011 09:26:37 +0900
Message-ID: <CAKYAXd9m_n8SV9Ei=jA9-aZ3G9JtB8WFAjs7XteJn5jc0ems5A@mail.gmail.com>
Subject: RFC : squashfs : devblksize set to 4KB instread of BLK_SIZE(1KB).
From: NamJae Jeon <linkinjeon@gmail.com>
To: phillip@lougher.demon.co.uk, squashfs-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, devblksize is set to 1KB in squashfs like below code.

#define BLOCK_SIZE_BITS 10
#define BLOCK_SIZE (1<<BLOCK_SIZE_BITS)

msblk->devblksize = sb_min_blocksize(sb, BLOCK_SIZE);
-> msblk->devblksize = sb_min_blocksize(sb, PAGE_SIZE); or
->#define SQUASHFS_DEVBLK_SIZE 4096
-> msblk->devblksize = sb_min_blocksize(sb, SQUASHFS_DEVBLK_SIZE);

If devblksize is set by NAND page size before, I think that it is
changed to optimal vaule with increasing physical page size of NAND.

So I suggest that devblksize is set to 4KB, it is suitable for
physical page size of NAND(Onenand,flexOnenand 4KB) and minimal
compressed size.

We will gain improved performance(~20%) and stop reading inefficiently
several time by page alignment.

Thanks.
