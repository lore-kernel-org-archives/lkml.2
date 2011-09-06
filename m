Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754102Ab1IFI4h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 04:56:37 -0400
Received: from www17.your-server.de ([213.133.104.17]:37823 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754069Ab1IFI4Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 04:56:24 -0400
Subject: binfmt_misc: hangs in syscall with x86 userland on x86_64 kernel
From: Thomas Meyer <thomas@m3y3r.de>
To: viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org
Date: Tue, 06 Sep 2011 10:55:19 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.2 (3.0.2-3.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1315299323.7365.10.camel@localhost.localdomain>
Mime-Version: 1.0
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hello,

something in the binfmt_misc filesystem system seems to be broken when
trying to use this driver with an x86 user land on an x86_64 kernel.

the command "ls /proc/sys/fs/binfmt_misc" seems to hang in the stat64
syscall:

> stat64("/proc/sys/fs/binfmt_misc", 0x8bf68e8) = -1 EINTR (Interrupted system call)
> --- {si_signo=SIGINT, si_code=SI_KERNEL, si_value={int=1248448068, ptr=0x4a69ce44}} (Interrupt) ---
> +++ killed by SIGINT +++

I had to remove the systemd-binfmt register service from my default
runlevel to get to a shell/X11.

any ideas what's going on here?

the program "systemd-binfmt" seems to hang in this open() syscall:

> open("/proc/sys/fs/binfmt_misc/status", O_WRONLY|O_CREAT|O_TRUNC|O_LARGEFILE|O_CLOEXEC, 0666) = -1 EINTR (Interrupted system call)
> --- {si_signo=SIGINT, si_code=SI_KERNEL, si_value={int=1248448068, ptr=0x4a69ce44}} (Interrupt) ---
> +++ killed by SIGINT +++

with kind regards
thomas

