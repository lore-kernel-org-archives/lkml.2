Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933999Ab2AKVtZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 16:49:25 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:34878 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933502Ab2AKVtX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 16:49:23 -0500
Date: Wed, 11 Jan 2012 13:49:19 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Xiaotian Feng <xtfeng@gmail.com>
cc: linux-kernel@vger.kernel.org, Xiaotian Feng <dannyfeng@tencent.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Stephen Wilson <wilsons@start.ca>
Subject: Re: [PATCH] proc: fix null pointer deref in proc_pid_permission()
In-Reply-To: <1326307625-11561-1-git-send-email-xtfeng@gmail.com>
Message-ID: <alpine.DEB.2.00.1201111348380.21755@chino.kir.corp.google.com>
References: <1326307625-11561-1-git-send-email-xtfeng@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Jan 2012, Xiaotian Feng wrote:

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
> 
> Signed-off-by: Xiaotian Feng <dannyfeng@tencent.com>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Vasiliy Kulikov <segoon@openwall.com>
> Cc: Stephen Wilson <wilsons@start.ca>
> Cc: David Rientjes <rientjes@google.com>

Acked-by: David Rientjes <rientjes@google.com>

You're right to use -ESRCH so it matches the same behavior as the 
remainder of /proc/pid when get_proc_task() returns NULL.
