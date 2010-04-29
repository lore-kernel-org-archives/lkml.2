Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933552Ab0D3RqY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 13:46:24 -0400
Received: from perceval.irobotique.be ([92.243.18.41]:38829 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933364Ab0D3RqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 13:46:11 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH 0/5] Pushdown bkl from v4l ioctls
Date: Thu, 29 Apr 2010 09:10:42 +0200
User-Agent: KMail/1.13.2 (Linux/2.6.33; KDE/4.4.2; x86_64; ; )
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
       John Kacur <jkacur@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jan Blunck <jblunck@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
       Mauro Carvalho Chehab <mchehab@infradead.org>, Greg KH <gregkh@suse.de>,
       Linux Media Mailing List <linux-media@vger.kernel.org>
References: <alpine.LFD.2.00.1004280750330.3739@i5.linux-foundation.org> <1272512564-14683-1-git-send-regression-fweisbec@gmail.com> <201004290844.29347.hverkuil@xs4all.nl>
In-Reply-To: <201004290844.29347.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: 7bit
Message-Id: <201004290910.43412.laurent.pinchart@ideasonboard.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hans,

On Thursday 29 April 2010 08:44:29 Hans Verkuil wrote:
> On Thursday 29 April 2010 05:42:39 Frederic Weisbecker wrote:
> > Hi,
> > 
> > Linus suggested to rename struct v4l2_file_operations::ioctl
> > into bkl_ioctl to eventually get something greppable and make
> > its background explicit.
> > 
> > While at it I thought it could be a good idea to just pushdown
> > the bkl to every v4l drivers that have an .ioctl, so that we
> > actually remove struct v4l2_file_operations::ioctl for good.
> > 
> > It passed make allyesconfig on sparc.
> > Please tell me what you think.
> 
> I much prefer to keep the bkl inside the v4l2 core. One reason is that I
> think that we can replace the bkl in the core with a mutex. Still not
> ideal of course, so the next step will be to implement proper locking in
> each driver. For this some additional v4l infrastructure work needs to be
> done. I couldn't proceed with that until the v4l events API patches went
> in, and that happened yesterday.
> 
> So from my point of view the timeline is this:
> 
> 1) I do the infrastructure work this weekend. This will make it much easier
> to convert drivers to do proper locking. And it will also simplify
> v4l2_priority handling, so I'm killing two birds with one stone :-)
> 
> 2) Wait until Arnd's patch gets merged that pushes the bkl down to
> v4l2-dev.c
> 
> 3) Investigate what needs to be done to replace the bkl with a v4l2-dev.c
> global mutex. Those drivers that call the bkl themselves should probably be
> converted to do proper locking, but there are only about 14 drivers that do
> this. The other 60 or so drivers should work fine if a v4l2-dev global lock
> is used. At this point the bkl is effectively removed from the v4l
> subsystem.
> 
> 4) Work on the remaining 60 drivers to do proper locking and get rid of the
> v4l2-dev global lock. This is probably less work than it sounds.
> 
> Since your patch moves everything down to the driver level it will actually
> make this work harder rather than easier. And it touches almost all drivers
> as well.

Every driver will need to be carefully checked to make sure the BKL can be 
replaced by a v4l2-dev global mutex. Why would it be more difficult to do so 
if the BKL is pushed down to the drivers ?

-- 
Regards,

Laurent Pinchart
