Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756132Ab1GEMCx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 08:02:53 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:62384 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755887Ab1GEMCv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 08:02:51 -0400
X-Nat-Received: from [202.181.97.72]:65127 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1309867356.7307
To: richard@nod.at
Cc: viro@zeniv.linux.org.uk, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH][Resend v2] Fix infinite loop in search_binary_handler()
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <1309779003-8668-1-git-send-email-richard@nod.at>
	<201107050017.30365.richard@nod.at>
	<201107050124.p651OExY025046@www262.sakura.ne.jp>
	<201107051155.18465.richard@nod.at>
In-Reply-To: <201107051155.18465.richard@nod.at>
Message-Id: <201107052102.BHE69234.OLQOVMJFOFFHSt@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Tue, 5 Jul 2011 21:02:34 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.44/RELEASE, bases: 05072011 #5599170, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Richard Weinberger wrote:
> But IMHO adding a new attribute to task_struct is a bit overkill.
> Why is your variant better than my strcmp() in fs/exec.c?

Say, there are multiple /sbin/modprobe

/sbin/modprobe
/var/chroot/sbin/modprobe

and only /var/chroot/sbin/modprobe needs request_module() whereas
/sbin/modprobe does not need request_module(). Why do we need to make
execl("/sbin/modprobe", "--help", NULL) from chroot("/var/chroot/") fail
by denying request_module() that does not cause recursion?
