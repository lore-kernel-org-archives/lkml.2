Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756925Ab1GAOqh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 10:46:37 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:51059 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756621Ab1GAOqg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 10:46:36 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Johannes Stezenbach <js@sig21.net>
Subject: Re: [PATCH resend] compat_ioctl: fix warning caused by qemu
Date: Fri, 1 Jul 2011 16:46:28 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Kevin Wolf <kwolf@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>, Alexander Viro <viro@zeniv.linux.org.uk>
References: <20110701093336.GA9582@sig21.net>
In-Reply-To: <20110701093336.GA9582@sig21.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201107011646.28918.arnd@arndb.de>
X-Provags-ID: V02:K0:HuohgkClsj4p/Ys0QmMPu9AbNMCw8sou1bTqEIenO96
 g7EzDaFS1kEaggrhXHtOFGhkGa1KjrdF2TQF+zdQv0ifr0mTKO
 2KRZWI2MtgyBWJO7qLckycne0qSSjwSXYeoyO6VeWAVJEpz+mN
 Ul1RMfvmCR6d63Smhv/u1wS5GlJlrEGs5+OKeM5ink+Jp/5ye6
 H7FKuo3F3d7JEvD5Fyvmg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 01 July 2011, Johannes Stezenbach wrote:
> 
> On Linux x86_64 host with 32bit userspace, running
> qemu or even just "qemu-img create -f qcow2 some.img 1G"
> causes a kernel warning:
> 
> ioctl32(qemu-img:5296): Unknown cmd fd(3) cmd(00005326){t:'S';sz:0} arg(7fffffff) on some.img
> ioctl32(qemu-img:5296): Unknown cmd fd(3) cmd(801c0204){t:02;sz:28} arg(fff77350) on some.img
> 
> ioctl 00005326 is CDROM_DRIVE_STATUS,
> ioctl 801c0204 is FDGETPRM.
> 
> The warning appears because the Linux compat-ioctl handler for these
> ioctls only applies to block devices, while qemu also uses the ioctls on
> plain files.
> 
> Signed-off-by: Johannes Stezenbach <js@sig21.net>

Acked-by: Arnd Bergmann <arnd@arndb.de>

> ---
> (resend with Cc: suggested by get_maintainer.pl)
> 
> discussed in http://lkml.kernel.org/r/20110617090424.GA19345@sig21.net
> 
> Arnd, is this what you had in mind, or did you mean to move
> all floppy compat definitions?  I decided to go with the
> minimal change.  Tested on both 2.6.39.2 and 3.0-rc5-63-g0d72c6f.

Yes, that should be fine, unless Jens would like to see a different
solution for the struct definitions, e.g. moving all of the floppy
compat ioctl numbers to fd.h. I'm fine with it either way.

	Arnd
