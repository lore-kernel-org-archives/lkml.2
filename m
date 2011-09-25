Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752078Ab1IYLL4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Sep 2011 07:11:56 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:64218 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751967Ab1IYLLz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Sep 2011 07:11:55 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Thomas Meyer <thomas@m3y3r.de>
Cc: gregkh@suse.de, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Support compat_ioctl get/set termios_locked
Date: Sun, 25 Sep 2011 13:11:14 +0200
Message-ID: <2272244.eQGJoCfPBm@wuerfel>
User-Agent: KMail/4.7.1 (Linux/3.0.0-rc1nosema+; KDE/4.7.1; x86_64; ; )
In-Reply-To: <1316854289.1696.6.camel@localhost.localdomain>
References: <1316854289.1696.6.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:98O5Eiiu7UN5maYSueL3oMnnhCtoz71OAMixDgAKTTP
 bQRTO4QyLok+D4oM5xm6yHaakWr48J8AmRt90i6p4Q4lcglLOd
 SeDIej2FK+FeOjq62jEwzQgGe9HUu31h3jSOuElA3HTDBolPN0
 bBSUq8lgfBG6+RJWX2B+fVHtBDuYP9KY4b4C/9ZG5pVt6geWT6
 CTNyFEO5aFqdGAdOrBiOu7vWdgoANN4mF4NmCYKBTn1hYzEFfn
 Sm7CbFWy+S165yFDX6sYKI7ujvKjDUeD+3Lm9sgmdmUjhscdpM
 D4mv1hMu2DepnZD3v+NgAdKadI1rm0TF3AhcvXmzYTiVYpiV5M
 KfMNI24J5UQQTYdaZvL4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 24 September 2011 10:51:24 Thomas Meyer wrote:
> When running a Fedora 15 (x86) on an x86_64 kernel, in the boot process
> plymouthd complains about those two missing ioctls:
> [    2.581783] ioctl32(plymouthd:186): Unknown cmd fd(10) cmd(00005457){t:'T';sz:0} arg(ffb6a5d0) on /dev/tty1
> [    2.581803] ioctl32(plymouthd:186): Unknown cmd fd(10) cmd(00005456){t:'T';sz:0} arg(ffb6a680) on /dev/tty1
> 
> both ioctl functions work on the 'struct termios', which has the same
> size (36 bytes) on x86 and x86_64, so it's just a matter of converting the
> pointer from userland.
> 
> Signed-off-by: Thomas Meyer <thomas@m3y3r.de>

Hi Thomas,

This looks ok for n_tty, but the same commands are supported for some
(all?) other tty line disciplines as well, and they remain broken
after your patch.

I think it would be better to handle this in the common tty_compat_ioctl()
function before calling into the line discipline's compat_ioctl function.

It would also be nice to move similar commands from fs/compat_ioctl.c into
the same place. The easiest solution would be to add the two missing command
in fs/compat_ioctl.c, but I would prefer getting stuff out of there instead.

	Arnd
