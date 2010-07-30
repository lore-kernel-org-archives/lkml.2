Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758795Ab0G3RTn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 13:19:43 -0400
Received: from kroah.org ([198.145.64.141]:51979 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758769Ab0G3RTi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:19:38 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:15:09 2010
Message-Id: <20100730171509.855043933@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:15:41 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        "Theodore Tso" <tytso@mit.edu>, Akira Fujita <a-fujita@rs.jp.nec.com>
Subject: [113/165] ext4: allow defrag (EXT4_IOC_MOVE_EXT) in 32bit compat mode
In-Reply-To: <20100730171550.GA1299@kroah.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

commit b684b2ee9409f2890a8b3aea98525bbe5f84e276 upstream (as of v2.6.34-git13)

I have an x86_64 kernel with i386 userspace. e4defrag fails on the
EXT4_IOC_MOVE_EXT ioctl because it is not wired up for the compat
case. It seems that struct move_extent is compat save, only types
with fixed widths are used:
{
        __u32 reserved;         /* should be zero */
        __u32 donor_fd;         /* donor file descriptor */
        __u64 orig_start;       /* logical start offset in block for orig */
        __u64 donor_start;      /* logical start offset in block for donor */
        __u64 len;              /* block length to be moved */
        __u64 moved_len;        /* moved block length */
};

Lets just wire up EXT4_IOC_MOVE_EXT for the compat case.

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Reviewed-by: Eric Sandeen <sandeen@redhat.com>
CC: Akira Fujita <a-fujita@rs.jp.nec.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/ext4/ioctl.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -375,6 +375,8 @@ long ext4_compat_ioctl(struct file *file
 		break;
 	case EXT4_IOC_GROUP_ADD:
 		break;
+	case EXT4_IOC_MOVE_EXT:
+		break;
 	default:
 		return -ENOIOCTLCMD;
 	}


