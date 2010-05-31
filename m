Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753516Ab0EaL3Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 07:29:16 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:64095 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752145Ab0EaL3P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 07:29:15 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Olaf Hering <olaf@aepfle.de>
Subject: Re: acquire_console_mutex: WARNING: at 2.6.33.4-rt20/kernel/mutex-debug.c:65 mutex_remove_waiter+0xe8/0x11c()
Date: Mon, 31 May 2010 13:29:07 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-19-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <20100524225357.GA19513@aepfle.de> <201005251318.37242.arnd@arndb.de> <20100530213902.GA3619@aepfle.de>
In-Reply-To: <20100530213902.GA3619@aepfle.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201005311329.07182.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+stAdxgU2ZI3N2KmeotqRhyif00P5wUEHgOhq
 i2qF4s1G4cT4KYn2CnpH0Ee0HVe0e9lLkn/NlnpzFlbMiscJKq
 VQAZQANIBkU9MG2zL27Ew==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 30 May 2010, Olaf Hering wrote:
> > You could try to pull in the blk/tty branch from
> > http://git.kernel.org/?p=linux/kernel/git/arnd/playground.git and enable
> > CONFIG_TTY_MUTEX to see if that gives you better lockdep output,
> > because that replaces the implicit dropping of the BKL with mutex operations
> > that lockdep is aware of.
> 
> CONFIG_TTY_MUTEX depends on SMP and this ARM system does not support
> CONFIG_SMP, its hidden by Kconfig dependencies.
> 
Ah right, sorry about that.

It should be

	depends on SMP || PREEMPT

	Arnd


