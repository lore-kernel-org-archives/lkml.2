Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754162Ab0J3Xdq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 19:33:46 -0400
Received: from wine.ocn.ne.jp ([122.1.235.145]:55127 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753026Ab0J3Xdn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 19:33:43 -0400
To: paulmck@linux.vnet.ibm.com
Cc: sergey.senozhatsky@gmail.com, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, mingo@elte.hu
Subject: Re: [PATCH] rcu_read_lock/unlock protect find_task_by_vpid call
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <20101029125550.GA3932@swordfish.minsk.epam.com>
	<20101029201648.GK2367@linux.vnet.ibm.com>
	<20101030093234.GK3932@swordfish.minsk.epam.com>
	<201010302214.DDF98906.MSFJOFtFHOLQVO@I-love.SAKURA.ne.jp>
	<20101030210244.GE2664@linux.vnet.ibm.com>
In-Reply-To: <20101030210244.GE2664@linux.vnet.ibm.com>
Message-Id: <201010310833.CCE89052.FtQFHSOFLOOJMV@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Sun, 31 Oct 2010 08:33:35 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul E. McKenney wrote:
> So we should remove the lockdep_tasklist_lock_is_held() and then
> apply Sergey's patch, correct?

Yes. rcu_lockdep_assert(rcu_read_lock_held()) in find_task_by_pid_ns()
is correct and callers need to use rcu_read_lock().

As of 2.6.32, there are 20+ users who missed rcu_read_lock().
So, similar reports will be posted like popcorn.
http://kerneltrap.org/mailarchive/linux-kernel/2009/12/11/4518016
