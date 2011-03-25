Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933874Ab1CYIiE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 04:38:04 -0400
Received: from ud10.udmedia.de ([194.117.254.50]:51559 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933688Ab1CYIh7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 04:37:59 -0400
Date: Fri, 25 Mar 2011 09:37:57 +0100
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chris Mason <chris.mason@oracle.com>
Subject: Re: [GIT PULL] Core block IO bits for 2.6.39 - early Oops
Message-ID: <20110325083757.GA1754@gentoo.trippels.de>
References: <20110324185445.GB1696@gentoo.trippels.de>
 <4D8B9457.2020608@fusionio.com>
 <20110324193441.GA1723@gentoo.trippels.de>
 <4D8B9D2F.4010504@fusionio.com>
 <20110324194546.GA1741@gentoo.trippels.de>
 <4D8BA235.7060904@fusionio.com>
 <20110324200613.GA1724@gentoo.trippels.de>
 <4D8BB114.2070002@fusionio.com>
 <20110324214150.GA1739@gentoo.trippels.de>
 <4D8C4304.3050101@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D8C4304.3050101@fusionio.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011.03.25 at 08:23 +0100, Jens Axboe wrote:
> On 2011-03-24 22:41, Markus Trippelsdorf wrote:
> > On 2011.03.24 at 22:01 +0100, Jens Axboe wrote:
> >> On 2011-03-24 21:06, Markus Trippelsdorf wrote:
> >>> On 2011.03.24 at 20:57 +0100, Jens Axboe wrote:
> >>>>
> >>>> OK, still a data point. What was the last -git kernel you used?
> >>>
> >>> This one was the last and gave me no problems:
> >>>
> >>> commit b81a618dcd3ea99de292dbe624f41ca68f464376
> >>> Merge: 2f284c8 a9712bc
> >>> Author: Linus Torvalds <torvalds@linux-foundation.org>
> >>> Date:   Wed Mar 23 20:51:42 2011 -0700
> >>>
> >>>     Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs-2.6
> >>
> >> Puzzling... Poking at straws here so far. Does this make any difference
> >> whatsoever?
> > 
> > I will test your patch later.
> > 
> > Git-bisect gave me this result thus far:
> > 
> > 9026e521c0da0731eb31f9f9022dd00cc3cd8885 is bad
> > 82f04ab47e1d94d78503591a7460b2cad9601ede is good
> > 
> > When I continue the bisection with 4345caba340f051e10847924fc078ae18ed6695c
> > the system will start normally, but it then silently corrupts my xfs
> > partitions. And on next (re)boot I get this (only fixable with
> > xfs_repair):
> > 
> How confident are you in those bisection results? Not trying to put you
> on the spot, just wondering whether you tested and it's completely
> consistent, or whether it was a one-off.

Just double checked and 82f04ab47e1d94d78503591a7460b2cad9601ede is also
bad. It just silently corrupts the file system (without a BUG) and I
didn't notice.
So back to square one. 

How can I tell git-bisect just to try the commits in the block merge and
not to take wild swings in history?

-- 
Markus
