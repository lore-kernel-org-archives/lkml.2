Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754050Ab2JNQUV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 12:20:21 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:50579 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752049Ab2JNQUU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 12:20:20 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Ravishankar N <cyberax82@gmail.com>,
        Amit Sahrawat <amit.sahrawat83@gmail.com>
Subject: Re: [PATCH v2] fat: editions to support fat_fallocate()
References: <1350138661-2454-1-git-send-email-linkinjeon@gmail.com>
Date: Mon, 15 Oct 2012 01:20:16 +0900
In-Reply-To: <1350138661-2454-1-git-send-email-linkinjeon@gmail.com> (Namjae
	Jeon's message of "Sat, 13 Oct 2012 23:31:01 +0900")
Message-ID: <87lif958lb.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.2.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Namjae Jeon <linkinjeon@gmail.com> writes:

> Implement preallocation via the fallocate syscall on VFAT partitions.
> This patch is based on an earlier patch of the same name which had some
> issues detailed below and did not get accepted. Refer
> https://lkml.org/lkml/2007/12/22/130.
>
> a)The preallocated space was not persistent across remounts when the
> FALLOC_FL_KEEP_SIZE flag was set. Also, writes to the file allocated new
> clusters instead of using the preallocated area.
>
> Consider the scenario:
> mount-->preallocate space for a file --> unmount.
> In the old patch,the preallocated space was not reflected for that
> file (verified using the 'du' command).
>
> This is now fixed with modifications to fat_fill_inode().

What is real usage pattern of persistent across remounts on FAT? If once
device was unmounted, we can't know the state of FS anymore, there are
many implementations of FAT. And preallocation is not in the spec.

I worry to break something. And I guess the freeing preallocation on
last close may fix the issue for usage.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
