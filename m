Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753963Ab0L0SUo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Dec 2010 13:20:44 -0500
Received: from inx.pm.waw.pl ([195.116.170.130]:60445 "EHLO inx.pm.waw.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752378Ab0L0SUm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Dec 2010 13:20:42 -0500
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Mark Knecht <markknecht@gmail.com>
Cc: Jeff Moyer <jmoyer@redhat.com>, Rogier Wolff <R.E.Wolff@bitwizard.nl>,
        Greg Freemyer <greg.freemyer@gmail.com>,
        Bruno =?utf-8?Q?Pr=C3=A9mont?= <bonbons@linux-vserver.org>,
        linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: Slow disks.
References: <20101220141553.GA6088@bitwizard.nl>
	<20101220190630.66084e1d@neptune.home>
	<AANLkTi=VAJbVSzX_DH9_==a3RonLJmawYu3MzF-uqGXC@mail.gmail.com>
	<20101222104306.GB30941@bitwizard.nl>
	<x49aajxsrh3.fsf@segfault.boston.devel.redhat.com>
	<AANLkTi=qAGCFU0u8joKVR4o4QQaRZt1XWfOPSt8eiD3r@mail.gmail.com>
Date: Mon, 27 Dec 2010 19:20:24 +0100
In-Reply-To: <AANLkTi=qAGCFU0u8joKVR4o4QQaRZt1XWfOPSt8eiD3r@mail.gmail.com>
	(Mark Knecht's message of "Sun, 26 Dec 2010 15:38:51 -0800")
Message-ID: <m3pqsnnklz.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Knecht <markknecht@gmail.com> writes:

> Even when I got that part worked out I found that the drives just
> didn't work well in a RAID. The mdadm list led me to believe that the
> root cause was the lack of TLER in the firmware. I don't know how to
> show that's true or not...

But TLER only matters when the drive can't read a sector. For a normal
drive which can easily read all its sectors (at least without retrying
for several seconds) TLER doesn't matter.

Alignment, sure. Personally I'd use whole disks (not partitions) for
RAID-5 and partition the resulting /dev/md* instead, taking into account
even longer "sector" size.

Or better, use RAID-1 (or RAID-10) with 4 KB block fs, partition
/dev/md* with 4 KB alignment, and avoid all these issues. Disks aren't
that expensive now.
-- 
Krzysztof Halasa
