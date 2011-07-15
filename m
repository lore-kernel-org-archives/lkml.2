Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751337Ab1GOLFi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 07:05:38 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:36594 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750705Ab1GOLFg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 07:05:36 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Cc: Erez Zadok <ezk@fsl.cs.sunysb.edu>,
        Andrew Morton <akpm@linux-foundation.org>,
        "viro\@ZenIV.linux.org.uk Viro" <viro@ZenIV.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        apw@canonical.com, nbd@openwrt.org, neilb@suse.de, hramrach@centrum.cz,
        jordipujolp@gmail.com
Subject: Re: [PATCH 0/7] overlay filesystem: request for inclusion
References: <1306932380-10280-1-git-send-email-miklos@szeredi.hu>
	<4540f7aa16724111bd792a1d577261c2@HUBCAS1.cs.stonybrook.edu>
	<954F11FF-339B-48E2-8358-A158DE1E53BC@fsl.cs.sunysb.edu>
	<12728.1308237302@jrobl> <87hb7piwrl.fsf@tucsk.pomaz.szeredi.hu>
	<877h7s3kfp.fsf@tucsk.pomaz.szeredi.hu> <8523.1310213890@jrobl>
Date: Fri, 15 Jul 2011 12:59:20 +0200
In-Reply-To: <8523.1310213890@jrobl> (J. R. Okajima's message of "Sat, 09 Jul
	2011 21:18:10 +0900")
Message-ID: <87oc0vdd2v.fsf@tucsk.pomaz.szeredi.hu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"J. R. Okajima" <hooanon05@yahoo.co.jp> writes:

> Miklos Szeredi:
>> Here's a patch to limit stacking overlayfs instances on top of each
>> other and on ecryptfs to prevent kernel stack overflow.
>
> I don't think it a good idea to introduce such new member to generic
> struct super_block.
> - the new member is unrelated to most of other fs.
> - ecryptfs already rejects such nests by checking
>   (sb->s_type == &ecryptfs_fs_type).
> Instead I'd suggest you to introduce a new small test function,
> something like
> int test_nested(sb)
> {
> 	return sb->s_magic == ECRYPTFS_SUPER_MAGIC
> 		|| sb->s_type == &ovl_fs_type;
> }

I don't want to prevent stacking completely, only limit it.  And the
only sane way to do that is with a counter in super_block.

Thanks,
Miklos
