Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755314Ab0EQSus (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 14:50:48 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:51629 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751735Ab0EQSup (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 14:50:45 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH v3 00/10] BKL conversion in tty layer
Date: Mon, 17 May 2010 20:49:56 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-19-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Greg KH <gregkh@suse.de>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       John Kacur <jkacur@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
       Ingo Molnar <mingo@elte.hu>
References: <1273957196-13768-1-git-send-email-arnd@arndb.de> <20100517144130.1d8aa313@lxorguk.ukuu.org.uk>
In-Reply-To: <20100517144130.1d8aa313@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005172049.56930.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19gBtKAjls3bW0FConx8T5a2RDUQv99yTK76zb
 +dYJrTPOyKuOzP76PGYLQaR1kxvlsy+W6yGt74AIqSXR7oVo+x
 o9s/KAcW0/QzJimiMD8xQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 17 May 2010, Alan Cox wrote:
> At this point I think the only way to make further progress is to
> actually push this stuff into the kernel on top of the BKL removal
> patches for the drivers and see what happens. Something will no doubt
> break but we can try and nail them in time or if not revert the series
> and try again next kernel.

Ok, thanks. Most of the breakage that I've seen while testing this (after
I first got it working) was either trivially breaking the build, or
causing lockdep splats for things that are correct with CONFIG_TTY_MUTEX
disabled but violating the lock order with it enabled.

I'm ok with having the series in -next for another kernel to improve
the quality, as long as no new major changes to the tty locking get
merged that break the assumptions I made. Your last series did make
my work easier (or maybe even possible) to get to this point, but most
of the time was spent checking every possible code path by hand to
validate the locking rules, and that would need to be done again
if the code changes.

	Arnd
