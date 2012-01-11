Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933939Ab2AKUoK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 15:44:10 -0500
Received: from smtp.outflux.net ([198.145.64.163]:52749 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933006Ab2AKUoH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 15:44:07 -0500
Date: Wed, 11 Jan 2012 12:43:30 -0800
From: Kees Cook <keescook@chromium.org>
To: Xiaotian Feng <xtfeng@gmail.com>
Cc: linux-kernel@vger.kernel.org, Xiaotian Feng <dannyfeng@tencent.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Stephen Wilson <wilsons@start.ca>,
        David Rientjes <rientjes@google.com>
Subject: Re: [PATCH] proc: fix null pointer deref in proc_pid_permission()
Message-ID: <20120111204330.GT2618@outflux.net>
References: <1326307625-11561-1-git-send-email-xtfeng@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1326307625-11561-1-git-send-email-xtfeng@gmail.com>
Organization: Chromium
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Jan 11, 2012 at 01:47:05PM -0500, Xiaotian Feng wrote:
> get_proc_task() can fail to search the task and return NULL, put_task_struct()
> will then bomb the kernel with following oops:
> 
> [ 1870.574045] BUG: unable to handle kernel NULL pointer dereference at 0000000000000010
> [ 1870.574065] IP: [<ffffffff81217d34>] proc_pid_permission+0x64/0xe0
> [ 1870.574088] PGD 112075067 PUD 112814067 PMD 0
> [ 1870.574106] Oops: 0002 [#1] PREEMPT SMP
> 
> This is a regression introduced by commit 0499680a, kernel should
> return -ESRCH if get_proc_task() failed.

Nice catch!

However since this error is returned to userspace, shouldn't this be
-ENOENT instead?

-Kees

-- 
Kees Cook
ChromeOS Security
