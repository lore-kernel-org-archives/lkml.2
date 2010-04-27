Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752168Ab0D0PGV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 11:06:21 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:50417 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011Ab0D0PGT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 11:06:19 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: =?utf-8?q?J=C3=B6rn_Engel?= <joern@logfs.org>
Subject: Re: [PATCH 1/7] logfs: push down BKL into ioctl function
Date: Tue, 27 Apr 2010 17:05:50 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-19-generic; KDE/4.3.2; x86_64; ; )
Cc: John Kacur <jkacur@redhat.com>, lkml <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Jan Blunck <jblunck@gmail.com>, Thomas Gleixner <tglx@linutronix.de>
References: <alpine.LFD.2.00.1004271359180.3318@localhost> <1272378265-10909-2-git-send-email-arnd@arndb.de> <20100427145804.GA16794@logfs.org>
In-Reply-To: <20100427145804.GA16794@logfs.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <201004271705.50499.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19xA/mURUaah4eHx3S8G8wnj1CUj2q/mEqjQra
 ZoWp+Yg+xoPEbLs1rdMAByes3kJgQBD+Swkvm446BjtoUREbKQ
 GqJ1CWCgPTNq2jd3hjMjA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 27 April 2010, Jörn Engel wrote:
> On Tue, 27 April 2010 16:24:19 +0200, Arnd Bergmann wrote:
> > 
> > I'm sure that logfs doesn't rely on the BKL, but right now,
> > we're just pushing it down.
> 
> So why do you create logfs_unlocked_ioctl in the first place? ;)

I don't want to get caught in discussions on whether any of my patches
might introduce silent bugs in something I'm not maintaining. Also
to put pressure on maintainers by threatening them to make their code
ugly.

If you just add a patch to convert to ->unlocked_ioctl without
the BKL, we can drop this patch ;-)

	Arnd
