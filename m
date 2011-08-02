Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753060Ab1HBXAc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 19:00:32 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:58115 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752427Ab1HBXA2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 19:00:28 -0400
Date: Wed, 3 Aug 2011 01:58:25 +0300
From: Dan Carpenter <error27@gmail.com>
To: David Rientjes <rientjes@google.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: openssh-server: sshd (<pid>): /proc/<pid>/oom_adj is deprecated,
 please use /proc/<pid>/oom_score_adj instead.
Message-ID: <20110802225825.GE3839@shale.localdomain>
References: <20110514102014.12739.91576.reportbug@eiffel4.mcfm>
 <20110801122537.GA9469@mwanda>
 <alpine.DEB.2.00.1108011206130.28986@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1108011206130.28986@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Debian testing and Fedora 14 (and 15) are still using an old version
of sshd so in 3.1, I get a popup in gnome that a "kernel crash has
been detected."  We made the warning about using old versions of sshd
print a stack trace in be8f684d73d "oom: make deprecated use of
oom_adj more verbose"

[   20.717978] ------------[ cut here ]------------
[   20.718003] WARNING: at fs/proc/base.c:1123 oom_adjust_write+0x286/0x2a0()
[   20.718011] Hardware name: N150P/N210P/N220P          
[   20.718020] sshd (2910): /proc/2910/oom_adj is deprecated, please use /proc/2910/oom_score_adj instead.
[   20.718029] Modules linked in: fuse brcmsmac(C) brcmutil(C) [last unloaded: scsi_wait_scan]
[   20.718052] Pid: 2910, comm: sshd Tainted: G         C  3.0.0+ #1
[   20.718059] Call Trace:
[   20.718076]  [<ffffffff81041f9a>] warn_slowpath_common+0x7a/0xb0
[   20.718090]  [<ffffffff81042071>] warn_slowpath_fmt+0x41/0x50
[   20.718104]  [<ffffffff8104d2d5>] ? ns_capable+0x25/0x50
[   20.718116]  [<ffffffff81292e45>] ? kstrtoint+0x15/0x40
[   20.718129]  [<ffffffff81171bf6>] oom_adjust_write+0x286/0x2a0
[   20.718145]  [<ffffffff8111514e>] vfs_write+0xae/0x180
[   20.718157]  [<ffffffff81115465>] sys_write+0x45/0x90
[   20.718172]  [<ffffffff816f143b>] system_call_fastpath+0x16/0x1b
[   20.718183] ---[ end trace b16d62b4b2b98e24 ]---

There was a warning there for a year, and the distributions have one
more year to upgrade to the newer software, so it's valid to apply
pressure now.

Could we do it in a way that made it more clear that the problem was
an old version of openssh-server and not the kernel?  The information
is there, but it's overwhelmed in stack trace spam.  Also the kernel
is tainted now because of sshd.  Maybe the message could include a
link to a wiki page that told people which version off sshd uses the
new proc file.

regards,
dan carpenter
