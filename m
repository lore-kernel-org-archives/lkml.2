Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756088Ab0C3Sya (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 14:54:30 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:57558 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756018Ab0C3Sy3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 14:54:29 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 5/6] procfs: Push down the bkl from ioctl
Date: Tue, 30 Mar 2010 20:54:11 +0200
User-Agent: KMail/1.13.1 (Linux/2.6.33-00063-g0795fff; KDE/4.4.1; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       John Kacur <jkacur@redhat.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Al Viro <viro@zeniv.linux.org.uk>, Ingo Molnar <mingo@elte.hu>
References: <1269930015-863-1-git-send-regression-fweisbec@gmail.com> <201003301237.28083.arnd@arndb.de> <20100330182710.GC5078@nowhere>
In-Reply-To: <20100330182710.GC5078@nowhere>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201003302054.11962.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/CmhFgFTG2wwC7dIL7PPYV0YfykoI/15HSAFZ
 ED0aY2MwaLAaBs/zEaFNXUP+5HduKiSbdExacQ5ai2fTfsXBjS
 eQ6X9Nfl57luJN9K3x7NQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 30 March 2010 20:27:12 Frederic Weisbecker wrote:
> On Tue, Mar 30, 2010 at 11:37:27AM +0100, Arnd Bergmann wrote:
> > On Tuesday 30 March 2010, Frederic Weisbecker wrote:
> > > Push down the bkl from procfs's ioctl main handler to its users.
> > > Only three procfs users implement an ioctl (non unlocked) handler.
> > > Turn them into unlocked_ioctl and push down the Devil inside.
> > 
> > Looks good to me. I would have used a single unlock and return statement
> > in i8k_ioctl and isdn_divert_ioctl, with goto instead of adding an
> > unlock to each return, but it doesn't matter much.
> 
> 
> I did that first, but actually that didn't make much difference:
> 
> ret = foo;            unlock_kernel()
> goto end;      VS     return foo;

Yes, the amount of code needed is comparable, but it is much easier
to validate that you did not miss an unlock when you know that there
is a single return statement in the function. It also helps the next
person that may want to replace the BKL with a different lock.

	Arnd
