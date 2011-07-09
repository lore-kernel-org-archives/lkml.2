Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753543Ab1GIMSS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jul 2011 08:18:18 -0400
Received: from mail01-md.ns.itscom.net ([175.177.155.111]:56340 "EHLO
	mail01-md.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753348Ab1GIMSQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jul 2011 08:18:16 -0400
From: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Subject: Re: [PATCH 0/7] overlay filesystem: request for inclusion
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Erez Zadok <ezk@fsl.cs.sunysb.edu>,
        Andrew Morton <akpm@linux-foundation.org>,
        "viro\@ZenIV.linux.org.uk Viro" <viro@ZenIV.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        apw@canonical.com, nbd@openwrt.org, neilb@suse.de, hramrach@centrum.cz,
        jordipujolp@gmail.com
In-Reply-To: <877h7s3kfp.fsf@tucsk.pomaz.szeredi.hu>
References: <1306932380-10280-1-git-send-email-miklos@szeredi.hu> <4540f7aa16724111bd792a1d577261c2@HUBCAS1.cs.stonybrook.edu> <954F11FF-339B-48E2-8358-A158DE1E53BC@fsl.cs.sunysb.edu> <12728.1308237302@jrobl> <87hb7piwrl.fsf@tucsk.pomaz.szeredi.hu> <877h7s3kfp.fsf@tucsk.pomaz.szeredi.hu>
Date: Sat, 09 Jul 2011 21:18:10 +0900
Message-ID: <8523.1310213890@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Miklos Szeredi:
> Here's a patch to limit stacking overlayfs instances on top of each
> other and on ecryptfs to prevent kernel stack overflow.

I don't think it a good idea to introduce such new member to generic
struct super_block.
- the new member is unrelated to most of other fs.
- ecryptfs already rejects such nests by checking
  (sb->s_type == &ecryptfs_fs_type).
Instead I'd suggest you to introduce a new small test function,
something like
int test_nested(sb)
{
	return sb->s_magic == ECRYPTFS_SUPER_MAGIC
		|| sb->s_type == &ovl_fs_type;
}
Of course "#ifdef CONFIG_ECRYPT_FS" or something should be added too.

If overlayfs had its own SUPER_MAGIC number, it might be better to test it
instead of s_type. But there is no such magic number currently, and I am
afraid intoducing it may affect stat/statfs for overlayfs which you
might dislike.


J. R. Okajima
