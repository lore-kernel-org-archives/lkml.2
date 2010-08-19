Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753537Ab0HSOii (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 10:38:38 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:58816 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752041Ab0HSOif (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 10:38:35 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Namhyung Kim <namhyung@gmail.com>
Subject: Re: [PATCH 0/4] initramfs: remove sparse warnings
Date: Thu, 19 Aug 2010 16:38:23 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-8-generic; KDE/4.3.2; x86_64; ; )
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
References: <1282189064-3904-1-git-send-email-namhyung@gmail.com>
In-Reply-To: <1282189064-3904-1-git-send-email-namhyung@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201008191638.23248.arnd@arndb.de>
X-Provags-ID: V02:K0:r+2shXYBGzhw1B5qug/Cx7JTQqAkwPQ0H2GqeK5nvRO
 nvRZDqYxJXqq2wxJ6RkbiVDjlm4YauC4kGdCkM4u8CTTl1RCAk
 SoP/Gn8OjEoY7t9xGgs8MFsad3f4N5gMj6fHocCzEIWJhjhZqK
 Bn5F4jfnwkAzVfX33iVCFSgcwJY4AmqnZIQb3TUpMo/apVnXQu
 tIM4/tMSG553nrbsan1oA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 19 August 2010, Namhyung Kim wrote:
> This patchset removes most of sparse warnings in init/initramfs.c.
> Current implementation of initramfs relies on syscall service rountins heavily
> so it requires many of arguments to be __user address space pointers but, in
> most cases, were missing proper markups. This patchset tries to fix those at
> a minimum change.

I'm skeptical about this, you are adding obviously incorrect annotations
to the code to make something work that was written without the awareness
for address spaces.

A better way would be to call path_lookup or kern_path to look up the
path and pass that to a lower-level file I/O function.

	Arnd
