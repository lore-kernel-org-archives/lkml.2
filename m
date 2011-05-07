Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754679Ab1EGCO1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 22:14:27 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:65343 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754102Ab1EGCO0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 22:14:26 -0400
X-Nat-Received: from [202.181.97.72]:65384 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1304734458.22347
To: akpm@linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        john.stultz@linaro.org
Subject: Re: [PATCH 1/1] coredump: use task comm instead of (unknown)
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <4DC0FFAB.1000805@gmail.com>
	<1304494354-21487-1-git-send-email-jslaby@suse.cz>
	<20110505150601.a4457970.akpm@linux-foundation.org>
	<201105062126.DIE34311.OJHtFMFFSQLVOO@I-love.SAKURA.ne.jp>
	<20110506123328.d0a707b7.akpm@linux-foundation.org>
In-Reply-To: <20110506123328.d0a707b7.akpm@linux-foundation.org>
Message-Id: <201105071114.CJH64556.FOOVFHOQJSFLtM@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Sat, 7 May 2011 11:14:14 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.44/RELEASE, bases: 06052011 #5384387, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> > char *strncpy(char *dest, const char *src, size_t n)
> > {
> > 	size_t len = __strnend(src, n) - src;

If src was overwritten by prctl(PR_SET_NAME) at this moment (i.e. after len was
calculated),

> > 	__builtin_memset(dest + len, 0, n - len);
> > 	__builtin_memcpy(dest, src, len);

won't this result in inconsistent copying of src when length of src has changed
by prctl(PR_SET_NAME)?

> > 	return dest;
> > }

This strncpy() assumes that length of src won't change within the function.
I thought prctl(PR_SET_NAME) might break such assumption.
