Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935787Ab1ETUAB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 16:00:01 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:52216 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935699Ab1ETUAA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 16:00:00 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: virtualization@lists.linux-foundation.org
Subject: Re: [PATCH] arch/tile: add /proc/tile, /proc/sys/tile, and a sysfs cpu attribute
Date: Fri, 20 May 2011 21:59:50 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.39-rc4+; KDE/4.5.1; x86_64; ; )
Cc: Chris Metcalf <cmetcalf@tilera.com>, linux-kernel@vger.kernel.org
References: <201105181807.p4II7C5g015224@farm-0002.internal.tilera.com> <4DD6821F.6060707@tilera.com> <201105201713.25364.arnd@arndb.de>
In-Reply-To: <201105201713.25364.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105202159.50780.arnd@arndb.de>
X-Provags-ID: V02:K0:Z5kvfq1te395PuT7qp73VAdFuIyXRsJpm5O/uaP5RCm
 qYCDuzJTcxH99Gr6QUmQhjpB0JRNB/CYF9ioMT8umKW0OJtiqY
 FYtWxREyzMcVNHgQwYpz69jWWaXioWz6y8lyKvf8X23o7nnCrb
 ddk99tZy6DZgYtPErVSPJFZ8oKpjkyK/BTiXe9VHEP87zsM9d8
 HasV9gXAElEVxzfprS5dA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 20 May 2011 17:13:25 Arnd Bergmann wrote:
> On Friday 20 May 2011 17:00:47 Chris Metcalf wrote:
> > > Any chance you can still restructure the information? I would recommend
> > > making it a first-class procfs member, since the data is really per-task.
> > >
> > > You can add a conditional entry to tgid_base_stuff[] in fs/proc/base.c
> > > to make it show up for each pid, and then just have the per-task information
> > > in there to do the lookup the other way round:
> > >
> > > # cat /proc/484/hardwall
> > > 2x2 1,1 @2,1
> > >
> > > # cat /proc/479/hardwall
> > > 2x2 1,1 @1,1
> > 
> > It's not unreasonable to do what you're suggesting, i.e. "what's this
> > task's hardwall?", but it's not something that we've come up with any kind
> > of use case for in the past, so I'm not currently planning to implement
> > this.  If we did, I agree, your solution looks like the right one.
> 
> It's fairly easy to aggregate in user space though, we do similar
> things for 'lsof' and 'top', which walk all of procfs in order
> to show the complete picture. This is obviously more overhead than
> walking the lists in the kernel, but still not an expensive
> operation, and it keeps the data format much simpler.

Another problem with the existing interface is that it doesn't currently
support PID name spaces. That could of course be retrofitted, but having
the data split by pid directory would make it work implicitly.

Another approach would be to have a /proc/hardwall/ directory with
one entry per hardwall instance, and symlinks from /proc/<pid>/hardwall
to the respective file.

	Arnd
