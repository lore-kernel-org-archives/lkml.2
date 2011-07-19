Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751242Ab1GSRyG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 13:54:06 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:64334 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903Ab1GSRyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 13:54:05 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Vegard Nossum <vegard.nossum@gmail.com>
Subject: Re: WARNING: at drivers/tty/tty_ldisc.c:766 tty_ldisc_reinit+0x7d/0x90()
Date: Tue, 19 Jul 2011 19:53:12 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc1nosema+; KDE/4.6.3; x86_64; ; )
Cc: Jiri Slaby <jirislaby@gmail.com>, LKML <linux-kernel@vger.kernel.org>
References: <CAOMGZ=HS2EPkYD=5HfkSPpwPqHB5V3q0vaFmoZ8Hh+pMM9phrQ@mail.gmail.com>
In-Reply-To: <CAOMGZ=HS2EPkYD=5HfkSPpwPqHB5V3q0vaFmoZ8Hh+pMM9phrQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201107191953.12923.arnd@arndb.de>
X-Provags-ID: V02:K0:s/j4bZssiXQ233jDMXE1eSwyhP111fOMh2hPQ5qXN74
 4NxWA/N9I4epVioJsAhU42MVgowql6pxoGPDwGKy3yhVuR370Q
 2aas3RA5s0DAKhILOLh+eErE9NxxFvqC4LwvY57D95rGeUc3ny
 ltQQGvkuN1tJ6vfdG6c/Dd/SheiVx9h2arZKWbjE0chEyWIr1y
 QjYUDPbtFrSCXluJ3St0A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 19 July 2011 13:33:36 Vegard Nossum wrote:

> [   74.930391]  [<c15e9879>] ? printk+0x18/0x1a
> [   74.931650]  [<c103e128>] warn_slowpath_common+0x68/0xa0
> [   74.933367]  [<c128515d>] ? tty_ldisc_reinit+0x7d/0x90
> [   74.934907]  [<c128515d>] ? tty_ldisc_reinit+0x7d/0x90
> [   74.936242]  [<c103e1fd>] warn_slowpath_null+0x1d/0x20
> [   74.937584]  [<c128515d>] tty_ldisc_reinit+0x7d/0x90
> [   74.939152]  [<c128577f>] tty_ldisc_hangup+0xdf/0x200
> [   74.968743]  [<c127e4f5>] __tty_hangup+0xe5/0x360
> [   74.970158]  [<c127ff3c>] disassociate_ctty+0x6c/0x200
> [   74.971526]  [<c104198b>] do_exit+0x55b/0x7d0
> [   74.972745]  [<c127dd20>] ? tty_write_lock+0x50/0x50
> [   74.974052]  [<c1041c79>] do_group_exit+0x39/0xa0
> [   74.975338]  [<c1041cf3>] sys_exit_group+0x13/0x20
> [   74.976658]  [<c15ec85c>] sysenter_do_call+0x12/0x2c
> [   74.977938]  [<c15e0000>] ? pci_fixup_i450gx+0x40/0x53
> [   74.979462] ---[ end trace c3cfae8b1239077b ]---
> 
> This is inside qemu/kvm with usb pass-through: -usbdevice host:9ac4:4b8f
> 
> Any ideas?

This is the WARN_ON that Jiri added in 92f6fa09b "TTY: ldisc, do not close
until there are readers".

Is the login process that triggered this running on the USB device you pass
through, or do you have vga or serial console?

	Arnd
