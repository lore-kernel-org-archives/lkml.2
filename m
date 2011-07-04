Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755085Ab1GDLwm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 07:52:42 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:54239 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751473Ab1GDLwl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 07:52:41 -0400
X-Nat-Received: from [202.181.97.72]:49329 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1309780317.2702
To: richard@nod.at
Cc: viro@zeniv.linux.org.uk, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH][Resend v2] Fix infinite loop in search_binary_handler()
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <1309779003-8668-1-git-send-email-richard@nod.at>
In-Reply-To: <1309779003-8668-1-git-send-email-richard@nod.at>
Message-Id: <201107042051.HEB57830.OJFtMLFSOHFVQO@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Mon, 4 Jul 2011 20:51:55 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.44/RELEASE, bases: 04072011 #5726947, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Richard Weinberger wrote:
> Running a x86_64 kernel without ia32 emulation and a x86 user land
> triggers this issue.

Executing /sbin/modprobe for x86_32 on an x86_64 kernel without x86_32 support?

Anyway, request_module() calls __request_module() but
__request_module() stops at MAX_KMOD_CONCURRENT levels of nesting.
So, I think "infinite loop" cannot happen.
