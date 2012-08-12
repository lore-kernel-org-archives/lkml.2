Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752258Ab2HLN7W (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2012 09:59:22 -0400
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:62334 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751990Ab2HLN7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2012 09:59:21 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av4EAFG1J1B5LUgY/2dsb2JhbABEhgGzd4EIgkoEER47FwYCBSECEQIoMQYCAogIl2iOQZF8gSGJcYMVggqBEgOITI4TiBiGZIJv
Message-ID: <5027B6B2.70204@internode.on.net>
Date: Sun, 12 Aug 2012 23:29:14 +0930
From: Arthur Marsh <arthur.marsh@internode.on.net>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.6esrpre) Gecko/20120805 Icedove/10.0.6
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: fuse: implement i_op->atomic_open() prevents writes to ntfs-3g filesystem
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[repost, apologies if you see it twice]
I'm running Debian unstable on AMD64 (quad core) with Linus' github.com 
kernels.

Recently (post 3.5.0 kernels) writes to an ntfs-3g filesystem started 
failing, and I bisected back to the following:

# git bisect good
c8ccbe032feb127a977c66865cb63d72d9a6e08b is the first bad commit
commit c8ccbe032feb127a977c66865cb63d72d9a6e08b
Author: Miklos Szeredi <mszeredi@suse.cz>
Date:   Tue Jun 5 15:10:22 2012 +0200

     fuse: implement i_op->atomic_open()

     Add an ->atomic_open implementation which replaces the atomic 
open+create
     operation implemented via ->create.  No functionality is changed.

     Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
     Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

:040000 040000 7a000897ad0d1524a7e1cb187bc77d92b8397d56 
38f02e55f70b009f8b1149cdd75f571c72406fe4 M      fs

Has this problem been seen by anyone else?

Is a fix already in the works?

Regards,

Arthur.
