Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753966Ab0F1TEh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 15:04:37 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:51523 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751338Ab0F1TEg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 15:04:36 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Tony Luck <tony.luck@intel.com>
Subject: Re: [PATCH] tty: avoid recursive BTM in pty_close
Date: Mon, 28 Jun 2010 21:03:58 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.35-rc3-00069-gc502b38-dirty; KDE/4.4.85; x86_64; ; )
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       Greg KH <gregkh@suse.de>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       John Kacur <jkacur@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
       Ingo Molnar <mingo@elte.hu>
References: <1273957196-13768-1-git-send-email-arnd@arndb.de> <201006182035.17394.arnd@arndb.de> <AANLkTikMuR-KLBnYN5Utbz2MV3WRLWLYg3s4QcSkQjYd@mail.gmail.com>
In-Reply-To: <AANLkTikMuR-KLBnYN5Utbz2MV3WRLWLYg3s4QcSkQjYd@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201006282103.58269.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18sPCMkmUYwF26xav/j32O8Fu7ItUpBGcl2JCY
 5/Dv+NkT9mPKc1gSUjxOelv3YoqUPu/jaIkY3opWWbIgNUpOaE
 gnsGNYlJ18C8UIdFOeUsw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 28 June 2010 19:17:39 Tony Luck wrote:
> On Fri, Jun 18, 2010 at 11:35 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> >> Call Trace:
> >>  [<a0000001000159d0>] show_stack+0x50/0xa0
> >>  [<a00000010090f270>] dump_stack+0x30/0x50
> >>  [<a00000010008e2c0>] warn_slowpath_common+0xc0/0x120
> >>  [<a00000010008e360>] warn_slowpath_null+0x40/0x60
> >>  [<a00000010053eb40>] tty_open+0x160/0xc60
> >>  [<a0000001001af9b0>] chrdev_open+0x310/0x360
> >>  [<a0000001001a58b0>] __dentry_open+0x350/0x680
> >>  [<a0000001001a5d80>] nameidata_to_filp+0x80/0xc0
> >>  [<a0000001001bfee0>] finish_open+0x160/0x380
> >>  [<a0000001001c0cc0>] do_last+0xbc0/0xce0
> >>  [<a0000001001c5270>] do_filp_open+0x2f0/0xb40
> >>  [<a0000001001a5290>] do_sys_open+0x90/0x200
> >>  [<a0000001001a54d0>] sys_open+0x50/0x80
> >>  [<a000000100b907e0>] kernel_init+0x340/0x420
> >>  [<a000000100013c10>] kernel_thread_helper+0x30/0x60
> >>  [<a00000010000a0c0>] start_kernel_thread+0x20/0x40
> >
> > Ok, this is the same one you reported at first. I forgot to
> > mention that the other patch I sent as a reply to your report
> > is still needed and not yet in -next since I'm trying to
> > sort through the other BKL removal patches now.
> > This instance of the WARN_ON is completely harmless though,
> > you could consider this one a false positive.
> 
> Quick status check. I'm still seeing these messages in next-20100628.
> Are you still working on a fix?

I got distracted and it wasn't on my list of pressing issues because
this particular warning is harmless. I should get the base bkl series
into -next to fix this.

For the other issue (garbled output), I'm not sure how to proceed.
Alan didn't like the easy workaround of reverting the commit that
introduced it and the fix that Alan suggested only solved the
problem partially as far as I can tell.

	Arnd
