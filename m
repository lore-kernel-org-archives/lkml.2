Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757055Ab0CaH5m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 03:57:42 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:62547 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756182Ab0CaH5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 03:57:41 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [RFC 0/9] BKL conversion in TTY drivers
Date: Wed, 31 Mar 2010 09:57:02 +0200
User-Agent: KMail/1.13.1 (Linux/2.6.33-00063-g0795fff; KDE/4.4.1; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Greg KH <gregkh@suse.de>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       John Kacur <jkacur@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
       Ingo Molnar <mingo@elte.hu>
References: <1269982580-9361-1-git-send-email-arnd@arndb.de> <20100330233759.00877e80@lxorguk.ukuu.org.uk>
In-Reply-To: <20100330233759.00877e80@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201003310957.03025.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+pwSOI/BXRTh8v9iIO+y/a40+rg9jXSj+9hzf
 WZ2r43cSnXJUckYct8gLsuzN7Nqy6zCwQV5r5WPFdm6CyDLzQm
 zcdr61WdolKl2ajy67mcA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 31 March 2010 00:37:59 Alan Cox wrote:
> 
> > This means we are still safe, because there is no code
> > left that the new BTM fails to serialize with.
> 
> We hope. I'm currently poking at sorting out the locking properly and
> quite frankly the locking rules for the current tty reference have me
> baffled. It clearly works as we've not got a pile of dumps in the
> bugzilla tree but its also quite a mystery *how*.

Yes, that's why I didn't even attempt to find out why the BKL is
in some places or what it protects, but only changed the way it gets
taken and released.

We also have empirical evidence that turning the BKL into a semaphore
doesn't make the code fall apart, so I'm assuming that the mutex based
implementation with the explicit release-when-blocking instead of
implicit release-when-sleeping is still equivalent.

Are you more worried that the interface conversion (patches 1-8)
can introduce bugs and make your life harder, or that the mutex
based implementation from patch 9 causes problems that were previously
hidden by other bugs?

	Arnd
