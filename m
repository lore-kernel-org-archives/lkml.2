Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760687Ab0FQTNy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 15:13:54 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:40635 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757417Ab0FQTNx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 15:13:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=msUD1hpN3SHMWqtO43GZtfnX3de73VzttuIom9FKjvyu+bZTCXlg6LWzbGiUO4CvmZ
         aW7GIvgshUzOFUXcYZYuh4HloSVWh5dPAHoDeLua/K2ed7DhK/B6FIFCV7pFnFTibCjV
         6fMWA5njpFCZ/VxKKoBc/2wXvr+uWAfUsgqPg=
MIME-Version: 1.0
In-Reply-To: <20100517144130.1d8aa313@lxorguk.ukuu.org.uk>
References: <1273957196-13768-1-git-send-email-arnd@arndb.de>
	<20100517144130.1d8aa313@lxorguk.ukuu.org.uk>
Date: Thu, 17 Jun 2010 12:13:52 -0700
X-Google-Sender-Auth: g5d1VTxjwTp2Np_lLFxZSVFfVP4
Message-ID: <AANLkTimO08zZV4DenxT0wi3eWp1BngGu14x0GWRyfgO5@mail.gmail.com>
Subject: Re: [PATCH v3 00/10] BKL conversion in tty layer
From: Tony Luck <tony.luck@intel.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
       Greg KH <gregkh@suse.de>, Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       John Kacur <jkacur@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
       Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 17, 2010 at 6:41 AM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> At this point I think the only way to make further progress is to
> actually push this stuff into the kernel on top of the BKL removal
> patches for the drivers and see what happens. Something will no doubt
> break but we can try and nail them in time or if not revert the series
> and try again next kernel.

These changes showed up in linux-next (tag: next-20100617) ... and I'm seeing
a few WARN_ON messages on ia64 while booting:

WARNING: at include/linux/tty.h:589 tty_open+0x160/0xc60()
WARNING: at include/linux/tty.h:589 tty_open+0x9d0/0xc60()
WARNING: at include/linux/tty.h:589 tty_release+0x90/0xbc0()
WARNING: at include/linux/tty.h:589 tty_release+0x630/0xbc0()
WARNING: at include/linux/tty.h:589 tty_release+0x90/0xbc0()
WARNING: at include/linux/tty.h:589 tty_release+0x630/0xbc0()
WARNING: at include/linux/tty.h:589 tty_release+0x90/0xbc0()
WARNING: at include/linux/tty.h:589 tty_release+0x630/0xbc0()

Stack trace for the first of these looks like:
Call Trace:
 [<a0000001000159d0>] show_stack+0x50/0xa0
 [<a00000010090f250>] dump_stack+0x30/0x50
 [<a00000010008e2c0>] warn_slowpath_common+0xc0/0x120
 [<a00000010008e360>] warn_slowpath_null+0x40/0x60
 [<a00000010053ebe0>] tty_open+0x160/0xc60
 [<a0000001001af9b0>] chrdev_open+0x310/0x360
 [<a0000001001a58b0>] __dentry_open+0x350/0x680
 [<a0000001001a5d80>] nameidata_to_filp+0x80/0xc0
 [<a0000001001bfee0>] finish_open+0x160/0x380
 [<a0000001001c0cc0>] do_last+0xbc0/0xce0
 [<a0000001001c5270>] do_filp_open+0x2f0/0xb40
 [<a0000001001a5290>] do_sys_open+0x90/0x200
 [<a0000001001a54d0>] sys_open+0x50/0x80
 [<a000000100b907e0>] kernel_init+0x340/0x420
 [<a000000100013c10>] kernel_thread_helper+0x30/0x60
 [<a00000010000a0c0>] start_kernel_thread+0x20/0x40

Does anyone see anything similar on other architectures?  Or is ia64 doing
something "special" here?

-Tony
