Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754428Ab0KCJkB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 05:40:01 -0400
Received: from isrv.corpit.ru ([86.62.121.231]:57610 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754112Ab0KCJj7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 05:39:59 -0400
Message-ID: <4CD12DED.3010902@msgid.tls.msk.ru>
Date: Wed, 03 Nov 2010 12:39:57 +0300
From: Michael Tokarev <mjt@tls.msk.ru>
User-Agent: Mozilla-Thunderbird 2.0.0.24 (X11/20100328)
MIME-Version: 1.0
To: Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: bind-mount vs second mount of the same blockdev?
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

I'm trying to understand the differences between
a bind-mount of a whole filesystem versus mounting
the same block device the second time.  Like this:

 mount -t ext3 /dev/block /mnt/a
 mount --bind /mnt/a /mnt/b

versus

 mount -t ext3 /dev/block /mnt/a
 mount -t ext3 /dev/block /mnt/b

In the second case, second mount does not happen
but the first one is "reused" instead - this is
visible in dmesg, since only once ext3fs prints
a note about the mounting.

Now, the first case is quite clear: we've one fs
visible in two places, pretty much like two hard-
links to the same file.  So things like, for
example, fcntl locking will work "from" both
ends.  But it is not that obvious in the second
case, even if we clearly have some common
"inode" in this case too.

What are the differences in behavour?

Thanks!

/mjt
