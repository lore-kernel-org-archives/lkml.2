Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754444Ab0EPM7B (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 May 2010 08:59:01 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:59361 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754352Ab0EPM7A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 May 2010 08:59:00 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Daniel K." <dk@uw.no>
Subject: Re: [PATCH 10/10] tty: implement BTM as mutex instead of BKL
Date: Sun, 16 May 2010 14:58:37 +0200
User-Agent: KMail/1.13.2 (Linux/2.6.34-rc6-00202-gac5d593; KDE/4.4.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Greg KH <gregkh@suse.de>, Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       John Kacur <jkacur@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
       Ingo Molnar <mingo@elte.hu>
References: <1273957196-13768-1-git-send-email-arnd@arndb.de> <1273957196-13768-11-git-send-email-arnd@arndb.de> <4BEF677A.2030003@uw.no>
In-Reply-To: <4BEF677A.2030003@uw.no>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005161458.37866.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/Mvhc5ie6e9oaPPbHBjAgnVrJ0YnS2mP3RSG/
 hOKCXOm21WuViYZkwmHSOzQCxwVaMg0bFUi91gDUoJgfng1s6z
 viQ9RY+ZXckp7vMv3CFgQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 16 May 2010 05:33:14 Daniel K. wrote:
> Arnd Bergmann wrote:
> > diff --git a/drivers/char/tty_mutex.c b/drivers/char/tty_mutex.c
> > new file mode 100644
> > index 0000000..f66dfdf
> > --- /dev/null
> > +++ b/drivers/char/tty_mutex.c
> > @@ -0,0 +1,47 @@
> > +/*
> > + * drivers/char/tty_lock.c
> > + */
> > +#include <linux/tty.h>
> > +#include <linux/module.h>
> > +#include <linux/kallsyms.h>
> > +#include <linux/semaphore.h>
> > +#include <linux/sched.h>
> > +
> > +/*
> > + * The 'big tty semaphore'
> 
> Referred to as Big TTY Mutex or BTM elsewhere.
> 
> 
> > + * This mutex is taken and released by tty_lock() and tty_unlock(),
> > + * replacing the older big kernel mutex.
> 
> big kernel lock, or BKL?
> 

Thanks for looking at this, this (and the bug you found in amiserial)
were caused by changing it a few times from one implementation to the next.

Fixed now and pushed out to git.

	Anrd
