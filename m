Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932242Ab0EEGLK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 02:11:10 -0400
Received: from smtp.nokia.com ([192.100.122.230]:35088 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755382Ab0EEGLG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 02:11:06 -0400
Subject: Re: [PATCH v2] mtd: Do not corrupt backing device of device node
 inode
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: David Woodhouse <dwmw2@infradead.org>, Jan Kara <jack@suse.cz>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       David Howells <dhowells@redhat.com>,
       Alexander Shishkin <virtuoso@slind.org>, linux-mtd@lists.infradead.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1272922368-18517-1-git-send-email-kirill@shutemov.name>
References: <1272922368-18517-1-git-send-email-kirill@shutemov.name>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 05 May 2010 09:04:16 +0300
Message-ID: <1273039456.3702.59.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 05 May 2010 06:10:29.0258 (UTC) FILETIME=[A95296A0:01CAEC19]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-05-04 at 00:32 +0300, Kirill A. Shutemov wrote:
> We cannot modify file->f_mapping->backing_dev_info, because it will corrupt
> backing device of device node inode, since file->f_mapping is equal to
> inode->i_mapping (see __dentry_open() in fs/open.c).
> 
> Let's introduce separate inode for MTD device with appropriate backing
> device.
> 
> Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
> 
> ---
> Changelog v1 -> v2:
>  - Fix error handling based on comments by Jan Kara.

How about a version of this patch which applies to the mtd-2.6 tree

git://git.infradead.org/mtd-2.6.git
(webview: http://git.infradead.org/mtd-2.6.git)

This one does not apply:

[dedekind@eru mtd-2.6]$ git am ~/tmp/k
Applying: mtd: Do not corrupt backing device of device node inode
error: patch failed: drivers/mtd/mtdchar.c:954
error: drivers/mtd/mtdchar.c: patch does not apply
error: patch failed: drivers/mtd/mtdcore.c:383
error: drivers/mtd/mtdcore.c: patch does not apply
Patch failed at 0001 mtd: Do not corrupt backing device of device node
inode
When you have resolved this problem run "git am --resolved".
If you would prefer to skip this patch, instead run "git am --skip".
To restore the original branch and stop patching run "git am --abort".
[dedekind@eru mtd-2.6]$ patch -p1 < .git/rebase-apply/patch 
patching file drivers/mtd/mtdchar.c
Hunk #2 succeeded at 88 (offset -3 lines).
Hunk #3 succeeded at 119 (offset -3 lines).
Hunk #4 succeeded at 145 (offset -3 lines).
Hunk #5 FAILED at 979.
1 out of 5 hunks FAILED -- saving rejects to file
drivers/mtd/mtdchar.c.rej
patching file drivers/mtd/mtdcore.c
Hunk #1 FAILED at 383.
1 out of 1 hunk FAILED -- saving rejects to file
drivers/mtd/mtdcore.c.rej
patching file include/linux/mtd/mtd.h
Hunk #2 succeeded at 175 (offset -3 lines).

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

