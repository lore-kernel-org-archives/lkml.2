Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755469Ab0FNPLY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 11:11:24 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:34156 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754672Ab0FNPLW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 11:11:22 -0400
X-Sasl-enc: 3modDWzv14majjULVAtN4FGqyaVu0v5aXahPo0iPstuf 1276528270
Date: Mon, 14 Jun 2010 10:11:06 -0500
From: Roman Kononov <roman@binarylife.net>
To: Ilia Mirkin <imirkin@alum.mit.edu>
Cc: Dave Chinner <david@fromorbit.com>, xfs@oss.sgi.com,
       linux-kernel@vger.kernel.org
Subject: Re: WARNING in xfs_lwr.c, xfs_write()
Message-ID: <20100614101106.6d883a2e@abend.internal.xtremedata.com>
In-Reply-To: <AANLkTilqrYxnRzB3FNNE3k3hX2Sp1U63gyTo3T4CIzWV@mail.gmail.com>
References: <20100523002023.41f5a5c8@aaa.pulp.binarylife.net>
	<20100523101856.GL2150@dastard>
	<20100523092344.0fcaab42@aaa.pulp.binarylife.net>
	<20100524011907.GC12087@dastard>
	<AANLkTinyt6V9phjXrzrxm67THdRwTiN6pOim3uBUbo1Z@mail.gmail.com>
	<20100613224752.GA2069@dastard>
	<AANLkTikA2d44tZF1TWZAjCqXkhsw0mzsAIaeCosZLqVq@mail.gmail.com>
	<20100614012933.GB6590@dastard>
	<AANLkTilqrYxnRzB3FNNE3k3hX2Sp1U63gyTo3T4CIzWV@mail.gmail.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010-06-13 23:27 CDT, Ilia Mirkin <imirkin@alum.mit.edu> said:
>Instead it will be "mysql works fine on ext3, but with xfs it spams
>the logs with warnings, therefore xfs must be broken". I don't think
>there's anything realistically that you can do about uninformed users
>and FUD. Although I wasn't suggesting to get rid of the warning,
>rather to make it more explicit as to what it's warning about. I
>interpret a WARN as a BUG that can be recovered but where the
>underlying system needs a careful look; my first inclination after
>seeing a fs-related WARN would be to take the system down and run an
>fsck. What's happening here seems more akin to getting a WARN when
>calling an ioctl with invalid parameters.

I agree. My reaction to this WARN was horrible: I brought the system
down, started fsck-ing and re-installing older kernels, with all kinds
of FUD, which took me considerable time. The message was not well
explained on the Internet, nor was it clear reading the source code.
After talking to the mailing list and investigation of my S/W, I've
realized that the system works fine, and the warning now sounds to me
as useless and unwanted noise of quite high volume.

I am suggesting to issue a notice once per filesytem/mount without
taint. The notice could be as such:

"WARNING: Userspace issues direct IO which races with buffered or mmap
IO on the same file (inode <number>, device <name>). File data
corruption is possible. This message is issued only once per mount".

Thanks.
