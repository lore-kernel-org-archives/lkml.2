Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751523Ab0HQTG6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 15:06:58 -0400
Received: from fieldses.org ([174.143.236.118]:48470 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750753Ab0HQTGw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 15:06:52 -0400
Date: Tue, 17 Aug 2010 15:04:47 -0400
From: "J. Bruce Fields" <bfields@fieldses.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: "Patrick J. LoPresti" <lopresti@gmail.com>, linux-fsdevel@vger.kernel.org,
        linux-nfs@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Proposal: Use hi-res clock for file timestamps
Message-ID: <20100817190447.GA28049@fieldses.org>
References: <AANLkTimnyXKahtjaFeSsgcq=xMy-pP3na1jidQhZ-dt2@mail.gmail.com>
 <87aaolwar8.fsf@basil.nowhere.org>
 <20100817174134.GA23176@fieldses.org>
 <20100817182920.GD18161@basil.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100817182920.GD18161@basil.fritz.box>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 17, 2010 at 08:29:20PM +0200, Andi Kleen wrote:
> > OK, so that leaves us with the race, even on newer filesystems:
> > 
> > 	1. File is modified, mtime updated
> > 	2. Client fetches mtime to revalidate cache
> > 	3. File is modified again, mtime updated
> > 	4. Client fetches new mtime to revalidate cache
> 
> You'll always have a race window with time, the only way around
> that would be a version number.

Agreed, but as a practical matter, nanosecond resolution would extend
the useful lifetime of NFSv3 by quite a bit.

> > 	- Tell everyone to use NFSv4 (and make sure we have
> > 	  changeattr/i_version working correctly).
> > 	- Use a finer-grained time source.  (I believe you when you say
> > 	  the TSC is too slow, but maybe we should run some tests to
> > 	  make sure.)
> 
> It depends on the CPU too.

If we wanted to look into this, what would you suggest (hardware,
workload) to demonstrate the worst case?  (Or are the results from the
TSC or any other higher-precision time source likely to be useless for
other reasons?)

> > 	- Increment mtime by a nanosecond when necessary.  
> 
> You cannot be more precise than the backing file system: this causes
> non monotonity when the inodes are flushed (has happened in the past)

Right, I think that we probably have to give up ext3 as a lost cause.
But perhaps we could get away with a hack like this on filesystems that
can store nanoseconds.

--b.
