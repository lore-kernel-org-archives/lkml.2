Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933283Ab0FQUPg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 16:15:36 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:61417 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933058Ab0FQUPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 16:15:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=Gr28YDhpzb+26lWl9+pJ7T2K83xNhg+uT+cxKm6kaPcOpdsxsRWvqXsfe6knd4yAHQ
         1ZLg79M2EdFRZphsiSU9jzRMBhUhEXiPLo9QKVWugMm5IIVsVjY3twcOnXCtQl9OzU81
         F5SxPHXhwGWQL9kYgfrZs+ZO49ehOpCSHKNyY=
MIME-Version: 1.0
In-Reply-To: <201006172140.46203.arnd@arndb.de>
References: <1273957196-13768-1-git-send-email-arnd@arndb.de>
	<20100517144130.1d8aa313@lxorguk.ukuu.org.uk>
	<AANLkTimO08zZV4DenxT0wi3eWp1BngGu14x0GWRyfgO5@mail.gmail.com>
	<201006172140.46203.arnd@arndb.de>
Date: Thu, 17 Jun 2010 13:15:32 -0700
X-Google-Sender-Auth: Itto6P5lp8LeR8uWvr7ahEM9ouI
Message-ID: <AANLkTinGJJJ4vWvDGCqSPpMnYyE5WKALVmBUAJ_72y-G@mail.gmail.com>
Subject: Re: [PATCH v3 00/10] BKL conversion in tty layer
From: Tony Luck <tony.luck@intel.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Greg KH <gregkh@suse.de>, Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       John Kacur <jkacur@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
       Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Does the patch below make this go away? We should probably include
> the 'misc' branch of my BKL repository in -next to fix this.

That fixes a couple of instances (the tty_open() cases).  I still have:

WARNING: at include/linux/tty.h:589 tty_release+0x90/0xbc0()
WARNING: at include/linux/tty.h:589 tty_release+0x630/0xbc0()
WARNING: at include/linux/tty.h:589 tty_release+0x90/0xbc0()
WARNING: at include/linux/tty.h:589 tty_release+0x630/0xbc0()
WARNING: at include/linux/tty.h:589 tty_release+0x90/0xbc0()
WARNING: at include/linux/tty.h:589 tty_release+0x630/0xbc0()

Stack traces for these all look the same:

Call Trace:
 [<a000000100015990>] show_stack+0x50/0xa0
 [<a00000010090f1f0>] dump_stack+0x30/0x50
 [<a00000010008e280>] warn_slowpath_common+0xc0/0x120
 [<a00000010008e320>] warn_slowpath_null+0x40/0x60
 [<a00000010053d910>] tty_release+0x90/0xbc0
 [<a0000001001ab200>] __fput+0x260/0x420
 [<a0000001001ab400>] fput+0x40/0x60
 [<a00000010053b3b0>] tty_vhangup_locked+0x870/0x8a0
 [<a00000010054f3f0>] pty_close+0x350/0x3a0
 [<a00000010053ddd0>] tty_release+0x550/0xbc0
 [<a0000001001ab200>] __fput+0x260/0x420
 [<a0000001001ab400>] fput+0x40/0x60
 [<a0000001001a4dc0>] filp_close+0x120/0x140
 [<a0000001001a4f90>] sys_close+0x1b0/0x2c0
 [<a00000010000b940>] ia64_ret_from_syscall+0x0/0x20

-Tony
