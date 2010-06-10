Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752260Ab0FJGnf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 02:43:35 -0400
Received: from www17.your-server.de ([213.133.104.17]:55730 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751712Ab0FJGne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 02:43:34 -0400
Subject: Re: [PATCH 0/8] floppy: cleanup patches
From: Thomas Meyer <thomas@m3y3r.de>
To: Stephen Hemminger <shemminger@vyatta.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20100609183449.110905403@vyatta.com>
References: <20100609183449.110905403@vyatta.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 10 Jun 2010 08:43:32 +0200
Message-ID: <1276152212.13438.4.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 (2.30.1.2-8.fc13) 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, den 09.06.2010, 11:34 -0700 schrieb Stephen Hemminger:
> When going through floppy driver addressing some of the timing
> bugs, I also saw these leftover things that ought to be cleaned up.
> 

With your patches applied on top of 2.6.34 I still get this timeout
while resuming from ram:

[ 1086.971283] ata2.00: configured for UDMA/133
[ 1089.986024] 
[ 1089.986026] floppy driver state
[ 1089.986026] -------------------
[ 1089.986032] now=4295757282 last interrupt=4295281727 diff=475555 last called handler=main_command_interrupt
[ 1089.986033] timeout_message=lock fdc
[ 1089.986034] last output bytes:
[ 1089.986035]  2 90 4295192821
[ 1089.986036]  1 90 4295192821
[ 1089.986037]  d 90 4295192821
[ 1089.986038]  2 90 4295192821
[ 1089.986039]  e 90 4295192821
[ 1089.986040] 1b 90 4295192821
[ 1089.986041] ff 90 4295192821
[ 1089.986042]  f 80 4295281121
[ 1089.986043]  0 90 4295281121
[ 1089.986044]  0 91 4295281121
[ 1089.986045]  8 81 4295281129
[ 1089.986046] 45 80 4295281499
[ 1089.986047]  0 90 4295281499
[ 1089.986048]  0 90 4295281499
[ 1089.986049]  0 90 4295281499
[ 1089.986050]  3 90 4295281499
[ 1089.986051]  2 90 4295281499
[ 1089.986052]  4 90 4295281499
[ 1089.986053] 1b 90 4295281499
[ 1089.986054] ff 90 4295281499
[ 1089.986055] last result at 4295281741
[ 1089.986056] last redo_fd_request at 4295281741
[ 1089.986060] status=a
[ 1089.986061] fdc_busy=1
[ 1089.986063] do_floppy=reset_interrupt
[ 1089.986064] cont=ffffffffa0009ae0
[ 1089.986065] current_req=(null)
[ 1089.986066] command_status=-1
[ 1089.986067] 
[ 1089.986069] floppy0: floppy timeout called
[ 1089.986094] PM: resume of devices complete after 10536.229 msecs
[ 1089.986319] PM: resume devices took 10.537 seconds
[ 1089.986320] ------------[ cut here ]------------
[ 1089.986325] WARNING: at kernel/power/suspend_test.c:53 suspend_devices_and_enter+0xd2/0x220()
[ 1089.986326] Hardware name: MS-7250
[ 1089.986327] Component: resume devices, time: 10537
[ 1089.986328] Modules linked in: rndis_wlan olympic forcedeth floppy [last unloaded: scsi_wait_scan]
[ 1089.986333] Pid: 15510, comm: pm-suspend Not tainted 2.6.34 #1
[ 1089.986334] Call Trace:
[ 1089.986340]  [<ffffffff81063283>] ? warn_slowpath_common+0x73/0xb0
[ 1089.986343]  [<ffffffff81063320>] ? warn_slowpath_fmt+0x40/0x50
[ 1089.986345]  [<ffffffff81095132>] ? suspend_devices_and_enter+0xd2/0x220
[ 1089.986348]  [<ffffffff810953a8>] ? enter_state+0x128/0x150
[ 1089.986350]  [<ffffffff810949cd>] ? state_store+0x8d/0xf0
[ 1089.986353]  [<ffffffff81165215>] ? sysfs_write_file+0xd5/0x160
[ 1089.986356]  [<ffffffff811029e8>] ? vfs_write+0xb8/0x1a0
[ 1089.986360]  [<ffffffff810aff51>] ? audit_syscall_entry+0x1c1/0x1f0
[ 1089.986362]  [<ffffffff811032ce>] ? sys_write+0x4e/0x90
[ 1089.986365]  [<ffffffff81027e6b>] ? system_call_fastpath+0x16/0x1b
[ 1089.986367] ---[ end trace 210bc7fac7be9fbd ]---
[ 1089.986432] PM: Finishing wakeup.
[ 1089.986433] Restarting tasks ... 

Is this okay?


