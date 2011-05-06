Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756762Ab1EFTde (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 15:33:34 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50156 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750779Ab1EFTdd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 15:33:33 -0400
Date: Fri, 6 May 2011 12:33:28 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        John Stultz <john.stultz@linaro.org>
Subject: Re: [PATCH 1/1] coredump: use task comm instead of (unknown)
Message-Id: <20110506123328.d0a707b7.akpm@linux-foundation.org>
In-Reply-To: <201105062126.DIE34311.OJHtFMFFSQLVOO@I-love.SAKURA.ne.jp>
References: <4DC0FFAB.1000805@gmail.com>
	<1304494354-21487-1-git-send-email-jslaby@suse.cz>
	<20110505150601.a4457970.akpm@linux-foundation.org>
	<201105062126.DIE34311.OJHtFMFFSQLVOO@I-love.SAKURA.ne.jp>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Cc John)

On Fri, 6 May 2011 21:26:39 +0900
Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp> wrote:

> Andrew Morton wrote:
> > Direct access to current->comm is racy since we added
> > prctl(PR_SET_NAME).
> 
> A passer-by's question. Did we change below one
> 
> char *get_task_comm(char *buf, struct task_struct *tsk)
> {
> 	/* buf must be at least sizeof(tsk->comm) in size */
> 	task_lock(tsk);
> 	strncpy(buf, tsk->comm, sizeof(tsk->comm));
> 	task_unlock(tsk);
> 	return buf;
> }
> 
> since some archs may do like
> 
> char *strncpy(char *dest, const char *src, size_t n)
> {
> 	size_t len = __strnend(src, n) - src;
> 	__builtin_memset(dest + len, 0, n - len);
> 	__builtin_memcpy(dest, src, len);
> 	return dest;
> }
> 
> ( arch/s390/lib/string.c ) after adding prctl(PR_SET_NAME)?

I don't understand what you're asking, sorry.
