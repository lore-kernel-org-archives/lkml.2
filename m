Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758911Ab1FQNC7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 09:02:59 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:59415 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758706Ab1FQNC6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 09:02:58 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Johannes Stezenbach <js@sig21.net>
Subject: Re: missing compat-ioctl for CDROM_DRIVE_STATUS + FDGETPRM
Date: Fri, 17 Jun 2011 15:02:39 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc1nosema+; KDE/4.6.3; x86_64; ; )
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20110617090424.GA19345@sig21.net>
In-Reply-To: <20110617090424.GA19345@sig21.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106171502.39445.arnd@arndb.de>
X-Provags-ID: V02:K0:bkM5cdhdCwof5cjXqzXg4wrohpM8yFueaiBW+p6PlaS
 uGc1w08+9PEPX5Sw7dLnE1QzOAVzSN0Rq7NayBU88iIlNzjRlq
 2S9hYxX6rzfx1T4tyx+ZDrc7fn76UrZfnXwHGBd8XYeqGSnvQK
 vrrvcGQkC2RKE6o6HgAgmK1NZHmTqYYGMy9sPKchsdH1QZDqbq
 BYeQjjEBOzebZk2maTUhQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 17 June 2011 11:04:24 Johannes Stezenbach wrote:
> running even a simple "qemu-img create -f qcow2 some.img 1G" causes
> the following in dmesg on a Linux host with linux-2.6.39.1 x86_64 kernel
> and 32bit userspace:
> 
> ioctl32(qemu-img:5296): Unknown cmd fd(3) cmd(00005326){t:'S';sz:0} arg(7fffffff) on some.img
> ioctl32(qemu-img:5296): Unknown cmd fd(3) cmd(801c0204){t:02;sz:28} arg(fff77350) on some.img
> 
> (The same happens when starting a qemu or kvm vm.)
> 
> ioctl 00005326 seems to be CDROM_DRIVE_STATUS,
> ioctl 801c0204 is FDGETPRM.  Both are used in
> qemu/block/raw-posix.c in cdrom_probe_device()
> and floppy_probe_device() respectively.
> 
> FWIW, I'm using qemu/kvm from Debian unstable
> (qemu-0.14.0+dfsg-5.1, qemu-kvm-0.14.1+dfsg-1)

Both are handled by the kernel for block devices, but not for regular
files. The messages may be annoying but they are harmless. We could
silence them either by checking if the file is actually a block device in
qemu-img, or by adding a nop handler to the kernel for regular files.

	Arnd
