Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755302Ab0DSO2J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 10:28:09 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:49453 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755055Ab0DSO2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 10:28:07 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jan Blunck <jblunck@suse.de>
Subject: Re: [GIT PULL] Preparation for BKL'ed ioctl removal
Date: Mon, 19 Apr 2010 16:27:46 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-19-generic; KDE/4.3.2; x86_64; ; )
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Al Viro <viro@zeniv.linux.org.uk>
References: <1271390105-20355-1-git-send-regression-fweisbec@gmail.com> <20100419123003.GE10776@bolzano.suse.de>
In-Reply-To: <20100419123003.GE10776@bolzano.suse.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201004191627.46301.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1828aX23ewfVklZByQymJBxLZZTUMN92rbX037
 C4Y1rFxIZYjJVFj7FZUFWIf4DSHypI5ayaTS/UtPoA2rhn8IK0
 bnff/0dvGNY9jPcwYQDag==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 19 April 2010, Jan Blunck wrote:
> > --- a/include/linux/smp_lock.h
> > +++ b/include/linux/smp_lock.h
> > @@ -62,4 +62,8 @@ static inline void cycle_kernel_lock(void)
> >  #define kernel_locked()                              1
> >  
> >  #endif /* CONFIG_LOCK_KERNEL */
> > +
> > +loff_t default_llseek(struct file *file, loff_t offset, int origin);
> 
> Any specific reason why the default llseek() is in this patch?

A later patch moves both default_llseek and deprecated_ioctl into the new
bkl.ko module, while this is just the minimal preparation for getting
all the users changed.

It was intentional but not important to do the move now.

	Arnd
