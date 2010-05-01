Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752133Ab0EALHw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 May 2010 07:07:52 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:38136 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751739Ab0EALHu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 May 2010 07:07:50 -0400
Date: Sat, 1 May 2010 12:11:11 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
       Arnd Bergmann <arnd@arndb.de>, John Kacur <jkacur@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jan Blunck <jblunck@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
       Mauro Carvalho Chehab <mchehab@infradead.org>, Greg KH <gregkh@suse.de>,
       Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 0/5] Pushdown bkl from v4l ioctls
Message-ID: <20100501121111.4ac32c35@lxorguk.ukuu.org.uk>
In-Reply-To: <201004290844.29347.hverkuil@xs4all.nl>
References: <alpine.LFD.2.00.1004280750330.3739@i5.linux-foundation.org>
	<1272512564-14683-1-git-send-regression-fweisbec@gmail.com>
	<201004290844.29347.hverkuil@xs4all.nl>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I much prefer to keep the bkl inside the v4l2 core. One reason is that I
> think that we can replace the bkl in the core with a mutex. Still not
> ideal of course, so the next step will be to implement proper locking in

I did look at this a long time ago - it doesn't really work becaue the
mutex you propose then has to be dropped and taken in the sleeping parts
of each ioctl to avoid app problems and in some cases threaded apps
deadlocking.

I think Arnd is right on his approach to this, having tried the other way.
