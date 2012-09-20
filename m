Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754989Ab2ITM2b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 08:28:31 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:40888 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753576Ab2ITM2a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 08:28:30 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: <linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Serge Hallyn <serge@hallyn.com>,
        Linux Containers <containers@lists.linux-foundation.org>
Subject: Re: [PATCH 01/25] userns: Convert fat to use kuid/kgid where appropriate
References: <877grox6ql.fsf@xmission.com>
	<1348141326-23355-1-git-send-email-ebiederm@xmission.com>
	<87pq5gx60i.fsf@devron.myhome.or.jp> <87vcf8vr2l.fsf@xmission.com>
Date: Thu, 20 Sep 2012 21:28:26 +0900
In-Reply-To: <87vcf8vr2l.fsf@xmission.com> (Eric W. Biederman's message of
	"Thu, 20 Sep 2012 05:04:02 -0700")
Message-ID: <87ipb8x4id.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.2.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ebiederm@xmission.com (Eric W. Biederman) writes:

>> I'm not reading this thread, so I may be wrong though. Doesn't this need
>> to initialize opts->fs_uid/fs_gid by GLOBAL_ROOT_UID/GID?
>
> Good question.
>
> At the start of parse_options there is:
>
> static int parse_options(struct super_block *sb, char *options, int is_vfat,
> 			 int silent, int *debug, struct fat_mount_options *opts)
> {
> 	char *p;
> 	substring_t args[MAX_OPT_ARGS];
> 	int option;
> 	char *iocharset;
>
> 	opts->isvfat = is_vfat;
>
> 	opts->fs_uid = current_uid();
> 	opts->fs_gid = current_gid();
>
> So there should be no problems with initialization.

I see.

Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
