Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758705Ab0DATKY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 15:10:24 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:52725 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753634Ab0DATKV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 15:10:21 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [RFC 0/9] BKL conversion in TTY drivers
Date: Thu, 1 Apr 2010 21:10:15 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-19-generic; KDE/4.3.2; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Greg KH <gregkh@suse.de>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       John Kacur <jkacur@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
       Ingo Molnar <mingo@elte.hu>
References: <1269982580-9361-1-git-send-email-arnd@arndb.de> <201004011451.59712.arnd@arndb.de> <20100401151756.5e329014@lxorguk.ukuu.org.uk>
In-Reply-To: <20100401151756.5e329014@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201004012110.15209.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18BXueOAaNy9/lFLTQmQDLGWF3itzWozMlhrXc
 hxuyb3SF10UgKbQzfEBSbuVX49Unm8BMzn5XHGvjnI3w+JmM8n
 h5Bl1iDHBJhlE3ozM4WjQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 01 April 2010, Alan Cox wrote:
> > Greg, are you ok with merging these TTY patches in your tree for 2.6.35
> > then? There will be at least one more respin of it for minor changes
> > and anything that comes up during testing, but it's essentially what I
> > posted here.
> 
> Can we please wait a bit with the tty bits. I'm slowing picking through
> the job properly and there are a lot of low hanging fruit to clean up at
> the driver end of things that is best done before we complicate the core
> stuff.

Ok, sure thing. I tried to make the patches in a way that is helpful to your
goals, not hurting, but anything you are already working on should go in
first because it's more important in the long run.

> Arnd there is another problem I noticed in your changes - the ppp stuff
> is not tty locking, its some kind of driver/network locking and I don't
> claim to understand what is going on.

Ok. This was just me being conservative and assuming that it interacts
with TTY in ways I don't understand. The network layer does not use the
BKL at all, except for a few protocols (appletalk, ipx, ...), so I'm fairly
certain the ppp locking does not interact with that. I'll have a closer look
to see if there's any chance it could lock against TTY code at all and
do a patch to use a private lock if not.

	Arnd
