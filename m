Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932267Ab1FKCj4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 22:39:56 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:54489 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758511Ab1FKCjx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 22:39:53 -0400
X-Sasl-enc: OiV+fznpM7hCQ4V/xOyi2qp2i/B+SZaywYmEEY73/4DZ 1307759992
Date: Fri, 10 Jun 2011 19:39:47 -0700
From: Greg KH <greg@kroah.com>
To: Anton Altaparmakov <aia21@cam.ac.uk>
Cc: Miklos Szeredi <mszeredi@suse.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Whitcroft <apw@canonical.com>, NeilBrown <neilb@suse.de>,
        Miklos Szeredi <miklos@szeredi.hu>, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        nbd@openwrt.org, hramrach@centrum.cz, jordipujolp@gmail.com,
        ezk@fsl.cs.sunysb.edu
Subject: Re: [PATCH 0/7] overlay filesystem: request for inclusion
Message-ID: <20110611023947.GA9824@kroah.com>
References: <1306932380-10280-1-git-send-email-miklos@szeredi.hu>
 <20110608153208.dc705cda.akpm@linux-foundation.org>
 <20110609115934.3c53f78f@notabene.brown>
 <20110608205233.ebfedc4d.akpm@linux-foundation.org>
 <20110609134947.GD13242@shadowen.org>
 <20110609123220.6afb9d0f.akpm@linux-foundation.org>
 <BANLkTimTyYp1P4qd8awvsq6PVZn1TQ5A-Q@mail.gmail.com>
 <1307650642.9874.10.camel@tucsk.pomaz.szeredi.hu>
 <EE48B29B-EC3F-44D7-9A39-07F6EA138AC4@cam.ac.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <EE48B29B-EC3F-44D7-9A39-07F6EA138AC4@cam.ac.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 09, 2011 at 11:58:37PM +0100, Anton Altaparmakov wrote:
> > NTFS has been doing nicely in userspace for almost half a decade.  It's
> > not as fast as a kernel driver _could_ be, but it's faster than _the_
> > kernel driver.
> 
> Er, sorry to disappoint but the Tuxera NTFS kernel driver is faster
> than any user space NTFS driver could ever be.  It is faster than
> ext3/4, too.  (-:  To give you a random example on an embedded system
> (800MHz, 512MB RAM, 64kiB write buffer size) where NTFS in user space
> achieves a maximum cached write throughput of ~15MiB/s, ext3 achieves
> ~75MiB/s, ext4 ~100MiB/s and Tuxera NTFS kernel driver achieves
> ~190MiB/s blowing ext4 out of the water by almost a factor of 2 and
> the user space code by more than a factor of 10.  File systems in user
> space have their applications but high performance is definitely not
> one of them...  You might say that ext3/4 are journalling so not a
> fair comparison so let me add that FAT32 achieves about 100MiB/s in
> the same hardware/test, still about half of NTFS.

Talk to Tuxera, they have a new version of their userspace FUSE version
that is _much_ faster than their public one, and it might be almost as
fast as their in-kernel version for some streaming loads (where caching
isn't necessary or needed.)

So it can be done, and done well, if you know what you are doing :)

thanks,

greg k-h
