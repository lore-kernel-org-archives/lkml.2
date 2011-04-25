Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758600Ab1DYMYX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 08:24:23 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:62745 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758526Ab1DYMYV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 08:24:21 -0400
X-Nat-Received: from [202.181.97.72]:51936 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1303734119.13689
To: penberg@kernel.org, bonbons@linux-vserver.org
Cc: vapier.adi@gmail.com, kosaki.motohiro@jp.fujitsu.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, catalin.marinas@arm.com,
        adobriyan@gmail.com, torvalds@linux-foundation.org,
        viro@zeniv.linux.org.uk
Subject: Re: 2.6.39-rc4+: Kernel leaking memory during FS scanning, regression?
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <BANLkTi=2DK+iq-5NEFKexe0QhpW8G0RL8Q@mail.gmail.com>
	<20110425123444.639aad34@neptune.home>
	<20110425134145.048f7cc1@neptune.home>
	<BANLkTikpt7E5eE9vv9NFbNAwT_O6sHnQvA@mail.gmail.com>
	<201104252114.HID65107.FOHOQFMVJtOSFL@I-love.SAKURA.ne.jp>
In-Reply-To: <201104252114.HID65107.FOHOQFMVJtOSFL@I-love.SAKURA.ne.jp>
Message-Id: <201104252121.GJI30713.FMOQLFOSVFtJOH@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Mon, 25 Apr 2011 21:21:51 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.44/RELEASE, bases: 25042011 #5336500, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tetsuo Handa wrote:
> proc_pid_make_inode() gets a ref on task, but return value of pid_revalidate()
> (one of 0, 1, -ECHILD) may not be what above 'if (pid_revalidate(dentry, NULL))'
> part expects. (-ECHILD is a new return value introduced by LOOKUP_RCU.)
Sorry, nd == NULL so never returns -ECHILD.
