Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753491Ab0EFG75 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 02:59:57 -0400
Received: from smtp.nokia.com ([192.100.122.233]:16817 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751171Ab0EFG7z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 02:59:55 -0400
Subject: Re: [PATCH v4] mtd: Do not corrupt backing device of device node
 inode
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: David Woodhouse <dwmw2@infradead.org>, Jan Kara <jack@suse.cz>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       David Howells <dhowells@redhat.com>,
       Alexander Shishkin <virtuoso@slind.org>, linux-mtd@lists.infradead.org,
       linux-fsdevel@vger.kernel.org, stable@kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <1273074054-11849-1-git-send-email-kirill@shutemov.name>
References: <1273074054-11849-1-git-send-email-kirill@shutemov.name>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 06 May 2010 09:39:19 +0300
Message-ID: <1273127959.3702.200.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 06 May 2010 06:39:59.0685 (UTC) FILETIME=[F2FE0F50:01CAECE6]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-05-05 at 18:40 +0300, Kirill A. Shutemov wrote:
> We cannot modify file->f_mapping->backing_dev_info, because it will corrupt
> backing device of device node inode, since file->f_mapping is equal to
> inode->i_mapping (see __dentry_open() in fs/open.c).
> 
> Let's introduce separate inode for MTD device with appropriate backing
> device.
> 
> Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
> ---
> Changelog:
>  v3 -> v4:
>   - Use igrab() instead of __iget inside the inode_lock;
>   - Add stable@ to CC list.
>  v2 -> v3:
>   - Rebase to mtd-2.6.git.
>  v1 -> v2:
>   - Fix error handling based on comments by Jan Kara.

Pushed to l2-mtd-2.6.git / dunno

Also added Jan's ack which disappeared in v4

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

