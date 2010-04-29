Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759483Ab0D3Ucl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 16:32:41 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:65054 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758336Ab0D3Ucj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 16:32:39 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH 0/5] Pushdown bkl from v4l ioctls
Date: Thu, 29 Apr 2010 09:38:09 +0200
User-Agent: KMail/1.13.2 (Linux/2.6.31-19-generic; KDE/4.4.2; x86_64; ; )
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, John Kacur <jkacur@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jan Blunck <jblunck@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
       Mauro Carvalho Chehab <mchehab@infradead.org>, Greg KH <gregkh@suse.de>,
       Linux Media Mailing List <linux-media@vger.kernel.org>
References: <alpine.LFD.2.00.1004280750330.3739@i5.linux-foundation.org> <201004290844.29347.hverkuil@xs4all.nl> <201004290910.43412.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201004290910.43412.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: 7bit
Message-Id: <201004290938.09573.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+JQtjzX6F8ndixqirDlCZcrWKgI2vGOQ3XNAE
 6UBS81xszAnuTtNhzjUvilzUoimfGSoY1FSi3gIpe2PdjcT6+C
 BSvfRljcMwy3ATKBWZyzQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 29 April 2010 09:10:42 Laurent Pinchart wrote:
> On Thursday 29 April 2010 08:44:29 Hans Verkuil wrote:
> >
> > 3) Investigate what needs to be done to replace the bkl with a v4l2-dev.c
> > global mutex. Those drivers that call the bkl themselves should probably be
> > converted to do proper locking, but there are only about 14 drivers that do
> > this. The other 60 or so drivers should work fine if a v4l2-dev global lock
> > is used. At this point the bkl is effectively removed from the v4l
> > subsystem.
> > 
> > 4) Work on the remaining 60 drivers to do proper locking and get rid of the
> > v4l2-dev global lock. This is probably less work than it sounds.
> > 
> > Since your patch moves everything down to the driver level it will actually
> > make this work harder rather than easier. And it touches almost all drivers
> > as well.
> 
> Every driver will need to be carefully checked to make sure the BKL can be 
> replaced by a v4l2-dev global mutex. Why would it be more difficult to do so 
> if the BKL is pushed down to the drivers ?

Note that you can completely skip the step of a v4l2-dev global mutex with
Frederic's patch. This is the only use of the BKL in the common v4l2
code as far as I can tell, so instead of introducing yet another global
lock, you can go straight to stage 4 and look at each driver separately,
possibly introducing a per driver lock.

	Arnd
