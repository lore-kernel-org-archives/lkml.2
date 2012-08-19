Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751817Ab2HSVFK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2012 17:05:10 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:45709 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750937Ab2HSVFH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2012 17:05:07 -0400
Date: Sun, 19 Aug 2012 17:04:55 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Dan Luedtke <mail@danrl.de>
Cc: Jochen Striepe <jochen@tolot.escape.de>,
        Marco Stornelli <marco.stornelli@gmail.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        lanyfs@librelist.com
Subject: Re: [PATCH] fs: Introducing Lanyard Filesystem
Message-ID: <20120819210455.GA9208@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Dan Luedtke <mail@danrl.de>,
	Jochen Striepe <jochen@tolot.escape.de>,
	Marco Stornelli <marco.stornelli@gmail.com>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	lanyfs@librelist.com
References: <1345333117-2826-1-git-send-email-mail@danrl.de>
 <CAFLxGvwwAX=85hmgxg6qGTpp4YCppuj2mpw7GkB1eV8qhta2bg@mail.gmail.com>
 <1345371135.4441.2.camel@tunafish>
 <5030BC7E.3030000@gmail.com>
 <1345383264.4441.56.camel@tunafish>
 <20120819120254.GA2369@pompeji.miese-zwerge.org>
 <1345390432.2716.34.camel@tunafish>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345390432.2716.34.camel@tunafish>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 19, 2012 at 05:33:52PM +0200, Dan Luedtke wrote:
> 
> Poorly crafted example:
> Let's say you have a 6GB video file you want to give somebody (e.g. a
> video cutter) on a thumb drive. The cutter wants to edit the file, so he
> needs read and write access to it. After cutting the file is to be
> played on a TV screen with USB-port. What if the cutter does use two
> different, major, non-Linux operating systems, let's say one for cutting
> and the other one for adding visual effects? Now imagine the cutter (and
> of course the TV screen vendor) don't care much about filesystems as
> they are just generating costs (implementation), so it will only come
> with minimal compatibility.
> - What filesystem would you recommend to share that video file?

So the problem with using interoperability as your prime driver is
that other operating systems won't have implemented your LanyFS, and
because of licensing issues, it will be very hard to get even a
shareware distribution of LanyFS for Windows (because of licensing
issues around Window's IFS SDK).

In practice, the solution of using either FAT for most cases as the
interchange format works well enough for most purposes.  Granted it
doesn't in the case of your example of a 6GB video file (which I'd
probably transmit using a networking protocol, since a thumb drive
would be really slow.)  What I would do if I needed to transfer such a
file, and I didn't have access to high speed networking, would be to
use ext2, and then either use the ext2 FUSE driver with FUSE for
Windows or Macintosh --- or, I would port the userspace e2tools
package to the target OS, and use that to access the ext2 file ssytem.
And I'd do that because the software is available today, right now,
without having to figure out how to port LanyFS to the operating
system.

> There is a small niche which LanyFS tries to fit in. It is for those who
> do not want to bother about how to use a fs when they are in a hurry or
> when they just want to listen to music in the car.  It is for the
> it-must-be-easy-enough-for-my-gradma fraction. 

Music doesn't require > 4GB files, and there are plenty of very easy
to use solutions that utilize streaming over the network.  That is
*always* going to be easier than figuring out ahead of time which
files you want, and then manually copying them onto a thumb drive, and
then taking the thumb drive to the car....  Somehow I can't quite
imagine your grandma manually copying files over using LanyFS.  :-)

I also seriously question the niche of people who want to use a thumb
drive to transfer > 4GB files.  Try it sometime and see what a painful
user experience it is....

Regards,

						- Ted
