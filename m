Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752933Ab2LKKNg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 05:13:36 -0500
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:36859 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752149Ab2LKKNe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 05:13:34 -0500
Message-ID: <1355220811.2400.5.camel@dabdike.int.hansenpartnership.com>
Subject: Re: [patch,v3,repost 00/10] make I/O path allocations more
 numa-friendly
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>
Date: Tue, 11 Dec 2012 10:13:31 +0000
In-Reply-To: <x49zk1l6b5p.fsf@segfault.boston.devel.redhat.com>
References: <1354034799-8460-1-git-send-email-jmoyer@redhat.com>
	 <x49zk1l6b5p.fsf@segfault.boston.devel.redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-12-10 at 12:59 -0500, Jeff Moyer wrote:
> Jeff Moyer <jmoyer@redhat.com> writes:
> 
> > Hi,
> >
> > This patch set makes memory allocations for data structures used in
> > the I/O path more numa friendly by allocating them from the same numa
> > node as the storage device.  I've only converted a handful of drivers
> > at this point.  My testing is limited by the hardware I have on hand.
> > Using these patches, I was able to max out the bandwidth of the storage
> > controller when issuing I/O from any node on my 4 node system.  Without
> > the patch, I/O from nodes remote to the storage device would suffer a
> > penalty ranging from 6-12%.  Given my relatively low-end setup[1], I
> > wouldn't be surprised if others could show a more significant performance
> > advantage.
> >
> > This is a repost of the last posting.  The only changes are additional
> > reviewed-by/acked-by tags.  I think this version is ready for inclusion.
> > James, would you mind taking a look?
> 
> James?  Do you have any objections to including this for 3.8?

Probably for 3.9 since the 3.8 merge window is upon us.

Do we actually have any performance numbers from the big system people?
That's really a must for this type of work.

It's missing acks from the affected drivers; that's not a show stopper
but it would be better to have them.

James


