Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752524Ab2DNJuP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 05:50:15 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:48998 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011Ab2DNJuN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 05:50:13 -0400
X-Greylist: delayed 1953 seconds by postgrey-1.27 at vger.kernel.org; Sat, 14 Apr 2012 05:50:13 EDT
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Maling List <linux-kernel@vger.kernel.org>,
        Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Subject: Re: [PATCH v2 3/4] fat: mark superblock as dirty less often
References: <1334326795-2446-1-git-send-email-dedekind1@gmail.com>
	<1334326795-2446-4-git-send-email-dedekind1@gmail.com>
Date: Sat, 14 Apr 2012 18:17:32 +0900
In-Reply-To: <1334326795-2446-4-git-send-email-dedekind1@gmail.com> (Artem
	Bityutskiy's message of "Fri, 13 Apr 2012 17:19:54 +0300")
Message-ID: <87k41ihdub.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Artem Bityutskiy <dedekind1@gmail.com> writes:

> From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
>
> This patch is a preparation for further changes. It touches few functions
> in fatent.c and prevents them from marking the superblock as dirty
> unnecessarily often. Namely, instead of marking it as dirty in the internal
> tight loops - do it only once at the end of the functions. And instead of
> marking it as dirty while holding the FAT table lock, do it outside the lock.
>
> The reason for this patch is that marking the superblock as dirty will soon
> become a little bit heavier operation, so it is cleaner to do this only when it
> is necessary.

For it, please use local variable like,


{
       	int fsinfo_dirty = 0;

	while (1) {
        	change free_clusters
                fsinfo_dirty = 1;
        }

        if (fsinfo_dirty)
        	mark_fsinfo_dirty()
}

instead of dirty it always.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
