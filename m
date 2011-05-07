Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755554Ab1EGPhv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 May 2011 11:37:51 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:53725 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755272Ab1EGPht (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 May 2011 11:37:49 -0400
X-Nat-Received: from [202.181.97.72]:62114 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1304782658.29789
To: akpm@linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        john.stultz@linaro.org
Subject: Re: [PATCH 1/1] coredump: use task comm instead of (unknown)
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <20110505150601.a4457970.akpm@linux-foundation.org>
	<201105062126.DIE34311.OJHtFMFFSQLVOO@I-love.SAKURA.ne.jp>
	<20110506123328.d0a707b7.akpm@linux-foundation.org>
	<201105071114.CJH64556.FOOVFHOQJSFLtM@I-love.SAKURA.ne.jp>
	<20110506202826.68850d88.akpm@linux-foundation.org>
In-Reply-To: <20110506202826.68850d88.akpm@linux-foundation.org>
Message-Id: <201105080037.GFD90166.HFMQVLOSFOtFJO@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Sun, 8 May 2011 00:37:34 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.44/RELEASE, bases: 07052011 #5385913, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> PR_SET_NAME uses set_task_comm() which has appropriate locking to
> protect against get_task_comm().  
> 
> If kernel code directly accesses task->comm without taking task_lock()
> then yes, it's racy.

I see. Well,

  grep -r -- '->comm[,;)]' .

in 2.6.39-rc6 shows so many users directly reading/updating, including

	case 'e':
		err = cn_printf(cn, "%s", current->comm);
		break;

in format_corename().

> Hopefully John Stultz will soon be presenting us with a %p modifier for
> displaying task_struct.comm.

That will be nice. But caller might by error call printk() with that modifier
between task_lock() and task_unlock().
