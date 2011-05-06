Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754597Ab1EFM0u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 08:26:50 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:63914 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752288Ab1EFM0t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 08:26:49 -0400
X-Nat-Received: from [202.181.97.72]:50698 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1304684803.26892
To: akpm@linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] coredump: use task comm instead of (unknown)
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <4DC0FFAB.1000805@gmail.com>
	<1304494354-21487-1-git-send-email-jslaby@suse.cz>
	<20110505150601.a4457970.akpm@linux-foundation.org>
In-Reply-To: <20110505150601.a4457970.akpm@linux-foundation.org>
Message-Id: <201105062126.DIE34311.OJHtFMFFSQLVOO@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Fri, 6 May 2011 21:26:39 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.44/RELEASE, bases: 06052011 #5383052, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> Direct access to current->comm is racy since we added
> prctl(PR_SET_NAME).

A passer-by's question. Did we change below one

char *get_task_comm(char *buf, struct task_struct *tsk)
{
	/* buf must be at least sizeof(tsk->comm) in size */
	task_lock(tsk);
	strncpy(buf, tsk->comm, sizeof(tsk->comm));
	task_unlock(tsk);
	return buf;
}

since some archs may do like

char *strncpy(char *dest, const char *src, size_t n)
{
	size_t len = __strnend(src, n) - src;
	__builtin_memset(dest + len, 0, n - len);
	__builtin_memcpy(dest, src, len);
	return dest;
}

( arch/s390/lib/string.c ) after adding prctl(PR_SET_NAME)?
