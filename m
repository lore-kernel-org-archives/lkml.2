Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755870Ab1CAVk1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 16:40:27 -0500
Received: from legolas.restena.lu ([158.64.1.34]:36254 "EHLO
	legolas.restena.lu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754185Ab1CAVk0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 16:40:26 -0500
Date: Tue, 1 Mar 2011 22:39:32 +0100
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: linux-kernel@vger.kernel.org
Cc: Alexey Dobriyan <adobriyan@gmail.com>, dmitry.torokhov@gmail.com
Subject: Re: 2.6.38-rc6: SysRq broken?
Message-ID: <20110301223932.609a4a59@neptune.home>
In-Reply-To: <20110228225003.2cb4f62d@neptune.home>
References: <20110228214054.GA18538@p183.telecom.by>
	<20110228225003.2cb4f62d@neptune.home>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.1; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 February 2011 Bruno Prémont <bonbons@linux-vserver.org> wrote:
> On Mon, 28 February 2011 Alexey Dobriyan <adobriyan@gmail.com> wrote:
> > It just strikes me that SysRq is broken here:
> > Alt+SysRq+h doesn't print anything
> > 
> > CONFIG_MAGIC_SYSRQ=y
> > CONFIG_INPUT_EVDEV=y
> > kernel.sysrq=1
> > echo h >/proc/sysrq-trigger works
> > 
> > Keyboard is USB one, "Logitech HID compliant keyboard".
> 
> I've seen same kind of issue with built-in keybaord (PS2) of my laptop.
> 
> Sysrq-Sync, Sysrq-Umount, Sysrq-Help didn't work but Sysrq-reBoot did.
> 
> In my case it was during "stuck" shutdown process, caps key was still
> working and toggled caps LED anything else didn't trigger anything visible.
> 
> Bruno

Well it worked (half way?) though fb was probably frozen (vt-deadlock?)
as I have traces in my log:

[14382.063476] pcmanfm[28117]: segfault at 8 ip b772e5b5 sp bfcfba30 error 4 in libfm-gtk.so.0.0.0[b7700000+34000]
[43437.896858] SysRq : Emergency Sync
[43572.221361] SysRq : Keyboard mode set to system default
[43575.574551] SysRq : Emergency Sync
[43590.513441] SysRq : Emergency Remount R/O
[43605.923769] SysRq : Emergency Sync
[43607.320324] SysRq : Emergency Remount R/O
[43627.329605] SysRq : HELP : loglevel(0-9) reBoot Crash terminate-all-tasks(E) memory-full-oom-kill(F) kill-all-tasks(I) 
thaw-filesystems(J) saK show-memory-usage(M) nice-all-RT-tasks(N) powerOff show-registers(P) show-all-timers(Q) unRaw Sync show-task-states(T) Unmount force-fb
(V) show-blocked-tasks(W) 
[43676.561306] SysRq : Emergency Sync
[43690.319213] SysRq : SAK
[43690.319245] SAK: killed process 1926 (Xorg): task_session(p)==tty->session
[43690.319313] SAK: killed process 1926 (Xorg): task_session(p)==tty->session
[43690.319345] SAK: killed process 2801 (rc): fd#0 opened to the tty
[43690.319358] SAK: killed process 2802 (rc): fd#0 opened to the tty
[43690.319368] SAK: killed process 2890 (ntpd): fd#0 opened to the tty
[43690.319378] SAK: killed process 2891 (runscript.sh): fd#0 opened to the tty
[43690.319387] SAK: killed process 2898 (start-stop-daem): fd#0 opened to the tty
[43694.809374] SysRq : Keyboard mode set to system default
[43797.368728] SysRq : SAK
[43797.368768] SAK: killed process 1926 (Xorg): task_session(p)==tty->session
[43797.368829] SAK: killed process 1926 (Xorg): task_session(p)==tty->session
[43797.368864] SAK: killed process 2898 (start-stop-daem): fd#0 opened to the tty

But then, "Emergency Remount R/O" should have prevented anything further
from hitting the disk. (and after sysrq-reboot filesystems were dirty)

Bruno
