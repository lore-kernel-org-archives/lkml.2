Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752582Ab2IEO4k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 10:56:40 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:35745 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164Ab2IEO4j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 10:56:39 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, akpm@linux-foundation.org,
        bfields@fieldses.org, linux-kernel@vger.kernel.org,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Ravishankar N <ravi.n1@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: Re: [PATCH v2 1/5] fat: allocate persistent inode numbers
References: <1346774264-8031-1-git-send-email-linkinjeon@gmail.com>
	<20120904161747.GJ23464@ZenIV.linux.org.uk>
	<CAKYAXd_wTxqbC-UxYimCkZtvSddx=f3FG0hoiEY_doMjoxkKog@mail.gmail.com>
Date: Wed, 05 Sep 2012 23:56:34 +0900
In-Reply-To: <CAKYAXd_wTxqbC-UxYimCkZtvSddx=f3FG0hoiEY_doMjoxkKog@mail.gmail.com>
	(Namjae Jeon's message of "Wed, 5 Sep 2012 23:08:11 +0900")
Message-ID: <87harc34d9.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.2.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Namjae Jeon <linkinjeon@gmail.com> writes:

> In this long discusstion about the FAT acceptance over NFS, our belief
> is still that the objective should be to reduce errors as much as
> possible and then if there are certain scenarios - at least that could
> be highlighted as a limitation in Documentation instead of completely
> discarding the usage of FAT over NFS.  So how about puttting rename
> scenario as a limitation ? In ideal scenario how many times this is
> going to happen ?

My understanding of your patches is to introduce the silent corruption
bug by getting wrong location via ino on some cases, instead of
ESTALE. And make surprise to userland by change ino.

Why is it safe to change ino? If you are saying to remove the changing
ino on rename, how handle the case of collision?
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
