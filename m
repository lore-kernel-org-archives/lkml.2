Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753308Ab0DLAhm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Apr 2010 20:37:42 -0400
Received: from borg.medozas.de ([188.40.89.202]:46805 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753204Ab0DLAhk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Apr 2010 20:37:40 -0400
Date: Mon, 12 Apr 2010 02:37:35 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: Alan Cox <alan@redhat.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: pts_unix98_lookup returns -EIO dependent on path
Message-ID: <alpine.LSU.2.01.1004120227390.23484@obet.zrqbmnf.qr>
User-Agent: Alpine 2.01 (LSU 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


for reason not ultimately known to me, opening a pts node outside of
/dev/pts makes drivers/char/pty.c:pts_unix98_lookup return -EIO on 2.6.33.
The next ancestral commit which looks related to this is possibly 
99f1fe18.

In the following screenlog, /dev is a tmpfs, and /dev/pts is devpts. 
Whether CONFIG_DEVPTS_MULTIPLE_INSTANCES is set or not seems to play no 
role (the master instance is used only anyway).

02:30 yaguchi:/dev/pts # ls -l
total 0
drwxr-xr-x  2 root root    0 Apr 12  2010 .
drwxr-xr-x 16 root root 3720 Apr 12 01:55 ..

02:30 yaguchi:/dev/pts # socat pty pty &
[1] 7302

02:30 yaguchi:/dev/pts # ls -l
total 0
drwxr-xr-x  2 root root      0 Apr 12  2010 .
drwxr-xr-x 16 root root   3720 Apr 12 01:55 ..
crw--w----  1 root tty  136, 0 Apr 12 02:30 0
crw--w----  1 root tty  136, 1 Apr 12 02:30 1

02:30 yaguchi:/dev/pts # echo hi >0
02:30 yaguchi:/dev/pts # cp -a 0 ../0
02:30 yaguchi:/dev/pts # echo hi >../0
bash: ../0: Input/output error
02:30 yaguchi:/dev/pts # ls -l ../0
crw--w---- 1 root tty 136, 0 Apr 12 02:30 ../0


Jan
