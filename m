Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754854Ab1K3HJa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 02:09:30 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:61324 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751457Ab1K3HJ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 02:09:27 -0500
X-Nat-Received: from [202.181.97.72]:51281 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1322636965.25901
Message-Id: <201111300709.pAU79PAs010669@www262.sakura.ne.jp>
Subject: Re: [RFC][PATCH] trimming includes from linux/security.h
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
To: viro@ZenIV.linux.org.uk
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Wed, 30 Nov 2011 16:09:25 +0900
References: <20111130065000.GT2203@ZenIV.linux.org.uk>
In-Reply-To: <20111130065000.GT2203@ZenIV.linux.org.uk>
Content-Type: text/plain; charset="ISO-2022-JP"
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.44/RELEASE, bases: 17102011 #5502725, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro wrote:
> 	linux/security.h pulls a lot of garbage; most of it can be avoided
> by several more struct ....; added in there,

Does it make sense to create a header file that contains only "struct ....;"
lines? A lot of "struct ....;" lines are used for avoiding compiler warning.
This results in LXR (linux cross reference) showing like

Defined as a struct type in:

    * security/selinux/include/avc.h, line 35
    * fs/udf/udfdecl.h, line 78
    * fs/isofs/isofs.h, line 108
    * fs/gfs2/bmap.h, line 15
    * fs/gfs2/dir.h, line 16
    * fs/xfs/xfs_acl.h, line 21
    * fs/xfs/xfs_vnodeops.h, line 7
    * fs/freevxfs/vxfs_extern.h, line 44
    * include/linux/net.h, line 67
    * include/linux/exportfs.h, line 7
    * include/linux/seq_file.h, line 13
    * include/linux/mm.h, line 245
    * include/linux/syscalls.h, line 16
    * include/linux/reiserfs_xattr.h, line 32
    * include/linux/xattr.h, line 64
    * include/linux/cgroup.h, line 24
    * include/linux/fs.h, line 749
    * include/linux/audit.h, line 375
    * include/linux/cdev.h, line 9
    * include/linux/cred.h, line 23
    * include/linux/mtd/blktrans.h, line 31
    * include/linux/generic_acl.h, line 6
    * include/linux/futex.h, line 127 

and makes it difficult to find the location of actual definition.
