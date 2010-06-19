Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755615Ab0FSMcm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jun 2010 08:32:42 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:49787 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755571Ab0FSMcl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jun 2010 08:32:41 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Tony Luck <tony.luck@intel.com>
Subject: Re: [PATCH] tty: avoid recursive BTM in pty_close
Date: Sat, 19 Jun 2010 14:32:04 +0200
User-Agent: KMail/1.13.2 (Linux/2.6.35-rc1-00033-gd4ce942-dirty; KDE/4.4.2; x86_64; ; )
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       Greg KH <gregkh@suse.de>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       John Kacur <jkacur@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
       Ingo Molnar <mingo@elte.hu>
References: <1273957196-13768-1-git-send-email-arnd@arndb.de> <201006182035.17394.arnd@arndb.de> <AANLkTim4dHj_3ftAVD35DD-Cc7ZntHRi1YTRPup2wfJc@mail.gmail.com>
In-Reply-To: <AANLkTim4dHj_3ftAVD35DD-Cc7ZntHRi1YTRPup2wfJc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201006191432.04685.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19ach5Q7Xpkj+As3Trb7e1URHU618nLp23X1ra
 sksYY++bB7qKQt366r/z4CDScOQOa+fXTfwPW+jIwqADg748ah
 ieJprEbhIjlCMU7x0KFgw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 18 June 2010 22:25:22 Tony Luck wrote:
> On Fri, Jun 18, 2010 at 11:35 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> > Do you know if this was a problem with the original series or
> > something that got introduced by my last patch?
> 
> Problem was there before. Looks like it was not in next-20100616
> but began with next-20100617.

Ok, so it's certainly in one of the patches from Alan or me.

> > Also, if you don't mind, could you try if the problem also exists
> > with CONFIG_TTY_MUTEX enabled?
> With CONFIG_TTY_MUTEX=y kernel with both your patches builds
> and boots with no unusual messages.  Application output still gets
> garbled.

ok.
 
> > Which serial driver do you use?
> I boot with a "console=uart,io,0x3f8" argument, so I start out using
> 8250_early.c. Looks like it switched to 8250.c based on seeing
> this:
> 
> Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
> 
> on the console log.

Good, so it's something I should be able to reproduce on a PC.

	Arnd
