Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760286Ab0EEOSP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 10:18:15 -0400
Received: from smtp.nokia.com ([192.100.122.230]:62788 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760161Ab0EEOSO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 10:18:14 -0400
Subject: Re: [PATCH v3] mtd: Do not corrupt backing device of device node
 inode
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: David Woodhouse <dwmw2@infradead.org>, Jan Kara <jack@suse.cz>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       David Howells <dhowells@redhat.com>,
       Alexander Shishkin <virtuoso@slind.org>, linux-mtd@lists.infradead.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1273047688-20947-1-git-send-email-kirill@shutemov.name>
References: <1273047688-20947-1-git-send-email-kirill@shutemov.name>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 05 May 2010 17:17:19 +0300
Message-ID: <1273069039.3702.188.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 05 May 2010 14:17:47.0663 (UTC) FILETIME=[BCC521F0:01CAEC5D]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-05-05 at 11:21 +0300, Kirill A. Shutemov wrote:
> We cannot modify file->f_mapping->backing_dev_info, because it will corrupt
> backing device of device node inode, since file->f_mapping is equal to
> inode->i_mapping (see __dentry_open() in fs/open.c).
> 
> Let's introduce separate inode for MTD device with appropriate backing
> device.
> 
> Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
> Acked-by: Jan Kara <jack@suse.cz>

I get the following build error:

[dedekind@eru l2-mtd-2.6]$ make -j8
O=/home/dedekind/tmp/l2-mtd-2.6-x86_64/
  GEN     /home/dedekind/tmp/l2-mtd-2.6-x86_64/Makefile
  CHK     include/linux/version.h
  CHK     include/generated/utsrelease.h
  Using /home/dedekind/git/l2-mtd-2.6 as source for kernel
  CALL    /home/dedekind/git/l2-mtd-2.6/scripts/checksyscalls.sh
  CHK     include/generated/compile.h
  CHK     include/linux/version.h
make[3]: `scripts/unifdef' is up to date.
  Building modules, stage 2.
Kernel: arch/x86/boot/bzImage is ready  (#2)
  MODPOST 146 modules
ERROR: "__iget" [drivers/mtd/mtdchar.ko] undefined!
ERROR: "inode_lock" [drivers/mtd/mtdchar.ko] undefined!
make[2]: *** [__modpost] Error 1
make[1]: *** [modules] Error 2
make: *** [sub-make] Error 2

__iget and inode_lock are not exported...

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

